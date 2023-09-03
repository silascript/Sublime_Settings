
#-------------------------------------------------------------#
#						Sublime Text 脚本					  #
#						初始化及安装 LSP 插件				  #
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

# 复制 settings
subl_cp_settings

# 读取插件地址文件安装插件
addr_file=lsp_packages.txt

install_package_by_addrfile $addr_file


# 重启Sublime Text
subl_restart

