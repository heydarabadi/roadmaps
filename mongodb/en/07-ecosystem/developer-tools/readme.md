# Developer Tools: mongosh, Compass, and Database Tools

> **Persian edition:** [Read this lesson in Persian](../../../07-ecosystem/developer-tools/readme.md).

> **Learning goal:** Select the right tool for exploration, repeatable commands, data movement, and recovery.

## Tool roles

- **`mongosh`:** interactive shell and scripts for commands, inspection, and repeatable administrative tasks.
- **Compass:** visual collection browser, query builder, aggregation editor, index UI, and schema exploration.
- **Database Tools:** CLI utilities for importing, exporting, dumping, and restoring data.
- **Atlas UI:** managed deployment settings, users, network access, metrics, backups, and other hosted features.
- **Language drivers:** application code paths. Keep production behavior here rather than depending on a manual GUI action.

Use the tool whose output can be reviewed and repeated. Save important schema/index changes as scripts or migrations. Compass is useful for discovery, but an undocumented click is not a reliable deployment procedure.

## Import and export safety

Before using `mongoimport`, `mongoexport`, `mongodump`, or `mongorestore`, confirm the URI, database, collection, namespace mapping, and destructive options. Keep dumps encrypted and access-controlled. Production dumps often contain personal or confidential data; mask or minimize them before copying to a development workstation.

The operations lab uses a seed script that drops and rebuilds only its named learning collections. Run it only against a disposable database.

~~~bash
mongosh "mongodb://localhost:27017" labs/02-operations/seed.mongosh.js
~~~

## Runbook for a risky tool operation

1. Print or inspect the target URI without exposing its password.
2. Confirm the expected environment and database name.
3. Preview the selection and count affected documents.
4. Use a dry run or isolated restore when available.
5. Save a backup or export with a recovery plan.
6. Run the operation and record the result.
7. Verify application behavior and remove temporary sensitive files safely.

## Common mistakes

- Running a seed script against production.
- Importing with an unintended namespace or overwrite flag.
- Copying a production dump to an unsecured device.
- Treating GUI edits as a repeatable migration.
- Assuming a command-line backup is valid without restoring it.

## Exercises

1. Write an import runbook with target checks, preview, backup, and rollback.
2. Explain how you would anonymize production data for a development environment.
3. Choose between Compass, mongosh, Database Tools, and a driver for four tasks.

## Quiz and answer key

1. **What is `mongosh` for?** Interactive commands and scripts.
2. **What is Compass for?** Visual exploration and query/index/aggregation workflows.
3. **Which tools perform logical dump and restore?** MongoDB Database Tools such as `mongodump` and `mongorestore`.
4. **Why avoid copying an unprotected production dump to a workstation?** It may contain sensitive data; minimize or mask it and protect access, encryption, and retention.
5. **Applied task: write a safe import runbook.** Verify target, preview, backup, use a dry run or isolated environment, run with explicit namespace, and validate afterward.
6. **Are Compass changes automatically version controlled?** No; capture important changes in repeatable scripts or migrations.
7. **What should be checked before restore?** URI, target database, namespace mapping, overwrite behavior, and backup integrity.
8. **Why protect backup files?** They may contain the full sensitive dataset.
9. **Why run the lab seed script only in learning DB?** It drops and recreates its target collections.
10. **What proves a backup tool works?** A successful restore drill and validation, not only a completed dump command.

## Further reading

- [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)
- [MongoDB Compass](https://www.mongodb.com/docs/compass/current/)
- [MongoDB Database Tools](https://www.mongodb.com/docs/database-tools/)
- [mongodump](https://www.mongodb.com/docs/database-tools/mongodump/)
- [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/)
- [Atlas Get Started](https://www.mongodb.com/docs/atlas/getting-started/)
- [Persian MongoDB learning series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: tools](../../reference-library.md#foundations-tools)

---
Sources reviewed: 2026-11-11. Tool flags and Atlas UI labels can change by version.
