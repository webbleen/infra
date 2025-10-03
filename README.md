[中文](README.zh-CN.md) | [日本語](README.ja.md)

# Infrastructure Management

This directory contains a complete local development environment infrastructure services, providing database, cache, search, storage, message queue and other services. Supports local development and cloud deployment.

## 🎯 Project Overview

Infrastructure management tools provide:
- **Local Development Environment**: Complete development infrastructure
- **Cloud Deployment Support**: Railway and other cloud platform deployment
- **Unified Management**: Makefile standardized management
- **Multi-Environment Support**: Development, testing, production environment configuration

## 🛠️ Service List

### Database Services
- **PostgreSQL 15** - Relational database with ACID transaction support
- **MySQL 8.0** - Relational database with high-performance queries
- **MongoDB 7** - Document database with flexible data structure

### Cache Services
- **Redis 7** - In-memory cache with high-performance data storage

### Search Services
- **Elasticsearch 8.11** - Full-text search engine
- **Kibana 8.11** - Data visualization and analysis platform

### Storage Services
- **MinIO** - Object storage, S3-compatible storage service

### Message Queue
- **RabbitMQ 3** - Message queue supporting multiple message patterns

## 🎯 Service Use Cases

### Database Services
- **PostgreSQL**: Primary database for storing structured data
- **MySQL**: Backup database supporting specific business requirements
- **MongoDB**: Store unstructured data and logs

### Cache Services
- **Redis**: Cache hot data to improve system performance

### Search Services
- **Elasticsearch**: Implement full-text search and data analysis
- **Kibana**: Data visualization and system status monitoring

### Storage Services
- **MinIO**: Store files, images, videos and other static resources

### Message Queue
- **RabbitMQ**: Handle asynchronous tasks and decouple system components

## 🚀 Quick Start

### Local Development Environment

#### Start All Services

```bash
# Method 1: Using Makefile (Recommended)
make start

# Method 2: Using Docker Compose
docker-compose up -d
```

#### Start Services On-Demand

```bash
# Using Makefile
make start-db      # Start database services
make start-cache   # Start cache services
make start-search  # Start search services
make start-storage # Start storage services
make start-queue   # Start message queue
```

### Cloud Deployment (Railway)

#### Supported Services
- ✅ **MinIO** - Object storage
- ✅ **RabbitMQ** - Message queue
- ⚠️ **Elasticsearch** - Requires paid plan
- ⚠️ **Kibana** - Requires paid plan

#### Deployment Steps
1. Create a new project on Railway
2. Add PostgreSQL and Redis services (Railway native)
3. Deploy MinIO and RabbitMQ (Docker method)
4. Deploy Elasticsearch and Kibana as needed

#### Railway Configuration Example
```yaml
# railway-docker-compose.yml
version: '3.8'
services:
  minio:
    image: minio/minio:latest
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD}
    command: server /data --console-address ":9001"
  
  rabbitmq:
    image: rabbitmq:3-management
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASS}
```

## Management Commands

### Using Makefile (Recommended)

```bash
# View all available commands
make help

# Basic commands
make start      # Start all services
make stop       # Stop all services
make restart    # Restart all services
make logs       # View service logs
make status     # View service status
make clean      # Clean all data (including data volumes)

# Database connections
make shell-postgres  # Connect to PostgreSQL
make shell-mysql     # Connect to MySQL
make shell-mongodb   # Connect to MongoDB
make shell-redis     # Connect to Redis

# Data backup
make backup-postgres  # Backup PostgreSQL
make backup-mysql     # Backup MySQL
make backup-mongodb   # Backup MongoDB

# Data restore
make restore-postgres FILE=backup.sql  # Restore PostgreSQL
make restore-mysql FILE=backup.sql     # Restore MySQL

# On-demand startup
make start-db      # Start database services
make start-cache   # Start cache services
make start-search  # Start search services
make start-storage # Start storage services
make start-queue   # Start message queue

# Monitoring
make monitor       # Display service access addresses
```

### Using Docker Compose

```bash
# Basic commands
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart all services
docker-compose restart

# View service status
docker-compose ps

# View service logs
docker-compose logs -f

# Clean all data (including data volumes)
docker-compose down -v
```

## Service Configuration

