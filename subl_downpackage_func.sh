#!/usr/bin/env bash
# -------------------------------------------------- #
# 		下载安装插件包函数脚本
# -------------------------------------------------- #

# -------------------------------------------------- #
# 		  全局变量区
# -------------------------------------------------- #

# 当前路径 脚本所在的路径
setting_sh_root=$PWD

#----------------------------------------------------#

#----------------------------------------------------#
#		   函数定义区
#----------------------------------------------------#

# 生成缓存目录
function createCacheDir() {

	# 缓存目录
	local cachedir=".Cache"

	local subl_cdir=$1

	# 检测缓存目录是否已经存在
	if [[ ! -d $subl_cdir ]]; then
		echo -e "\e[96m 新建\e[93m .Cache \e[96m目录,用于临时保存下载文件！\n  \e[0m"
		mkdir .Cache
	else
		echo -e "\e[93m $cachedir \e[96m已存在！\n \e[0m"
	fi

}

# 将github地址变成数组
# 以/为分隔符
# function getGithubAddrsArray(){
#
# # github 仓库地址
# r_addrs=$1
#
# # 判断仓库地址有没有.git
# # 有就去除.git
# if [ ${r_addrs##*.}x = "git"x ];then
# r_addrs=${r_addrs%.*}
# fi
#
# # 使用空格替换斜杠作为分隔符，以此将字符串分割成数组
# arr_ads=(${r_addrs//\// })
#
# echo ${arr_ads[@]}
# }

