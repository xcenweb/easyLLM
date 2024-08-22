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

apt_install() {
    # 安装apt软件包
    pkgs=$1
    for pkg in "$@"; do
        if dpkg -l | awk '{print $2}' | grep -w -q "^$pkg$"; then
            echo "$pkg 已安装"
        elif dpkg -l | awk '{print $2}' | grep -w -q "^$pkg"; then
            echo "$pkg 已安装"
        else
            echo "$pkg 未安装，正在安装..."
            sudo apt install -y "$pkg"
        fi
    done
}

pkg_install() {
    # 安装pkg软件包
    pkgs=$1
    for pkg in "$@"; do
        if dpkg -l | awk '{print $2}' | grep -w -q "^$pkg$"; then
            echo "$pkg 已安装..."
        elif dpkg -l | awk '{print $2}' | grep -w -q "^$pkg"; then
            echo "$pkg 已安装..."
        else
            echo "$pkg 未安装，现在安装..."
            pkg install -y "$pkg"
        fi
    done
}

