set -e
apt install python2
apt install python3

setup_script_dir=$(dirname $0)
cd $setup_script_dir
./shadowsocks-all.sh

ln -s /usr/bin/python2 /usr/bin/python
systemctl enable shadowsocks-r
systemctl start shadowsocks-r