@echo off
setlocal enabledelayedexpansion

REM Ambil baris version dari pubspec.yaml
for /f "tokens=2 delims=:" %%a in ('findstr /b "version:" pubspec.yaml') do (
    set "version=%%a"
)

REM Hapus spasi
set "version=%version: =%"

REM Pisahkan version dan build number (gunakan delayed expansion)
for /f "tokens=1,2 delims=+" %%a in ("%version%") do (
    set "app_version=%%a"
    set "build_number=%%b"
)

REM Aktifkan ekspansi variabel delay
set "app_name=G_SURE"

REM Gunakan delayed expansion untuk baca versi
echo Versi: !app_version!+!build_number!

REM Cek dan rename masing-masing APK hasil split
set "apk_base=build\app\outputs\flutter-apk"

set "apk_arm64=%apk_base%\app-arm64-v8a-release.apk"
set "apk_armeabi=%apk_base%\app-armeabi-v7a-release.apk"
set "apk_x86=%apk_base%\app-x86_64-release.apk"

if exist "!apk_arm64!" (
    copy /Y "!apk_arm64!" "!app_name!-v!app_version!-arm64.apk"
)

@REM if exist "!apk_armeabi!" (
@REM     copy /Y "!apk_armeabi!" "!app_name!-v!app_version!-armeabi.apk"
@REM )

@REM if exist "!apk_x86!" (
@REM     copy /Y "!apk_x86!" "!app_name!-v!app_version!-x86_64.apk"
@REM )

echo ✅ APK berhasil di-rename jika file ditemukan.
