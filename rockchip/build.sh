#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTFS_PARTSIZE"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# Initialize PACKAGES variable
PACKAGES=""

# --- Base System & Core Utilities ---
PACKAGES="$PACKAGES autocore"
PACKAGES="$PACKAGES automount"
PACKAGES="$PACKAGES base-files"
PACKAGES="$PACKAGES block-mount"
PACKAGES="$PACKAGES ca-bundle"
PACKAGES="$PACKAGES default-settings-chn" # China region default settings
PACKAGES="$PACKAGES dnsmasq-full"        # DNS and DHCP server
PACKAGES="$PACKAGES dropbear"            # SSH server
PACKAGES="$PACKAGES fdisk"               # Partitioning utility (Needed by iStore etc.)
PACKAGES="$PACKAGES fstools"             # Filesystem tools
PACKAGES="$PACKAGES kmod-gpio-button-hotplug" # GPIO Button support
PACKAGES="$PACKAGES libc"                # Standard C library
PACKAGES="$PACKAGES libgcc"              # GCC support library
PACKAGES="$PACKAGES libustream-openssl" # ustream SSL library (openssl variant)
PACKAGES="$PACKAGES logd"                # Logging daemon
PACKAGES="$PACKAGES mkf2fs"              # F2FS filesystem creation tool
PACKAGES="$PACKAGES mtd"                 # Memory Technology Device utilities
PACKAGES="$PACKAGES opkg"                # Package manager
PACKAGES="$PACKAGES partx-utils"         # Partition table utilities
PACKAGES="$PACKAGES procd-ujail"         # Process manager jail support
PACKAGES="$PACKAGES script-utils"        # Scripting utilities (Needed by iStore etc.)
PACKAGES="$PACKAGES uboot-envtools"      # U-Boot environment tools
PACKAGES="$PACKAGES uci"                 # Unified Configuration Interface
PACKAGES="$PACKAGES uclient-fetch"       # URL fetch utility (like wget/curl)
PACKAGES="$PACKAGES urandom-seed"        # Random seed management
PACKAGES="$PACKAGES urngd"               # Random number generator daemon

# --- Networking & Firewall ---
PACKAGES="$PACKAGES firewall4"           # Firewall (nftables based)
PACKAGES="$PACKAGES kmod-nf-nathelper"   # Kernel NAT helpers
PACKAGES="$PACKAGES kmod-nf-nathelper-extra" # Extra kernel NAT helpers
PACKAGES="$PACKAGES kmod-nft-offload"    # NFTables offloading support
PACKAGES="$PACKAGES netifd"              # Network interface daemon
PACKAGES="$PACKAGES nftables"            # Netfilter Tables userspace utilities
PACKAGES="$PACKAGES odhcp6c"             # IPv6 DHCP client
PACKAGES="$PACKAGES odhcpd-ipv6only"     # IPv6 DHCP server/RA daemon
PACKAGES="$PACKAGES ppp"                 # Point-to-Point Protocol daemon
PACKAGES="$PACKAGES ppp-mod-pppoe"       # PPPoE support for PPP
PACKAGES="$PACKAGES openssh-sftp-server" # SFTP server support for ssh

# --- Wireless & Drivers ---
PACKAGES="$PACKAGES iwinfo"              # Wireless information utility
PACKAGES="$PACKAGES kmod-r8125"          # Realtek R8125 (2.5GbE) NIC driver
PACKAGES="$PACKAGES kmod-rtw88-8822ce"   # Realtek 8822CE WiFi driver
PACKAGES="$PACKAGES rtl8822ce-firmware"  # Realtek 8822CE WiFi firmware
PACKAGES="$PACKAGES wpad-openssl"        # WPA Supplicant (Full OpenSSL version)
# Packages for MediaTek MT7921 Wireless Support
PACKAGES="$PACKAGES kmod-mt7921-common"  # Common driver code for MT7921 series
PACKAGES="$PACKAGES kmod-mt7921e"        # Driver for MT7921 PCIe wireless cards

# --- LuCI Web Interface & Applications ---
PACKAGES="$PACKAGES luci-light"          # LuCI core (light version)
PACKAGES="$PACKAGES luci-compat"         # LuCI compatibility layer
PACKAGES="$PACKAGES luci-lib-base"       # LuCI base library
PACKAGES="$PACKAGES luci-lib-ipkg"       # LuCI opkg library
# LuCI Applications
PACKAGES="$PACKAGES luci-app-cpufreq"        # LuCI CPU Frequency management app
PACKAGES="$PACKAGES luci-app-package-manager" # LuCI Package Manager app
PACKAGES="$PACKAGES luci-app-argon-config"  # LuCI Argon theme configuration app
PACKAGES="$PACKAGES luci-app-openclash"      # LuCI OpenClash app
# Note: The script mentioned luci-i18n-* packages for filebrowser, passwall, homeproxy, dockerman, samba4, ttyd, diskman
# but didn't include the base luci-app-* packages for them. You might need to add:
# luci-app-diskman, luci-app-filebrowser-go, luci-app-ttyd, luci-app-passwall, luci-app-homeproxy, luci-app-dockerman, luci-app-samba4
# depending on which ones you actually want installed. The i18n packages only provide translations.

# --- LuCI app packages
PACKAGES="$PACKAGES luci-app-diskman"
PACKAGES="$PACKAGES luci-app-filebrowser-go"
PACKAGES="$PACKAGES luci-app-ttyd"          
PACKAGES="$PACKAGES luci-app-passwall"
PACKAGES="$PACKAGES luci-app-homeproxy"     
PACKAGES="$PACKAGES luci-app-dockerman"     
PACKAGES="$PACKAGES luci-app-samba4"

# --- LuCI Internationalization (zh-cn / Chinese) ---
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn" # Assumes luci-app-filebrowser-go is installed
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"          # Assumes luci-app-ttyd is installed
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"      # Assumes luci-app-passwall is installed
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"     # Assumes luci-app-homeproxy is installed
PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"     # Assumes luci-app-dockerman is installed
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"        # Assumes luci-app-samba4 is installed

# --- Other Applications ---
PACKAGES="$PACKAGES curl"                # Command line tool for transferring data with URL syntax

# --- End of Combined Packages ---

# You can now use the $PACKAGES variable in your build command
# e.g., make image PACKAGES="$PACKAGES"

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
