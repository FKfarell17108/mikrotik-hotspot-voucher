# 2026-03-10 02:43:52 by RouterOS 7.20.8
# system id = ZTcDCMhaRdL
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/ip hotspot profile
add hotspot-address=192.168.10.1 name=hsprof1
/ip pool
add name=dhcp_pool0 ranges=192.168.10.2-192.168.10.254
/ip hotspot
add address-pool=dhcp_pool0 disabled=no interface=ether4 name=hotspot1 \
    profile=hsprof1
/ip address
add address=192.168.56.1/24 interface=ether2 network=192.168.56.0
add address=192.168.10.1/24 interface=ether4 network=192.168.10.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether4 name=dhcp1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8,8.8.8.8,8.8.8.8 gateway=\
    192.168.10.1
/ip dns
set servers=8.8.8.8
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.10.0/24
/ip hotspot user
add name=admin
add name=user1
