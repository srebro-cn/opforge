# 使用 Node.js 20 作为基础镜像
FROM node:20-alpine

LABEL maintainer srebro

# 设置软件源(apt-get 源)
RUN sed -i 's@dl-cdn.alpinelinux.org@mirrors.cloud.tencent.com@g' /etc/apk/repositories

# 设置npm源
RUN npm config set registry https://mirrors.cloud.tencent.com/npm/

# 安装必要的系统依赖
RUN apk add --no-cache \
    git \
    wget \
    python3 \
    make \
    g++

# 设置工作目录
WORKDIR /app/docs

# 安装 Mintlify CLI
RUN npm i -g mintlify

# 清理 Mintlify 缓存
RUN rm -rf ~/.mintlify

# 安装 Next.js 相关依赖
RUN npm install --save-dev next@latest react@latest react-dom@latest

# 复制文档文件
COPY docs/ ./

# 暴露端口
EXPOSE 3000

# 创建启动脚本
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'rm -rf ~/.mintlify' >> /start.sh && \
    echo 'mint dev --host 0.0.0.0 --no-open' >> /start.sh && \
    chmod +x /start.sh

# 启动命令
CMD ["/start.sh"]