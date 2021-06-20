# rpuk_migrate

A collection of migration tools needed to be run when we change how scripts function. You usally need to run the latest SQL file before running any migration.

## Commands

### /migrate_kashacters1

Migrates identifier column in the users table if the identifier string starts with "Char". It will append the character index in a sepeate column and replace the identifier to be the regular steam hex. It will also alter gcphone tables

### /migrate_kashacters2

Run /migrate_kashacters1 first! After all the identifiers starting with "Char" has been migrated you must also migrate the characters with identifiers starting with "steam:" since it also doesn't have a character index provided by kashacters. The migration tool will assign a available character index to the identifier with no character index. It will also alter gcphone tables
