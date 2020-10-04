require 'sqlite3'

STORAGE_FILE_NAME = 'cache.db'

def connect_to_storage
  db = SQLite3::Database.open(STORAGE_FILE_NAME)

  db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS quotations (
      symbol TEXT,
      date TEXT,
      ratio FLOAT,
      UNIQUE(symbol, date)
    );
  SQL
  db
end
