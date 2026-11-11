# Images, Layers, and Registries
[Persian edition](../../../../../fa/kubernetes/02-containers/topics/images/README.md) · [Chapter references](../../../references/README.md#02-containers-and-images)

[فارسی](../../../../../fa/kubernetes/02-containers/topics/images/README.md) | [Chapter 02](../../README.md)

## From source code to an image

An image is a build artifact commonly made from filesystem layers. Dockerfile instructions can be cached. Place rarely changing dependency metadata before frequently changing source files so a source edit does not invalidate every previous layer. A multi-stage build keeps compiler and build dependencies out of the final image.

~~~dockerfile
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./
RUN npm ci --omit=dev
USER node
CMD ["node", "dist/server.js"]
~~~

This example assumes the project contains those Node.js files. For a real application, pin base images, exclude unnecessary files with .dockerignore, and copy only the runtime dependencies and built output.

## Tags, digests, and pull policy

A tag is readable but can be moved to different content. A digest identifies specific image content and is useful for recording an exact artifact. Kubernetes also uses imagePullPolicy; node caches and mutable tags can make results surprising. Establish one clear release policy.

For a private registry, attach an imagePullSecret in the workload namespace. Pull failures can come from a typo, missing permission, expired credentials, CA/TLS problems, or network failure. Pod events usually give the first clue.

## Supply-chain security

- Do not place secrets in the Dockerfile, build layer, or source repository.
- Scan dependencies and images and record artifact provenance.
- Use trusted, maintained base images.
- Run as a non-root user when the application supports it.
- Signing and admission policy can require approved artifacts.

## Practice and quiz

1. **Why can a floating tag be risky in production?** Its content can change, making rebuilds and precise rollback harder.
2. **How does ImagePullBackOff differ from CrashLoopBackOff?** The first cannot prepare the image; the second starts the container, which then exits repeatedly.
3. **Why use a multi-stage build?** Keep build tools and unneeded dependencies out of the runtime image.
4. **Where should secrets live?** In an appropriate secret manager or secure delivery mechanism, not image layers.
5. **Exercise:** use a deliberately invalid image tag, read the events, correct it, and observe rollout status.

## Further reading

- [Kubernetes image concepts](https://kubernetes.io/docs/concepts/containers/images/)
- [Pull an image from a private registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
- [OCI Image Specification](https://github.com/opencontainers/image-spec)
- [Kubernetes image security and supply-chain guidance](https://kubernetes.io/docs/concepts/security/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
