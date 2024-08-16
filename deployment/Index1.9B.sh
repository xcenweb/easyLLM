#!/bin/bash
# 作者：xcenweb@gmail.com
# 仓库：https://github.com/xcenweb

echo "${PINK}    ____          __             ___ ____  ____ ${PINK}";
echo "${PINK}   /  _/___  ____/ /__  _  __   <  // __ \/ __ )${PINK}";
echo "${PINK}   / // __ \/ __  / _ \| |/_/   / // /_/ / __  |${PINK}";
echo "${PINK} _/ // / / / /_/ /  __/>  <    / / \__, / /_/ / ${PINK}";
echo "${PINK}/___/_/ /_/\__,_/\___/_/|_|   /_(_)____/_____/  ${PINK}";
echo "";
echo "";
echo "${PINK}欢迎使用b站 Index 1.9B Ubuntu 部署工具 ((つ≧▽≦)つ${PINK}";
echo "";
echo "${YELLOW}请确认你的 Ubuntu 为新环境且你的网络连接正常！${YELLOW}";
echo "---------------";
read -p "输入y回车安装Index模型及程序，n回车取消安装[y/n]：" yn
echo "";

if [ $yn == "y" ]; then
    echo "";
    echo "";

    # 初始化 支持库
    echo "${PINK}那么咱们就...开始安装(๑•̀ㅂ•́)✧！首先得装点儿必要的库...${PINK}"
    echo "";
    apt update -y && apt install sudo -y
    sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget -y
    echo "";
    echo "";
    
    # Python 3.10
    if [ -e "/usr/local/bin/python3.10" ]; then
        echo "${YELLOW}检测到已安装 Python 3.10，跳过${YELLOW}"
    else
        echo "${PINK}开始下载并编译安装 Python v3.10.12 o(￣ヘ￣o#)，过程较耗时，等着吧！${PINK}"
        echo "${RES}${RES}";
        
        wget https://repo.huaweicloud.com/python/3.10.12/Python-3.10.12.tgz
        tar -xf Python-3.10.12.tgz
        cd Python-3.10.12
        ./configure --enable-optimizations
        make -j 8
        sudo make install
        cd ..
        rm Python-3.10.12.tgz
        rm -rf Python-3.10.12
        
        echo "${PINK}Python 3.10.12 安装成功！缓存已删除！${PINK}";
    fi
    echo "${RES}${RES}";
    
    # 初始化 Python310
    pip3.10 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    python3.10 -m pip install --upgrade pip setuptools wheel
    
    # github clone easyLLM-Index
    
    # 初始化并激活venv
    
    # pip3.10 安装一遍全量库
    
    echo "";
    echo "${PINK}    ____          __             ___ ____  ____ ${PINK}";
    echo "${PINK}   /  _/___  ____/ /__  _  __   <  // __ \/ __ )${PINK}";
    echo "${PINK}   / // __ \/ __  / _ \| |/_/   / // /_/ / __  |${PINK}";
    echo "${PINK} _/ // / / / /_/ /  __/>  <    / / \__, / /_/ / ${PINK}";
    echo "${PINK}/___/_/ /_/\__,_/\___/_/|_|   /_(_)____/_____/  ${PINK}";
    echo "${GREEN}-----------${GREEN}";
    echo "安装成功！";
    echo "- Shell作者微信：wx_0xbcyuncen";
    echo "- GitHub仓库：https://github.com/xcenweb"
    echo "-----------";
    echo "${RES}${RES}";
    
else

    echo "";
    echo "好叭咱不安装 (つ﹏<。)";
    echo "${RES}${RES}";
    
fi



# /usr/local/bin/python3.10