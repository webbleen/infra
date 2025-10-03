# 基础设施管理 (Infrastructure)

这个目录包含了完整的本地开发环境基础设施服务，提供数据库、缓存、搜索、存储、消息队列等服务。支持本地开发和云端部署。

## 🎯 项目概述

基础设施管理工具提供：
- **本地开发环境**：完整的开发基础设施
- **云端部署支持**：Railway 等云平台部署
- **统一管理**：Makefile 标准化管理
- **多环境支持**：开发、测试、生产环境配置

## 🛠️ 服务列表

### 数据库服务
- **PostgreSQL 15** - 关系型数据库，支持 ACID 事务
- **MySQL 8.0** - 关系型数据库，高性能查询
- **MongoDB 7** - 文档数据库，灵活的数据结构

### 缓存服务
- **Redis 7** - 内存缓存，高性能数据存储

### 搜索服务
- **Elasticsearch 8.11** - 全文搜索引擎
- **Kibana 8.11** - 数据可视化和分析平台

### 存储服务
- **MinIO** - 对象存储，S3 兼容的存储服务

### 消息队列
- **RabbitMQ 3** - 消息队列，支持多种消息模式

## 🎯 服务使用场景

### 数据库服务
- **PostgreSQL**: 主数据库，存储结构化数据
- **MySQL**: 备用数据库，支持特定业务需求
- **MongoDB**: 存储非结构化数据和日志

### 缓存服务
- **Redis**: 缓存热点数据，提升系统性能

### 搜索服务
- **Elasticsearch**: 实现全文搜索和数据分析
- **Kibana**: 数据可视化，监控系统状态

### 存储服务
- **MinIO**: 存储文件、图片、视频等静态资源

### 消息队列
- **RabbitMQ**: 处理异步任务，解耦系统组件

## 🚀 快速开始

### 本地开发环境

#### 启动所有服务

```bash
# 方法1: 使用 Makefile (推荐)
make start

# 方法2: 使用 Docker Compose
docker-compose up -d
```

#### 按需启动服务

```bash
# 使用 Makefile
make start-db      # 启动数据库服务
make start-cache   # 启动缓存服务
make start-search  # 启动搜索服务
make start-storage # 启动存储服务
make start-queue   # 启动消息队列
```

### 云端部署 (Railway)

#### 支持的服务
- ✅ **MinIO** - 对象存储
- ✅ **RabbitMQ** - 消息队列
- ⚠️ **Elasticsearch** - 需要付费计划
- ⚠️ **Kibana** - 需要付费计划

#### 部署步骤
1. 在 Railway 创建新项目
2. 添加 PostgreSQL 和 Redis 服务（Railway 原生）
3. 部署 MinIO 和 RabbitMQ（Docker 方式）
4. 根据需要部署 Elasticsearch 和 Kibana

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

### 本地开发
1. **使用 Makefile**: 推荐使用 `make` 命令进行管理，更加标准化
2. **数据备份**: 定期备份重要数据
3. **资源监控**: 注意内存和磁盘使用情况
4. **版本控制**: 将配置文件纳入版本控制
5. **环境隔离**: 为不同项目使用不同的数据卷前缀

### 生产部署
1. **服务选择**: 根据实际需求选择服务，避免过度配置
2. **成本优化**: 优先使用云平台原生服务
3. **监控告警**: 设置适当的监控和告警机制
4. **数据安全**: 定期备份和加密敏感数据
5. **性能优化**: 根据使用情况调整资源配置

## 环境配置

### 开发环境
- 所有服务都在本地运行
- 使用 Docker 数据卷持久化数据
- 支持热重载和调试

### 测试环境
- 使用 Railway 或类似平台
- 配置与生产环境相似
- 用于集成测试和性能测试

### 生产环境
- 使用云平台原生服务
- 高可用和负载均衡
- 监控和日志收集

## 监控与维护

### 健康检查
```bash
# 检查所有服务状态
make status

# 查看服务日志
make logs

# 监控服务访问地址
make monitor
```

### 数据备份
```bash
# 备份 PostgreSQL
make backup-postgres

# 备份 MySQL
make backup-mysql

# 备份 MongoDB
make backup-mongodb
```

### 故障排除
1. **服务启动失败**: 检查 Docker 状态和端口占用
2. **数据丢失**: 检查数据卷和备份
3. **网络问题**: 检查网络配置和防火墙
4. **性能问题**: 监控资源使用情况

## 部署指南

### Railway 部署
1. 创建 Railway 项目
2. 添加数据库和缓存服务
3. 部署 MinIO 和 RabbitMQ
4. 配置环境变量
5. 部署应用服务

### 其他云平台
- **AWS**: 使用 RDS、ElastiCache、S3 等服务
- **Google Cloud**: 使用 Cloud SQL、Memorystore、Cloud Storage 等
- **Azure**: 使用 Azure Database、Redis Cache、Blob Storage 等

## 更新日志

### v1.0.0
- 初始版本发布
- 支持所有核心服务
- 完整的 Makefile 管理
- Railway 部署支持

---

## 多语言支持

本项目支持多种语言的文档：

- [English](README.md) - 英文版本文档
- [中文](README.zh-CN.md) - 中文版本文档  
- [日本語](README.ja.md) - 日文版本文档
