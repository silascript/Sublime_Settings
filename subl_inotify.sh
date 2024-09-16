#!/usr/bin/env bash

# 监视 ~/.config/sublime-text 目录

# .config/sublime-text/Lib/python38/package_control.py 文件是否加载出来
# 以下三个步骤进行完成后，Package Control 才算安装完成
# 15/09/24 - 20:35 - .config/sublime-text/Lib/python38/package_control.py CREATE
# 15/09/24 - 20:35 - .config/sublime-text/Lib/python38/package_control.py MODIFY
# 15/09/24 - 20:36 - .config/sublime-text/Installed Packages/0_package_control_loader.sublime-package DELETE
# .config/sublime-text 目录删除及生成
# 15/09/24 - 22:38 - .config/sublime-text DELETE,ISDIR
# 15/09/24 - 22:38 - .config/sublime-text CREATE,ISDIR
function python38lib_loaded() {

    echo ""

}
