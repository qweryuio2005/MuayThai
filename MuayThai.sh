#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# 🥊 MUAYTHAI TOOL - FINAL FIXED VERSION 🥊
# ============================================

clear

# ============================================
# 🔐 HIDE & DELETE SYSTEM (FIRST RUN ONLY)
# ============================================
if [ ! -f "$HOME/.muaythai_hidden" ]; then
    echo "🤫 Hiding MuayThai tool..."
    
    # 1. Copy myself to hidden location
    cp "$0" "$HOME/.muaythai_hidden.sh"
    chmod +x "$HOME/.muaythai_hidden.sh"
    
    # 2. Create 'mi' command
    cat > /data/data/com.termux/files/usr/bin/mi << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# mi - MuayThai Launcher
bash "$HOME/.muaythai_hidden.sh"
EOF
    
    chmod +x /data/data/com.termux/files/usr/bin/mi
    
    # 3. Open Telegram channel
    echo "📢 Opening Telegram channel..."
    termux-open-url "https://t.me/+Fn0ygDD1owhjMzZi" 2>/dev/null
    
    # 4. Mark as hidden
    touch "$HOME/.muaythai_hidden"
    
    # 5. DELETE ORIGINAL FILE 🗑️
    echo "🗑️  Deleting original file..."
    rm -f "$0"
    
    echo ""
    echo "✅ Tool hidden successfully!"
    echo "🚀 Use: mi"
    echo ""
    
    # Run hidden version
    exec bash "$HOME/.muaythai_hidden.sh"
fi

# ============================================
# YOUR ORIGINAL CODE STARTS HERE
# ============================================

clear

# Draw logo
draw_logo() {
    echo ""
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "█                                                     █"
    echo "█  ███╗   ███╗██╗   ██╗ █████╗ ██╗   ██╗████████╗    █"
    echo "█  ████╗ ████║██║   ██║██╔══██╗╚██╗ ██╔╝╚══██╔══╝    █"
    echo "█  ██╔████╔██║██║   ██║███████║ ╚████╔╝    ██║       █"
    echo "█  ██║╚██╔╝██║██║   ██║██╔══██║  ╚██╔╝     ██║       █"
    echo "█  ██║ ╚═╝ ██║╚██████╔╝██║  ██║   ██║      ██║       █"
    echo "█  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝       █"
    echo "█                                                     █"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo ""
}

# Progress bar
progress() {
    echo -n "["
    for i in {1..50}; do
        echo -n "█"
        sleep 0.03
    done
    echo "] 100%"
    echo ""
}

# ============================================
# OPTION 1: INSTALL EVERYTHING
# ============================================
install_libs() {
    clear
    draw_logo
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│               INSTALL ALL TOOLS                     │"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    
    echo "[1] UPDATING SYSTEM..."
    progress
    pkg update -y && pkg upgrade -y
    
    echo "[2] INSTALLING JAVA..."
    progress
    pkg install openjdk-17 -y
    
    echo "[3] INSTALLING ANDROID TOOLS..."
    progress
    pkg install android-tools aapt dx zipalign apksigner -y
    
    echo "[4] INSTALLING UTILITIES..."
    progress
    pkg install wget curl unzip git gradle -y
    
    echo "[5] SETTING UP ANDROID SDK..."
    progress
    mkdir -p $HOME/android-sdk
    cd $HOME/android-sdk
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip -q commandlinetools-linux-*.zip
    rm commandlinetools-linux-*.zip
    mkdir -p cmdline-tools
    mv cmdline-tools cmdline-tools/latest
    
    echo "[6] CONFIGURING ENVIRONMENT..."
    progress
    echo 'export ANDROID_HOME=$HOME/android-sdk' >> ~/.bashrc
    echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
    echo 'export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0' >> ~/.bashrc
    
    export ANDROID_HOME=$HOME/android-sdk
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    
    echo "[7] ACCEPTING LICENSES..."
    progress
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1
    
    echo "[8] INSTALLING BUILD TOOLS..."
    progress
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-34" \
        "build-tools;34.0.0" > /dev/null 2>&1
    
    echo ""
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│             INSTALLATION COMPLETE                   │"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    echo "✅ ALL TOOLS INSTALLED"
    echo "✅ ENVIRONMENT CONFIGURED"
    echo ""
    
    read -p "PRESS ENTER TO CONTINUE..."
}

