
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#


source ./subl_init_main.sh


echo -e "\e[96m 初始化完成！\n \e[0m"

# 重启 Sublime Text
echo -e "\e[96m 重启 Sublime Text！\n \e[0m"
# 关闭 Sublime Text
pkill -f "sublime_text"
# 启动 Sublime Text
subl


