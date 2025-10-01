# DailyZen 本地开发环境基础设施管理 Makefile
# 为所有项目提供通用的数据库、缓存等服务

.PHONY: help start stop restart logs status clean
.PHONY: shell-postgres shell-mysql shell-mongodb shell-redis
.PHONY: backup-postgres backup-mysql backup-mongodb
.PHONY: restore-postgres restore-mysql
.PHONY: start-db start-cache start-search start-storage start-queue
.PHONY: monitor check-docker

# 默认目标
.DEFAULT_GOAL := help

# 颜色定义
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
RESET := \033[0m

# 帮助信息
help: ## 显示帮助信息
	@echo "$(CYAN)本地开发环境基础设施管理工具$(RESET)"
	@echo ""
	@echo "$(YELLOW)用法: make {命令}$(RESET)"
	@echo ""
	@echo "$(GREEN)🚀 基础命令:$(RESET)"
	@echo "  start         启动所有服务"
	@echo "  stop          停止所有服务"
	@echo "  restart       重启所有服务"
	@echo "  logs          查看服务日志"
	@echo "  status        查看服务状态"
	@echo "  clean         清理所有数据（包括数据卷）"
	@echo ""
	@echo "$(GREEN)🔌 数据库连接:$(RESET)"
	@echo "  shell-postgres 连接到 PostgreSQL"
	@echo "  shell-mysql    连接到 MySQL"
	@echo "  shell-mongodb  连接到 MongoDB"
	@echo "  shell-redis    连接到 Redis"
	@echo ""
	@echo "$(GREEN)💾 数据备份:$(RESET)"
	@echo "  backup-postgres  备份 PostgreSQL"
	@echo "  backup-mysql     备份 MySQL"
	@echo "  backup-mongodb   备份 MongoDB"
	@echo ""
	@echo "$(GREEN)📥 数据恢复:$(RESET)"
	@echo "  restore-postgres FILE=backup.sql  恢复 PostgreSQL"
	@echo "  restore-mysql FILE=backup.sql     恢复 MySQL"
	@echo ""
	@echo "$(GREEN)🎯 按需启动:$(RESET)"
	@echo "  start-db      启动数据库服务"
	@echo "  start-cache   启动缓存服务"
	@echo "  start-search  启动搜索服务"
	@echo "  start-storage 启动存储服务"
	@echo "  start-queue   启动消息队列"
	@echo ""
	@echo "$(GREEN)📊 监控:$(RESET)"
	@echo "  monitor       显示服务访问地址"
	@echo ""
	@echo "$(GREEN)示例:$(RESET)"
	@echo "  make start"
	@echo "  make start-db"
	@echo "  make shell-postgres"
	@echo "  make backup-postgres"
	@echo "  make monitor"

# 检查 Docker 是否运行
check-docker: ## 检查 Docker 是否运行
	@if ! docker info > /dev/null 2>&1; then \
		echo "$(RED)❌ Docker 未运行，请先启动 Docker$(RESET)"; \
		exit 1; \
	fi

# 基础服务管理
start: check-docker ## 启动所有服务
	@echo "$(GREEN)🚀 启动本地开发基础设施...$(RESET)"
	@docker-compose up -d
	@echo "$(GREEN)✅ 基础设施服务启动完成！$(RESET)"

stop: ## 停止所有服务
	@echo "$(YELLOW)🛑 停止基础设施服务...$(RESET)"
	@docker-compose down
	@echo "$(GREEN)✅ 基础设施服务已停止！$(RESET)"
	@echo "$(BLUE)💾 数据卷保留，下次启动时会恢复数据$(RESET)"
	@echo "$(BLUE)🗑️  如需完全清理，请运行: make clean$(RESET)"

restart: stop start ## 重启所有服务
	@echo "$(GREEN)🔄 重启基础设施服务完成$(RESET)"

logs: ## 查看服务日志
	@echo "$(CYAN)📋 查看服务日志...$(RESET)"
	@docker-compose logs -f

status: ## 查看服务状态
	@echo "$(CYAN)🔍 查看服务状态...$(RESET)"
	@docker-compose ps

clean: ## 清理所有数据（包括数据卷）
	@echo "$(RED)🧹 清理所有数据（包括数据卷）...$(RESET)"
	@echo "$(RED)⚠️  这将删除所有数据，确定继续吗？$(RESET)"
	@read -p "输入 y 确认继续: " confirm && [ "$$confirm" = "y" ] || (echo "$(RED)❌ 操作已取消$(RESET)" && exit 1)
	@docker-compose down -v
	@echo "$(GREEN)✅ 清理完成$(RESET)"

# 数据库连接
shell-postgres: ## 连接到 PostgreSQL
	@echo "$(BLUE)🐘 连接到 PostgreSQL...$(RESET)"
	@docker-compose exec postgres psql -U postgres

shell-mysql: ## 连接到 MySQL
	@echo "$(BLUE)🐬 连接到 MySQL...$(RESET)"
	@docker-compose exec mysql mysql -u root -p

shell-mongodb: ## 连接到 MongoDB
	@echo "$(BLUE)🍃 连接到 MongoDB...$(RESET)"
	@docker-compose exec mongodb mongosh -u admin -p password

shell-redis: ## 连接到 Redis
	@echo "$(BLUE)🔴 连接到 Redis...$(RESET)"
	@docker-compose exec redis redis-cli

# 数据备份
backup-postgres: ## 备份 PostgreSQL 数据库
	@echo "$(PURPLE)💾 备份 PostgreSQL 数据库...$(RESET)"
	@BACKUP_FILE="postgres_backup_$$(date +%Y%m%d_%H%M%S).sql"; \
	docker-compose exec postgres pg_dump -U postgres postgres > "$$BACKUP_FILE"; \
	echo "$(GREEN)✅ 备份完成: $$BACKUP_FILE$(RESET)"

backup-mysql: ## 备份 MySQL 数据库
	@echo "$(PURPLE)💾 备份 MySQL 数据库...$(RESET)"
	@BACKUP_FILE="mysql_backup_$$(date +%Y%m%d_%H%M%S).sql"; \
	docker-compose exec mysql mysqldump -u root -ppassword dev > "$$BACKUP_FILE"; \
	echo "$(GREEN)✅ 备份完成: $$BACKUP_FILE$(RESET)"

backup-mongodb: ## 备份 MongoDB 数据库
	@echo "$(PURPLE)💾 备份 MongoDB 数据库...$(RESET)"
	@BACKUP_DIR="mongodb_backup_$$(date +%Y%m%d_%H%M%S)"; \
	docker-compose exec mongodb mongodump --username admin --password password --authenticationDatabase admin --out /backup; \
	docker cp dev-mongodb:/backup ./"$$BACKUP_DIR"; \
	echo "$(GREEN)✅ 备份完成: $$BACKUP_DIR$(RESET)"

# 数据恢复
restore-postgres: ## 恢复 PostgreSQL 数据库 (使用 FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ 请指定备份文件: make restore-postgres FILE=backup.sql$(RESET)"; \
		exit 1; \
	fi
	@echo "$(PURPLE)📥 恢复 PostgreSQL 数据库: $(FILE)$(RESET)"
	@docker-compose exec -T postgres psql -U postgres -d postgres < "$(FILE)"
	@echo "$(GREEN)✅ 恢复完成$(RESET)"

restore-mysql: ## 恢复 MySQL 数据库 (使用 FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ 请指定备份文件: make restore-mysql FILE=backup.sql$(RESET)"; \
		exit 1; \
	fi
	@echo "$(PURPLE)📥 恢复 MySQL 数据库: $(FILE)$(RESET)"
	@docker-compose exec -T mysql mysql -u root -ppassword dev < "$(FILE)"
	@echo "$(GREEN)✅ 恢复完成$(RESET)"

# 按需启动服务
start-db: check-docker ## 启动数据库服务
	@echo "$(GREEN)🐘 启动数据库服务...$(RESET)"
	@docker-compose up -d postgres mysql mongodb

start-cache: check-docker ## 启动缓存服务
	@echo "$(GREEN)🔴 启动缓存服务...$(RESET)"
	@docker-compose up -d redis

start-search: check-docker ## 启动搜索服务
	@echo "$(GREEN)🔍 启动搜索服务...$(RESET)"
	@docker-compose up -d elasticsearch kibana

start-storage: check-docker ## 启动存储服务
	@echo "$(GREEN)📦 启动存储服务...$(RESET)"
	@docker-compose up -d minio

start-queue: check-docker ## 启动消息队列
	@echo "$(GREEN)📨 启动消息队列...$(RESET)"
	@docker-compose up -d rabbitmq

# 监控和管理
monitor: ## 显示服务监控信息
	@echo "$(CYAN)📊 服务监控信息...$(RESET)"
	@echo "$(BLUE)PostgreSQL: http://localhost:5432$(RESET)"
	@echo "$(BLUE)MySQL: http://localhost:3306$(RESET)"
	@echo "$(BLUE)MongoDB: http://localhost:27017$(RESET)"
	@echo "$(BLUE)Redis: http://localhost:6379$(RESET)"
	@echo "$(BLUE)Elasticsearch: http://localhost:9200$(RESET)"
	@echo "$(BLUE)Kibana: http://localhost:5601$(RESET)"
	@echo "$(BLUE)MinIO: http://localhost:9001 (admin/password123)$(RESET)"
	@echo "$(BLUE)RabbitMQ: http://localhost:15672 (admin/password)$(RESET)"
