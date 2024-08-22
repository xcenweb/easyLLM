#!/bin/bash

# This script only supports bash, do not support posix sh.
# If you have the problem like Syntax error: "(" unexpected (expecting "fi"),
# Try to run "bash -version" to check the version.
# Try to visit WIKI to find a solution.

VAR='1.0.0' # 当前版本

easyLLM_rootDir=.easyLLM                          # 主目录
easyLLM_coreDir=$easyLLM_rootDir/core             # 核心库
easyLLM_rninDir=$easyLLM_rootDir/runner_installer # LLM配套安装器
easyLLM_fsinDir=$easyLLM_rootDir/rootfs_installer # 发行版镜像安装库

source $easyLLM_rootDir/util/function.sh
source $easyLLM_rootDir/util/trap.sh

install_ubuntu() {
    # 对于termux：直接安装运行 Ubuntu
    # color_echo yellow "你未安装 Ubuntu，这是easyLLM运行所需，请你安装"
    # read -p $(tput setaf 3)"回车则开始安装Ubuntu，请确认手机存储>10G！按ctrl+c退出。"$(tput setaf 3) ok
    bash $easyLLM_fsinDir/ubuntu.sh ubuntu
    
    # 写入termux启动时运行文件
    cat>.bash_profile<<EOF
screenfetch -A Ubuntu -L
pulseaudio --start
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r ubuntu"
command+=" -b /dev"
command+=" -b /proc"
command+=" -b ubuntu/root:/dev/shm"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
exec $command
EOF
    
    # 替换termux启动页面、启动系统
    echo "Ubuntu 22.04 LTS on Termux" > $PREFIX/etc/motd
    chmod +x .bash_profile
    
    # 移动 .easyLLM 目录和复制本脚本至 Ubuntu 的 root/
    mv .easyLLM ubuntu/root
    
    # 直接启动Ubuntu
    clear
    bash .bash_profile
}

# 脚本运行的环境
if [ -n "$TERMUX_VERSION" ]; then
    # termux
    environment_type=1
    environment_name='Termux'

elif [ -f /etc/os-release ]; then
    # ubuntu
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        environment_type=2
        environment_name='Ubuntu'
    fi
else
    color_echo red "This script is currently only supported in Ubuntu and Termux\n该脚本目前只支持在Ubuntu、termux中运行"
    exit 1
fi

# 初始化
if [ $environment_type == 1 ];then
    # termux
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
    pkg update -y && pkg upgrade -y
    pkg install pulseaudio git screenfetch ncurses-utils -y
    
    # github拉取easyLLM核心后重命名
    if [ ! -d $easyLLM_rootDir ];then
        git clone https://github.com/xcenweb/easyLLM.git
        mv easyLLM $easyLLM_rootDir
    fi
fi

if [ $environment_type == 2 ] && [ $1 != 'reload' ];then
    # ubuntu
    apt update -y && apt upgrade -y
    apt install sudo -y
    apt_install wget python3 python3-venv python3-full git jq
    apt_install build-essential zlib1g-dev libncurses-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev rustc
    sudo apt autoremove
        
    # pip换源更新
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    python -m pip install --upgrade pip
fi

# 开始UI
clear
color_echo blue "This script is running in $environment_name.\n此脚本正在$environment_name中运行"
echo "    ______                 __    __    __  ___";
echo "   / ____/___ ________  __/ /   / /   /  |/  /";
echo "  / __/ / __ \`/ ___/ / / / /   / /   / /|_/ / ";
echo " / /___/ /_/ (__  ) /_/ / /___/ /___/ /  / /  ";
echo "/_____/\__,_/____/\__, /_____/_____/_/  /_/   ";
echo "                 /____/                       ";
echo "";
color_echo green "欢迎你使用 EasyLLM ！脚本版本 v$VAR ，你正在 "$environment_name" 环境中使用本脚本！";
color_echo
color_echo green "Github仓库 => https://github.com/xcenweb/easyLLM\n作者微信 => wx_0xbcyuncen"
color_echo


if [ $environment_type == 2 ];then
    color_echo
else
    if [ ! -d ubuntu ];then
        install_ubuntu
    fi
fi


# 列出操作列表
# TODO shell select
if [ $environment_type == 2 ];then
    echo " 1. 选择运行LLM        2. 安装LLM运行器"
    echo
    read -p "输入上方数字进行相应操作，输入exit退出：" act
    if [ ! -n "$act" ];then
        exit 40
    elif [ "$act" == "exit" ];then
        exit 0
    elif [ $act == 1 ];then
        python3 $easyLLM_coreDir/runner.py --get installed
        exit 40
    elif [ $act == 2 ];then
        python3 $easyLLM_coreDir/runner.py --get packages
        exit 40
    else
        exit 40
    fi
fi