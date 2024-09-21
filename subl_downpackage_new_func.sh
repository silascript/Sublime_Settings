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
    # 返回的数组元素格式：name:version 都名称和版本号用冒号:分隔
    echo "${package_arr[@]}"
}

# 解析 channel json 文件
# 参数1: 插件名
# 参数2: 版本号，如果省略，获取最新的
# 参数3: json 地址，可省略，默认设为https://packagecontrol.io/channel_v3.json
# 返回值: 插件release包的url地址，如果获取不到则返回"no_url"字样
function analysis_json() {

    # channel json 地址
    # https://packagecontrol.github.io/channel/channel_v4.json
    # https://packagecontrol.io/channel_v3.json
    # local channel_json_v4="https://packagecontrol.github.io/channel/channel_v4.json"

    # 如果不给任何参数
    if [[ $# -eq 0 ]]; then
        echo -e "\e[93m请指定包的名称及版本号！ \n \e[0m"
        return 1
    # elif [[ -z $package_name ]]; then
    #     echo -e "\e[92m请指定包的名称！ \n \e[0m"
    fi

    # 插件名
    local package_name=$1
    # 版本号
    local package_version=$2
    # 如果没给版本号，默认是 latest 即取最新版
    if [[ -z $package_version ]]; then
        package_version="latest"
    fi

    # channel_json v3 地址
    local channel_json_v3=$3
    if [[ -z $channel_json_v3 ]]; then
        channel_json_v3="https://packagecontrol.io/channel_v3.json"
    fi

    # echo "$channel_json_v3"

    # 下载地址
    local dl_url="no_url"

    # curl https://packagecontrol.io/channel_v3.json | jq '.["packages_cache"]'
    # cat channel_jq_test.json| jq '.packages_cache.[].[]|{name,releases}'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|{name,authors,releases}'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")|{url}'
    # curl https://packagecontrol.io/channel_v3.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")|{url}'
    # curl https://packagecontrol.io/channel_v3.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2").url'
    # curl https://packagecontrol.io/channel_v3.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[0].url'

    if [[ $package_version == "latest" ]]; then
        # echo $package_name
        # echo $package_version
        dl_url=$(curl -s $channel_json_v3 | jq -r --arg pkg_name "$package_name" '.packages_cache.[].[]| select(.name==$pkg_name)|.releases[0].url')
    else
        # echo $package_name
        # echo $package_version
        dl_url=$(curl -s $channel_json_v3 | jq -r --arg pkg_name "$package_name" --arg pkg_version "$package_version" '.packages_cache.[].[]| select(.name==$pkg_name)|.releases[]| select(.version==$pkg_version).url')
    fi

    # echo ${#dl_url}

    # 返回下载url
    if [[ -z $dl_url ]]; then
        dl_url="no_url"
        # echo -e "\e[93m取不到下载地址！ \n \e[0m"
        echo "$dl_url"
    else
        echo "$dl_url"
    fi
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

# # s1="${arr_1[0]}"

# echo $s1

# 以:分隔符替换为空格
# 然后切割字符串并构建成新数组
# arr2=(${s1//:/ })

# echo ${#arr2[@]}
# echo "${arr2[@]}"
# echo "${arr2[0]}"
# echo "${arr2[1]}"

# 测试解析json函数

# analysis_json "$@"
# analysis_json
# analysis_json "NeoVintageous"
# analysis_json "NeoVintageous" "latest"
# analysis_json "NeoVintageous" "1.35.2"
# analysis_json "NeoVintageous" "1.34.2"
# 带空格的name值
# analysis_json "A File Icon" "latest"
# analysis_json "A File Icon" "3.27.0"

# 测试获取地址url
# r_str=$(analysis_json NeoVintageous 1.34.2)
# echo $r_str

# 测试不存在url
# r_str=$(analysis_json "NeoVintageous" "1.34.1")
# echo $r_str
