/routing table
add fib name=Rota_FerranteLFCitrus
add fib name=Rota_Vizinhos

/ip firewall address-list
add address=172.16.1.0/24 list=LAN_FerranteLFCitrus
add address=172.16.2.0/24 list=LAN_FerranteLFCitrus
add address=172.16.3.0/24 list=LAN_Vizinhos

/ip firewall mangle
add action=mark-routing chain=prerouting comment="Vizinhos -> principal SinalBR, backup TurboNET" new-routing-mark=Rota_Vizinhos passthrough=yes src-address-list=LAN_Vizinhos
add action=mark-routing chain=prerouting comment="FerranteLFCItrus -> principal TurboNET, backup SinalBR" new-routing-mark=Rota_FerranteLFCitrus passthrough=yes src-address-list=LAN_FerranteLFCitrus

/ip route
add comment="Vizinhos - SinalBR Primario" disabled=no distance=1 dst-address=0.0.0.0/0 gateway=186.225.133.105 pref-src="" routing-table=Rota_Vizinhos scope=30 suppress-hw-offload=no target-scope=10
add comment="Vizinhos - TurboNET Backup" disabled=no distance=2 dst-address=0.0.0.0/0 gateway=PPPoE-TurboNET pref-src="" routing-table=Rota_Vizinhos scope=30 suppress-hw-offload=no target-scope=10
add comment="FerranteLFCItrus - TurboNET Primario" disabled=no distance=1 dst-address=0.0.0.0/0 gateway=PPPoE-TurboNET pref-src="" routing-table=Rota_FerranteLFCitrus scope=30 suppress-hw-offload=no target-scope=10
add comment="FerranteLFCItrus - SinalBR Backup" disabled=no distance=2 dst-address=0.0.0.0/0 gateway=186.225.133.105 pref-src="" routing-table=Rota_FerranteLFCitrus scope=30 suppress-hw-offload=no target-scope=10
add comment="Fallback/Failover Geral TurboNet" disabled=no distance=10 dst-address=0.0.0.0/0 gateway=PPPoE-TurboNET pref-src="" routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add comment="Fallback/Failover Geral SinalBR" disabled=no distance=20 dst-address=0.0.0.0/0 gateway=186.225.133.105 pref-src="" routing-table=main scope=30 suppress-hw-offload=no target-scope=10

/ip firewall nat
add chain=srcnat src-address=172.16.1.0/24 action=masquerade out-interface-list=WAN comment="Libera navegação FerranteLFCItrus"
add chain=srcnat src-address=172.16.2.0/24 action=masquerade out-interface-list=WAN comment="Libera navegação FerranteLFCItrus"
add chain=srcnat src-address=172.16.3.0/24 action=masquerade out-interface-list=WAN comment="Libera navegação Vizinhos"
