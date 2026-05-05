# 🔧 MedExplain Network Configuration Guide

## ❌ Problem: Network Error During Registration

When trying to register on the mobile app, you see a network error message like:
```
Network error. Please check your connection.
```

### Root Cause
The Flutter app was hardcoded to connect to `http://localhost:8000`, which on a mobile device refers to the **device itself**, not your development PC where the backend is running.

---

## ✅ Solution: Update Your Machine's IP Address

### Step 1: Find Your PC's IP Address

#### On Windows (Recommended)
1. Open **Command Prompt** (press `Win + R`, type `cmd`, press Enter)
2. Type the following command:
   ```
   ipconfig
   ```
3. Look for **"IPv4 Address"** under your active network adapter
4. Copy the address (typically looks like: `192.168.x.x` or `10.0.x.x`)

**Example Output:**
```
Ethernet adapter Local Area Connection:
   IPv4 Address . . . . . . . . . . . : 192.168.220.108
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
```

#### Alternative: Find IP via Network Settings
1. Go to **Settings** → **Network & Internet** → **Wi-Fi** (or Ethernet)
2. Click **Properties**
3. Scroll down to find **IPv4 address**

---

### Step 2: Update the App Configuration

1. Open this file in VS Code:
   ```
   flutter_app/lib/config/app_config.dart
   ```

2. Find this line (around line 13):
   ```dart
   static const String apiBaseUrl = 'http://192.168.220.108:8000/api/v1';
   ```

3. **Replace `192.168.220.108` with YOUR actual IP address** from Step 1

4. Save the file (Ctrl + S)

---

### Step 3: Rebuild and Run the App

1. In VS Code terminal, run:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Or hot reload with **`r`** if the app is still running

---

## 🎯 Quick Reference

### IP Address Formats

| Device Type | Example IP | Use Case |
|-------------|-----------|----------|
| PC on WiFi | `192.168.1.100` | Most common - use this! |
| PC on LAN | `10.0.0.50` | Corporate networks |
| Localhost (WRONG) | `127.0.0.1` | ❌ Don't use for mobile |
| Android Emulator | `10.0.2.2` | ✅ If using Android Studio emulator |

### Configuration Verification

After updating, the app logs will show:
```
[ApiService] Base URL changed to: http://192.168.220.108:8000/api/v1
[AppConfig] Configuration OK: http://192.168.220.108:8000/api/v1
```

---

## 🐛 Troubleshooting

### "Still getting network error after updating IP"

**Check 1:** Verify backend is running
```bash
# In another terminal, go to backend folder
cd backend
python -m uvicorn app:app --host 0.0.0.0 --port 8000
# Should show: "Uvicorn running on http://0.0.0.0:8000"
```

**Check 2:** Test connectivity
- Open browser on your phone
- Try: `http://YOUR_IP:8000/docs`
- You should see API documentation

**Check 3:** Ensure device and PC are on same network
- Check both are connected to same WiFi/LAN
- Ping test: `ping 192.168.x.x` from PC to verify network

### "Timeout errors"
- Firewall may be blocking. Check Windows Firewall settings
- Allow Python/Uvicorn through firewall

### "Connection refused"
- Backend server not running (see Check 1 above)
- Wrong IP address entered
- Port 8000 not accessible

---

## 📱 Special Cases

### Android Emulator (Android Studio)
If using Android emulator instead of physical device:
```dart
static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';
```
(10.0.2.2 is special IP for Android emulator to reach host machine)

### Multiple Development Environments

If you need to switch between environments, use the method:
```dart
// Dynamically change URL at runtime
ApiService.setBaseUrl('http://NEW_IP:8000/api/v1');
```

---

## 🎓 How It Works

1. **Backend**: Runs on your PC, listens on `0.0.0.0:8000`
2. **Mobile App**: Needs to reach your PC's actual IP address
3. **Configuration**: App reads from `AppConfig.apiBaseUrl` on startup
4. **API Service**: Uses the configured URL for all network requests

---

## ✨ Need Help?

- **Backend not running?** Start it: `python -m uvicorn app:app --host 0.0.0.0 --port 8000`
- **Don't know your IP?** Run `ipconfig` in Command Prompt and find IPv4 Address
- **CORS Error?** Backend config already allows all origins in development mode
- **Still stuck?** Check the console logs in `flutter run` output for detailed error messages

