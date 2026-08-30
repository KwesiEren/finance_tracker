@echo off
REM Requires JDK 17 via JAVA_HOME and Android SDK
REM Release AAB for Play Store (com.fused, signed via android/key.properties)
setlocal
if not defined JAVA_HOME set JAVA_HOME=C:\Program Files\Java\jdk-17.0.19
echo JAVA_HOME=%JAVA_HOME%
call flutter build appbundle --release
if errorlevel 1 (
  echo Build failed
  exit /b 1
)
echo Release AAB at build\app\outputs\bundle\release\app-release.aab
