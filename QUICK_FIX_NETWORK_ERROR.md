# ⚡ QUICK FIX: Network Error During Registration

## 🎯 3-Step Solution

### Step 1: Get Your PC's IP Address
1. Press `Win + R`, type `cmd`, press Enter
2. Type: `ipconfig`
3. **Find and copy** the IPv4 Address (looks like `192.168.x.x`)

Example:
```
IPv4 Address . . . . . . . . . . . : 192.168.220.108
```

---

### Step 2: Update App Configuration
1. Open this file:
   ```
   flutter_app/lib/config/app_config.dart
   ```

2. Find line 13:
   ```dart
   static const String apiBaseUrl = 'http://192.168.220.108:8000/api/v1';
   ```

3. Replace `192.168.220.108` with **YOUR** IP from Step 1

4. Save (Ctrl + S)

---

### Step 3: Rebuild & Run
```bash
flutter clean
flutter pub get
flutter run
```

---

## ✅ Verify It Works

After app launches, check console for:
```
[AppConfig] Configuration OK: http://192.168.220.108:8000/api/v1
```

Try registering again - network error should be gone! ✨

---

## 📋 Checklist

- [ ] Found IPv4 Address using `ipconfig`
- [ ] Updated `app_config.dart` with your IP
- [ ] Ran `flutter clean && flutter pub get`
- [ ] Ran `flutter run`
- [ ] Backend server is running (`python -m uvicorn app:app --host 0.0.0.0 --port 8000`)
- [ ] Device and PC on same WiFi network
- [ ] Registration now working!

---

## 🆘 Still Not Working?

### Backend not running?
```bash
cd backend
python -m uvicorn app:app --host 0.0.0.0 --port 8000
```
Should show: `Uvicorn running on http://0.0.0.0:8000`

### Wrong IP?
Re-run `ipconfig` and verify the IPv4 Address matches what's in `app_config.dart`

### Firewall blocking?
- Windows Firewall may block port 8000
- Go to Windows Defender Firewall → Allow an app → Add Python/Uvicorn

### Test connectivity:
Open phone browser and visit: `http://YOUR_IP:8000/docs`
Should show Swagger API docs

---

## 📚 For More Details
See: `NETWORK_CONFIGURATION_GUIDE.md`
