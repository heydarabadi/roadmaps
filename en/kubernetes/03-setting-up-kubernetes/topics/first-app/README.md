# Deploy Your First Application
[Persian edition](../../../../../fa/kubernetes/03-setting-up-kubernetes/topics/first-app/README.md) · [Chapter references](../../../references/README.md#03-setting-up-kubernetes)

[فارسی](../../../../../fa/kubernetes/03-setting-up-kubernetes/topics/first-app/README.md) | [Chapter 03](../../README.md)

## Goal

Deploy a workload declaratively, give it internal access, and observe the difference between an accepted object and an application that is ready.

## Example

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
        - name: web
          image: nginx:stable
          ports:
            - name: http
              containerPort: 80
          readinessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 5
          resources:
            requests:
              cpu: 100m
              memory: 64Mi
---
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  selector:
    app: hello
  ports:
    - name: http
      port: 80
      targetPort: http
  type: ClusterIP
~~~

The Deployment's selector must match the Pod-template labels. The Service has its own selector and uses it to find backend Pods.

~~~sh
kubectl apply -f hello.yaml
kubectl rollout status deployment/hello
kubectl get deploy,rs,pods,svc,endpointslices
kubectl describe pod -l app=hello
kubectl port-forward service/hello 8080:80
~~~

Open localhost:8080, change replicas to three, apply again, and compare desired replicas with ready replicas.

## Troubleshooting cycle
1. get for overall status.
2. describe for conditions and events.
3. logs for application failures.
4. EndpointSlices to inspect Service backends.
5. Fix the cause and watch rollout status.

An invalid image, a Pod that never becomes Ready, and a mismatched selector break different layers.

## Quiz with explanations
1. **Why can a Service have no endpoints?** No matching Pods, missing Pods, or Pods that are not Ready.
2. **What does successful apply prove?** The API accepted the request, not that the image was pulled or the app is ready.
3. **What is missing for production?** Pinned image, workload-sized resources, securityContext, monitoring/logging, TLS/ingress, and policy.
4. **How should you clean up?** Confirm the context, then delete the practice namespace or resources from the manifest.

## Further reading
- [Deploy an App tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/)
- [Deployment concepts](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Service concepts](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Kubernetes debugging guides](https://kubernetes.io/docs/tasks/debug/)
- [DevNA Persian beginner guide](https://devna.ir/articles/kubernetes-basics-for-beginners)
