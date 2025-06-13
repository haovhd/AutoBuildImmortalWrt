#!/bin/sh
# 99-custom.sh 就是immortalwrt固件首次启动时运行的脚本 位于固件内的/etc/uci-defaults/99-custom.sh
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
# 设置默认防火墙规则，方便虚拟机首次访问 WebUI
uci set firewall.@zone[1].input='ACCEPT'

# /etc/config/dhcp
uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.ra_flags
uci del dhcp.lan.max_preferred_lifetime
uci del dhcp.lan.max_valid_lifetime
uci del dhcp.lan.dhcpv6
uci set dhcp.lan.ignore='1'
# /etc/config/network
uci del network.lan.ip6assign
uci set network.lan.ipaddr='192.168.2.9'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='192.168.2.1'
uci add_list network.lan.dns='192.168.2.1'
uci set network.lan.delegate='0'
# /etc/config/firewall
uci del firewall.cfg01e63d.syn_flood
uci del firewall.cfg01e63d.fullcone
uci del firewall.cfg01e63d.fullcone6
uci del firewall.cfg01e63d.flow_offloading
uci del firewall.cfg01e63d.flow_offloading_hw
uci set firewall.cfg02dc81.masq='1'

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci commit

# 设置编译作者信息
FILE_PATH="/etc/openwrt_release"
NEW_DESCRIPTION="Compiled by hao133"
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='$NEW_DESCRIPTION'/" "$FILE_PATH"

exit 0
