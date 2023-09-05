# Sublime 设置脚本

---

这一套脚本是用来在 Linux 平台下快速设置 vim。

脚本编写平台：Manjaro（core：6.1.49-1）。

---

## 各脚本说明


脚本名称带**func**字样的，都是函数脚本，只定义了函数，没有执行过程。

* **reset**：重置脚本，删除`.vim`及设置基础`.vimrc`。
* **init**：初始化，主要是重置`.vim`目录及设置`.vimrc`基础设置，以及安装`Package Control`
* **basice**：基础配置方案，添加了`basice_package.txt`文件中插件列表的插件。
* **test**：测试脚本。

---

## 其他文件说明

* **_packages.txt**：插件列表文件，记录了插件的地址。
* **_settings.json**：各配置方案的配置文件。
* **.Cache**目录：是插件临时目录，是下载或构建`sublime-package`插件包临时暂存目录。


---

## 关于LSP插件

关于 Sublime 的 [LSP](https://packagecontrol.io/packages/LSP) [![LSP Repo](https://img.shields.io/github/stars/sublimelsp/LSP?style=social
)](https://github.com/sublimelsp/LSP/)插件及各「子插件」，是要配合外部「LSP」实现才能实现代码揭示等语言服务的。

关于相关插件说明请参考：[https://lsp.sublimetext.io/](https://lsp.sublimetext.io/)

部分子插件已自带相应的Sever实现，装了插件后，在启用些插件后，会在Sublime的缓存目录：`~/.cache/sublime-text/Package Storage`中安装相应的本地Server。无须另外配置使用外部Server端了。

下面就大概简介部分LSP插件的使用！

### Json

[LSP-json](https://packagecontrol.io/packages/LSP-json) [![LSP-json Repo](https://img.shields.io/github/stars/sublimelsp/LSP-json?style=social
)](https://github.com/sublimelsp/LSP-json) 这个插件应该是LSP插件中除了[LSP](https://packagecontrol.io/packages/LSP)外，必装的插件。因为 [Sublime Text](https://www.sublimetext.com/) 的配置本身就是使用`json`格式。

这个插件使用到的Server是VSCode的。此插件已自带了，所以这插件装完就能用了。


### Bash



### Typescript&Javascript



### HTML