### PostgreSQL
- **Port**: 5432
- **Username**: postgres
- **Password**: password
- **Databases**: postgres, dailyzen, test_db, staging_db

### MySQL
- **Port**: 3306
- **Username**: root / dev
- **Password**: password
- **Database**: dev

### MongoDB
- **Port**: 27017
- **Username**: admin
- **Password**: password

### Redis
- **Port**: 6379
- **No password**

### Elasticsearch
- **Port**: 9200 (HTTP), 9300 (TCP)
- **No authentication**

### Kibana
- **Port**: 5601
- **No authentication**

### MinIO
- **Port**: 9000 (API), 9001 (Console)
- **Username**: admin
- **Password**: password123

### RabbitMQ
- **Port**: 5672 (AMQP), 15672 (Management)
- **Username**: admin
- **Password**: password

## Data Persistence

All data is stored in Docker data volumes, so data will not be lost even if containers restart. Data volume locations:

- PostgreSQL: `postgres_data`
- MySQL: `mysql_data`
- MongoDB: `mongodb_data`
- Redis: `redis_data`
- Elasticsearch: `elasticsearch_data`
- MinIO: `minio_data`
- RabbitMQ: `rabbitmq_data`

## Network Configuration

All services are in the `dev-network` network and can access each other by service name:

- PostgreSQL: `postgres:5432`
- MySQL: `mysql:3306`
- MongoDB: `mongodb:27017`
- Redis: `redis:6379`
- Elasticsearch: `elasticsearch:9200`
- Kibana: `kibana:5601`
- MinIO: `minio:9000`
- RabbitMQ: `rabbitmq:5672`

## Troubleshooting

### Service Startup Failure
1. Check if Docker is running
2. Check if ports are occupied
3. View service logs: `make logs` or `docker-compose logs`

### Data Loss
1. Check if data volumes exist: `docker volume ls`
2. Check container status: `make status`
3. If you need to reset data, run: `make clean`

### Network Connection Issues
1. Check if network exists: `docker network ls`
2. Recreate network: `docker network create dev-network`

## Development Recommendations

### Local Development
1. **Use Makefile**: Recommended to use `make` commands for management, more standardized
2. **Data Backup**: Regularly backup important data
3. **Resource Monitoring**: Pay attention to memory and disk usage
4. **Version Control**: Include configuration files in version control
5. **Environment Isolation**: Use different data volume prefixes for different projects

### Production Deployment
1. **Service Selection**: Choose services based on actual needs, avoid over-configuration
2. **Cost Optimization**: Prioritize cloud platform native services
3. **Monitoring and Alerts**: Set up appropriate monitoring and alert mechanisms
4. **Data Security**: Regularly backup and encrypt sensitive data
5. **Performance Optimization**: Adjust resource configuration based on usage

## Environment Configuration

### Development Environment
- All services run locally
- Use Docker data volumes for data persistence
- Support hot reload and debugging

### Testing Environment
- Use Railway or similar platforms
- Configuration similar to production environment
- Used for integration testing and performance testing

### Production Environment
- Use cloud platform native services
- High availability and load balancing
- Monitoring and log collection

## Monitoring and Maintenance

### Health Checks
```bash
# Check all service status
make status

# View service logs
make logs

# Monitor service access addresses
make monitor
```

### Data Backup
```bash
# Backup PostgreSQL
make backup-postgres

# Backup MySQL
make backup-mysql

# Backup MongoDB
make backup-mongodb
```

### Troubleshooting
1. **Service startup failure**: Check Docker status and port occupancy
2. **Data loss**: Check data volumes and backups
3. **Network issues**: Check network configuration and firewall
4. **Performance issues**: Monitor resource usage

## Deployment Guide

### Railway Deployment
1. Create Railway project
2. Add database and cache services
3. Deploy MinIO and RabbitMQ
4. Configure environment variables
5. Deploy application services

### Other Cloud Platforms
- **AWS**: Use RDS, ElastiCache, S3 and other services
- **Google Cloud**: Use Cloud SQL, Memorystore, Cloud Storage, etc.
- **Azure**: Use Azure Database, Redis Cache, Blob Storage, etc.

## Changelog

### v1.0.0
- Initial version release
- Support for all core services
- Complete Makefile management
- Railway deployment support
