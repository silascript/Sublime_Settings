
#-------------------------------------------------------------#
#		Sublime Text 初始化脚本			      #
#-------------------------------------------------------------#


source ./subl_init_main.sh


echo -e "\e[96m 初始化完成！\n \e[0m"

# 如果已启动了 Sublime Text，就关闭，重启Sublime Text
# 检测 sublime_text 进程数量
# 大于1就意味着 Sublime Text 已经启动
#subl_ps_count=`ps -ef|grep 'sublime_text'|grep -v grep|wc -l`
subl_ps_count=`pgrep 'sublime_text' -l|wc -l`

#echo $subl_ps_count

if [ $subl_ps_count -gt 0 ];then

  # 关闭 Sublime Text
  subl_pid=`pgrep 'sublime_text' -l|awk '{print $1}'`
  #echo $subl_pid
  kill $subl_pid

  echo -e "\e[96m 重启 Sublime Text...\n \e[0m"
  sleep 5
fi

# 启动 Sublime Text
subl


