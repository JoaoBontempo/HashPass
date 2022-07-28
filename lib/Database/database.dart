const String DB_NAME = 'hashpass_db';

const String SENHA_TABLE_NAME = "senha";

const String SENHA_ID_NAME = 'id';
const String SENHA_TITULO_NAME = 'titulo';
const String SENHA_CREDENCIAL_NAME = 'credencial';
const String SENHA_SENHA_BASE_NAME = 'senhaBase';
const String SENHA_AVANCADO_NAME = 'avancado';
const String SENHA_ALGORITMO_NAME = 'algoritmo';
const String SENHA_CRIPTOGRAFADO_NAME = 'criptografado';
const String PASSWORD_LEAK_COUNT = 'leakCount';

const String CREATE_TABLE_SENHA = ''' 
    CREATE TABLE $SENHA_TABLE_NAME (
      $SENHA_ID_NAME INTEGER PRIMARY KEY AUTOINCREMENT,
      $SENHA_TITULO_NAME TEXT,
      $SENHA_CREDENCIAL_NAME TEXT,
      $SENHA_SENHA_BASE_NAME TEXT,
      $SENHA_AVANCADO_NAME INTEGER,
      $SENHA_ALGORITMO_NAME INTEGER,
      $SENHA_CRIPTOGRAFADO_NAME INTEGER,
      $PASSWORD_LEAK_COUNT INTEGER
    )
  ''';
