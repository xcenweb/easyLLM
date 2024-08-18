sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
pkg update -y && pkg upgrade -y
pkg install ncurses-utils python3 python-pip git -y
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple