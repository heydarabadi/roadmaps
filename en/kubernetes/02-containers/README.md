# Chapter 02: Containers
[Persian edition](../../../fa/kubernetes/02-containers/README.md) · [Chapter references](../references/README.md#02-containers-and-images)

[فارسی](../../../fa/kubernetes/02-containers/README.md) | [Course index](../README.md)

## Learning objectives

- Explain the difference between source code, image, container, runtime, and registry.
- Describe Kubernetes' role in starting containers and what is delegated to a runtime.
- Build a versioned image and troubleshoot image-pull failures.
- Account for the limits of container isolation in security decisions.

## Mental model

An image is a portable application artifact; a container is a running instance of that artifact. A registry stores images, and a runtime pulls and starts them. Kubernetes communicates with the runtime through CRI, but it does not build images. CI usually builds images; Kubernetes schedules and supervises Pods.

## From build to execution

1. Define source and dependencies in the build context.
2. A Dockerfile or another OCI build tool creates the image.
3. Publish the image to a registry reachable by cluster nodes.
4. A Deployment records the image reference.
5. kubelet asks the runtime to pull the image or use its cache.
6. The runtime starts the process; kubelet reports health and exit status.

If pulling fails, start with Pod events and check the image name/tag, credentials, TLS, DNS, and network path. If the image pulls but the process crashes, inspect the command, environment, filesystem, and logs.

## Safer, reproducible images

Use a versioned tag or digest for traceable releases. Build in CI and scan or sign the artifact. Smaller images can reduce pull time and the number of included packages, but are not automatically secure. Never bake permanent secrets into image layers or build arguments.

## Practice

Run and tag a sample image, then update its Deployment. In a local cluster, deliberately use a non-existent tag and inspect the ImagePullBackOff events. Restore the correct image and explain how an image-pull failure differs from an application crash.

## Quiz with answers

1. **How do an image and a container differ?** — An image is a packaged artifact; a container is a running instance created by a runtime.
2. **Does Kubernetes build container images?** — No. CI or a separate build system creates images; Kubernetes schedules and supervises workloads.
3. **What should you inspect first for ImagePullBackOff?** — Pod events, then image reference, registry access, credentials, TLS, DNS, and network connectivity.
4. **Why record a digest?** — It identifies an immutable image artifact more precisely than a mutable tag.
5. **Do containers have a separate host kernel?** — Usually no; containers use kernel isolation mechanisms while sharing the host kernel.
## Further reading

- [Container images](https://kubernetes.io/docs/concepts/containers/images/)
- [Container runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
- [Kubernetes container concepts](https://kubernetes.io/docs/concepts/containers/)
- [OCI Image Specification](https://github.com/opencontainers/image-spec)
- [Private image registries](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
- [EasyEnv's Persian Kubernetes course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
