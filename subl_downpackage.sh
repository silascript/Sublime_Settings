
# -------------------------------------------------- #
# 			下载包脚本
# -------------------------------------------------- #



# -------------------------------------------------- #
# 		  全局变量区
# -------------------------------------------------- #

# 缓存目录
cachedir=".Cache"

# 包目录
packages_path=~/.config/sublime-text/Packages
installed_packages_path=~/.config/sublime-text/'Installed Packages'

# 当前路径 脚本所在的路径
setting_sh_root=$PWD

#----------------------------------------------------#


#----------------------------------------------------#
#		   函数定义区
#----------------------------------------------------#

# 生成缓存目录
function createCacheDir(){
   
  subl_cdir=$1
  
  # 检测缓存目录是否已经存在
  if [ ! -d $subl_cdir ];then
    echo -e "\e[96m 新建\e[93m .Cache \e[96m目录,用于临时保存下载文件！\n  \e[0m"
    mkdir .Cache
  else
    echo -e "\e[93m $cachedir \e[96m已存在！\n \e[0m"
  fi

}


# 从仓库地址获取仓库名
# 主要用于获取下载下来github项目的目录名
function getRepoName(){

  # github 仓库地址
  repo_addrs=$1

  # 判断仓库地址有没有.git
  # 有就去除.git
  if [ ${repo_addrs##*.}x = "git"x ];then
    repo_addrs=${repo_addrs%.*}
  fi

  # 使用空格替换斜杠作为分隔符，以此将字符串分割成数组
  arr_addrs=(${repo_addrs//\// })

  # 取最后一个元素
  # 取最后一个元素的索引
  #repo_index=$((${#arr_addrs[@]}-1))
  repo_name=${arr_addrs[-1]}

  echo $repo_name

}


# 通过github地址下载
function download_by_github_address(){
    # 下载
    # 第一个参数是github地址
    # 第二个参数是下载的目标目录路径
    git clone $1 $2
}


# 构建 sublime-package 包 
function buildPackage(){
  
  
  # github 库的地址
  github_addrs=$1

  # 通过仓库地址获取仓库名称
  # 这个名称亦为下载后的目录名
  repoName=$(getRepoName $github_addrs)

  # 下载后的项目路径
  repo_path=$cachedir/$repoName

  # 通过路径判断项目是否已经下载
  if [ ! -d "$repo_path" ];then
    echo -e "\e[96m 开始下载...\n \e[0m"
    # 下载
    download_by_github_address $github_addrs $repo_path

    # 获取判断是否下载成功
    if [ $? -eq 0 ];then
      echo -e "\e[96m $repoName 下载成功！\n \e[0m"
      echo -e "\e[96m $repoName 开始构建 sublime-package 包...\n \e[0m"

      # 构建 sublime-package
      #echo $PWD

      # 进入到.Cache目录
      # 为下载github库作准备
      cd $repo_path
     
      # 如果存在.git目录，就删掉 
      git_dir=.git
      if [ -d "$git_dir" ];then
	echo -e "\e[96m 删除\e[93m $git_dir\n \e[0m"
	rm -rf .git
      fi      
	
      # 将当成目录中所有文件都打包成 zip
      echo -e "\e[96m 打包... \n \e[0m"
      zip -q -r $repoName *
      # 移动到 Sublime Packages目录
      mv "$repoName.zip" "$installed_packages_path/$repoName.sublime-package"
    else
      echo -e "\e[92m 下载存在问题! \e[0m"
    fi

  else
    echo -e "\e[96m \e[93m$repoName \e[96m项目已下载！\e[0m"
  fi
}

#----------------------------------------------------#
#			主代码区
#----------------------------------------------------#

# 下载包

#addrs="https://github.com/rexdf/ChineseLocalization"
addrs="https://github.com/rexdf/ChineseLocalization.git"


# 生成.Cache 目录
createCacheDir $cachedir

# 下载及构建
buildPackage $addrs


#----------------------------------------------------#



