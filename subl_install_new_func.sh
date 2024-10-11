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

# 读取包列表
# 可多个参数
# 每个参数都为插件文件列表文件
# 至少要有一个参数，即至少给一个插件文件列表文件
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

# 读取插件包列表yaml文件
# 参数为插件的yaml文件
# 此函数使用到 yaml 解析工具 yq
# 返回 插件名:版本号 数组
function read_package_list_yml() {

    # 列表文件地址数组
    # 可以传多个插件文件参数
    # package_list 目录下的文件
    local arg_list=($@)

    # 插件数组
    local package_arr=()

    # 循环参数列表
    # 获取多个插件列表文件
    if [[ $# -eq 0 ]]; then
        echo -e "\e[93m请至少指定一个插件列表yaml文件！\n \e[0m"
    else
        for file_tmp in "${arg_list[@]}"; do

            # 读取插件列表
            # 遍历插件列表获取每一个插件信息
            if [[ -f $file_tmp ]]; then
                # echo $file_tmp

                # cat package_list/pklist_basic.yml | yq -r '.sublime-packages.[]| select(.name=="NeoVintageous")
                # cat package_list/pklist_basic.yml | yq -r '.sublime-packages.[]'
                # cat package_list/pklist_basic.yml | yq -r '.sublime-packages.[] | .name'
                # cat package_list/pklist_basic.yml | yq -r '.sublime-packages.[] | .version'

                # 查询 依赖插件列表
                # cat package_list/pklist_default.yml | yq -r '.dependence[]'

                # 依赖 yaml 文件
                local pk_dependence_yml_temp=$(cat "$file_tmp" | yq -r '.dependence[]')
                # echo "$pk_dependence_yml_temp"
                if [[ -n "$pk_dependence_yml_temp" ]]; then

                    # 循环各 yaml 文件
                    # cat "$file_tmp" | yq -r '.dependence[]' | while read line; do

                    # IFS=$'\n' # 设置内部字段分隔符为换行符
                    # 将字符串转成数组
                    # local dependence_yml_arr=("$pk_dependence_yml_temp")
                    # unset IFS # 恢复IFS为默认值
                    #
                    # local sub_pk_arr=($(read_package_list_yml "${dependence_yml_arr[@]}"))
                    local sub_pk_arr=($(read_package_list_yml "$pk_dependence_yml_temp"))

                    package_arr+=("${sub_pk_arr[@]}")

                    # 遍历出yml中插件
                    # for pk_temp in "${sub_pk_arr[@]}"; do
                    #     package_arr+=("$pk_temp")
                    # done

                    # done

                fi

                # 添加进数组中
                # echo "$line"
                # package_arr+=("$line")
                IFS=$'\n' # 设置内部字段分隔符为换行符
                local pk_name_arr=($(cat "$file_tmp" | yq -r '.sublime-packages.[] | .name'))
                local pk_version_arr=($(cat "$file_tmp" | yq -r '.sublime-packages.[] | .version'))

                unset IFS # 恢复IFS为默认值

                # 遍历两数组
                for i in "${!pk_name_arr[@]}"; do
                    local pk_name="${pk_name_arr[$i]}"
                    local pk_version="${pk_version_arr[$i]}"

                    # 将 名称:版本 字符串添加进返回数组
                    package_arr+=("$pk_name":"$pk_version")

                done
            else
                echo -e "\e[96m$file_tmp \e[93myaml文件不存在！\n \e[0m"
            fi
        done
    fi

    # echo "数组个数：${#package_arr[@]}"

    # 返回数组
    # echo ${#package_arr[@]}
    # 返回的数组元素格式：name:version 都名称和版本号用冒号:分隔
    echo "${package_arr[@]}"
}

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
    if [[ -z "$cache_dir" ]]; then
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
# 返回 插件包名称：插件名.sublime-package 默认放在 .Cache 缓存目录下
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
    echo -e "\e[92m开始解压 \e[96m$cache_dir/$dl_pkg_name \e[92m ... \n \e[0m"
    sleep 2s
    local unpack_dir_name=$(unpackage "$cache_dir/$dl_pkg_name" "$cache_dir")

    # echo $unpack_dir_name
    sleep 2s

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
        echo -e "\e[92m已经将 \e[96m$dl_pkg_name \e[92m解压到 \e[96m$unpack_full_path \e[92m目录！ \n \e[0m"
        echo -e "\e[92m开始构建sublime-package包 ... \n \e[0m"
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
        echo -e "\e[92m清理 \e[96m$unpack_full_path \e[92m目录 ... \n \e[0m"
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

    # echo $PWD

    # 返回 sublime-package 包名称
    echo "$pkg_name.sublime-package"

}

# 安装插件
function install_core() {

    # 插件名称
    local pkg_name=$1
    # 版本号
    local pkg_version=$2

    # 缓存目录
    local cache_dir=$3

    # 如果没给缓存目录，就设置默认的.Cache目录
    if [[ -z "$cache_dir" ]]; then
        cache_dir=".Cache"
    fi

    echo -e "\e[96m安装插件... \e[0m"

}

# 批量安装
# 参数：插件列表文件 可以有多个参数，即多个插件列表文件
function install_batch() {

    # 获取 包名:版本 字符串数组
    local pkg_namev_arr=($(read_package_list "$@"))

    # echo "${pkg_namev_arr[@]}"

    echo -e "\e[96m批量安装插件... \e[0m"
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

# 测试 解包函数 unpackage

# pkg_name="NeoVintageous"
# 解析json
# d_url=$(analysis_json "$pkg_name")
# 下载
# download_package "$d_url" "NeoVintageous.zip" ".Cache"
# 不给第三个参数，即缓存目录
# download_package "$d_url" "NeoVintageous.zip"
# 解压
# unpack_d=$(unpackage ".Cache/NeoVintageous.zip" ".Cache")
# 不给第三个参数，即缓存目录
# unpack_d=$(unpackage ".Cache/NeoVintageous.zip")
# echo "解压后的目录为：$unpack_d"

# 模拟一个没有只有一个根目录的压缩包解压
# unpack_d=$(unpackage ".Cache/zip_tmp.zip" ".Cache")
# echo ${#unpack_d}

# echo "解压后的目录为：$unpack_d"

# 测试 构建包函数 build_package

# build_package "NeoVintageous" "latest"
# pkg_name=$(build_package "NeoVintageous" "1.34.2")
# echo "$pkg_name"

# ======================================== #

# 测试 解析yaml 函数 read_package_list_yml
# pk_list_arr_test=($(read_package_list_yml "./package_list/pklist_basic.yml"))
# pk_list_arr_test=($(read_package_list_yml "./package_list/pklist_default.yml"))

# echo "${pk_list_arr_test[@]}"

# 测试 批量安装 函数
# install_batch "./package_list/pklist_basic.txt"
