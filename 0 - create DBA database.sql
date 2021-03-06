USE [master];

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'DBA')
BEGIN
    ALTER DATABASE DBA SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DBA;
END

CREATE DATABASE DBA;
GO