#!/bin/bash
set -e 

ubuntu_version=20.04
jetbrains_mono_version=2.242

function gnome_setup() {
	gsettings set org.gnome.desktop.background show-desktop-icons false
	gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
	gsettings set org.gnome.desktop.sound event-sounds false
}

function install_apt_pkgs() {
	sudo apt update
	sudo apt upgrade -y
	sudo apt install -y neovim samba xrdp apt-transport-https ca-certificates curl gnupg-agent software-properties-common ffmpeg openssh-server valgrind openjdk-11-jre-headless htop neofetch gnome-tweaks git firefox vlc remmina net-tools qemu-kvm bridge-utils ncdu tree gnupg2 docker.io fish abcde exfat-fuse exfat-utils deja-dup thunderbird python3-pip python3-virtualenv httpie
}

function install_wine() {
	sudo apt install -y  wine winetricks libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio 
	sudo winetricks --self-update
	winetricks -q allcodecs
}

function install_dotnet_sdk() {
	wget https://packages.microsoft.com/config/ubuntu/$ubuntu_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb
	rm packages-microsoft-prod.deb

	sudo apt-get update; \
	sudo apt-get install -y apt-transport-https && \
	sudo apt-get update && \
	sudo apt-get install -y dotnet-sdk-5.0
}

function install_snap_pkgs() {
	sudo snap install kubectl --classic
	sudo snap install discord --classic
	sudo snap install heroku --classic
	sudo snap install postman --classic
	sudo snap install node --classic --channel=14
	sudo snap install libreoffice --classic 
	sudo snap install code-insiders --classic 
	sudo snap install sublime-text --classic
	sudo snap install slack --classic
	sudo snap install code --classic
	sudo snap install lxd
}

function install_ppa_pkgs() {
	sudo add-apt-repository ppa:yann1ck/onedrive -y
	sudo add-apt-repository ppa:obsproject/obs-studio -y
	sudo apt update
	sudo apt install obs-studio onedrive -y
	sudo apt autoremove -y
}


function shell_setup() {
	sudo chsh -s `which fish`
}

function fonts_setup() {
	pushd /tmp
		wget "https://download-cdn.jetbrains.com/fonts/JetBrainsMono-$jetbrains_mono_version.zip"
		unzip JetBrainsMono-$jetbrains_mono_version.zip
		pushd fonts
			sudo mkdir /usr/share/fonts/Jetbrains
			sudo mv * /usr/share/fonts/Jetbrains/
			fc-cache -f -v
		popd
	popd
}

function main() {
	gnome_setup

	install_apt_pkgs
	install_dotnet_sdk
	install_snap_pkgs
	install_ppa_pkgs
	install_wine
	shell_setup
	fonts_setup
}

main
# sudo reboot
