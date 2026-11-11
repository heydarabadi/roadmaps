# Container Runtime and Isolation
[Persian edition](../../../../../fa/kubernetes/02-containers/topics/runtime-isolation/README.md) · [Chapter references](../../../references/README.md#02-containers-and-images)

[فارسی](../../../../../fa/kubernetes/02-containers/topics/runtime-isolation/README.md) | [Chapter 02](../../README.md)

## Separate the layers

The Kubernetes API manages Pods. kubelet on a node supervises assigned Pods. CRI is the interface between kubelet and a container runtime. A runtime such as containerd prepares the image and starts containers. CNI provides Pod networking, while CSI connects storage. These boundaries help troubleshooting: an image error is not automatically a Deployment-controller problem.

## A container is not a full virtual machine

A container is an isolated process that runs on the host kernel. Linux namespaces isolate views such as process IDs, network, and mounts. cgroups account for and constrain CPU and memory. A virtual machine normally runs a separate guest kernel. Shared-kernel exposure means runtime configuration and kernel vulnerabilities matter to the security model.

Use a Pod securityContext to run as non-root, drop unneeded capabilities, make the root filesystem read-only, or apply seccomp where compatible. Test the actual application: restrictive settings can prevent it from writing required files or binding to required ports.

## Troubleshoot by layer

- A running process crashes: inspect current and previous container logs.
- A command or filesystem is wrong: inspect the command and paths in a safe debug session.
- An image cannot be prepared: inspect Pod events, registry access, and credentials.
- The issue occurs only on one node: inspect node conditions, events, kubelet, and runtime.
- Networking or a mount fails: inspect the relevant CNI or CSI component and node status.

Node-level access is highly privileged. Do not use it as the first response to every application error.

## Quiz

1. **Does a container have its own kernel?** No. It shares the host kernel.
2. **What starts the process on the node?** The container runtime, coordinated by kubelet through CRI.
3. **What do cgroups do?** Account for and constrain resource use.
4. **Why can a root process inside a container raise risk?** Combined with a misconfiguration or escape, elevated privileges can amplify impact.
5. **Where do you begin when a Pod crashes?** Inspect status, events, and logs; investigate runtime or node only when evidence points there.

## Further reading

- [Container Runtime Interface](https://kubernetes.io/docs/concepts/containers/cri/)
- [Container runtimes in production](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
- [Security context for Pods and containers](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [EasyEnv Persian Kubernetes course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
