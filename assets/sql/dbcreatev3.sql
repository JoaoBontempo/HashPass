CREATE TABLE senha (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT,
    credencial TEXT,
    senhaBase TEXT,
    avancado INTEGER,
    algoritmo INTEGER,
    criptografado INTEGER,
    leakCount INTEGER
)