# 从仓库地址获取仓库名
# 主要用于获取下载下来github项目的目录名
function getRepoName() {

	# github 仓库地址
	local repo_addrs=$1

	# 判断仓库地址有没有.git
	# 有就去除.git
	if [[ ${repo_addrs##*.}x = "git"x ]]; then
		repo_addrs=${repo_addrs%.*}
	fi

	# 使用空格替换斜杠作为分隔符，以此将字符串分割成数组
	local arr_addrs=(${repo_addrs//\// })
	# arr_addrs=$(getGithubAddrsArray $1)

	# 取最后一个元素
	# 取最后一个元素的索引
	#repo_index=$((${#arr_addrs[@]}-1))
	# repo_name=${arr_addrs[-1]}

	# 如果是github仓库分支
	# 就取倒数第三个
	if [[ ${arr_addrs[-2]} == "tree" ]]; then
		local repo_name=${arr_addrs[-3]}
	else
		local repo_name=${arr_addrs[-1]}
	fi

	echo $repo_name

}

# 通过github地址下载
function download_by_github_address() {
	# 下载
	# 第一个参数是github地址
	# 第二个参数是下载的目标目录路径

	# github 仓库地址
	local github_addrs=$1

	# 判断仓库地址有没有.git
	# 有就去除.git
	if [ ${github_addrs##*.}x = "git"x ]; then
		github_addrs=${github_addrs%.*}
	fi

	# 使用空格替换斜杠作为分隔符，以此将字符串分割成数组
	local arr1=(${github_addrs//\// })

	# 取出tree之前的地址
	if [[ ${arr1[-2]} == "tree" ]]; then
		# echo ${s1%/tree*}
		# 取tree左边的地址
		github_addrs=${github_addrs%/tree*}
		# 使用分支参数下载
		# 取数组最后一个元素为分支名
		git clone -b ${arr1[-1]} $github_addrs $2
	else
		git clone $1 $2
	fi

}

# github release 包下载
# 第一个参数是下载地址
# 第二个参数是存储目录
function download_by_release_address() {

	# $1包地址
	# $2下载到哪个目录
	local s1=$1
	# 将/替换为空格，并按空格切割成数组
	local arr1=(${s1//\// })

	if [ ${arr1[1]} == "github.com" ] && [[ ${arr1[4]} == "releases" || ${arr1[4]} == "archive" ]]; then
		# 使用代理加速
		# 代理加速网址
		# 使用 https://github.moeyy.xyz/ 来加速下载release包
		local proxy_addrs=https://github.moeyy.xyz/

		wget $proxy_addrs$1 -P $2
	else
		wget $1 -P $2
	fi
}

# 通过 Github 库 构建 sublime-package 包
function buildPackage_githubRepo() {

	# 缓存目录
	local cachedir=".Cache"

	# 包目录
	local packages_path=~/.config/sublime-text/Packages
	local installed_packages_path=~/.config/sublime-text/'Installed Packages'

	# github 库的地址
	local github_addrs=$1

	# 通过仓库地址获取仓库名称
	# 这个名称亦为下载后的目录名
	local repoName=$(getRepoName $github_addrs)

	# 下载后的项目路径
	local repo_path=$cachedir/$repoName

	# 通过路径判断项目是否已经下载
	if [ ! -d "$repo_path" ]; then
		echo -e "\e[96m 开始下载...\n \e[0m"
		# 下载
		download_by_github_address $github_addrs $repo_path

		# 获取判断是否下载成功
		if [ $? -eq 0 ]; then
			echo -e "\e[96m $repoName 下载成功！\n \e[0m"
			echo -e "\e[96m $repoName 开始构建 sublime-package 包...\n \e[0m"

			# 构建 sublime-package
			#echo $PWD

			# 进入到.Cache目录
			# 为下载github库作准备
			cd $repo_path

			# 如果存在.git目录，就删掉
			git_dir=.git
			if [ -d "$git_dir" ]; then
				echo -e "\e[96m 删除\e[93m $git_dir\n \e[0m"
				rm -rf .git
			fi

			# 将当成目录中所有文件都打包成 zip
			echo -e "\e[96m 打包... \n \e[0m"
			zip -r -q $repoName ./*
			#ls -al
			# 移动到 Sublime Packages目录
			if [ -f "$repoName.zip" ]; then
				echo -e "\e[96m移动 \e[92m'$repoName.zip' \e[96m至 \e[92m'$installed_packages_path' \e[96m目录... \n \e[0m"
				mv "$repoName.zip" "$installed_packages_path/$repoName.sublime-package"
			fi
			# 跳回 Sublime_Settings根目录
			cd $setting_sh_root
			# 删除项目目录
			echo -e "\e[96m 删除 \e[93m $repo_path \e[96m目录...\n \e[0m"
			rm -rf $repo_path
		else
			echo -e "\e[92m 下载存在问题! \e[0m"
		fi

	else
		echo -e "\e[96m \e[93m$repoName \e[96m项目已下载！\e[0m"
	fi
}

# 使用release zip 包来构建
# 如 ChineseLocalization 包
# 因为 这个包github库与release包结构存在差异
# 并且github库构建的sublime-package包在使用时效果不理想
function buildPackage_zip() {

	# 缓存目录
	local cachedir=".Cache"

	# 包目录
	local packages_path=~/.config/sublime-text/Packages
	local installed_packages_path=~/.config/sublime-text/'Installed Packages'

	# release 包地址
	local release_addrs=$1

	# 代理加速网址
	# 使用 https://github.moeyy.xyz/ 来加速下载release包
	# proxy_addrs=https://github.moeyy.xyz/

	# 从下载地址获取包名
	local zipName=$(getRepoName $release_addrs)

	# 下载后的包路径
	local repo_path=$cachedir/$zipName

	# 通过路径判断.Cache下是否已经下载了包
	# 不存在就下载
	if [ ! -f "$repo_path" ]; then
		echo -e "\e[96m 开始下载...\n \e[0m"
		# 下载
		download_by_release_address $release_addrs $cachedir

		# 获取判断是否下载成功
		if [ $? -eq 0 ]; then
			echo -e "\e[96m \e[92m$zipName \e[96m下载成功！\n \e[0m"
		else
			echo -e "\e[96m \e[93m$zipName \e[96m下载失败！\n \e[0m"
		fi
	fi

	#ls -al $cachedir

	# 查看zip包中到底有几个文件或目录
	# 如果只有一个，那就解压，进行一步打包操作
	# 如果是多个目录或文件，那就直接把后缀名更改为 sublime-package 移动到SublimeText插件目录
	# zip -sf xxx.zip | awk -F "/" 'NR>2 {print line} {line=$0}' | awk -F "/" '{print $1}' | uniq | wc -l
	# 压缩包内的数量
	local file_count=$(zip -sf $cachedir/$zipName | awk -F "/" 'NR>2 {print line} {line=$0}' | awk -F "/" '{print $1}' | uniq | wc -l)
	if [ $file_count -gt 1 ]; then
		# 去除.zip后缀名
		if [ ${zipName##*.}x = "zip"x ]; then
			zipName_nozip=${zipName%.*}
		fi

		echo -e "\e[96m 移动 \e[92m'$zipName_nozip.zip' \e[96m至 \e[92m'$installed_packages_path' \e[96m目录...\n \e[0m"
		mv $repo_path "$installed_packages_path/"$zipName_nozip.sublime-package
		return
	fi

	# 解压
	# 获取 压缩包内文件列表
	# 主要取解压后的目录名
	local unzip_dir=$(unzip -l $repo_path | awk 'NR==5{print $NF}')

	#echo $unzip_dir

	# 使用空格替换横杠作为分隔符，以此将字符串分割成数组
	local uz_arr=(${unzip_dir//-// })

	# 取第一个元素
	# 这是 sublime-package 包的名称
	local sublpk_name=${uz_arr[0]}
	# 把最后的斜杠 / 去除
	sublpk_name=${sublpk_name%/*}

	#echo $sublpk_name

	# 开始解压
	echo -e "\e[96m 开始解压 \e[92m$zipName \e[96m...\n \e[0m"
	unzip $repo_path -d $cachedir
	#echo $pk_name

	if [ -d "$cachedir/$unzip_dir" ]; then
		echo -e "\e[96m \e[92m$zipName \e[96m解压成功！\n \e[0m"
	else
		echo -e "\e[93m $zipName 解压失败！\n \e[0m"
	fi

	#ls -al $cachedir

	# 构建 sublime-package
	echo -e "\e[96m 开始构建 sublime-package 包...\n \e[0m"
	# 跳转到解压后的目录
	cd $cachedir/$unzip_dir

	# 只有一个目录没有其他文件
	echo -e "\e[96m 开始打包... \e[0m"
	zip -r -q $sublpk_name *
	# 将压缩包移到 ~/.config/sublime-text/Installed Packages
	if [ -f "$sublpk_name.zip" ]; then
		echo -e "\e[96m 移动 \e[92m'$sublpk_name.zip' \e[96m至 \e[92m'$installed_packages_path' \e[96m目录...\n \e[0m"
		mv "$sublpk_name.zip" "$installed_packages_path/"$sublpk_name.sublime-package
		# 删除解压的目录
		cd $setting_sh_root
		echo -e "\e[96m 删除 \e[92m'$cachedir/$unzip_dir' \e[96m目录... \n \e[0m"
		rm -rf $cachedir/$unzip_dir
	else
		echo -e "\e[96m 没找到 \e[93m'$sublpk_name.zip' \n \e[0m"
	fi
	#ls -al $cachedir
	#echo $cachedir/$pk_name

}

# 通过github地址安装插件
function install_package_github() {
	# 包地址
	local paddrs=$1

	# 下载及构建
	buildPackage_githubRepo $paddrs

}

# 安装zip插件
function install_package_zip() {
	# zip 包地址
	local zip_addrs=$1

	# 下载构建
	buildPackage_zip $zip_addrs

}

# 安装sublime-package插件
# 如果是sublime-package格式
# 直接把包移到~/.config/sublime-text/Intalled Package/目录
function install_package_sbpk() {

	# 缓存目录
	local cachedir=".Cache"

	# 包目录
	local packages_path=~/.config/sublime-text/Packages
	local installed_packages_path=~/.config/sublime-text/'Installed Packages'

	local pk_addrs=$1

	# 使用空格替换斜杠作为分隔符，以此将字符串分割成数组
	local arr_addrs=(${pk_addrs//\// })

	# 文件名称
	# 取最后一个元素
	# 取最后一个元素的索引
	local sbpk_name=${arr_addrs[-1]}

	if [ ${pk_addrs##*.}x = "sublime-package"x ]; then

		# 取不带后缀名的包名
		local sbpk_name_without_suffix=${sbpk_name%.*}

		# 处理 A File Icon这个特殊的插件
		# if [ "$sbpk_name" == "A.File.Icon.sublime-package" ];then
		dotstr="."
		if [[ $sbpk_name_without_suffix == *$dotstr* ]]; then
			# sbpk_name="A File Icon.sublime-package"
			echo -e "\e[96m 开始下载 \e[92m$sbpk_name \e[96m...\n \e[0m"

			# 将.替换为空格
			sbpk_name_without_suffix_space=${sbpk_name_without_suffix//./ }

			# 使用 https://github.moeyy.xyz/ 来加速下载release包
			local proxy_addrs=https://github.moeyy.xyz/
			# wget $proxy_addrs$pk_addrs -O "$cachedir/$sbpk_name"
			# 重新组装sublime-package包的名称
			sbpk_name=$sbpk_name_without_suffix_space.sublime-package
			wget $proxy_addrs$pk_addrs -O "$cachedir/$sbpk_name"
		else
			echo -e "\e[96m 开始下载 \e[92m$sbpk_name \e[96m...\n \e[0m"
			download_by_release_address $pk_addrs $cachedir
		fi

		#wget $pkaddrs -P $cachedir
		echo -e "\e[96m 开始移动 \e[92m$sbpk_name \e[96m至 \e[92m$installed_packages_path \e[96m目录...\n \e[0m"
		mv "$cachedir/$sbpk_name" "$installed_packages_path"
	fi

}

# 读取地址文件批量安装
function install_package_by_addrfile() {

	# 文件名
	local addr_file=$1

	echo -e "\e[96m开始读取 \e[92m$addr_file \e[96m批量安装插件...\n \e[0m"

	cat $addr_file | grep -v ^$ | grep -v ^\# | while read line; do
		local pk_addrs=$line

		# 判断是否以#符号起始
		# 以#符号起始视为注释该行插件
		# if [ ${pk_addrs:0:1}x == "#"x ];then
		# continue
		# fi

		# 判断是不是zip包
		# 地址不同，使用不同的下载构建函数
		if [ ${pk_addrs##*.}x = "zip"x ]; then
			install_package_zip $pk_addrs
		elif [ ${pk_addrs##*.}x = "sublime-package"x ]; then
			install_package_sbpk $pk_addrs
		else
			install_package_github $pk_addrs
		fi
	done

}

#----------------------------------------------------#
#		  	测试区
#----------------------------------------------------#

# github reop 地址
#addrs="https://github.com/titoBouzout/SideBarEnhancements"
#addrs="https://github.com/titoBouzout/SideBarEnhancements.git"
#addrs="https://github.com/NeoVintageous/NeoVintageous"

# 生成.Cache 目录
#createCacheDir $cachedir

# 安装插件包
#install_package $addrs
#

# ------------------------------------------------- #

# 中文语言包下载地址
#chl_addrs="https://github.com/rexdf/ChineseLocalization/archive/refs/tags/st3-1.11.7.zip"

#----------------------------------------------------#

#for line in `cat basic_packages.txt`
#do
#  echo $line
#done

#cat basic_packages.txt | while read line
#do
#  echo $line
#done

#while read line
#do
#  echo $line
#done < basic_packages.txt

#----------------------------------------------------#
# 测试批量安装插件
# addr_file=basic_packages.txt

# install_package_by_addrfile $addr_file
