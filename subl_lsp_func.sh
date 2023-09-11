
#-------------------------------------------------------------#
#						Sublime Text 脚本					  #
#						 LSP 函数 插件						  #
#-------------------------------------------------------------#


#--------------------------引入脚本---------------------------#

# 重置函数脚本
# 重置函数脚本已经引入了subl_start_close_func.sh
source ./subl_reset_func.sh

# 初始化脚本
source ./subl_init_func.sh

# 下载脚本
source ./subl_downpackage_func.sh


#---------------------------函数--------------------------- #

# 读取编辑语言名称文件批量编程语言配置文件
function generate_language_settings(){
  
  # 文件名
  addr_file=$1

  echo -e "\e[96m开始读取 \e[92m$addr_file \e[96m批量生成各编程语言配置文件...\n \e[0m"

  cat $addr_file | grep -v ^$ | grep -v ^\# | while read line
  do
    pk_addrs=$line
	
	# 判断是否以#符号起始
	# 以#符号起始视为注释该行插件
	# if [ ${pk_addrs:0:1}x == "#"x ];then
		# continue
	# fi

    
  done

}


function init_lsp(){

	echo -e "\e[96m 开始对 SublimeText 基础化配置...\n \e[0m"

	# 重置
	resetAll

	# 关闭 Sublime Text
	sleep 5
	echo -e "\e[96m暂时关闭 Sublimet Text 以方便下面的操作... \n \e[0m"
	subl_close

	# 安装 Package Control
	install_packagecontrol

	# 重启
	subl_restart

	# 关闭 Sublime Text
	sleep 5
	echo -e "\e[96m暂时关闭 Sublimet Text 并开始进行批量插件安装... \n \e[0m"
	subl_close

	# 读取插件地址文件安装插件
	addr_file=lsp_packages.txt

	install_package_by_addrfile $addr_file

	# 复制 settings
	# 全局
	# s_settings_path=./subl_settings/lsp_settings.sublime-settings
	# t_settings_path=~/.config/sublime-text/Packages/User/Preferences.sublime-settings

	# python
	# s_py_settings_path=./subl_settings/Python.sublime-settings
	# t_py_settings_path=~/.config/sublime-text/Packages/User/Python.sublime-settings

	# html
	# s_html_settings_path=./subl_settings/HTML.sublime-settings
	# t_html_settings_path=~/.config/sublime-text/Packages/User/HTML.sublime-settings

	# typescript
	# s_ts_settings_path=./subl_settings/TypeScript.sublime-settings
	# t_ts_settings_path=~/.config/sublime-text/Packages/User/TypeScript.sublime-settings

	# golang
	# s_go_settings_path=./subl_settings/Go.sublime-settings
	# t_go_settings_path=~/.config/sublime-text/Packages/User/Go.sublime-settings

	# Rust
	# s_rust_settings_path=./subl_settings/Rust.sublime-settings
	# t_rust_settings_path=~/.config/sublime-text/Packages/User/Rust.sublime-settings

	# Java
	# s_java_settings_path=./subl_settings/Java.sublime-settings
	# t_java_settings_path=~/.config/sublime-text/Packages/User/Java.sublime-settings

	# Preferences settings
	# subl_cp_settings $s_settings_path $t_settings_path
	# Python settings
	# subl_cp_settings $s_py_settings_path $t_py_settings_path
	# html settings
	# subl_cp_settings $s_html_settings_path $t_html_settings_path
	# typescript settings
	# subl_cp_settings $s_ts_settings_path $t_ts_settings_path
	# go settings
	# subl_cp_settings $s_go_settings_path $t_go_settings_path
	# Rust settings
	# subl_cp_settings $s_rust_settings_path $t_rust_settings_path
	# Java
	# subl_cp_settings $s_java_settings_path $t_java_settings_path


	# 重启Sublime Text
	subl_restart

}

# --------------------------测试-------------------------- #