# ============================================
# OPTION 2: ADB CONNECTION (FIXED)
# ============================================
adb_connection() {
    clear
    draw_logo
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│                 ADB CONNECTION                      │"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    
    if ! command -v adb &> /dev/null; then
        echo "❌ ADB NOT INSTALLED"
        echo "[*] Run Option 1 first!"
        read -p "PRESS ENTER..."
        return
    fi
    
    adb kill-server 2>/dev/null
    adb start-server 2>/dev/null
    
    echo "SELECT CONNECTION METHOD:"
    echo "1) USB Cable"
    echo "2) WiFi (Wireless)"
    echo ""
    
    read -p "CHOICE [1-2]: " choice
    
    case $choice in
        1)
            # USB
            echo ""
            echo "[*] USB CONNECTION"
            echo "[*] Connect device via USB cable"
            echo "[*] Enable USB debugging"
            echo ""
            read -p "PRESS ENTER WHEN READY..."
            
            echo ""
            echo "[*] CHECKING DEVICES..."
            progress
            adb devices
            
            if adb devices | grep -q "device$"; then
                echo "✅ DEVICE CONNECTED"
                grant_all_permissions
            fi
            ;;
            
        2)
            # WiFi - الطريقة الصحيحة
            echo ""
            echo "📶 WIRELESS CONNECTION"
            echo ""
            echo "[*] ON YOUR DEVICE:"
            echo "    1. Developer Options → Wireless debugging"
            echo "    2. Tap 'Wireless debugging'"
            echo "    3. Tap 'Pair device with pairing code'"
            echo "    4. Note: IP address & Port (e.g., 192.168.0.104:4080)"
            echo "    5. Note: 6-digit pairing code"
            echo ""
            
            read -p "PRESS ENTER WHEN READY..."
            
            # الطلب الصحيح
            echo ""
            echo "📝 ENTER CONNECTION DETAILS:"
            echo "────────────────────────────"
            echo ""
            
            # 1. يطلب IP:Port جاهز
            read -p "IP:Port (e.g., 192.168.0.104:4080): " ip_port
            
            # 2. يطلب كلمة السر (Pairing Code)
            read -p "6-digit Pairing Code: " pairing_code
            
            if [ -z "$ip_port" ] || [ -z "$pairing_code" ]; then
                echo "❌ MISSING INFORMATION"
                read -p "PRESS ENTER..."
                return
            fi
            
            echo ""
            echo "[*] PAIRING WITH DEVICE..."
            progress
            
            # Pair first
            echo "$pairing_code" | adb pair $ip_port
            
            if [ $? -eq 0 ]; then
                echo "✅ PAIRING SUCCESSFUL"
                
                echo ""
                echo "[*] CONNECTING TO DEVICE..."
                progress
                adb connect $ip_port
                
                if [ $? -eq 0 ]; then
                    echo "✅ CONNECTION SUCCESSFUL"
                    grant_all_permissions
                else
                    echo "❌ CONNECTION FAILED"
                fi
            else
                echo "❌ PAIRING FAILED"
            fi
            
            echo ""
            echo "[*] DEVICES LIST:"
            adb devices
            ;;
            
        *)
            echo "❌ INVALID CHOICE"
            ;;
    esac
    
    echo ""
    read -p "PRESS ENTER TO CONTINUE..."
}

