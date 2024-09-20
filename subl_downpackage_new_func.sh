#!/usr/bin/env bash

# -------------------------------------------------- #
# 		        新的下载安装插件包函数脚本
#     使用查询channel json 文件获取相应的相应的插件包信息
# -------------------------------------------------- #

# 读取包列表
function read_package_list() {
    # 读取包列表构建数组
    # ["name1:version","name2:version"]

    # 列表文件地址数组
    # 可以传多个插件文件参数
    # package_list 目录下的文件
    local arg_list=($@)

    # local default_plugin_list=".package_list/pklist_default.txt"

    # 插件数组
    local package_arr=()

    # 循环参数列表
    # 获取多个插件列表文件
    if [[ $# -eq 0 ]]; then
        echo -e "\e[93m请至少指定一个插件列表！\n \e[0m"
    else
        for file_tmp in "${arg_list[@]}"; do

            # 读取插件列表
            # 遍历插件列表获取每一个插件信息
            if [[ -f $file_tmp ]]; then
                # echo $file_tmp
                for line in $(cat "$file_tmp" | grep -v "^$" | grep -v "^#"); do
                    # 添加进数组中
                    # echo "$line"
                    package_arr+=("$line")
                done
            else
                echo -e "\e[96m$file_tmp \e[93m文件不存在！\n \e[0m"
            fi
        done
    fi

    # 返回数组
    # echo ${#package_arr[@]}
    echo "${package_arr[@]}"
}

# 解析 channel json 文件
function analysis_json() {

    # channel json 地址
    # https://packagecontrol.github.io/channel/channel_v4.json
    # https://packagecontrol.io/channel_v3.json
    local channel_json_v4="https://packagecontrol.github.io/channel/channel_v4.json"
    local channel_json_v3="https://packagecontrol.io/channel_v3.json"

    # 插件名
    local package_name=$1
    # 版本号
    local package_version=$2

    # 如果不给任何参数
    if [[ $# -eq 0 ]]; then
        echo -e "\e[92m请指定包的名称及版本号！ \n \e[0m"
    fi

    if [[ -z $package_name ]]; then
        echo -e "\e[92m请指定包的名称！ \n \e[0m"
    fi

    # 如果没给版本号，默认是 latest 即取最新版
    if [[ -z $package_version ]]; then
        package_version="latest"
    fi

    # curl https://packagecontrol.io/channel_v3.json | jq '.["packages_cache"]'
    # cat channel_jq_test.json| jq '.packages_cache.[].[]|{name,releases}'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|{name,authors,releases}'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")|{url}'
    # curl https://packagecontrol.io/channel_v3.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")|{url}'
    # curl https://packagecontrol.io/channel_v3.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2").url'
    # curl https://packagecontrol.io/channel_v3.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[0].url'
    echo -e "\e[93m解析json文件成功！ \n \e[0m"
}

# 下载包
function download_package() {

    # 包的url
    local package_url=$1

    if [[ $# -eq 0 ]]; then
        echo -e "\e[92m请指定插件包的url \n \e[0m"
    fi

    echo -e "\e[93m下载包成功！ \n \e[0m"

}

# 解包
function unpackage() {

    # 判断包中第一层文件一是否大于一个
    # 大于一个，证明此包不用再解压及重新构建包，直接更名就可以丢到.config/sublime-text/Installed Packages 目录
    # 如果第一层只有一个目录，证明需要解压，然后重新构建包

    # 计算包中一级文件或目录数量
    # zipinfo -1 AFileIcon-3.28.0.zip | awk 'BEGIN{FS="/"}{print $1}' | uniq | wc -l
    # 或者写成这样：zipinfo -1 AFileIcon-3.28.0.zip | awk -F "/" '{print $1}' | uniq | wc -l

    echo -e "\e[93m解压缩包成功！ \n \e[0m"
}

# 构建包
function build_package() {

    # download_package

    # unpackage

    # 构建

    echo -e "\e[93m构建包成功！ \n \e[0m"
}

# -----------------------执行区----------------------- #
# 测试 读取插件列表文件函数
# arr_1=($(read_package_list "$@"))
# echo "${arr_1[@]}"

# for pk_tmp in "${arr_1[@]}"; do
#     echo $pk_tmp
# done

# echo "-----------------------------------------"

# echo ${#arr_1[@]}
# echo "${arr_1[@]}"
# echo "${arr_1[0]}"
# echo "${arr_1[1]}"
