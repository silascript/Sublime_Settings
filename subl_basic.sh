
#-------------------------------------------------------------#
#		Sublime Text 基础配置脚本	    	      #
#		初始化及安装一些基础插件		      #
#-------------------------------------------------------------#


#--------------------------引入脚本---------------------------#

# 重置函数脚本
# 重置函数脚本已经引入了subl_start_close_func.sh
source ./subl_reset_func.sh

# 初始化脚本
source ./subl_init_func.sh

# 下载脚本
source ./subl_downpackage_func.sh


#-------------------------------------------------------------#

echo -e "\e[96m 开始对 SublimeText 基础化配置...\n \e[0m"

# 重置
resetAll

# 关闭 Sublime Text
sleep 5
echo -e "\e[96m暂时关闭 Sublimet Text 以方便下面的操作... \n \e[0m"
subl_close

# 安装 Package Control
install_packagecontrol


# 关闭 Sublime Text
sleep 5
echo -e "\e[96m暂时关闭 Sublimet Text 并开始进行批量插件安装... \n \e[0m"
subl_close


# 读取插件地址文件安装插件
addr_file=basic_packages.txt
install_package_by_addrfile $addr_file

# 复制 settings
subl_cp_settings basic_gruvbox_settings.json

# 重启Sublime Text
subl_restart


