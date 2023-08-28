
# -------------------------------------------------- #
# 			下载包脚本
# -------------------------------------------------- #

cachedir=".Cache"

# 生成缓存目录
if [ ! -d $cachedir ];then
  echo -e "\e[96m 新建\e[93m .Cache \e[96m目录,用于临时保存下载文件！ \e[0m"
  mkdir .Cache
fi

#----------------------------------------------------#


setting_sh_root=$pwd

echo $setting_sh_root

#----------------------------------------------------#

# 从github上clone
function clone_repo_from_github(){
cd $cachedir

git clone $1

#return 0
}

# 从仓库地址获取仓库名
# 主要用于获取下载下来github项目的目录名
function repoName(){

#echo $1

# github 仓库地址
repo_addrs=$1

# 使用空格替换斜杠作为分隔符，以此将字符串分割成数组
arr_addrs=(${repo_addrs//\// })

# 取最后一个元素
# 取最后一个元素的索引
#repo_index=$((${#arr_addrs[@]}-1))
repo_name=${arr_addrs[-1]}

echo $repo_name

}


#----------------------------------------------------#

# 下载包

addrs="https://github.com/rexdf/ChineseLocalization"

# 通过仓库地址获取仓库名称
# 这个名称亦为下载后的目录名
repoName=$(repoName $addrs)

repo_path=$cachedir/$repoName

echo $repo_path

if [ ! -d "$repo_path" ];then

  echo "开始下载..."
  #dl_result=$(clone_repo_from_github $addrs)
  clone_repo_from_github $addrs

  if [ $? -eq 0 ];then
    echo getRepoName $addrs
  else
    echo -e "\e[92m 下载存在问题! \e[0m"
  fi

else
  echo -e "\e[96m 项目已下载！\e[0m"
fi

#----------------------------------------------------#



