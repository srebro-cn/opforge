# Mintlify 文档站点 Docker 配置

这个仓库包含了使用 Docker 运行 Mintlify 文档站点的配置文件。使用 Docker 可以显著提高开发效率，避免本地环境配置问题。

## 前提条件

- 安装 [Docker](https://docs.docker.com/get-docker/)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/)
- 确保 Docker 有足够的资源（建议至少 2GB 内存）

## 快速开始

### 方法 1：使用启动脚本（推荐）

```bash
# 赋予脚本执行权限（如果尚未执行）
chmod +x start-docs.sh

# 运行启动脚本
./start-docs.sh
```

### 方法 2：手动使用 Docker Compose

```bash
# 清理旧构建（如果需要）
docker-compose down -v

# 构建镜像（不使用缓存）
docker-compose build --no-cache

# 启动容器
docker-compose up -d

# 查看日志
docker-compose logs -f
```

## 访问文档

启动服务后，可以通过浏览器访问：

```
http://localhost:3000
```

## 配置说明

### 健康检查机制

Docker Compose 配置了全面的健康检查机制：

```yaml
healthcheck:
  test: [
    "CMD-SHELL",
    "curl -f http://localhost:3000 || exit 1; ps aux | grep 'mint' | grep -v grep > /dev/null || exit 1; free -m | awk '/Mem:/ {if ($4 < 100) exit 1}'"
  ]
  interval: 15s    # 每15秒检查一次
  timeout: 5s      # 检查超时时间
  retries: 3       # 重试次数
  start_period: 40s # 启动后等待时间
```

健康检查包含三个方面：
1. HTTP 检查：确保服务可访问
2. 进程检查：确保 Mintlify 进程在运行
3. 内存检查：确保有足够的可用内存

### 资源限制

配置了合理的资源限制以确保稳定运行：

```yaml
deploy:
  resources:
    limits:
      memory: 2G    # 最大内存限制
    reservations:
      memory: 512M  # 保证最小内存
```

### 日志管理

配置了日志轮转以防止日志文件过大：

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"  # 单个日志文件最大大小
    max-file: "3"    # 保留的日志文件数量
```

### 系统限制

设置了适当的系统限制：

```yaml
ulimits:
  nofile:
    soft: 65536
    hard: 65536
```

### 网络配置

使用独立的桥接网络和可靠的 DNS：

```yaml
networks:
  mintlify-net:
    driver: bridge

dns:
  - 8.8.8.8
  - 114.114.114.114
```

## 监控和维护

### 检查容器健康状态

```bash
# 查看容器状态
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}"

# 查看详细健康检查日志
docker inspect --format "{{json .State.Health }}" mintlify-docs | jq
```

### 查看资源使用情况

```bash
# 查看容器资源使用情况
docker stats mintlify-docs

# 查看容器详细信息
docker inspect mintlify-docs
```

### 日志管理

```bash
# 查看实时日志
docker-compose logs -f

# 查看最近100行日志
docker-compose logs --tail=100

# 查看特定时间段的日志
docker-compose logs --since "2024-01-01T00:00:00"
```

## 故障排除指南

### 1. 健康检查失败

如果健康检查失败，按以下步骤排查：

```bash
# 1. 检查服务可访问性
curl -v http://localhost:3000

# 2. 检查进程状态
docker-compose exec mintlify ps aux | grep mint

# 3. 检查内存使用情况
docker-compose exec mintlify free -m
```

### 2. 资源问题

如果遇到资源相关问题：

```bash
# 查看容器资源使用情况
docker stats mintlify-docs

# 增加内存限制（修改 docker-compose.yml 后）
docker-compose up -d --scale mintlify=0 && docker-compose up -d
```

### 3. 网络问题

如果遇到网络连接问题：

```bash
# 检查网络连接
docker network inspect mintlify-net

# 检查DNS解析
docker-compose exec mintlify nslookup google.com
```

## 性能优化

### 1. 调整资源限制

根据实际需求调整 docker-compose.yml 中的资源限制：

```yaml
deploy:
  resources:
    limits:
      memory: 4G    # 增加内存限制
      cpus: '2'     # 限制CPU使用
```

### 2. 优化卷挂载

使用卷挂载缓存依赖：

```yaml
volumes:
  - ./docs:/app/docs
  - node_modules:/app/docs/node_modules
```

### 3. 网络优化

如果需要更好的网络性能，可以考虑使用 host 网络模式：

```yaml
network_mode: "host"
```

## 许可证

根据 MIT 许可证分发。查看 `LICENSE` 文件了解更多信息。