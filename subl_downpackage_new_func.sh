#!/usr/bin/env bash

# -------------------------------------------------- #
# 		        新的下载插件包函数脚本
#     使用查询channel json 文件获取相应的相应的插件包信息
# -------------------------------------------------- #

# -----------------------函数定义----------------------- #

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
# 参数1: 插件release包的url
# 参数2: 重命名下载文件的名称。可省。如果指定重命名的文件名，那参数2 下载目标目录也必须指定。
# 参数3: 下载的目标目录，即要下载包到哪个目录中。可省略，如果省略，设默认值为".Cache"
function download_package() {

    # 包的url
    local package_url=$1

    # 重命名文件名
    local dl_file_name=$2

    if [[ $# -eq 0 ]]; then
        echo -e "\e[92m请指定插件包的url \n \e[0m"
        return 1
    fi

    # 下载到哪个目录
    local target_dir=$3
    if [[ -z $target_dir ]]; then
        target_dir=".Cache"
    fi

    # 如果下载目标目录不存在则创建
    if [[ ! -d $target_dir ]]; then
        echo -e "\e[92m创建 \e[96m$target_dir \e[92m缓存目录... \n \e[0m"
        mkdir "$target_dir"
    fi

    # 下载
    echo -e "\e[92m开始下载 \e[96m$package_url \e[92m... \n \e[0m"
    # 判断有没有指定重命名的下载文件名
    if [[ -z $dl_file_name ]]; then
        wget "$package_url" -P "$target_dir"
    else
        wget -O "$target_dir/$dl_file_name" "$package_url"
    fi

    # tail -f wget-log

    echo -e "\e[92m下载包成功！ \n \e[0m"

}

# -----------------------执行区----------------------- #

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
# r_str=$(analysis_json "DoxyDoxygen (evolution)" "latest")
# echo $r_str

# 测试 下载函数 download_package

# 获取下载url
# d_url=$(analysis_json "NeoVintageous")

# download_package "$d_url"
# 使用重命名下载文件文件方式下载
# download_package "$d_url" ".Cache" "NeoVintageous.zip"
