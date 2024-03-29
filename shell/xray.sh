#!/bin/bash

#require: jq unzip

set -e #exit immediately when something go wrong

identify_the_operating_system_and_architecture() {
  if [[ "$(uname)" == 'Linux' ]]; then
    case "$(uname -m)" in
      'amd64' | 'x86_64')
        MACHINE='64'
        ;;
      'armv8' | 'aarch64')
        MACHINE='arm64-v8a'
        ;;
    esac
  else
    echo "error: This operating system is not supported."
    exit 1
  fi
}

identify_the_operating_system_and_architecture

apt install jq unzip -y

latest_version=`curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" | jq -r '.tag_name'`
url="https://github.com/XTLS/Xray-core/releases/download/${latest_version}/Xray-linux-${MACHINE}.zip"

cd $(mktemp -d)
wget -q --show-progress "${url}" -O xray.zip
unzip -q xray.zip && $(which rm) -f xray.zip

mv xray /usr/local/bin/xray && chmod +x /usr/local/bin/xray
printf "Installed: %s\n" "/usr/local/bin/xray"

mkdir -p /usr/local/share/xray

$(which mv) geoip.dat /usr/local/share/xray/geoip.dat
printf "Installed: %s\n" "/usr/local/share/xray/geoip.dat"

$(which mv) geosite.dat /usr/local/share/xray/geosite.dat
printf "Installed: %s\n" "/usr/local/share/xray/geosite.dat"

cat > "/etc/systemd/system/xray.service" <<-EOF
[Unit]
Description=Xray - A unified platform for anti-censorship
Documentation=https://github.com/xtls
After=network.target nss-lookup.target
Wants=network-online.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
Environment=XRAY_LOCATION_ASSET=/usr/local/share/xray
ExecStart=/usr/local/bin/xray run -confdir /usr/local/etc/xray
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable xray

(crontab -l 2>/dev/null; echo "0 7 * * * wget -q https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geoip.dat -O /usr/local/share/xray/geoip.dat >/dev/null >/dev/null") | crontab -
(crontab -l 2>/dev/null; echo "0 7 * * * wget -q https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geosite.dat -O /usr/local/share/xray/geosite.dat >/dev/null >/dev/null") | crontab -
echo "geoip/geosite crontab set"

exit
