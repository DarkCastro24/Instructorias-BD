CREATE DATABASE DB_Gimnasio;

USE DB_Gimnasio;

EXEC('CREATE SCHEMA ref');

CREATE TABLE ref.Socio (
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(100),
	fecha_registro DATE
)

USE master;
GO

-- Primero crear directorio para logs si no existe (en C:\AuditLogs\Socios\), luego:

-- Crear Server Audit a nivel de servidor
CREATE SERVER AUDIT Audit_Socios
TO FILE (
    FILEPATH = 'C:\AuditLogs\',
    MAXSIZE = 20 MB,
    MAX_FILES = 20
)
WITH (
    ON_FAILURE = CONTINUE,
    QUEUE_DELAY = 1000
);
GO

ALTER SERVER AUDIT Audit_Socios WITH (STATE = ON);

PRINT 'Server Audit creado y activado';
GO

-- Crear Database Audit Specification
USE DB_Gimnasio;
GO

CREATE DATABASE AUDIT SPECIFICATION Audit_DB_Socio
FOR SERVER AUDIT Audit_Socios
    ADD (INSERT ON ref.Socio BY PUBLIC)
GO

-- Activar auditoria de base de datos
ALTER DATABASE AUDIT SPECIFICATION Audit_DB_Socio WITH (STATE = ON);
PRINT 'Database Audit Specification creada y activada';
GO

INSERT INTO ref.Socio (nombre, fecha_registro) 
VALUES 
('Juan Manual Gonzalez River', '2024-01-15'),
('Camina Maria Morataya Velazquez', '2024-02-20');

INSERT INTO ref.Socio (nombre, fecha_registro) 
VALUES 
('Kenia Melissa Ayala Santos', '2021-09-05'),
('Karla Maria Gomez Velazquez', '2024-01-26');

-- 6. Consulta de auditoria
SELECT
	event_time,
	action_id,
	succeeded,
	server_principal_name,
	database_name,
	schema_name, object_name,
	statement
FROM sys.fn_get_audit_file('C:\AuditLogs\*', DEFAULT, DEFAULT)
ORDER BY event_time DESC;

