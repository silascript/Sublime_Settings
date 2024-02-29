# Sublime 设置脚本

---

## 简介

这一套脚本是用来在 Linux 平台下快速设置 SublimeText。

脚本编写平台：Manjaro（core：6.6.16-2）。

---

## 各脚本说明


脚本名称带**func**字样的，都是函数脚本，只定义了函数，没有执行过程。

* **reset**：重置脚本，删除`.vim`及设置基础`.vimrc`。
* **init**：初始化，主要是重置`.vim`目录及设置`.vimrc`基础设置，以及安装`Package Control`
* **basice**：基础配置方案，添加了`basice_package.txt`文件中插件列表的插件。
* **lsp**：LSP配置方案，使用了`lsp_packages.txt`插件列表文件安装插件。
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

[LSP-bash](https://packagecontrol.io/packages/LSP-bash) [![LSP-bash Repo](https://img.shields.io/github/stars/sublimelsp/LSP-bash?style=social
)](https://github.com/sublimelsp/LSP-bash) 是写 bash shell 很好的 lsp。

这插件使用到 [bash-language-server](https://github.com/bash-lsp/bash-language-server)，所以得安装下：`npm i -g bash-language-server`。

### Typescript&Javascript

安装 lsp：

```shell
npm install -g typescript-language-server typescript
```
> [!tip] typescript lsp
> `typescript-language-server` 这个是 Typescript 的 [LSP](https://github.com/typescript-language-server/typescript-language-server)，要使用 ts 的 lsp 服务就得把这货装上。


### HTML

[LSP-html](https://github.com/sublimelsp/LSP-html) 使用的同样也是微软的LSP。

安装 html lsp：

```shell
npm install -g vscode-html-languageserver-bin
```


### CSS


安装 css lsp：

```shell
npm install css-language-server -g
```

或者装 vscode 相关的 lsp：

```shell
npm install -g vscode-css-languageserver-bin
```
> [!info]
> 
> 建议还是装 `vscode-css-languageserver-bin` 这个lsp。因为上面那个版本号0.0.2，已经长期没更了。


### Python

Sublime LSP 与Python相关的，主要有三个插件Pyright、Pylsp和ruff。

ruff主要是当Linter用的。而LSP主体功能实现，就有Pyright和Pylsp两个可选。

#### Pyright

Pyright如果跟ruff插件一起使用，那就把pyright中Linter部分功能关掉，使用ruff来代替。

所以Pyright可以作以下配置：

```json
"settings": {
	"python.analysis.diagnosticSeverityOverrides": {
	"reportDuplicateImport": "none",
	"reportImplicitStringConcatenation": "none",
	"reportMissingParameterType": "none",
	"reportUnboundVariable": "none",
	"reportUninitializedInstanceVariable": "none",
	"reportUnusedClass": "none",
	"reportUnusedFunction": "none",
	"reportUnusedImport": "none",
	"reportUnusedVariable": "none",
}
```


#### Pylsp

同样的Pylsp与ruff配合使用，也得进行一些配置：

```json
"settings": {
	"pylsp.plugins.ruff.enabled":true,
	"pylsp.plugins.pycodestyle.enabled":false,
	"pylsp.plugins.pylsp_black.enabled":true,
},
```

> [!info] pylsp 与 [ruff](../vim/LSP_Complete.md#ruff) 配合使用
> 
> pylsp 也能与 ruff 配合使用。其实就是把 ruff 当成 pylsp 的 linter，当下 ruff 的功能也是只能当 linter 使用。
> 就一句设置：`pylsp.plugins.ruff.enabled`，即启用 ruff-- 默认 pylsp 使用的是 linter 是 `pycondestyle`。
> 
> 相关说明：[linters](https://github.com/sublimelsp/LSP-pylsp#linters)

> [!info] pylsp 格式化
> pylsp 默认格式化使用的是 `autopep8`，可以使用 `"pylsp.plugins.yapf.enabled"` 或 `"pylsp.plugins.pylsp_black.enabled"`，使用不同的格式策略。
> 相关说明：[formatters](https://github.com/sublimelsp/LSP-pylsp#formatters)



---


## 其他推荐需要手动安装插件

除了插件列表文件中的插件外，有些插件因各种原因不便使用脚本自动安装，只能手动根据需求安装。

* [Pretty Shell](https://github.com/aerobounce/Sublime-Pretty-Shell)： 这是一个 shell 格式化插件。这个插件使用到了[shfmt](https://github.com/mvdan/sh)这个shell格式化工具，请自行通过操作系统的包管理工具先行安装。
* [open in browser](https://github.com/vicke4/open_in_browser)：打开浏览器进行预览插件。这插件即能用于普通的html也能用于markdown预览--当然，要实现Markdown预览，你的浏览器得先安装markdown预览插件，可以到浏览器商店找下安下就行了。

配置浏览器：

```json
"custom_browser":"microsoft-edge"
```

> [!info]
> 也就说没必要去装 Sublime 那些什么 Markdown 预览插件，那些插件实际都是用到如 Python 的转换工具及小型 server，对 Markdown 文档进行转换和预览。只要浏览器装了相应的 Markdown 插件，就能使用 Sublime 的单纯浏览器调用插件，如这个 `open in browser`，就能实现 Markdown 文档的预览。
>












