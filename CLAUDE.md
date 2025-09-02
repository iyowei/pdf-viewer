## JESSE

基于 [mozilla/pdf.js](https://github.com/mozilla/pdf.js) v5.3.93 实现的 PDF 阅读器。

## 关联信息

查看 @README.md 了解项目。
查看 @Makefile 了解可用的脚手架指令。

## Markdown 文档

Markdown 文件都用英文命名，命名风格微 Screaming Snake Case (下划线 + 全大写)。如：SYSTEM_AUDIT_AND_OPTIMIZATION_REPORT.md。

## Makefile

查看 @Makefile 了解当前具体既有指令。

@Makefile 使用 tab 缩进（非空格）缩进。

Makefile 里管理如下指令，

1. 复合任务：重新部署
2. 删除容器
3. 删除镜像
4. 清理 Docker
5. 构建镜像
6. 运行容器

## "构建时间" 标签

在 `<html>` 标签中增加 `data-time` 属性，将构建时间赋值其中，使用 date-fns 模块格式化为 `yyyy/MM/dd-HH:mm:ss`，时区为 `Asia/Shanghai`。

## 部署

使用 Docker 容器部署。

## 其它

用中文回复对话消息、编写代码注释等。

修改/删除文件前，先备份文件，文件名后附加精确到秒的日期，且附加上一份文件是被删除还是修改的标识。

每次新增或改完代码，要做类型检测和功能测试。