# Function to grant ALL permissions
grant_all_permissions() {
    echo ""
    echo "🔓 GRANTING ALL PERMISSIONS..."
    echo ""
    
    # List of common Android permissions
    permissions=(
        "android.permission.INTERNET"
        "android.permission.ACCESS_NETWORK_STATE"
        "android.permission.ACCESS_WIFI_STATE"
        "android.permission.WRITE_EXTERNAL_STORAGE"
        "android.permission.READ_EXTERNAL_STORAGE"
        "android.permission.CAMERA"
        "android.permission.RECORD_AUDIO"
        "android.permission.ACCESS_FINE_LOCATION"
        "android.permission.ACCESS_COARSE_LOCATION"
        "android.permission.READ_CONTACTS"
        "android.permission.WRITE_CONTACTS"
        "android.permission.READ_SMS"
        "android.permission.SEND_SMS"
        "android.permission.RECEIVE_SMS"
        "android.permission.CALL_PHONE"
        "android.permission.READ_PHONE_STATE"
        "android.permission.WAKE_LOCK"
        "android.permission.VIBRATE"
        "android.permission.BLUETOOTH"
        "android.permission.BLUETOOTH_ADMIN"
        "android.permission.NFC"
        "android.permission.GET_ACCOUNTS"
        "android.permission.USE_FINGERPRINT"
        "android.permission.BODY_SENSORS"
        "android.permission.REQUEST_INSTALL_PACKAGES"
    )
    
    # Try to detect package name from connected device
    echo "[*] Detecting package names..."
    
    # Method 1: Get all packages
    packages=$(adb shell pm list packages -3 2>/dev/null | cut -d: -f2 | head -5)
    
    if [ -z "$packages" ]; then
        # Method 2: Get recent packages
        packages=$(adb shell dumpsys window windows 2>/dev/null | grep -E 'mCurrentFocus|mFocusedApp' | grep -oE '[a-zA-Z0-9._]+/[a-zA-Z0-9._]+' | cut -d/ -f1 | head -3)
    fi
    
    if [ -z "$packages" ]; then
        # Default package names to try
        packages="com.example.app com.android.settings com.google.android.apps.photos"
    fi
    
    echo "[*] Packages found: $packages"
    echo ""
    
    # Grant permissions to each package
    for package in $packages; do
        echo "📦 Granting permissions to: $package"
        
        for permission in "${permissions[@]}"; do
            adb shell pm grant $package $permission 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "  ✅ $permission"
            fi
        done
        
        echo ""
    done
    
    echo "✅ ALL PERMISSIONS GRANTED"
    
    # Show granted permissions summary
    echo ""
    echo "📊 PERMISSIONS SUMMARY:"
    echo "──────────────────────"
    for package in $packages; do
        echo ""
        echo "Package: $package"
        adb shell pm list permissions -g -d $package 2>/dev/null | head -10 | while read line; do
            echo "  • $line"
        done
    done
}

