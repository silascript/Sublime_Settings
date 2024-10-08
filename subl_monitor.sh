#!/usr/bin/env bash
# --------------------------------------------------- #
# 		          监视器函数脚本                        #
#                用来监控各种目录                       #
# -------------------------------------------------- #

# -----------------------函数定义----------------------- #

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
        local dir_reg="^($subl_config_dir).*"
        #目录+文件
        local dirfile=$dir$file
        if [[ "$dir" =~ $dir_reg ]]; then

            if [[ "$dirfile" == "$subl_config_dir/Lib/python38/package_control.py" && "$event" == "MODIFY" ]]; then
                # 输出监视信息
                echo -e "\e[92m$date - $time - $dir$file - $event \e[0m"
                echo -e "\e[92m已经加载完 \e[96m$dirfile \e[92m文件！\n \e[0m"
            elif [[ "$dirfile" == "$subl_config_dir/Packages/User/Package Control.user-ca-bundle" && "$event" == "CREATE" ]]; then
                # 输出监视信息
                echo -e "\e[92m$date - $time - $dir$file - $event \e[0m"
                echo -e "\e[92m创建 \e[96m$dirfile \e[92m文件！\n \e[0m"
            elif [[ "$dirfile" == "$subl_config_dir/Installed Packages/0_package_control_loader.sublime-package" && "$event" == "DELETE" ]]; then
                # 输出监视信息
                # echo -e "\e[92m$date - $time - $dir$file - $event\n \e[0m"
                echo -e "\e[92m删除 \e[96m$dirfile \e[92m文件！ \e[0m"
                echo -e "\e[96m请手动重启 \e[92mSublime Text \e[96m以完成 \e[92mPackage Control \e[96m安装！\n \e[0m"
            elif [[ "$dirfile" == "$subl_config_dir/Trash" && "$event" == "CREATE,ISDIR" ]]; then
                # 输出监视信息
                # echo -e "\e[92m$date - $time - $dir$file - $event\n \e[0m"
                echo -e "\e[92mPackage Control \e[96m安装完成！\n \e[0m"
                # 杀掉 inotifywait 进程
                pkill -9 inotifywait
            # else
            #     # 输出监视信息
            #     echo "$date - $time - $dir$file - $event"
            fi
        fi
    done
}

# 解压缩包监视器
# function subl_unpack_monitor() {

#     # 要监控的缓存目录
#     # 此目录用来下载及解压包的临时目录
#     local cache_dir=$1

#     # 包解压后的目录
#     local unpack_dir=$2

#     inotifywait -mrq --timefmt "%d/%m/%y#%H:%M" --format '%T#%w#%f#%e' -e create,delete,modify,attrib "$cache_dir" | while IFS=\# read date time dir file event; do

#         #目录+文件
#         local dirfile=$dir$file
#         if [[ "$dir" == "$unpack_dir" ]]; then
#             echo "$date - $time - $dir$file - $event"

#             if [[ "$event" == "DELETE,ISDIR" ]]; then

#                 echo -e "\e[92m$date - $time - $dir$file - $event \e[0m"
#                 echo -e "\e[92m删除 \e[96m$dir \e[92m目录！ \n \e[0m"
#                 # 停止监视
#                 pkill -9 inotifywait
#             fi
#         fi
#     done

# }

# -----------------------执行区----------------------- #
# subl_configdir_monitor "$HOME/.config" &
# subl_configdir_monitor
