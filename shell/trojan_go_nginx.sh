# !/bin/bash

# get nginx
apt-get install software-properties-common -y -q
add-apt-repository ppa:ondrej/nginx-mainline -y
apt-get update
apt-get install wget curl unzip nginx-extras -y

# get trojan
trojango_link="https://github.com/p4gefau1t/trojan-go/releases/download/v0.8.1/trojan-go-linux-amd64.zip"
mkdir -p "/etc/trojan-go"
wget -nv "${trojango_link}" -O trojan-go.zip
unzip -q trojan-go.zip && rm -rf trojan-go.zip
mv trojan-go /usr/bin/trojan-go
mv example/trojan-go.service /etc/systemd/system/trojan-go.service

# build website
mkdir -p /var/www/html
template="$(curl -s https://raw.githubusercontent.com/phlinhng/web-templates/master/list.txt | shuf -n  1)"
wget -q https://raw.githubusercontent.com/phlinhng/web-templates/master/${template} -O /tmp/template.zip
${sudoCmd} mkdir -p /var/www/html
${sudoCmd} unzip -q /tmp/template.zip -d /var/www/html
${sudoCmd} wget -q https://raw.githubusercontent.com/phlinhng/v2ray-tcp-tls-web/master/custom/robots.txt -O /var/www/html/robots.txt

# replace /etc/nginx/sites-available/default to make force ssl redirection
cat > /etc/nginx/sites-available/default <<-EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	server_name _;
	return 301 https://\$host\$request_uri;
}
EOF

# get acme.sh
curl https://get.acme.sh | sh
