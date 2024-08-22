add_venv() {
    # 新增一个Python虚拟环境
    if [ ! -d $python_venvs/$1 ];then
        python -m venv $python_venvs/$1
    fi
}

del_venv() {
    # 删除一个Python虚拟环境
    deactivate
    rm -rf $python_venvs/$1
}

start_venv() {
    # 启用虚拟环境
    if [ -d $python_venvs/$1 ];then
        source $python_venvs/$1/bin/activate
    fi
}