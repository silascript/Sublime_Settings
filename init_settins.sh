
echo "复制settings..."


cp -v ./base_settings.json ~/.config/sublime-text/Packages/User/Preferences.sublime-settings 


#curl https://packagecontrol.io/Package%20Control.sublime-package --output ~/.config/sublime-text/'Installed Packages'/'Package Control.sublime-package' --progress-bar
#
# wget -P ~/.config/sublime-text/Installed\ Packages/ 'https://packagecontrol.io/Package Control.sublime-package'

if [ $? == 0 ]
then
	echo "settings复制成功！"
else
	echo "settings复制失败！"
fi


