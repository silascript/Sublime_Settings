
echo -e "\e[96m 重置 Sublime... \e[0m"

#检测目录
subldir=~/.config/sublime-text
sublcachedir=~/.cache/sublime-text

if [ ! -d "$subldir" ];then
  echo -e "\e[33m \e[93m \e[37m$subldir \e[93m目录不存在！\e[0m"
else
  # 删除 ~/.config/sublime-text
  echo -e "\e[32m 将删除 $subldir 目录，并启动 Sublime Text，以便重新生成 $subldir \e[0m"
  rm -rvf $subldir
fi

if [ ! -d "$sublcachedir" ];then
  echo -e "\e[33m \e[37m$sublcachedir \e[93m目录不存在！\e[0m"
else
  # 删除 ~/.cache/sublime-text
  rm -rvf $sublcachedir
fi

echo -e "\e[96m 现在重新启动 SublimeText... \e[0m"
subl

# ------------------------------------------------------------------ #

