-- 创建 DailyZen 相关数据库
-- 这个脚本会在 PostgreSQL 容器启动时自动执行

-- 创建主数据库
CREATE DATABASE dailyzen;

-- 创建测试数据库
CREATE DATABASE dailyzen_test;

-- 创建预发布数据库
CREATE DATABASE dailyzen_staging;

-- 创建用户并授权
CREATE USER dailyzen_user WITH PASSWORD 'dailyzen_password';
GRANT ALL PRIVILEGES ON DATABASE dailyzen TO dailyzen_user;
GRANT ALL PRIVILEGES ON DATABASE dailyzen_test TO dailyzen_user;
GRANT ALL PRIVILEGES ON DATABASE dailyzen_staging TO dailyzen_user;

-- 切换到 dailyzen 数据库并创建扩展
\c dailyzen;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 切换到 dailyzen_test 数据库并创建扩展
\c dailyzen_test;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 切换到 dailyzen_staging 数据库并创建扩展
\c dailyzen_staging;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
