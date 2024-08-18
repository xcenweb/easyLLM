#!/bin/bash

easyLLM_version='1.0.0' # 当前版本

easyLLM_rootDir=.easyLLM            # 主目录
easyLLM_coreDir=$easyLLM_rootDir/core       # 核心功能
easyLLM_deptDir=$easyLLM_rootDir/deployment # LLM配套安装器
easyLLM_modelDir=$easyLLM_rootDir/models    # 模型库
easyLLM_fsinDir=$easyLLM_rootDir/fsinstaller # 系统镜像安装库
python_venvs=.easyLLM/venvs # Python虚拟环境目录，对应模型

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
    id=$?
    if [ $id -eq 0 ];then
        clear
        color_echo blue "\neasyLLM::exit 退出";
        color_echo
    elif [ $id -eq 40 ];then
        bash easyLLM.sh
    else
        color_echo red "\neasyLLM::error 执行错误，请将上方报错相关内容提交\nissue：https://github.com/xcenweb/easyLLM/issues";
        color_echo
    fi
}
trap cleanup EXIT

add_venv() {
    # 新增一个Python虚拟环境
    python -m venv $python_venvs/$1
}

del_venv() {
    # 删除一个Python虚拟环境
    deactivate
    rm -rf $python_venvs/$1
}

install_ubuntu() {
    # 对于termux：安装 Ubuntu
    color_echo yellow "你未安装 Ubuntu，这是easyLLM运行所需，请你安装"
    read -p $(tput setaf 3)"回车则开始安装Ubuntu，请确认手机存储>10G！按ctrl+c退出。"$(tput setaf 3) ok
    color_echo
    pkg install wget openssl-tool proot -y
    bash $easyLLM_fsinDir/ubuntu.sh
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


# 获取脚本运行的环境
# environment_type 环境默化id
# environment_name 环境名称
clear
if [ -n "$TERMUX_VERSION" ]; then
    # termux
    color_echo blue "This script is running in Termux.\n此脚本正在Termux中运行"
    color_echo
    environment_type=1
    environment_name='Termux'

elif [ -f /etc/os-release ]; then
    # ubuntu
    . /etc/os-release
    if [ "$ID" == "ubuntu" ]; then
        color_echo blue "This script is running on Ubuntu.\n此脚本正在Ubuntu上运行"
        color_echo
        environment_type=2
        environment_name='Ubuntu'
    fi
else
    color_echo red "This script is currently only supported in Ubuntu and Termux\n该脚本目前只支持在Ubuntu、termux中运行"
    color_echo
    exit 1
fi


# 初始化
if [ ! -d $easyLLM_rootDir ];then
    color_echo yellow 'EasyLLM未进行初始化...'
    
    if [ $environment_type == 1 ];then
        # termux
        # 在 termux 中初始化时不创建 .easyLLM 目录，只在除 termux 外才创建
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y && pkg upgrade -y
        pkg install ncurses-utils python3 python-pip git screenfetch -y
        pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    
    elif [ $environment_type == 2 ];then
        # ubuntu
        apt update -y && apt upgrade -y
        apt install sudo -y
        sudo apt install python python3-venv git -y
        sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget rustc -y
        pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
        python -m pip install --upgrade pip
        
        # github拉取easyLLM核心后重命名为.easyLLM
        git clone https://github.com/xcenweb/easyLLM.git
        #mv easyLLM .easyLLM
    fi
    
    color_echo
    color_echo green "easyLLM::初始化完毕";
    color_echo
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

# termux中：确认后启动已经安装好的Ubuntu系统
if [ -d .ubuntu-fs ] && [ $environment_type == 1 ];then
    read -p $(tput setaf 3)"你已安装了 Ubuntu，回车则直接登录Ubuntu系统以进行LLM管理和运行LLM，ctrl+c退出！"$(tput setaf 3) ok
    start_ubuntu
elif [ $environment_type == 2 ];then
    color_echo
else
    install_ubuntu
fi

# Ubuntu中：列出操作列表
if [ $environment_type == 2 ];then
    echo -e " 1. 选择运行LLM      2. 在线安装LLM\n"
    read -p "输入上方数字进行相应操作，输入 exit 退出：" act
    if [ ! -n "$act" ];then
        exit 40
    elif [ "$act" == "exit" ];then
        exit 0
    elif [ $act == 1]
        python $easyLLM_coreDir/
    else
        exit 40
    fi
fi