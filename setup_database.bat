@echo off
REM Hospital Management System - Database Setup Script for Windows
REM This script creates the database and runs the schema

echo ========================================
echo Hospital Management System
echo Database Setup Script
echo ========================================
echo.

REM Set PostgreSQL credentials (modify if needed)
set PGUSER=postgres
set PGPASSWORD=m
set PGHOST=localhost
set PGPORT=5432
set DBNAME=hospital_db

echo Please ensure PostgreSQL is running before continuing.
echo.
echo Current settings:
echo   Host: %PGHOST%
echo   Port: %PGPORT%
echo   User: %PGUSER%
echo   Database: %DBNAME%
echo.
pause

REM Check if psql is available
where psql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: psql command not found!
    echo Please add PostgreSQL bin directory to your PATH.
    echo Typical location: C:\Program Files\PostgreSQL\16\bin
    echo.
    pause
    exit /b 1
)

echo.
echo Step 1: Checking if database exists...
psql -U %PGUSER% -h %PGHOST% -p %PGPORT% -lqt | findstr /C:"%DBNAME%" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Database '%DBNAME%' already exists.
    echo.
    set /p recreate="Do you want to drop and recreate it? (y/n): "
    if /i "%recreate%"=="y" (
        echo Dropping existing database...
        psql -U %PGUSER% -h %PGHOST% -p %PGPORT% -c "DROP DATABASE IF EXISTS %DBNAME%;" postgres
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Failed to drop database!
            pause
            exit /b 1
        )
        echo Database dropped successfully.
    ) else (
        echo Skipping database creation.
        goto :schema
    )
)

echo.
echo Step 2: Creating database '%DBNAME%'...
psql -U %PGUSER% -h %PGHOST% -p %PGPORT% -c "CREATE DATABASE %DBNAME%;" postgres
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create database!
    pause
    exit /b 1
)
echo Database created successfully!

:schema
echo.
echo Step 3: Running schema.sql...
if not exist "database\schema.sql" (
    echo ERROR: schema.sql not found in database folder!
    pause
    exit /b 1
)

psql -U %PGUSER% -h %PGHOST% -p %PGPORT% -d %DBNAME% -f "database\schema.sql"
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to run schema.sql!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Database setup completed successfully!
echo ========================================
echo.
echo Database: %DBNAME%
echo Tables created:
echo   - users
echo   - departments
echo   - doctors
echo   - appointments
echo   - medical_records
echo.
echo Sample data has been inserted.
echo.
echo You can now:
echo 1. Update database credentials in src\main\resources\database.properties
echo 2. Build the project with: mvn clean package
echo 3. Deploy to Tomcat
echo.

REM Verify tables were created
echo Verifying database setup...
psql -U %PGUSER% -h %PGHOST% -p %PGPORT% -d %DBNAME% -c "\dt"

echo.
echo Press any key to exit...
pause >nul
