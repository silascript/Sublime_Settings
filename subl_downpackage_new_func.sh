#!/usr/bin/env bash

# -------------------------------------------------- #
# 		        新的下载安装插件包函数脚本
#     使用查询channel json 文件获取相应的相应的插件包信息
# -------------------------------------------------- #

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

    # curl https://packagecontrol.io/channel_v3.json | jq '.["packages_cache"]'
    # cat channel_jq_test.json| jq '.packages_cache.[].[]|{name,releases}'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|{name,authors,releases}'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")'
    # cat channel_jq_test.json| jq -r '.packages_cache.[].[]|select(.name == "NeoVintageous")|.releases[]|select(.version == "1.35.2")|{url}'
    echo -e "\e[93m解析json文件成功！ \n \e[0m"
}

# 下载包
function download_package() {

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

    echo -e "\e[93m构建包成功！ \n \e[0m"
}
