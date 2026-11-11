<div dir="ltr" align="left">

# Install, Run, and Connect to Redis

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [نصب، اجرا و اتصال](./README.md)

## Learning objective

Start a safe local Redis environment and distinguish the server process from a command-line client.

## The lesson

Redis is primarily developed and tested on Linux and macOS. Docker makes the version and lifecycle of a learning environment explicit. `redis-server` is the service; `redis-cli` is a client that sends commands. For a lab, publish the port only on localhost. Pin a version for a repeatable exercise; separately verify the version selected for production.

## Which environment should I install?

Keep these three parts distinct:

- **Image/package:** server and tool files, such as the official Docker image or an operating-system package.
- **Server process:** the process listening on a port and executing commands.
- **Client:** a tool such as `redis-cli` or an application library.

On Windows, this course recommends Docker Desktop; do not bind the Redis port to a public network interface. WSL2 can provide a Linux environment, but one container is enough to start. On Linux, install through a package manager or official instructions; the distribution repository can lag behind current Redis releases. On macOS, a package manager is also an option. Check the package source and exact version in every environment.

Example for Debian/Ubuntu distribution packages:

```bash
sudo apt update
sudo apt install redis-server
sudo systemctl enable --now redis-server
redis-cli PING
```

A successful result is `PONG`. Run these commands only on your own Linux machine; `enable` configures automatic service startup. On a shared host, do not expose default settings to a network without review.

## Step-by-step Docker lab

Lesson zero created a container named `redis-course`. This lesson uses `redis-lab` for its separate exercise. Keep the `127.0.0.1` binding so only this host can access the lab:

```powershell
docker run --name redis-lab -p 127.0.0.1:6379:6379 -d redis:8
docker ps --filter name=redis-lab
docker exec redis-lab redis-cli PING
docker exec redis-lab redis-cli INFO server
docker logs redis-lab
```

In port mapping, the left number is the computer's port and the right number is the port inside the container. If host port 6379 is already in use, map 6380 on the left:

```powershell
docker run --name redis-lab -p 127.0.0.1:6380:6379 -d redis:8
docker exec redis-lab redis-cli PING
```

`docker exec` reaches the port inside the container. If you use a client from the host, target port 6380, the left side of the mapping. If the container fails to start, inspect `docker logs`; do not resolve a name conflict by blindly removing a container.

For exact team reproducibility, pin a patch tag or digest and record it in the project README. `redis:8` is convenient for learning but may download a different patch image later. A production image, configuration, and rollout method require review.

## Difference between stop, start, and remove

- `stop` stops the container process; the container remains.
- `start` runs the same container again.
- `rm` removes the container.
- A volume has a separate lifecycle; removing a container does not necessarily remove its volume.

This lab has no volume. Removing `redis-lab` also removes the data in that container. Run cleanup commands only for the named lab container.

## Example and experiment

```powershell
docker run --name redis-lab -p 127.0.0.1:6379:6379 -d redis:8
docker exec -it redis-lab redis-cli PING
docker stop redis-lab
docker rm redis-lab
```

`stop` stops the container process; `rm` removes this lab container and, because there is no volume, also removes its lab data.

## Practical pattern

Ephemeral environments are common for development, while production commonly uses Linux or a managed service. This is a general engineering pattern, not a claim about a named company.

## Common mistakes

- Publishing the port on every network interface.
- Putting passwords in shell history.
- Assuming container removal and volume removal are the same thing.

## Practice

1. Run the example in a local Redis environment and explain the result.
2. Write two failure modes or edge cases.
3. Estimate workload size, read/write rate, TTL/retention, and outage behavior.
4. Choose a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. What is `redis-cli`?

<details><summary>Answer</summary>

A client for connecting to Redis and sending commands, not a datastore.

</details>

### 2. Why bind the lab port to `127.0.0.1`?

<details><summary>Answer</summary>

So the lab Redis is not reachable from other machines.

</details>

### 3. Why pin a version?

<details><summary>Answer</summary>

For repeatability and controlled upgrades.

</details>

## Published deployment example

AWS’s DBS Bank case study describes using Amazon ElastiCache for Redis in pricing workloads. It is a real managed-service deployment context: clients connect to a provisioned service endpoint, while the provider operates the Redis service. It does not describe the local Docker workflow in this lesson and does not prove that every pricing system should use Redis. [DBS Bank case study](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/)

## Further reading

- [Install Redis](https://redis.io/docs/latest/operate/oss_and_stack/install/)
- [Redis CLI](https://redis.io/docs/latest/develop/tools/cli/)
- [Official Redis Docker image](https://hub.docker.com/_/redis)
- [Redis release and upgrade guidance](https://redis.io/docs/latest/operate/oss_and_stack/management/upgrade/)
- [DNTips Redis overview in Persian (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [Persian video on Redis basic commands](https://www.youtube.com/watch?v=e5Q_RUwviaE)

For specialized features, the official documentation for the version you run is the reference. Persian coverage varies, so this lesson includes a complete local lab.

</div>
