#!/bin/bash

easyLLM_version='1.0.0' # 当前版本

easyLLM_rootDir=$HOME/.easyLLM            # 主目录
easyLLM_coreDir=$easyLLM_rootDir/core       # 核心功能
easyLLM_deptDir=$easyLLM_rootDir/deployment # LLM配套安装器
easyLLM_modelDir=$easyLLM_rootDir/models    # 模型库
easyLLM_fsinDir=$easyLLM_rootDir/fsinstaller # 系统镜像安装库

python_venvs=$HOME/.easyLLM/venvs # Python虚拟环境目录，对应模型

environment_type=0
environment_name=''

color_echo() {
    # 带颜色打印文本
    case $1 in
        'red')
            echo -e $(tput setaf 1)$2$(tput setaf 1);
            ;;
        'green')
            echo -e $(tput setaf 2)$2$(tput setaf 2);
            ;;
        'yellow')
            echo -e $(tput setaf 3)$2$(tput setaf 3);
            ;;
        'blue')
            echo -e $(tput setaf 4)$2$(tput setaf 4);
            ;;
        'pink')
            echo -e $(tput setaf 5)$2$(tput setaf 5);
            ;;
        *)
            echo -e $(tput sgr0)$1$(tput sgr0);
            ;;
    esac
}

cleanup() {
    # 退出时执行
    if [ $? -eq 0 ]; then
        color_echo
        color_echo blue "easyLLM::close 退出脚本";
        color_echo
    else
        color_echo
        color_echo red "easyLLM::error 脚本执行错误，请将上方报错内容提交至issue：https://github.com/xcenweb/easyLLM/issues";
        color_echo
    fi
}
trap cleanup EXIT

check_environment() {
    # 获取脚本运行的环境
    color_echo
    
    # termux
    if [ -n "$TERMUX_VERSION" ]; then
        color_echo blue "This script is running in Termux.\n此脚本正在Termux中运行"
        color_echo
        environment_type=1
        environment_name='Termux'
        return 1
    fi
    
    # ubuntu
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" == "ubuntu" ]; then
            color_echo blue "This script is running on Ubuntu.\n此脚本正在Ubuntu上运行"
            color_echo
            environment_type=2
            environment_name='Ubuntu'
            return 2
        fi
    fi
    
    color_echo red "This script is currently only supported in Ubuntu and Termux\n该脚本目前只支持在Ubuntu、termux中运行"
    color_echo
    exit 1
}
check_environment

install_ubuntu() {
    # 对于termux：安装 Ubuntu
    read -p $(tput setaf 3)"回车则开始安装Ubuntu，请确认手机存储>10G！按ctrl+c退出。"$(tput setaf 3) ok
    pkg install wget openssl-tool proot -y
    bash ubuntu.sh
}

start_ubuntu() {
    # 对于termux：Ubuntu！启动！
    cd $(dirname $0)
    pulseaudio --start
    unset LD_PRELOAD
    command="proot"
    command+=" --link2symlink"
    command+=" -0"
    command+=" -r .ubuntu-fs"
    command+=" -b /dev"
    command+=" -b /proc"
    command+=" -b .ubuntu-fs/root:/dev/shm"
    command+=" -b /data/data/com.termux/files/home:/root"
    command+=" -w /root"
    command+=" /usr/bin/env -i"
    command+=" HOME=/root"
    command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
    command+=" TERM=$TERM"
    command+=" LANG=C.UTF-8"
    command+=" /bin/bash --login"
    color_echo
    color_echo pink "Ubuntu 启动！ ((づ￣ ³￣)づ，输入exit回车即可退出Ubuntu～"
    color_echo
    exec $command
}

# 初始化
if [ ! -d $easyLLM_rootDir ];then
    color_echo yellow 'EasyLLM未进行初始化...'
    
    if [ $environment_type == 1 ];then
        # termux
        # 在 termux 中运行时不创建 .easyLLM 目录，只在除 termux 外才创建
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y && pkg upgrade -y
        pkg install ncurses-utils python3 python-pip -y
        pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    
    elif [ $environment_type == 2 ];then
        # ubuntu
        apt update -y && apt upgrade -y
        apt install sudo -y
        sudo apt install python build-essential python3-venv zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget rustc -y
        pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
        python -m pip install --upgrade pip
        # github拉取easyLLM核心
    fi
fi

# 开始UI
echo "    ______                 __    __    __  ___";
echo "   / ____/___ ________  __/ /   / /   /  |/  /";
echo "  / __/ / __ \`/ ___/ / / / /   / /   / /|_/ / ";
echo " / /___/ /_/ (__  ) /_/ / /___/ /___/ /  / /  ";
echo "/_____/\__,_/____/\__, /_____/_____/_/  /_/   ";
echo "                 /____/                       ";
echo "";
color_echo green "欢迎你使用EasyLLM！启动器版本 v$easyLLM_version，你正在 "$environment_name" 环境中使用本脚本！";
color_echo
color_echo green "Github仓库->https://github.com/xcenweb/easyLLM\n作者微信->wx_0xbcyuncen"
color_echo

if [ -d $HOME/.ubuntu-fs ] && [ $environment_type == 1 ];then
    # termux中：确认后启动已经安装好的Ubuntu系统
    read -p $(tput setaf 3)"你已安装了 Ubuntu，回车则直接登录Ubuntu系统以进行LLM管理和运行LLM，ctrl+c退出！"$(tput setaf 3) ok
    start_ubuntu
fi

if [ $environment_type == 2 ];then
    # Ubuntu中：
    echo dev
fi

# 若当前在termux，则显示选择进入系统列表
#shopt -s dotglob nullglob
#declare -a matching_dirs
#for dir in */; do
#    dir=${dir%/}
#    if [[ $dir =~ .*-fs$ ]]; then
#        matching_dirs+=("$dir")
#    fi
#done
#echo $matching_dirs