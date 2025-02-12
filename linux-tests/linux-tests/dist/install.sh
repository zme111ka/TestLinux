#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

install_docker() {
  (curl -fsSL https://get.docker.com | sudo sh)
  sudo systemctl start docker
  sudo usermod -aG docker $USER
}

install_tools() {
	apt update
	apt install -y gnupg ca-certificates apt-transport-https software-properties-common wget
	apt install -y build-essential at ccrypt clang cron curl ed iproute2 iputils-ping kmod libpam0g-dev less lsof netcat net-tools nmap p7zip python2 python3 python3-pip rsync samba selinux-utils ssh sshpass sudo tcpdump telnet ufw vim whois zip unzip  at
  which docker || install_docker
}

install_tools_rhel() {
	sudo yum install make gcc curl zip unzip git python3-pip

	# link /usr/bin/pip3
	find /usr/bin -name "pip*" | head -n 1 | xargs -I {} sudo ln {} /usr/bin/pip

	which docker || install_docker
}

install_goart() {
  test -f $SCRIPT_DIR/goart && sudo cp $SCRIPT_DIR/goart /usr/bin/goart
}

install_goart
which apt && install_tools
which yum && install_tools_rhel
