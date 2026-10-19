#!/usr/bin/env bash
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#

# --------------------------引入脚本--------------------------- #

# 重置函数脚本
# 重置函数脚本中同时引入了 subl_start_close_func.sh 脚本

# 初始化函数脚本
# 初始化函数脚本已经引入了 subl_reset_func.sh 函数脚本
source ./subl_init_func.sh

#---------------------------主代码区--------------------------#

function init_subl() {

	# Package Control 下载地址
	local pc_down_url=$1

	# 如果没有提供 Package Control 下载地址
	# 则使用此地址：https://download.sublimetext.com/Package%20Control.sublime-package
	if [ $# -eq 0 ]; then
		pc_down_url="https://download.sublimetext.com/Package%20Control.sublime-package"
	fi
	# 初始化主函数
	# 要提供Package Control 包下载地址
	init_main "$pc_down_url"

}

# -------------------------------执行区#------------------------------- #

init_subl "$@"
