
# ----------------------------------------------------------- #
# 			Sublime Text 启动关闭		      #
# ----------------------------------------------------------- #


# 关闭 Sublime Text
function subl_close(){

  # 检测 Sublime Text 是否已经启动
  subl_pid_count=`pgrep 'sublime_text' -l|wc -l`

  if [ $subl_pid_count -gt 0 ];then
    # 获取 sublime_text 的进程PID
    subl_pid=`pgrep 'sublime_text' -l|awk '{print $1}'`
    #echo $subl_pid

    # 关闭 sublime_text 进程
    echo -e "\e[96m Sublime Text已经启动，现先将其关闭...\n \e[0m"
    kill $subl_pid 
    sleep 3

  fi

}


# 重启 Sublime Text
function subl_restart(){
  # 关闭
  subl_close
  # 启动 
  echo -e "\e[96m 重启... \e[0m"
  subl
}




# ----------------------------------------------------------- #







