ALTER TABLE senha RENAME COLUMN titulo TO title;
ALTER TABLE senha RENAME COLUMN credencial TO credential;
ALTER TABLE senha RENAME COLUMN senhaBase TO basePassword;
ALTER TABLE senha RENAME COLUMN avancado TO isAdvanced;
ALTER TABLE senha RENAME COLUMN algoritmo TO hashAlgorithm;
ALTER TABLE senha RENAME COLUMN criptografado TO useCriptography