#!/usr/bin/env bash

# 监视 Sublime 的Package Control 的 lib目录变化
# inotify_subl_pkclibd() {

# 监视的目录
# local file_dir="$PWD/.config/sublime-text/Lib/python38/"
# file_dir="$PWD/.config/sublime-text/Lib/python38"
file_dir=$1

# echo $file_dir

# inotifywait -mrq --timefmt "%d/%m/%y/%H:%M"  --format "%T %w %f" -e create,delete,modify,attrib $file_dir

inotifywait -mrq --timefmt "%d/%m/%y %H:%M" --format '%T %w%f %e' -e create,delete,modify,attrib $file_dir | while read date time dirfile event; do
	# case $event in DELETE,ISDIR | CREATE,ISDIR | MODIFY,ISDIR | ATTRIB,ISDIR | CREATE | DELETE | MODIFY | ATTRIB)
	file_reg='^(.config/sublime-text).*'
	if [[ "$dirfile" =~ $file_reg ]]; then
		# 输出监视log
		# echo $date'-'$time'-'$dirfile'-'$event >>$HOME/subl_lib_watch.log
		echo $date'-'$time'-'$dirfile'-'$event >>$HOME/subl_lib_watch.log
	fi
	# ;;
	# esac
done

# echo "测试" >>$PWD/subl_lib_watch.log
# }

# -----------------执行------------------------- #

# inotify_subl_pkclibd
