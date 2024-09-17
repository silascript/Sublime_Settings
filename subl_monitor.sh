#!/usr/bin/env bash

# .config/sublime-text 目录监视器
function subl_configdir_monitor() {
    # 要监视的目录
    # local file_dir=$1
    # local file_dir="$HOME/.config"
    local config_dir=$HOME/.config
    local subl_config_dir=$config_dir/sublime-text

    # echo $file_dir

    # inotifywait -mrq --timefmt "%d/%m/%y %H:%M" --format '%T %f %w %e' -e create,delete,modify,attrib "$config_dir" | while read date time file dir event; do
    inotifywait -mrq --timefmt "%d/%m/%y#%H:%M" --format '%T#%w#%f#%e' -e create,delete,modify,attrib "$config_dir" | while IFS=\# read date time dir file event; do
        # 目录正则
        dir_reg="^($subl_config_dir).*"
        #目录+文件
        dirfile=$dir$file
        if [[ "$dir" =~ $dir_reg ]]; then

            if [[ "$dirfile" == "$subl_config_dir/Lib/python38/package_control.py" && "$event" == "MODIFY" ]]; then
                # 输出监视信息
                echo -e "\e[92m$date - $time - $dir$file - $event\n \e[0m"
                echo -e "\e[92m已经加载完 \e[96m$dirfile \e[92m文件！\n \e[0m"
            elif [[ "$dirfile" == "$subl_config_dir/Packages/User/Package Control.user-ca-bundle" && "$event" == "CREATE" ]]; then
                # 输出监视信息
                echo -e "\e[92m$date - $time - $dir$file - $event\n \e[0m"
                echo -e "\e[92m创建 \e[96m$dirfile \e[92m文件！\n \e[0m"
            elif [[ "$dirfile" == "$subl_config_dir/Installed Packages/0_package_control_loader.sublime-package" && "$event" == "DELETE" ]]; then
                # 输出监视信息
                echo -e "\e[92m$date - $time - $dir$file - $event\n \e[0m"
                echo -e "\e[92m删除 \e[96m$dirfile \e[92m文件！\n \e[0m"
                echo -e "\e[96m请手动重启Sublime Text 完成 Package Control 安装！\n \e[0m"
            elif [[ "$dirfile" == "$subl_config_dir/Trash" && "$event" == "CREATE,ISDIR" ]]; then
                # 输出监视信息
                echo -e "\e[92m$date - $time - $dir$file - $event\n \e[0m"
                echo -e "\e[92mPackage Control 安装完成！\n \e[0m"
                # 杀掉 inotifywait 进程
                pkill -9 inotifywait
            else
                # 输出监视信息
                echo "$date - $time - $dir$file - $event"
            fi
        fi
    done
}

# -----------------------------测试------------------------------------- #
# subl_configdir_monitor "$HOME/.config" &
subl_configdir_monitor
