<div dir="ltr" align="left">

# Capstone Lab: A Web Service You Can Diagnose

**Persian edition:** [فارسی](README.md) · **Reference library:** [Kubernetes references](../../references/README.en.md)  
Run this lab only in kind, minikube, or another disposable training cluster. Prerequisites: kubectl and a local Kubernetes cluster.

## 1. Check context and isolate the exercise

~~~sh
kubectl config current-context
kubectl cluster-info
kubectl create namespace k8s-lab
~~~

Verify the context before making changes. Do not commit the local Secret file to Git; Base64 encoding is not encryption.

## 2. Configuration

~~~yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-settings
  namespace: k8s-lab
data:
  APP_MODE: training
~~~

Create a local test Secret:

~~~sh
kubectl create secret generic web-credentials --from-file=TOKEN=./token.txt -n k8s-lab
~~~

## 3. Deployment and Service

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: k8s-lab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - name: http
          containerPort: 80
        envFrom:
        - configMapRef:
            name: web-settings
        env:
        - name: API_TOKEN
          valueFrom:
            secretKeyRef:
              name: web-credentials
              key: TOKEN
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
          limits:
            memory: 128Mi
        readinessProbe:
          httpGet:
            path: /
            port: http
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: 10
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: k8s-lab
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: http
  type: ClusterIP
~~~

Save this as lab.yaml. Before using a similar manifest in production, pin the image, restrict its security context, and size resources using observed workload behavior. This deliberately compact teaching example is not a production security baseline.

## 4. Deploy and inspect

~~~sh
kubectl apply -f lab.yaml
kubectl -n k8s-lab rollout status deployment/web
kubectl -n k8s-lab get deploy,pods,svc,endpointslices
kubectl -n k8s-lab describe deployment/web
kubectl -n k8s-lab logs deployment/web
kubectl -n k8s-lab port-forward service/web 8080:80
~~~

Open localhost:8080. Compare Pod readiness with the backends selected for the Service.

## 5. Break and recover

- Delete one Pod and watch the Deployment replace it.
- In a disposable manifest, use an invalid image name and find the ImagePullBackOff events.
- Change readiness to a nonexistent path and observe the effect on EndpointSlices.
- Stop a rollout and return to the known-good application revision; explain why application rollback and database schema recovery are different.

| Symptom | First check | Possible causes |
| --- | --- | --- |
| ImagePullBackOff | Describe the Pod and inspect events | Name or tag, registry access, credentials, or TLS |
| Pending | Describe the Pod | Resources, quota, taint, selector, or PVC |
| CrashLoopBackOff | Previous logs and events | Command, configuration, startup failure, or OOM |
| Service has no response | Selector and EndpointSlice | Labels, readiness, or port mismatch |

## Quiz and answers

1. Why use a Deployment instead of one Pod? — It manages replicas and rollout behavior.
2. How does a Service find Pods? — Through selectors, labels, and EndpointSlices.
3. Is Base64 encoding encryption for a Secret? — No. It is an encoding.
4. Is a persistent volume the same thing as a backup? — No. A backup must be independently restorable.
5. How do readiness and liveness differ? — Readiness controls whether a Pod should receive traffic; liveness can trigger a container restart.
6. What does an HPA need to scale on CPU? — Metrics and meaningful CPU requests for the relevant containers.
7. What does a PDB not prevent? — Sudden node failure and every kind of forced disruption.
8. How should you clean up after the lab? — Confirm the context, then remove the test namespace.

~~~sh
kubectl config current-context
kubectl delete namespace k8s-lab
~~~

## References

- [Kubernetes tutorials](https://kubernetes.io/docs/tutorials/)
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Course reference library](../../references/README.en.md)

</div>
