# 本地开发环境基础设施

这个目录包含了本地开发环境的通用基础设施服务，为所有项目提供数据库、缓存、搜索、存储等服务。

## 服务列表

### 数据库服务
- **PostgreSQL 15** - 关系型数据库
- **MySQL 8.0** - 关系型数据库
- **MongoDB 7** - 文档数据库

### 缓存服务
- **Redis 7** - 内存缓存

### 搜索服务
- **Elasticsearch 8.11** - 搜索引擎
- **Kibana 8.11** - 日志分析

### 存储服务
- **MinIO** - 对象存储

### 消息队列
- **RabbitMQ 3** - 消息队列

## 快速开始

### 启动所有服务

```bash
# 方法1: 使用 Makefile (推荐)
make start

# 方法2: 使用管理脚本
./manage.sh start

# 方法3: 使用 Docker Compose
docker-compose up -d
```

### 按需启动服务

```bash
# 使用 Makefile (推荐)
make start-db      # 启动数据库服务
make start-cache   # 启动缓存服务
make start-search  # 启动搜索服务
make start-storage # 启动存储服务

# 或使用管理脚本
./manage.sh start-db
./manage.sh start-cache
./manage.sh start-search
./manage.sh start-storage
```

## 管理命令

### 使用 Makefile (推荐)

```bash
# 查看所有可用命令
make help

# 基础命令
make start      # 启动所有服务
make stop       # 停止所有服务
make restart    # 重启所有服务
make logs       # 查看服务日志
make status     # 查看服务状态
make clean      # 清理所有数据（包括数据卷）

# 数据库连接
make shell-postgres  # 连接到 PostgreSQL
make shell-mysql     # 连接到 MySQL
make shell-mongodb   # 连接到 MongoDB
make shell-redis     # 连接到 Redis

# 数据备份
make backup-postgres  # 备份 PostgreSQL
make backup-mysql     # 备份 MySQL
make backup-mongodb   # 备份 MongoDB

# 数据恢复
make restore-postgres FILE=backup.sql  # 恢复 PostgreSQL
make restore-mysql FILE=backup.sql     # 恢复 MySQL

# 按需启动
make start-db      # 启动数据库服务
make start-cache   # 启动缓存服务
make start-search  # 启动搜索服务
make start-storage # 启动存储服务
make start-queue   # 启动消息队列

# 监控
make monitor       # 显示服务访问地址
```

### 使用管理脚本

```bash
# 基础命令
# 启动所有服务
./manage.sh start

# 停止所有服务
./manage.sh stop

# 重启所有服务
./manage.sh restart

# 查看服务状态
./manage.sh status

# 查看服务日志
./manage.sh logs

# 清理所有数据（包括数据卷）
./manage.sh clean
```

## 服务配置

### PostgreSQL
- **端口**: 5432
- **用户名**: postgres
- **密码**: password
- **数据库**: postgres, dailyzen, test_db, staging_db

### MySQL
- **端口**: 3306
- **用户名**: root / dev
- **密码**: password
- **数据库**: dev

### MongoDB
- **端口**: 27017
- **用户名**: admin
- **密码**: password

### Redis
- **端口**: 6379
- **无密码**

### Elasticsearch
- **端口**: 9200 (HTTP), 9300 (TCP)
- **无认证**

### Kibana
- **端口**: 5601
- **无认证**

### MinIO
- **端口**: 9000 (API), 9001 (Console)
- **用户名**: admin
- **密码**: password123

### RabbitMQ
- **端口**: 5672 (AMQP), 15672 (Management)
- **用户名**: admin
- **密码**: password

## 数据持久化

所有数据都存储在 Docker 数据卷中，即使容器重启数据也不会丢失。数据卷位置：

- PostgreSQL: `postgres_data`
- MySQL: `mysql_data`
- MongoDB: `mongodb_data`
- Redis: `redis_data`
- Elasticsearch: `elasticsearch_data`
- MinIO: `minio_data`
- RabbitMQ: `rabbitmq_data`

## 网络配置

所有服务都在 `dev-network` 网络中，可以通过服务名相互访问：

- PostgreSQL: `postgres:5432`
- MySQL: `mysql:3306`
- MongoDB: `mongodb:27017`
- Redis: `redis:6379`
- Elasticsearch: `elasticsearch:9200`
- Kibana: `kibana:5601`
- MinIO: `minio:9000`
- RabbitMQ: `rabbitmq:5672`

## 故障排除

### 服务启动失败
1. 检查 Docker 是否运行
2. 检查端口是否被占用
3. 查看服务日志: `make logs` 或 `docker-compose logs`

### 数据丢失
1. 检查数据卷是否存在: `docker volume ls`
2. 检查容器状态: `make status`
3. 如果需要重置数据，运行: `make clean`

### 网络连接问题
1. 检查网络是否存在: `docker network ls`
2. 重新创建网络: `docker network create dev-network`

## 开发建议

1. **使用 Makefile**: 推荐使用 `make` 命令进行管理，更加标准化
2. **数据备份**: 定期备份重要数据
3. **资源监控**: 注意内存和磁盘使用情况
4. **版本控制**: 将配置文件纳入版本控制
5. **环境隔离**: 为不同项目使用不同的数据卷前缀
