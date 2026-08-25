@echo off
setlocal
set JAVA_HOME=C:\Program Files\Java\jdk-17.0.19
set PATH=%JAVA_HOME%\bin;%PATH%
cd /d %~dp0
call android\gradlew.bat assembleDebug