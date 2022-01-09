#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

version="v1.0.0"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Sai lầm: ${plain} Tập lệnh này phải được chạy với tư cách người dùng root!\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}Phiên bản hệ thống không được phát hiện, vui lòng liên hệ với tác giả kịch bản!${plain}\n" && exit 1
fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}Vui lòng sử dụng CentOS 7 trở lên!${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Vui lòng sử dụng Ubuntu 16 hoặc cao hơn!${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Vui lòng sử dụng Debian 8 trở lên!${plain}\n" && exit 1
    fi
fi

confirm() {
    if [[ $# > 1 ]]; then
        echo && read -p "$1 [vỡ nợ$2]: " temp
        if [[ x"${temp}" == x"" ]]; then
            temp=$2
        fi
    else
        read -p "$1 [y/n]: " temp
    fi
    if [[ x"${temp}" == x"y" || x"${temp}" == x"Y" ]]; then
        return 0
    else
        return 1
    fi
}

confirm_restart() {
    confirm "có nên khởi động lại soga" "y"
    if [[ $? == 0 ]]; then
        restart
    else
        show_menu
    fi
}

before_show_menu() {
    echo && echo -n -e "${yellow}Nhấn enter để quay lại menu chính: ${plain}" && read temp
    show_menu
}

install() {
    bash <(curl -Ls https://raw.githubusercontent.com/herotbty/Aiko-Soga-Crack/main/install.sh)
    if [[ $? == 0 ]]; then
        if [[ $# == 0 ]]; then
            start
        else
            start 0
        fi
    fi
}

update() {
    if [[ $# == 0 ]]; then
        echo && echo -n -e "Nhập phiên bản được chỉ định (phiên bản mới nhất mặc định): " && read version
    else
        version=$2
    fi
#    confirm "本功能会强制重装当前最新版，数据不会丢失，是否继续?" "n"
#    if [[ $? != 0 ]]; then
#        echo -e "${red}已取消${plain}"
#        if [[ $1 != 0 ]]; then
#            before_show_menu
#        fi
#        return 0
#    fi
    bash <(curl -Ls https://raw.githubusercontent.com/herotbty/Aiko-Soga-Crack/main/install.sh) $version
    if [[ $? == 0 ]]; then
        echo -e "${green}Cập nhật hoàn tất, soga đã được khởi động lại tự động, vui lòng sử dụng trạng thái soga để kiểm tra trạng thái khởi động${plain}"
        exit
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

uninstall() {
    confirm "Bạn có chắc chắn muốn gỡ cài đặt soga không?" "n"
    if [[ $? != 0 ]]; then
        if [[ $# == 0 ]]; then
            show_menu
        fi
        return 0
    fi
    systemctl stop soga
    systemctl disable soga
    rm /etc/systemd/system/soga.service -f
    systemctl daemon-reload
    systemctl reset-failed
    rm /etc/soga/ -rf
    rm /usr/local/soga/ -rf

    echo ""
    echo -e "Gỡ cài đặt thành công, nếu bạn muốn xóa tập lệnh này, hãy chạy sau khi thoát tập lệnh ${green}rm /usr/bin/soga -f${plain} xóa"
    echo ""

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

start() {
    check_status
    if [[ $? == 0 ]]; then
        echo ""
        echo -e "${green}soga đã chạy rồi, không cần khởi động lại, nếu muốn khởi động lại, vui lòng chọn khởi động lại${plain}"
    else
        systemctl start soga
        sleep 2
        check_status
        if [[ $? == 0 ]]; then
            echo -e "${green}soga đã bắt đầu thành công, vui lòng sử dụng trạng thái soga để kiểm tra trạng thái khởi động${plain}"
        else
            echo -e "${red}soga có thể không khởi động được, vui lòng sử dụng nhật ký soga để xem thông tin nhật ký sau${plain}"
        fi
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

stop() {
    systemctl stop soga
    sleep 2
    check_status
    if [[ $? == 1 ]]; then
        echo -e "${green}soga dừng thành công${plain}"
    else
        echo -e "${red}soga không dừng được, có thể do thời gian dừng vượt quá hai giây, vui lòng kiểm tra thông tin nhật ký sau${plain}"
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

restart() {
    systemctl restart soga
    sleep 2
    check_status
    if [[ $? == 0 ]]; then
        echo -e "${green}soga khởi động lại thành công, vui lòng sử dụng trạng thái soga để kiểm tra trạng thái khởi động${plain}"
    else
        echo -e "${red}soga có thể không khởi động được, vui lòng sử dụng nhật ký soga để xem thông tin nhật ký sau${plain}"
    fi
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

status() {
    systemctl status soga --no-pager -l
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

enable() {
    systemctl enable soga
    if [[ $? == 0 ]]; then
        echo -e "${green}soga thiết lập khởi động để bắt đầu thành công${plain}"
    else
        echo -e "${red}soga không đặt được tự khởi động khi khởi động${plain}"
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

disable() {
    systemctl disable soga
    if [[ $? == 0 ]]; then
        echo -e "${green}soga đã hủy khởi động và tự khởi động thành công${plain}"
    else
        echo -e "${red}soga không thể hủy tự khởi động khi khởi động${plain}"
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

show_log() {
    journalctl -u soga.service -e --no-pager
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

install_bbr() {
    bash <(curl -L -s https://raw.githubusercontent.com/herotbty/Aiko-bbr-Crack/master/tcp.sh)
    if [[ $? == 0 ]]; then
        echo ""
        echo -e "${green}Quá trình cài đặt bbr thành công, vui lòng khởi động lại máy chủ${plain}"
    else
        echo ""
        echo -e "${red}Không thể tải xuống tập lệnh cài đặt bbr, vui lòng kiểm tra xem máy tính của bạn có thể kết nối với Github không${plain}"
    fi

    before_show_menu
}

update_shell() {
    wget -O /usr/bin/soga -N --no-check-certificate https://raw.githubusercontent.com/herotbty/Aiko-Soga-Crack/main/soga.sh
    if [[ $? != 0 ]]; then
        echo ""
        echo -e "${red}Không tải được script xuống, vui lòng kiểm tra xem máy có thể kết nối với Github không${plain}"
        before_show_menu
    else
        chmod +x /usr/bin/soga
        echo -e "${green}Tập lệnh nâng cấp thành công, vui lòng chạy lại tập lệnh${plain}" && exit 0
    fi
}

# 0: running, 1: not running, 2: not installed
check_status() {
    if [[ ! -f /etc/systemd/system/soga.service ]]; then
        return 2
    fi
    temp=$(systemctl status soga | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
    if [[ x"${temp}" == x"running" ]]; then
        return 0
    else
        return 1
    fi
}

check_enabled() {
    temp=$(systemctl is-enabled soga)
    if [[ x"${temp}" == x"enabled" ]]; then
        return 0
    else
        return 1;
    fi
}

check_uninstall() {
    check_status
    if [[ $? != 2 ]]; then
        echo ""
        echo -e "${red}soga đã được cài đặt, vui lòng không cài đặt lại${plain}"
        if [[ $# == 0 ]]; then
            before_show_menu
        fi
        return 1
    else
        return 0
    fi
}

check_install() {
    check_status
    if [[ $? == 2 ]]; then
        echo ""
        echo -e "${red}Vui lòng cài đặt soga trước${plain}"
        if [[ $# == 0 ]]; then
            before_show_menu
        fi
        return 1
    else
        return 0
    fi
}

show_status() {
    check_status
    case $? in
        0)
            echo -e "trạng thái soga: ${green}đã được chạy${plain}"
            show_enable_status
            ;;
        1)
            echo -e "trạng thái soga: ${yellow}không chạy${plain}"
            show_enable_status
            ;;
        2)
            echo -e "trạng thái soga: ${red}Chưa cài đặt${plain}"
    esac
}

show_enable_status() {
    check_enabled
    if [[ $? == 0 ]]; then
        echo -e "Có tự động bắt đầu không: ${green}Có${plain}"
    else
        echo -e "Có tự động bắt đầu không: ${red}Không${plain}"
    fi
}

show_soga_version() {
    echo -n "phiên bản soga："
    /usr/local/soga/soga -v
    echo ""
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

show_usage() {
    echo "Cách sử dụng tập lệnh quản lý soga:- Crack By Aiko "
    echo "------------------------------------------"
    echo "soga              - Hiển thị menu quản lý (nhiều chức năng hơn)"
    echo "soga start        - khởi động soga"
    echo "soga stop         - dừng soga"
    echo "soga restart      - khởi động lại soga"
    echo "soga status       - Kiểm tra trạng thái soga"
    echo "soga enable       - Đặt soga để bắt đầu tự động"
    echo "soga disable      - Hủy tự động bắt đầu soga"
    echo "soga log          - Xem nhật ký soga"
    echo "soga update       - cập nhật soga"
    echo "soga update x.x.x - Cập nhật phiên bản đã chỉ định của soga"
    echo "soga install      - cài đặt soga"
    echo "soga uninstall    - gỡ cài đặt soga"
    echo "soga version      - xem phiên bản soga"
    echo "------------------------------------------"
}

show_menu() {
    echo -e "
  ${green}kịch bản quản lý phụ trợ soga，${plain}${red}không hoạt động với docker${plain}
--- https://github.com/RManLuo/crack-soga-v2ray ---
  ${green}0.${plain} tập lệnh thoát
————————————————
  ${green}1.${plain} cài đặt soga
  ${green}2.${plain} cập nhật soga
  ${green}3.${plain} gỡ cài đặt soga
————————————————
  ${green}4.${plain} bắt đầu soga
  ${green}5.${plain} dừng soga
  ${green}6.${plain} khởi động lại soga
  ${green}7.${plain} Kiểm tra trạng thái soga
  ${green}8.${plain} Xem nhật ký soga
————————————————
  ${green}9.${plain} Đặt soga để bắt đầu tự động
 ${green}10.${plain} Hủy tự động bắt đầu soga
————————————————
 ${green}11.${plain} Một cú nhấp chuột cài đặt bbr (hạt nhân mới nhất)
 ${green}12.${plain} xem phiên bản soga
 "
    show_status
    echo && read -p "Vui lòng nhập một lựa chọn [0-12]: " num

    case "${num}" in
        0) exit 0
        ;;
        1) check_uninstall && install
        ;;
        2) check_install && update
        ;;
        3) check_install && uninstall
        ;;
        4) check_install && start
        ;;
        5) check_install && stop
        ;;
        6) check_install && restart
        ;;
        7) check_install && status
        ;;
        8) check_install && show_log
        ;;
        9) check_install && enable
        ;;
        10) check_install && disable
        ;;
        11) install_bbr
        ;;
        12) check_install && show_soga_version
        ;;
        *) echo -e "${red}Vui lòng nhập số chính xác [0-12]${plain}"
        ;;
    esac
}


if [[ $# > 0 ]]; then
    case $1 in
        "start") check_install 0 && start 0
        ;;
        "stop") check_install 0 && stop 0
        ;;
        "restart") check_install 0 && restart 0
        ;;
        "status") check_install 0 && status 0
        ;;
        "enable") check_install 0 && enable 0
        ;;
        "disable") check_install 0 && disable 0
        ;;
        "log") check_install 0 && show_log 0
        ;;
        "update") check_install 0 && update 0 $2
        ;;
        "install") check_uninstall 0 && install 0
        ;;
        "uninstall") check_install 0 && uninstall 0
        ;;
        "version") check_install 0 && show_soga_version 0
        ;;
        *) show_usage
    esac
else
    show_menu
fi