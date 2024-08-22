exited() {
    # 退出时执行
    id=$?
    if [ $id -eq 0 ];then
        #clear
        color_echo blue "\neasyLLM::exit 退出";
        color_echo
    elif [ $id -eq 40 ];then
        bash easyLLM.sh reload
    else
        color_echo red "\neasyLLM::error 执行错误，请将上方报错相关内容提交\nissue：https://github.com/xcenweb/easyLLM/issues";
        color_echo
    fi
}

trap exited EXIT