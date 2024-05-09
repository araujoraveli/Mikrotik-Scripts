1 - Inserir o pendrive na RB.

2 - System > Disks > Format Driver:

	Slot: usb1 (ou o que aparecer)
	File System: Ext4
	Label: Nome sugestivo do disco/pendrive
	[OK]
	
3 - Depois de formatado, ejete o pendrive pelo botão do lado do "Format Driver".
	Remova o pendrive fisicamente, aguarde 5s, insira novamente na RB.
	
4 - New terminal:

##Cria a Bridge para os conteiners
/interface bridge
add name=brdg_Docker
##Cria uma interface ethernet virtual para o conteiner que vamos criar (pihole no caso)
##Será usada para atribuir ip da rede para o conteiner
/interface veth
add address=192.168.50.2/24 comment="Virtual Ethernet para o Pihole" gateway=192.168.50.1 gateway6="" name=veth_Pihole
##NAT para liberar internet para o Docker
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT libera internet para o Docker" src-address=192.168.50.0/24
##Variáveis de ambiente, mude "WEBPASSWORD" para a senha que vc deseja logar no pihole, nao mexa no restante.
/container envs
add key=TZ name=pihole value=America/Sao_Paulo
add key=WEBPASSWORD name=pihole value=raveliaraujo
add key=DNSMASQ_USER name=pihole value=root
##Define o diretório para salvar arquivos temporários e de onde buscar, durante a instalaçao dos conteiners
/container config
set registry-url=https://registry-1.docker.io tmpdir=usb1/pull
##Cria a estrutura de montagem fisica para o conteiner
/container mounts add name=etc_pihole src=usb1/etc dst=/etc/pihole
/container mounts add name=dnsmasq_pihole src=usb1/etc-dnsmasq.d dst=/etc/dnsmasq.d
##Baixa a imagem e faz a a instalação utilizando os parametros definidos anteriormente
/container add remote-image=pihole/pihole:latest interface=veth_Pihole root-dir=usb1/pihole mounts=dnsmasq_pihole,etc_pihole envlist=pihole

5 - Conteiner > duplo clique no conteiner existente:
	Aguarde a extração ser finalizada, quando finalizar vai aparecer em "Status" como "Stoped".
	Marque a caixa "Start on boot" e clique no botão "Start".
	Em "Status" aguarde até aparecer a mensagem "running".
	
6 - Pronto, só acessar o pihole usando o ip que definimos na "veth_Pihole" adicionando "/admin" 
	Ex: 192.168.50.2/admin
	Logar com a senha definida em "key=WEBPASSWORD"
