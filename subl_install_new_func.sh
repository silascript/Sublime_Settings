#!/usr/bin/env bash

# -------------------------------------------------- #
# 		        新的安装插件包函数脚本
#
# -------------------------------------------------- #

# -----------------------导入脚本----------------------- #

# 导入下载脚本
source ./subl_downpackage_new_func.sh

# 引入监视器脚本
# source ./subl_monitor.sh

# -----------------------函数定义----------------------- #

# 解包
# 参数1: 压缩包路径
# 参数2: 缓存目录
function unpackage() {

    # 判断包中第一层文件一是否大于一个
    # 大于一个，证明此包不用再解压及重新构建包，直接更名就可以丢到.config/sublime-text/Installed Packages 目录
    # 如果第一层只有一个目录，证明需要解压，然后重新构建包

    # 计算包中一级文件或目录数量
    # zipinfo -1 AFileIcon-3.28.0.zip | awk 'BEGIN{FS="/"}{print $1}' | uniq | wc -l
    # 或者写成这样：zipinfo -1 AFileIcon-3.28.0.zip | awk -F "/" '{print $1}' | uniq | wc -l

    # 压缩包路径
    local pkg_file_path=$1

    # 缓存目录
    local cache_dir=$2
    # 如果没指定缓存目录则指定默认.Cache目录
    if [[ -d "$cache_dir" ]]; then
        cache_dir=".Cache"
    fi

    # 查看压缩包内第一层目录有几个
    local zip_rdir_count=$(zipinfo -1 "$pkg_file_path" | awk -F "/" '{print $1}' | uniq | wc -l)

    # echo "$zip_rdir_count"

    # zip包名称 xxx.zip
    local zip_file="${pkg_file_path##*\/}"

    # 解压临时目录
    # 即解压后的目录
    local unpack_dir_temp="${zip_file%%.*}"

    # echo "$unpack_dir_temp"

    # 解压
    # 如果压缩包根目录只有一个，那无须管，直接解压
    # 如果压缩包根目录不止一个，就使用压缩包的包名作为解压后的目录名
    if [[ $zip_rdir_count -eq 1 ]]; then
        # zip包第一层目录
        local zip_rdir=$(zipinfo -1 "$pkg_file_path" | awk -F "/" '{print $1}' | uniq)
        # 解压
        unzip -q -d "$cache_dir" "$pkg_file_path"
        unpack_dir_temp="$zip_rdir"
    else
        # 解压
        unzip -q -d "$cache_dir/$unpack_dir_temp" "$pkg_file_path"
    fi

    # if [[ -d "$cache_dir/$unpack_dir_temp" ]]; then
    #     echo -e "\e[96m$pkg_file_path \e[92m解压缩成功！ \n \e[0m"
    # else
    #     echo -e "\e[96m$pkg_file_path \e[93m解压缩失败！ \n \e[0m"
    # fi
    # 返回解压后的目录
    echo $unpack_dir_temp
}

# 构建包
function build_package() {

    # download_package

    # unpackage

    # 构建

    echo -e "\e[93m构建包成功！ \n \e[0m"
}

# -----------------------执行区----------------------- #

# 测试 解包函数 unpackage

# pkg_name="NeoVintageous"
# 解析json
# d_url=$(analysis_json "$pkg_name")
# 下载
# download_package "$d_url" ".Cache" "NeoVintageous.zip"
# 解压
# unpack_d=$(unpackage ".Cache/NeoVintageous.zip" ".Cache")
# echo "解压后的目录为：$unpack_d"

# 模拟一个没有只有一个根目录的压缩包解压
# unpack_d=$(unpackage ".Cache/zip_tmp.zip" ".Cache")
# echo ${#unpack_d}

# echo "解压后的目录为：$unpack_d"
