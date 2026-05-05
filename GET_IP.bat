@echo off
REM Quick script to find your machine's IP address for MedExplain configuration
REM Run this and copy the IPv4 Address to AppConfig.apiBaseUrl

echo.
echo ========================================
echo Finding Your Machine IP Address
echo ========================================
echo.

ipconfig | findstr /R "IPv4 Address"

echo.
echo ========================================
echo Instructions:
echo ========================================
echo 1. Copy the IPv4 Address from above (e.g., 192.168.x.x)
echo 2. Open flutter_app/lib/config/app_config.dart
echo 3. Replace the apiBaseUrl value:
echo    static const String apiBaseUrl = 'http://YOUR_IP:8000/api/v1';
echo 4. Save and run: flutter run
echo.
pause
