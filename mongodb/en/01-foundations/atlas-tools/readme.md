# Atlas, Installation, and Development Tools

> **Persian edition:** [Read this lesson in Persian](../../../01-foundations/atlas-tools/readme.md).

> **Learning goal:** Set up a disposable environment and connect safely from the shell, GUI, or application.

## Choose a learning environment

For the basic lessons, use a local MongoDB Server or a temporary Atlas development deployment. Keep learning, test, and production environments separate. Use a dedicated practice database named `learning`, and do not paste real customer data into a course environment.

Atlas is a managed database service. It can provision a cluster and provide dashboards and operational features, but it does not remove the need to choose good data models, secure users, limit network access, or test recovery. A local installation is useful for shell practice and offline work. Compare the server version and topology with what a lesson assumes.

## The common tools

- **`mongosh`:** an interactive shell and JavaScript scripting environment for issuing commands.
- **MongoDB Compass:** a desktop GUI for browsing collections, filtering, aggregation, indexes, and schema exploration.
- **MongoDB Database Tools:** command-line programs such as `mongodump`, `mongorestore`, `mongoimport`, and `mongoexport` for data movement and backup tasks.
- **Language driver:** an application's supported library for connections, BSON conversion, pooling, and operations.
- **Atlas UI:** cloud interface for deployments, users, network rules, metrics, backups, and Search indexes.

Use Compass for exploration, but keep repeatable application behavior in version-controlled code or migration scripts. A manual GUI change is difficult to review and reproduce.

## Connect safely to Atlas

1. Create a development project and cluster.
2. Create a database user with only the permissions needed for the exercise.
3. Add the current development IP to the network access list. Avoid opening access to the entire Internet.
4. Copy the connection string and replace placeholders locally.
5. Store the URI in a secret manager or local environment variable, never in Git or logs.
6. Connect with `mongosh` or an official driver and verify the expected database name.
7. Delete the temporary cluster or remove access after the exercise if it is no longer needed.

~~~bash
mongosh "mongodb+srv://<user>:<password>@<cluster-host>/learning"
~~~

Treat the URI as a credential. If it is exposed, rotate the password and review access logs. TLS certificate verification should remain enabled.

## Local shell example

~~~javascript
use learning
db.healthcheck.insertOne({ name: "first-run", ok: true, createdAt: new Date() })
db.healthcheck.find({ ok: true })
~~~

The shell's `use learning` changes the current database context; it does not automatically create a collection. The insert creates the collection when needed.

## Troubleshooting connection failures

- **Authentication failed:** verify username, password encoding, authentication database, and user permissions.
- **Server selection timed out:** check DNS/SRV resolution, network access rules, firewall, deployment health, and the URI.
- **TLS error:** check system clock, certificate chain, CA configuration, and hostname; do not disable certificate verification as a workaround.
- **Connected to the wrong database:** inspect the URI path and run `db.getName()`.
- **Commands differ:** check shell, server, and driver versions; some syntax is not interchangeable.

## Exercise

Write a short setup checklist for local, test, and production environments. For each one, name the database user, network rule, secret source, backup owner, and cleanup method. Do not put an actual credential in the exercise file.

## Common mistakes

- Committing a URI with a password into source control.
- Allowing every network address for convenience.
- Using an administrator account for the application.
- Treating Compass edits as a reproducible migration.
- Connecting a tutorial seed script to a real database.

## Quiz and answer key

1. **What is `mongosh` for?** Interactive commands and shell scripts.
2. **What is Compass for?** GUI-based inspection and development workflows.
3. **What permission should the application user receive?** Only the roles needed for its collections and actions.
4. **Why must a URI with a password stay out of Git and logs?** Anyone who obtains it may gain database access; rotate exposed credentials and restrict permissions.
5. **Applied task: design dev/test/prod access.** Give each environment separate credentials and scoped network access; store secrets outside source code and define ownership and cleanup.
6. **Does `use learning` create all collections?** No. It changes shell context; collections are created when needed.
7. **What should remain enabled when connecting securely?** TLS certificate and hostname verification.
8. **Why separate environments?** To prevent practice changes or test data from affecting production and to control access independently.
9. **Which tool handles BSON dump/restore tasks?** MongoDB Database Tools, including `mongodump` and `mongorestore`.
10. **What should you check if a connection times out?** DNS, network rules, firewall, URI, and deployment health.

## Further reading

- [Atlas Get Started](https://www.mongodb.com/docs/atlas/getting-started/)
- [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)
- [MongoDB Compass](https://www.mongodb.com/docs/compass/current/)
- [MongoDB Database Tools](https://www.mongodb.com/docs/database-tools/)
- [MongoDB University](https://learn.mongodb.com/)
- [Persian MongoDB learning series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: Atlas and tools](../../reference-library.md#foundations-tools)

---
Sources reviewed: 2026-11-11. Setup screens and available cluster features can change.
