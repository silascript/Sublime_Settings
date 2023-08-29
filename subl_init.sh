
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#

#--------------------------引入脚本---------------------------#

# 重置函数脚本
# 重置函数脚本中同时引入了 subl_start_close_func.sh 脚本
source ./subl_reset_func.sh

# 初始化函数脚本
source ./subl_init_func.sh

#---------------------------主代码区--------------------------#

# 重置
resetAll

# 复制 settings
subl_cp_settings

# 安装 Package Control
install_packagecontrol

echo -e "\e[96m 初始化完成！\n \e[0m"

# 重启Sublime Text
subl_restart


#-------------------------------------------------------------#





