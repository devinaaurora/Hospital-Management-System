@echo off
REM Hospital Management System - Quick Start Script
REM This script builds and runs the application with embedded Tomcat 10

echo ========================================
echo Hospital Management System
echo Quick Start Script
echo ========================================
echo.

REM Check if Maven is available
where mvn >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven (mvn) command not found!
    echo Please install Maven and add it to your PATH.
    echo Download from: https://maven.apache.org/download.cgi
    echo.
    pause
    exit /b 1
)

echo Step 1: Cleaning and building project...
call mvn clean package
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Build failed!
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build successful!
echo ========================================
echo.
echo Step 2: Starting embedded Tomcat 10 server...
echo.
echo Application will be available at:
echo   http://localhost:8080/hospital/
echo.
echo Press Ctrl+C to stop the server
echo.
echo ========================================
echo.

call mvn cargo:run
