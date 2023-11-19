
#-------------------------------------------------------------#
#						Sublime Text 脚本					  #
#						初始化及安装 LSP 插件				  #
#-------------------------------------------------------------#


#--------------------------引入脚本---------------------------#

# lsp 函数脚本
# 此函数脚本已引入了以下三个函数脚本：
# subl_reset_func.sh （重置脚本）
# subl_init_func.sh （初始化脚本）
# subl_downpackage_func.sh （下载脚本）
source ./subl_lsp_func.sh



# --------------------------主执行区-------------------------- #

init_lsp


# 配置文件路径
# s_settings_lsp_path=./subl_settings/LSP.sublime-settings
# s_settings_pylsp_path=./subl_settings/LSP-pylsp.sublime-settings
# s_settings_pyright_path=./subl_settings/LSP-pyright.sublime-settings

settings_path[0]=./subl_settings/LSP.sublime-settings
settings_path[1]=./subl_settings/LSP-pylsp.sublime-settings
settings_path[2]=./subl_settings/LSP-pyright.sublime-settings
settings_path[3]=./subl_settings/LSP-jdtls.sublime-settings

# 目标目录路径
t_settings_dir=~/.config/sublime-text/Packages/User/

# 复制配置文件到目标目录
# subl_cp_settings $s_settings_lsp_path $t_settings_dir
# subl_cp_settings $s_settings_pylsp_path $t_settings_dir
# subl_cp_settings $s_settings_pyright_path $t_settings_dir

for sp in ${settings_path[*]}
do
	subl_cp_settings $sp $t_settings_dir
done



