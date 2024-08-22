#!/bin/bash
# 作者：xcenweb@gmail.com
# 仓库：https://github.com/xcenweb


config_modelhub_type="modelscope" # 模型库
config_modelhub_link="IndexTeam/Index-1.9B-Chat" # 模型链接

config_runner_github="xcenweb/em_index1.9B" # 运行器github链接
config_runner_dir="em_index1.9B" # 运行器安装至目录
config_runner_type=(api web cli) # 运行器类型
config_runner_file=("api.py" "web.py" "cli.py") # 运行器对应文件名及命令后缀

description="B站发布的index1.9B大语言模型" # 简介


logo() {
    # 安装器logo
    echo "    ____          __             ___ ____  ____ ";
    echo "   /  _/___  ____/ /__  _  __   <  // __ \/ __ )";
    echo "   / // __ \/ __  / _ \| |/_/   / // /_/ / __  |";
    echo " _/ // / / / /_/ /  __/>  <    / / \__, / /_/ / ";
    echo "/___/_/ /_/\__,_/\___/_/|_|   /_(_)____/_____/  ";
    echo
    echo "欢迎使用b站 Index1.9B for easyLLM 部署工具 ((つ≧▽≦)つ";
    echo "- 作者微信：wx_0xbcyuncen";
    echo "- GitHub仓库：https://github.com/xcenweb/easyLLM";
}


detailedIntroduction() {
    # 安装器详细介绍
    echo "B站发布的index1.9B大语言模型"
}


install_event() {
    # 安装器开始安装事件
    # - return 0 继续安装
    # - return 1 取消安装
    read -p "确认安装[y/n]：" yn
    
    if [ $yn == "y" ]; then
        echo "开始安装";
        return 0
    else
        echo "取消安装";
        return 1
    fi
}


installed_event() {
    # 安装器安装结束事件
    echo "安装结束！";
}


downloadModel_event() {
    # 下载模型开始事件
    
}


downloadedModel_event() {
    # 下载模型结束事件
    # 传入 $1 模型安装到的path
}

#######################

install() {
    # 替换默认安装方法
    return 1
}

downloadModel() {
    # 替换默认下载模型方法
    return 1
}