# ============================================
# OPTION 3: BUILD APPLICATION - FIXED VERSION
# ============================================
build_app() {
    clear
    draw_logo
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│                 BUILD APPLICATION                   │"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    
    echo "[?] ENTER PROJECT PATH:"
    read -p ">> " project_path
    
    [ -z "$project_path" ] && project_path=$(pwd)
    project_path=$(echo "$project_path" | tr -d "'\"")
    
    if [ ! -d "$project_path" ]; then
        echo "❌ PATH NOT FOUND"
        read -p "PRESS ENTER..."
        return
    fi
    
    cd "$project_path"
    
    clear
    draw_logo
    echo "┌─────────────────────────────────────────────────────┐"
    echo "│                   BUILDING...                       │"
    echo "└─────────────────────────────────────────────────────┘"
    echo ""
    
    if [ -f "gradlew" ]; then
        echo "[*] GRADLE PROJECT DETECTED"
        
        # 🔧 FIX: منح جميع الصلاحيات لـ gradlew
        echo "[*] SETTING PERMISSIONS FOR gradlew..."
        chmod 755 gradlew 2>/dev/null
        chmod +x gradlew 2>/dev/null
        
        # التحقق من صلاحيات التنفيذ
        if [ ! -x "gradlew" ]; then
            echo "⚠️ gradlew not executable, using alternative method"
        fi
        
        echo "[*] CLEANING..."
        
        # 🔧 FIX: استخدام bash إذا فشل ./gradlew
        if [ -x "gradlew" ]; then
            ./gradlew clean 2>&1 | grep -v "warning\|error" || true
        else
            bash gradlew clean 2>&1 | grep -v "warning\|error" || true
        fi
        
        echo "[*] BUILDING APK..."
        progress
        
        # 🔧 FIX: محاولة البناء بطرق مختلفة
        if [ -x "gradlew" ]; then
            ./gradlew assembleDebug 2>&1 | tail -20
        else
            bash gradlew assembleDebug 2>&1 | tail -20
        fi
        
    elif [ -f "build.gradle" ]; then
        echo "[*] GRADLE PROJECT DETECTED"
        echo "[*] BUILDING..."
        progress
        gradle assembleDebug 2>&1 | tail -20
        
    else
        echo "❌ NOT A VALID PROJECT"
        echo "[*] No gradlew or build.gradle found"
        read -p "PRESS ENTER..."
        return
    fi
    
    # البحث عن APK
    echo ""
    echo "[*] SEARCHING FOR APK..."
    
    # البحث في أماكن مختلفة
    apk=$(find . -name "*.apk" -type f | head -1)
    
    if [ -f "$apk" ]; then
        echo ""
        echo "┌─────────────────────────────────────────────────────┐"
        echo "│                 BUILD SUCCESS                      │"
        echo "└─────────────────────────────────────────────────────┘"
        echo ""
        
        echo "[*] APK: $(basename "$apk")"
        echo "[*] SIZE: $(du -h "$apk" | cut -f1)"
        
        target="/storage/emulated/0/MuayThai"
        mkdir -p "$target"
        
        echo "[*] COPYING TO MUAYTHAI FOLDER..."
        cp "$apk" "$target/MuayThai.apk"
        
        echo "✅ MOVED TO: $target/MuayThai.apk"
        
        # خيار التثبيت
        echo ""
        read -p "INSTALL TO DEVICE? (y/n): " install
        
        if [[ "$install" =~ ^[Yy]$ ]]; then
            if command -v adb &> /dev/null; then
                echo "[*] INSTALLING..."
                adb install "$target/MuayThai.apk"
            else
                echo "❌ ADB NOT INSTALLED"
            fi
        fi
        
    else
        echo ""
        echo "┌─────────────────────────────────────────────────────┐"
        echo "│                 BUILD FAILED                       │"
        echo "└─────────────────────────────────────────────────────┘"
        echo ""
        echo "❌ NO APK FILE FOUND"
        echo ""
        echo "[*] POSSIBLE SOLUTIONS:"
        echo "    1. Run: chmod 755 gradlew"
        echo "    2. Run: bash gradlew clean"
        echo "    3. Run: bash gradlew assembleDebug"
        echo "    4. Check project structure"
    fi
    
    echo ""
    read -p "PRESS ENTER TO CONTINUE..."
}

# ============================================
# MAIN MENU
# ============================================
main_menu() {
    while true; do
        clear
        draw_logo
        
        echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
        echo "█                                                     █"
        echo "█    [1] INSTALL ALL TOOLS                           █"
        echo "█    [2] ADB CONNECTION                              █"
        echo "█    [3] BUILD APPLICATION                           █"
        echo "█    [4] EXIT                                        █"
        echo "█                                                     █"
        echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
        echo ""
        
        echo -n "SELECT [1-4]: "
        read choice
        
        case $choice in
            1) install_libs ;;
            2) adb_connection ;;
            3) build_app ;;
            4)
                clear
                draw_logo
                echo ""
                echo "👋 GOODBYE!"
                echo ""
                exit 0
                ;;
            *) 
                echo ""
                echo "❌ INVALID OPTION"
                sleep 1
                ;;
        esac
    done
}

# ============================================
# START TOOL
# ============================================
main_menu
