require 'sqlite3'

STORAGE_FILE_NAME = 'cache.db'

File.delete(STORAGE_FILE_NAME) if File.exist?(STORAGE_FILE_NAME)

db = SQLite3::Database.new(STORAGE_FILE_NAME)

# Create a table
rows = db.execute <<-SQL
  CREATE TABLE euro_quotations (
    symbol TEXT,
    date TEXT,
    ratio FLOAT
  );
SQL
