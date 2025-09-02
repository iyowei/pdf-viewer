#  PDF 阅读器

## 功能

- [ ] [mozilla/pdf.js](https://github.com/mozilla/pdf.js) v5.3.93 全部功能
- [X] 无 `file origin does not match viewer's` 报错
- [X] 亮、暗色切换
- [X] 显隐工具栏

## 容器

```shell
docker build . -t pdf-viewer:latest -f ./Dockerfile
docker build . -t pdf-viewer:1.0.0 -t pdf-viewer:latest -f ./Dockerfile
```

## 启动容器

```shell
docker run --name 'fiu-pdf-viewer' -d --restart=always -p 6781:80 pdf-viewer:latest
```