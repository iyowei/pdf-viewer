# PDF 阅读器 Makefile
# 使用 tab 缩进（非空格）

# 变量定义
IMAGE_NAME := pdf-viewer
CONTAINER_NAME := pdf-viewer
TAG := latest
PORT := 6781

# 默认目标
.PHONY: help
help:
	@printf "PDF 阅读器 Makefile 指令:\n  deploy        - 重新部署 (删除容器、镜像、清理 Docker、构建、运行)\n  rm-container  - 删除容器\n  rm-image      - 删除镜像\n  clean-docker  - 清理 Docker\n  build         - 构建镜像\n  run           - 运行容器\n  stop          - 停止容器\n  logs          - 查看容器日志\n"

# 复合任务：重新部署
.PHONY: deploy
deploy: rm-container rm-image clean-docker build run
	@echo "✅ 重新部署完成"

# 删除容器
.PHONY: rm-container
rm-container:
	@echo "🗑️ 删除容器 $(CONTAINER_NAME)..."
	-docker stop $(CONTAINER_NAME) 2>/dev/null || true
	-docker rm $(CONTAINER_NAME) 2>/dev/null || true

# 删除镜像
.PHONY: rm-image
rm-image:
	@echo "🗑️ 删除镜像 $(IMAGE_NAME)..."
	-docker rmi $(IMAGE_NAME):$(TAG)
	-docker rmi $(IMAGE_NAME):1.0.0

# 清理 Docker
.PHONY: clean-docker
clean-docker:
	@echo "🧹 清理 Docker..."
	-docker system prune -f
	-docker volume prune -f

# 构建镜像
.PHONY: build
build:
	@echo "📝 Injecting build time..."
	$(eval BUILD_TIME := $(shell TZ=Asia/Shanghai date +'%Y/%m/%d-%H:%M:%S' 2>/dev/null || date +'%Y/%m/%d-%H:%M:%S'))
	# Use sed to replace the data-time attribute. This is idempotent.
	@if command -v gsed >/dev/null 2>&1; then \
		gsed -i 's/ data-time="[^"]*"//g; s|<html|& data-time="$(BUILD_TIME)"|' "generic/web/viewer.html"; \
	elif sed --version 2>&1 | grep -q "GNU"; then \
		sed -i 's/ data-time="[^"]*"//g; s|<html|& data-time="$(BUILD_TIME)"|' "generic/web/viewer.html"; \
	else \
		sed -i '' -e 's/ data-time="[^"]*"//g' -e 's|<html|& data-time="$(BUILD_TIME)"|' "generic/web/viewer.html"; \
	fi
	@echo "🔨 构建镜像 $(IMAGE_NAME):$(TAG)..."
	docker build . -t $(IMAGE_NAME):1.0.0 -t $(IMAGE_NAME):$(TAG) -f ./Dockerfile

# 运行容器
.PHONY: run
run:
	@echo "🚀 运行容器 $(CONTAINER_NAME)..."
	docker run --name '$(CONTAINER_NAME)' -d --restart=always -p $(PORT):80 $(IMAGE_NAME):$(TAG)
	@echo "✅ 容器已启动，访问地址: http://localhost:$(PORT)"

# 停止容器
.PHONY: stop
stop:
	@echo "⏹️ 停止容器 $(CONTAINER_NAME)..."
	-docker stop $(CONTAINER_NAME)

# 查看容器日志
.PHONY: logs
logs:
	@echo "📋 查看容器日志..."
	docker logs -f $(CONTAINER_NAME)

# 打包项目
pack:
	@echo "打包项目为 zip 文件..."
	@PROJECT_NAME="pdf-viewer-$$(date +%Y%m%d-%H%M%S)"; \
	ZIP_FILE="$$PROJECT_NAME.zip"; \
	echo "创建压缩包: $$ZIP_FILE"; \
	zip -r "$$ZIP_FILE" \
		Makefile \
		Dockerfile \
		generic/ \
		-x "*.git*" "*.DS_Store" "*.log" "*~" "*.tmp" ".vscode/*" ".claude/*" \
		2>/dev/null || { \
			echo "错误: zip 命令未找到，请安装 zip 工具"; \
			echo "Ubuntu/Debian: sudo apt install zip"; \
			echo "macOS: brew install zip"; \
			exit 1; \
		}; \
	echo "打包完成: $$ZIP_FILE"; \
	ls -lh "$$ZIP_FILE"
