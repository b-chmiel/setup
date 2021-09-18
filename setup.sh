#!/bin/bash
set -e 

ubuntu_version=20.04
jetbrains_mono_version=2.242
username=$USER

function gnome_setup() {
	sudo -u $USER gsettings set org.gnome.desktop.background show-desktop-icons false
	sudo -u $USER gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
	sudo -u $USER gsettings set org.gnome.desktop.sound event-sounds false
}

function install_apt_pkgs() {
	apt update
	apt upgrade -y
	export DEBIAN_FRONTEND=noninteractive
	export TZ=Europe/Warsaw
	apt install -y neovim samba xrdp apt-transport-https ca-certificates curl gnupg-agent software-properties-common ffmpeg openssh-server valgrind openjdk-11-jre-headless htop neofetch gnome-tweaks git firefox vlc remmina net-tools qemu-kvm bridge-utils ncdu tree gnupg2 docker.io fish abcde exfat-fuse exfat-utils deja-dup thunderbird python3-pip python3-virtualenv httpie snapd
}

function install_wine() {
	apt install -y libopencv-dev
	apt install -y wine winetricks libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio winbind
	winetricks --self-update
	winetricks -q allcodecs --force
}

function install_dotnet_sdk() {
	sudo -u $USER wget https://packages.microsoft.com/config/ubuntu/$ubuntu_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	dpkg -i packages-microsoft-prod.deb
	sudo -u $USER rm packages-microsoft-prod.deb

	apt-get update
	apt-get install -y apt-transport-https
	apt-get update
	apt-get install -y dotnet-sdk-5.0
}

function install_snap_pkgs() {
	snap install discord --classic
	snap install heroku --classic
	snap install postman --classic
	snap install node --classic --channel=14
	snap install libreoffice --classic 
	snap install code-insiders --classic 
	snap install sublime-text --classic
	snap install slack --classic
	snap install code --classic
	snap install lxd
	snap install spotify
}

function install_ppa_pkgs() {
	add-apt-repository ppa:yann1ck/onedrive -y
	add-apt-repository ppa:obsproject/obs-studio -y
	apt update
	apt install obs-studio onedrive -y
	apt autoremove -y
}

function shell_setup() {
	chsh -s `which fish`
}

function fonts_setup() {
	pushd /tmp
		sudo -u $USER wget "https://download-cdn.jetbrains.com/fonts/JetBrainsMono-$jetbrains_mono_version.zip"
		sudo -u $USER unzip JetBrainsMono-$jetbrains_mono_version.zip
		pushd fonts
			mkdir /usr/share/fonts/Jetbrains
			mv * /usr/share/fonts/Jetbrains/
			sudo -u $USER fc-cache -f -v
		popd
	popd
}

function gestures_setup() {
	# gestures package
	gpasswd -a $USER input
	apt-get install -y wmctrl xdotool libinput-tools
	sudo -u $USER mkdir -p $HOME/Documents/Programs
	pushd $HOME/Documents/Programs
		sudo -u $USER git clone https://github.com/bulletmark/libinput-gestures.git
		pushd libinput-gestures
			./libinput-gestures-setup install
		popd
	popd

	sudo -u $USER libinput-gestures-setup autostart start

	#gtk gui for settings
	apt-get install -y python3 python3-gi python-gobject meson xdotool libinput-tools gettext
	pushd $HOME/Documents/Programs
		sudo -u $USER git clone https://gitlab.com/cunidev/gestures
		pushd gestures
			sudo -u $USER meson build --prefix=/usr
			sudo -u $USER ninja -C build
			ninja -C build install
		popd
	popd
}

function display_link() {
	pushd /tmp
		sudo -u $USER git clone https://github.com/AdnanHodzic/displaylink-debian.git
		pushd displaylink-debian
			./displaylink-debian.sh
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
	gestures_setup
	display_link
}

main
