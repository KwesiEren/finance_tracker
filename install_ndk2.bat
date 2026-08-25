@echo off
cd /d C:\Android\SDK\cmdline-tools\latest\bin
echo y | sdkmanager.bat --sdk_root=C:\Android\SDK "ndk;27.0.12077973"