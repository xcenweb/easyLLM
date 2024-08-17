#!/data/data/com.termux/files/usr/bin/bash

# 此安装器修改自 https://github.com/EXALAB/AnLinux-Resources 
# 仅作为 easyLLM 的 Ubuntu 安装器模块 :)
# 在此感谢原作者！

folder=.ubuntu-fs
tarball="ubuntu-rootfs.tar.xz"
cur=`pwd`

if [ -d "$folder" ]; then
	first=1
	echo -e "skipping downloading\n跳过下载"
fi

# 下载解压
if [ "$first" != 1 ];then
	if [ ! -f $tarball ]; then
		echo -e "Download Rootfs, this may take a while base on your internet speed.\n下载rootfs，这可能需要一段时间基于您的互联网速度。 "
		case `dpkg --print-architecture` in
		aarch64)
			archurl="arm64" ;;
		arm)
			archurl="armhf" ;;
		amd64)
			archurl="amd64" ;;
		x86_64)
			archurl="amd64" ;;	
		i*86)
			archurl="i386" ;;
		x86)
			archurl="i386" ;;
		*)
			echo -e "unknown architecture\n未知体系结构"; exit 1 ;;
		esac
		echo 
		wget "https://raw.staticdn.net/EXALAB/AnLinux-Resources/master/Rootfs/Ubuntu/arm64/ubuntu-rootfs-arm64.tar.xz" -O $tarball
	fi
	
	mkdir -p "$folder"
	cd "$folder"
	echo -e "Decompressing Rootfs, please be patient.\n解压rootfs请耐心等待。"
	proot --link2symlink tar -xJf ${cur}/${tarball}||:
	cd "$cur"
fi


# Ubuntu换源
rm $folder/etc/apt/sources.list
cat>$folder/etc/apt/sources.list<<EOF
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-backports main restricted universe multiverse

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb http://security.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ noble-proposed main restricted universe multiverse
EOF


# pulseaudio
echo -e "Setting up pulseaudio so you can have music in distro.\n设置pulseaudio，以便您可以在发行版中播放音乐。"
pkg install pulseaudio -y
if grep -q "anonymous" ~/../usr/etc/pulse/default.pa;then
    echo -e "module already present\n模块已存在"
else
    echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ~/../usr/etc/pulse/default.pa
fi
echo "exit-idle-time = -1" >> ~/../usr/etc/pulse/daemon.conf
echo -e "Modified pulseaudio timeout to infinite\n将pulseAudio超时修改为无限"
echo "autospawn = no" >> ~/../usr/etc/pulse/client.conf
echo -e "Disabled pulseaudio autospawn\n禁用pulseaudio autospawn"
echo "export PULSE_SERVER=127.0.0.1" >> $folder/etc/profile
echo -e "Setting Pulseaudio server to 127.0.0.1\n将Pulseaudio服务器设置为127.0.0.1"

# echo -e "fixing shebang of $bin"
# termux-fix-shebang $bin
# echo "making $bin executable"
# chmod +x $bin
# echo "removing image for some space"

rm $tarball
screenfetch -A Ubuntu -L
echo -e "You can now launch Ubuntu."
