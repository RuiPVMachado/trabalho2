CREATE TABLE current_score (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    value INTEGER NOT NULL,
    timestamp TEXT NOT NULL
);

CREATE TABLE ranking (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    value INTEGER NOT NULL,
    timestamp TEXT NOT NULL
);

-- Inicializa o score atual com 0
INSERT INTO current_score (value, timestamp) VALUES (0, datetime('now')); 