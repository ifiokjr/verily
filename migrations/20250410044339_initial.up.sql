-- Enable WAL mode for better concurrency and performance
PRAGMA journal_mode = wal;

-- Ensure foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Increase cache size (in KB) for better performance
PRAGMA cache_size = -2000000;

-- Uses 2GB of RAM for cache
-- Enable memory-mapped I/O for faster reads
PRAGMA mmap_size = 30000000000;

-- 30GB
-- Set temp store to memory for faster temp operations
PRAGMA temp_store = memory;

-- Enable auto_vacuum to keep the database file size in check
PRAGMA auto_vacuum = incremental;

-- Set page size (must be power of 2, default is 4096)
PRAGMA page_size = 4096;
