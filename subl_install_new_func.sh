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
# 返回值: 解压后的目录名
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
# 参数1: 插件的名称
# 参数2: 插件的版本号
# 参数3: 插件包的下载url。可省，如果省，会通过参数1和参数2，即插件名称及版本号到json文件中解析出来
function build_package() {

    # 插件名称
    local pkg_name=$1
    # 版本号
    local pkg_version=$2

    # 插件包url
    local pkg_url=$3

    # 如果插件包url没给，就通过插件名和版本号去解析json文件获取
    if [[ -z "$pkg_url" ]]; then
        pkg_url=$(analysis_json "$pkg_name" "$pkg_version")
    fi

    # 缓存目录
    local cache_dir=$4
    # 如果没给缓存目录，就设置默认的.Cache目录
    if [[ -z "$cache_dir" ]]; then
        cache_dir=".Cache"
    fi

    # 下载插件包 download_package
    # 使用 插件名+版本号 为压缩包重命名
    local dl_pkg_name="$pkg_name-$pkg_version.zip"
    download_package "$pkg_url" "$cache_dir" $dl_pkg_name

    # unpackage
    # 解压并获取解压后的目录名
    echo -e "\e[96m开始解压 \e[92m$cache_dir/$dl_pkg_name \e[96m包... \n \e[0m"
    local unpack_dir_name=$(unpackage "$cache_dir/$dl_pkg_name" "$cache_dir")

    # echo $unpack_dir_name

    sleep 3s

    # 构建
    # 项目根路径
    # 用于构建完包后 cd 回来
    local project_root="$PWD"

    # 解压目录完整路径
    # 从系统根目录开始，非项目根
    local unpack_full_path="$project_root/$cache_dir/$unpack_dir_name"

    if [[ -d "$unpack_full_path" ]]; then
        # 压包
        # 跳转到解压目录中
        # cd "$cache_dir/$unpack_dir_name"
        cd "$unpack_full_path"
        # echo $PWD
        echo -e "\e[92m开始构建... \n \e[0m"
        sleep 3
        zip -rq "$project_root/$cache_dir/$pkg_name.sublime-package" ./*

        # 更名 将后缀名改成 sublime-package
        # mv "$pkg_name.zip" "$pkg_name.sublime-package"
    else
        # echo -e "\e[93m不存在 \e[96m$cache_dir/$unpack_dir_name \e[93m目录！ \e[0m"
        echo -e "\e[93m不存在 \e[96m$unpack_full_path \e[93m目录！ \e[0m"
        echo -e "\e[93m请检查 \e[96m$cache_dir \e[93m缓存目录下，是否存在此目录！\n \e[0m"
    fi

    # 再跳回项目根目录
    cd "$project_root"

    # 删除 解压目录
    if [[ -d "$unpack_full_path" ]]; then
        echo -e "\e[92m清理 \e[96m$unpack_full_path \e[92m目录... \n \e[0m"
        sleep 3
        rm -rf "$unpack_full_path"
    fi

    # 判断sublime-package包是否存在
    if [[ -f "$cache_dir/$pkg_name.sublime-package" ]]; then
        echo -e "\e[96m$cache_dir/$pkg_name.sublime-package \e[92m构建成功！ \n \e[0m"
    else
        echo -e "\e[96m$cache_dir/$pkg_name.sublime-package \e[93m不存在，构建包失败！ \n \e[0m"
    fi

    # 删除缓存目录
    # if [[ -d "$cache_dir" ]]; then
    #     rm -rf "$cache_dir"
    # fi

}

# 安装插件
function install_core() {

    echo -e "\e[96m安装插件... \e[0m"

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

# 测试 构建包函数 build_package

# build_package "NeoVintageous" "latest"
