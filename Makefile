# DailyZen Local Development Environment Infrastructure Management Makefile
# Provides common database, cache and other services for all projects

.PHONY: help start stop restart logs status clean
.PHONY: shell-postgres shell-mysql shell-mongodb shell-redis
.PHONY: backup-postgres backup-mysql backup-mongodb
.PHONY: restore-postgres restore-mysql
.PHONY: start-db start-cache start-search start-storage start-queue
.PHONY: monitor check-docker

# Default target
.DEFAULT_GOAL := help

# Color definitions
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
RESET := \033[0m

# Help information
help: ## Display help information
	@echo "$(CYAN)Local Development Environment Infrastructure Management Tool$(RESET)"
	@echo ""
	@echo "$(YELLOW)Usage: make {command}$(RESET)"
	@echo ""
	@echo "$(GREEN)🚀 Basic Commands:$(RESET)"
	@echo "  start         Start all services"
	@echo "  stop          Stop all services"
	@echo "  restart       Restart all services"
	@echo "  logs          View service logs"
	@echo "  status        View service status"
	@echo "  clean         Clean all data (including data volumes)"
	@echo ""
	@echo "$(GREEN)🔌 Database Connections:$(RESET)"
	@echo "  shell-postgres  Connect to PostgreSQL"
	@echo "  shell-mysql     Connect to MySQL"
	@echo "  shell-mongodb   Connect to MongoDB"
	@echo "  shell-redis     Connect to Redis"
	@echo ""
	@echo "$(GREEN)💾 Data Backup:$(RESET)"
	@echo "  backup-postgres   Backup PostgreSQL"
	@echo "  backup-mysql      Backup MySQL"
	@echo "  backup-mongodb    Backup MongoDB"
	@echo ""
	@echo "$(GREEN)📥 Data Restore:$(RESET)"
	@echo "  restore-postgres FILE=backup.sql  Restore PostgreSQL"
	@echo "  restore-mysql FILE=backup.sql     Restore MySQL"
	@echo ""
	@echo "$(GREEN)🎯 On-Demand Startup:$(RESET)"
	@echo "  start-db      Start database services"
	@echo "  start-cache   Start cache services"
	@echo "  start-search  Start search services"
	@echo "  start-storage Start storage services"
	@echo "  start-queue   Start message queue"
	@echo ""
	@echo "$(GREEN)📊 Monitoring:$(RESET)"
	@echo "  monitor       Display service access addresses"
	@echo ""
	@echo "$(GREEN)Examples:$(RESET)"
	@echo "  make start"
	@echo "  make start-db"
	@echo "  make shell-postgres"
	@echo "  make backup-postgres"
	@echo "  make monitor"

# Check if Docker is running
check-docker: ## Check if Docker is running
	@if ! docker info > /dev/null 2>&1; then \
		echo "$(RED)❌ Docker is not running, please start Docker first$(RESET)"; \
		exit 1; \
	fi

# Basic service management
start: check-docker ## Start all services
	@echo "$(GREEN)🚀 Starting local development infrastructure...$(RESET)"
	@docker-compose up -d
	@echo "$(GREEN)✅ Infrastructure services started successfully!$(RESET)"

stop: ## Stop all services
	@echo "$(YELLOW)🛑 Stopping infrastructure services...$(RESET)"
	@docker-compose down
	@echo "$(GREEN)✅ Infrastructure services stopped!$(RESET)"
	@echo "$(BLUE)💾 Data volumes preserved, data will be restored on next startup$(RESET)"
	@echo "$(BLUE)🗑️  To completely clean up, run: make clean$(RESET)"

restart: stop start ## Restart all services
	@echo "$(GREEN)🔄 Infrastructure services restarted$(RESET)"

logs: ## View service logs
	@echo "$(CYAN)📋 Viewing service logs...$(RESET)"
	@docker-compose logs -f

status: ## View service status
	@echo "$(CYAN)🔍 Viewing service status...$(RESET)"
	@docker-compose ps

clean: ## Clean all data (including data volumes)
	@echo "$(RED)🧹 Cleaning all data (including data volumes)...$(RESET)"
	@echo "$(RED)⚠️  This will delete all data, are you sure you want to continue?$(RESET)"
	@read -p "Enter y to confirm: " confirm && [ "$$confirm" = "y" ] || (echo "$(RED)❌ Operation cancelled$(RESET)" && exit 1)
	@docker-compose down -v
	@echo "$(GREEN)✅ Cleanup completed$(RESET)"

# Database connections
shell-postgres: ## Connect to PostgreSQL
	@echo "$(BLUE)🐘 Connecting to PostgreSQL...$(RESET)"
	@docker-compose exec postgres psql -U postgres

shell-mysql: ## Connect to MySQL
	@echo "$(BLUE)🐬 Connecting to MySQL...$(RESET)"
	@docker-compose exec mysql mysql -u root -p

shell-mongodb: ## Connect to MongoDB
	@echo "$(BLUE)🍃 Connecting to MongoDB...$(RESET)"
	@docker-compose exec mongodb mongosh -u admin -p password

shell-redis: ## Connect to Redis
	@echo "$(BLUE)🔴 Connecting to Redis...$(RESET)"
	@docker-compose exec redis redis-cli

# Data backup
backup-postgres: ## Backup PostgreSQL database
	@echo "$(PURPLE)💾 Backing up PostgreSQL database...$(RESET)"
	@BACKUP_FILE="postgres_backup_$$(date +%Y%m%d_%H%M%S).sql"; \
	docker-compose exec postgres pg_dump -U postgres postgres > "$$BACKUP_FILE"; \
	echo "$(GREEN)✅ Backup completed: $$BACKUP_FILE$(RESET)"

backup-mysql: ## Backup MySQL database
	@echo "$(PURPLE)💾 Backing up MySQL database...$(RESET)"
	@BACKUP_FILE="mysql_backup_$$(date +%Y%m%d_%H%M%S).sql"; \
	docker-compose exec mysql mysqldump -u root -ppassword dev > "$$BACKUP_FILE"; \
	echo "$(GREEN)✅ Backup completed: $$BACKUP_FILE$(RESET)"

backup-mongodb: ## Backup MongoDB database
	@echo "$(PURPLE)💾 Backing up MongoDB database...$(RESET)"
	@BACKUP_DIR="mongodb_backup_$$(date +%Y%m%d_%H%M%S)"; \
	docker-compose exec mongodb mongodump --username admin --password password --authenticationDatabase admin --out /backup; \
	docker cp dev-mongodb:/backup ./"$$BACKUP_DIR"; \
	echo "$(GREEN)✅ Backup completed: $$BACKUP_DIR$(RESET)"

# Data restore
restore-postgres: ## Restore PostgreSQL database (use FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ Please specify backup file: make restore-postgres FILE=backup.sql$(RESET)"; \
		exit 1; \
	fi
	@echo "$(PURPLE)📥 Restoring PostgreSQL database: $(FILE)$(RESET)"
	@docker-compose exec -T postgres psql -U postgres -d postgres < "$(FILE)"
	@echo "$(GREEN)✅ Restore completed$(RESET)"

restore-mysql: ## Restore MySQL database (use FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ Please specify backup file: make restore-mysql FILE=backup.sql$(RESET)"; \
		exit 1; \
	fi
	@echo "$(PURPLE)📥 Restoring MySQL database: $(FILE)$(RESET)"
	@docker-compose exec -T mysql mysql -u root -ppassword dev < "$(FILE)"
	@echo "$(GREEN)✅ Restore completed$(RESET)"

# On-demand service startup
start-db: check-docker ## Start database services
	@echo "$(GREEN)🐘 Starting database services...$(RESET)"
	@docker-compose up -d postgres mysql mongodb

start-cache: check-docker ## Start cache services
	@echo "$(GREEN)🔴 Starting cache services...$(RESET)"
	@docker-compose up -d redis

start-search: check-docker ## Start search services
	@echo "$(GREEN)🔍 Starting search services...$(RESET)"
	@docker-compose up -d elasticsearch kibana

start-storage: check-docker ## Start storage services
	@echo "$(GREEN)📦 Starting storage services...$(RESET)"
	@docker-compose up -d minio

start-queue: check-docker ## Start message queue
	@echo "$(GREEN)📨 Starting message queue...$(RESET)"
	@docker-compose up -d rabbitmq

# Monitoring and management
monitor: ## Display service monitoring information
	@echo "$(CYAN)📊 Service monitoring information...$(RESET)"
	@echo "$(BLUE)PostgreSQL: http://localhost:5432$(RESET)"
	@echo "$(BLUE)MySQL: http://localhost:3306$(RESET)"
	@echo "$(BLUE)MongoDB: http://localhost:27017$(RESET)"
	@echo "$(BLUE)Redis: http://localhost:6379$(RESET)"
	@echo "$(BLUE)Elasticsearch: http://localhost:9200$(RESET)"
	@echo "$(BLUE)Kibana: http://localhost:5601$(RESET)"
	@echo "$(BLUE)MinIO: http://localhost:9001 (admin/password123)$(RESET)"
	@echo "$(BLUE)RabbitMQ: http://localhost:15672 (admin/password)$(RESET)"
