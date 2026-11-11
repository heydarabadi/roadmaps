<div dir="ltr" align="left">

# Lesson Zero — Lab Setup and How to Use This Course

> Persian edition: [درس صفر — محیط آزمایش و روش این دوره](./README.md)

This lesson establishes the tools and conventions used throughout the course. We will first run Redis locally. Never run the course's destructive or configuration-changing commands against a production service or important data.

## Prerequisites

- Ability to open PowerShell on Windows.
- Docker Desktop running and usable, or Docker Engine on Linux/macOS.
- Internet access to download the image the first time.
- Basic familiarity with text, keys/values, and JSON.

You do not need a native Windows Redis installation. Docker gives us a repeatable lab. After startup, read the exact server version from Redis; a moving version-family tag can point to a newer patch release later.

## Start a private lab

Run this in PowerShell:

```powershell
docker run --name redis-course -p 127.0.0.1:6379:6379 -d redis:8
```

What each part means:

- `docker run` creates and starts a container.
- `--name redis-course` gives it a predictable name for the lessons.
- `-p 127.0.0.1:6379:6379` publishes Redis only on this computer. Do not publish it on `0.0.0.0` for this lab.
- `-d` runs it in the background.
- `redis:8` uses the official Redis image from the 8.x family.

Docker prints a long container ID. Check its state and logs:

```powershell
docker ps --filter name=redis-course
docker logs redis-course
```

If a container with this name already exists, Docker reports a name conflict. Do not remove it automatically. First check that it is the course container:

```powershell
docker ps -a --filter name=redis-course
```

## Connect and send your first commands

Open `redis-cli` inside the container:

```powershell
docker exec -it redis-course redis-cli
```

The prompt usually looks like `127.0.0.1:6379>`. Enter:

```text
PING
PONG
SET greeting "Salam Redis"
OK
GET greeting
"Salam Redis"
```

The client sends `PING` and the server replies `PONG`. `SET` stores a value under the `greeting` key, and `GET` returns it. Redis also stores UTF-8 Persian text:

```text
SET greeting:fa "سلام ردیس"
GET greeting:fa
"سلام ردیس"
```

Exit the CLI with `QUIT`, or press Ctrl+C in PowerShell. You can also issue a one-shot command from PowerShell:

```powershell
docker exec redis-course redis-cli PING
```

Expected output: `PONG`.

## Check version and health

This command reads server information:

```powershell
docker exec redis-course redis-cli INFO server
```

Find `redis_version` in the output and write it down. Version-sensitive lessons refer to this value. To print only the version line:

```powershell
docker exec redis-course redis-cli INFO server | Select-String redis_version
```

If you do not receive `PONG`, check in this order:

1. Is Docker Desktop or Docker Engine running?
2. Does `docker ps` show the container?
3. Does `docker logs redis-course` show a startup error?
4. Is another program already using port 6379?
5. Did you spell the container name correctly?

If the port is occupied, do not stop unrelated services. Map host port 6380 to container port 6379 instead: `-p 127.0.0.1:6380:6379`, then connect to port 6380.

## Stop, restart, and clean up

Stopping the container does not remove it:

```powershell
docker stop redis-course
docker start redis-course
docker exec redis-course redis-cli PING
```

When you finish the course lab, remove only that named container:

```powershell
docker rm -f redis-course
```

This targets the container named `redis-course`. Do not run `docker system prune` or remove shared Docker volumes for this course; those operations may delete data belonging to other projects. This lab has no separate volume, so removing the container also removes its unpersisted lab data.

## Four terms to keep separate

- **Server:** the Redis process that listens on a port, executes commands, and holds data.
- **Client:** a program such as `redis-cli` that sends commands to the server.
- **Redis database:** a logical space selected inside one server; it is not a separate server.
- **Key:** a name used to locate a value or data structure.

## Practice with answers

1. Start the container, send `PING`, create a key, and read it.
2. Inspect `INFO server` and note the version.
3. Stop and start the container, then inspect the value again.
4. At the end, remove only `redis-course`.

**Expected result:** `PING` returns `PONG`, `SET` returns `OK`, and `GET` returns the stored value. A value may still exist after stop/start with the image's default configuration; do not rely on that behavior in later lessons, because persistence files and container lifecycle can change it. Removing this container without a volume removes this lab's data.

## Next step

Read [Chapter 1: Foundations](../01-foundations/README.md), then return to [installation and `redis-cli`](../02-getting-started/README.md). Look up terminology in the [glossary](../GLOSSARY.md) and commands in the [quick reference](../QUICK-REFERENCE.md).

## Further reading

- [Install Redis](https://redis.io/docs/latest/operate/oss_and_stack/install/)
- [Redis CLI](https://redis.io/docs/latest/develop/tools/cli/)
- [Official Redis Docker image](https://hub.docker.com/_/redis)
- [Redis protocol specification](https://redis.io/docs/latest/develop/reference/protocol-spec/)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
