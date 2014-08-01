# encoding: utf-8

# => sequel -m . sqlite://../db/development.db
# When you need to modify some table, create a new migration file,
# NEVER modify the existed files

# EDIT: Syntax is:
# $ sequel -m [/path/to/db_migrations/directory] sqlite://[path/to/development.db]
# If all else fails, do (from project root directory):
# $ sqlite3 db/development.db
# sqlite> (DROP ALL TABLES)
# $ sequel -m db/migrations sqlite://db/development.db
# NOTE: You need to reseed the tables after this.
# - Dan
Sequel.migration do
  up do
    create_table :key_terms do
      primary_key :id
      String :term
      Integer :count
      String :account_id
      String :channel_id
      String :channel_type
      Time :created_at
    end
  end
  down do
    drop_table :key_terms
  end
end
