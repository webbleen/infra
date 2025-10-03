[English](README.md) | [中文](README.zh-CN.md)

# インフラストラクチャ管理 (Infrastructure)

このディレクトリには、データベース、キャッシュ、検索、ストレージ、メッセージキューなどのサービスを提供する完全なローカル開発環境インフラストラクチャサービスが含まれています。ローカル開発とクラウドデプロイメントをサポートします。

## 🎯 プロジェクト概要

インフラストラクチャ管理ツールは以下を提供します：
- **ローカル開発環境**：完全な開発インフラストラクチャ
- **クラウドデプロイメントサポート**：Railway などのクラウドプラットフォームデプロイメント
- **統一管理**：Makefile 標準化管理
- **マルチ環境サポート**：開発、テスト、本番環境設定

## 🛠️ サービス一覧

### データベースサービス
- **PostgreSQL 15** - リレーショナルデータベース、ACID トランザクションサポート
- **MySQL 8.0** - リレーショナルデータベース、高性能クエリ
- **MongoDB 7** - ドキュメントデータベース、柔軟なデータ構造

### キャッシュサービス
- **Redis 7** - メモリキャッシュ、高性能データストレージ

### 検索サービス
- **Elasticsearch 8.11** - 全文検索エンジン
- **Kibana 8.11** - データ可視化と分析プラットフォーム

### ストレージサービス
- **MinIO** - オブジェクトストレージ、S3 互換ストレージサービス

### メッセージキュー
- **RabbitMQ 3** - メッセージキュー、複数のメッセージパターンをサポート

## 🎯 サービス使用シナリオ

### データベースサービス
- **PostgreSQL**: メインデータベース、構造化データの保存
- **MySQL**: バックアップデータベース、特定のビジネス要件をサポート
- **MongoDB**: 非構造化データとログの保存

### キャッシュサービス
- **Redis**: ホットデータをキャッシュし、システムパフォーマンスを向上

### 検索サービス
- **Elasticsearch**: 全文検索とデータ分析を実装
- **Kibana**: データ可視化、システム状態の監視

### ストレージサービス
- **MinIO**: ファイル、画像、動画などの静的リソースを保存

### メッセージキュー
- **RabbitMQ**: 非同期タスクの処理、システムコンポーネントの分離

## 🚀 クイックスタート

### ローカル開発環境

#### すべてのサービスを起動

```bash
# 方法1: Makefile を使用（推奨）
make start

# 方法2: Docker Compose を使用
docker-compose up -d
```

#### 必要に応じてサービスを起動

```bash
# Makefile を使用
make start-db      # データベースサービスを起動
make start-cache   # キャッシュサービスを起動
make start-search  # 検索サービスを起動
make start-storage # ストレージサービスを起動
make start-queue   # メッセージキューを起動
```

### クラウドデプロイメント (Railway)

#### サポートされているサービス
- ✅ **MinIO** - オブジェクトストレージ
- ✅ **RabbitMQ** - メッセージキュー
- ⚠️ **Elasticsearch** - 有料プランが必要
- ⚠️ **Kibana** - 有料プランが必要

#### デプロイメント手順
1. Railway で新しいプロジェクトを作成
2. PostgreSQL と Redis サービスを追加（Railway ネイティブ）
3. MinIO と RabbitMQ をデプロイ（Docker 方式）
4. 必要に応じて Elasticsearch と Kibana をデプロイ

## 管理コマンド

### Makefile を使用（推奨）

```bash
# 利用可能なすべてのコマンドを表示
make help

# 基本コマンド
make start      # すべてのサービスを起動
make stop       # すべてのサービスを停止
make restart    # すべてのサービスを再起動
make logs       # サービスログを表示
make status     # サービス状態を表示
make clean      # すべてのデータをクリーンアップ（データボリューム含む）

# データベース接続
make shell-postgres  # PostgreSQL に接続
make shell-mysql     # MySQL に接続
make shell-mongodb   # MongoDB に接続
make shell-redis     # Redis に接続

# データバックアップ
make backup-postgres  # PostgreSQL をバックアップ
make backup-mysql     # MySQL をバックアップ
make backup-mongodb   # MongoDB をバックアップ

# データ復元
make restore-postgres FILE=backup.sql  # PostgreSQL を復元
make restore-mysql FILE=backup.sql     # MySQL を復元

# 必要に応じて起動
make start-db      # データベースサービスを起動
make start-cache   # キャッシュサービスを起動
make start-search  # 検索サービスを起動
make start-storage # ストレージサービスを起動
make start-queue   # メッセージキューを起動

# 監視
make monitor       # サービスアクセスアドレスを表示
```

## サービス設定

### PostgreSQL
- **ポート**: 5432
- **ユーザー名**: postgres
- **パスワード**: password
- **データベース**: postgres, dailyzen, test_db, staging_db

### MySQL
- **ポート**: 3306
- **ユーザー名**: root / dev
- **パスワード**: password
- **データベース**: dev

### MongoDB
- **ポート**: 27017
- **ユーザー名**: admin
- **パスワード**: password

### Redis
- **ポート**: 6379
- **パスワードなし**

### Elasticsearch
- **ポート**: 9200 (HTTP), 9300 (TCP)
- **認証なし**

### Kibana
- **ポート**: 5601
- **認証なし**

### MinIO
- **ポート**: 9000 (API), 9001 (Console)
- **ユーザー名**: admin
- **パスワード**: password123

### RabbitMQ
- **ポート**: 5672 (AMQP), 15672 (Management)
- **ユーザー名**: admin
- **パスワード**: password

## データ永続化

すべてのデータは Docker データボリュームに保存され、コンテナが再起動してもデータは失われません。データボリュームの場所：

- PostgreSQL: `postgres_data`
- MySQL: `mysql_data`
- MongoDB: `mongodb_data`
- Redis: `redis_data`
- Elasticsearch: `elasticsearch_data`
- MinIO: `minio_data`
- RabbitMQ: `rabbitmq_data`

## ネットワーク設定

すべてのサービスは `dev-network` ネットワーク内にあり、サービス名で相互アクセスできます：

- PostgreSQL: `postgres:5432`
- MySQL: `mysql:3306`
- MongoDB: `mongodb:27017`
- Redis: `redis:6379`
- Elasticsearch: `elasticsearch:9200`
- Kibana: `kibana:5601`
- MinIO: `minio:9000`
- RabbitMQ: `rabbitmq:5672`

## トラブルシューティング

### サービス起動失敗
1. Docker が実行されているか確認
2. ポートが使用されていないか確認
3. サービスログを確認: `make logs` または `docker-compose logs`

### データ損失
1. データボリュームが存在するか確認: `docker volume ls`
2. コンテナ状態を確認: `make status`
3. データをリセットする必要がある場合、実行: `make clean`

### ネットワーク接続問題
1. ネットワークが存在するか確認: `docker network ls`
2. ネットワークを再作成: `docker network create dev-network`

## 開発推奨事項

### ローカル開発
1. **Makefile を使用**: 管理には `make` コマンドの使用を推奨、より標準化
2. **データバックアップ**: 重要なデータを定期的にバックアップ
3. **リソース監視**: メモリとディスク使用量に注意
4. **バージョン管理**: 設定ファイルをバージョン管理に含める
5. **環境分離**: 異なるプロジェクトに異なるデータボリュームプレフィックスを使用

### 本番デプロイメント
1. **サービス選択**: 実際のニーズに基づいてサービスを選択、過度な設定を避ける
2. **コスト最適化**: クラウドプラットフォームネイティブサービスを優先
3. **監視とアラート**: 適切な監視とアラートメカニズムを設定
4. **データセキュリティ**: 機密データを定期的にバックアップと暗号化
5. **パフォーマンス最適化**: 使用状況に基づいてリソース設定を調整

## 環境設定

### 開発環境
- すべてのサービスがローカルで実行
- Docker データボリュームを使用してデータを永続化
- ホットリロードとデバッグをサポート

### テスト環境
- Railway または類似プラットフォームを使用
- 本番環境と同様の設定
- 統合テストとパフォーマンステストに使用

### 本番環境
- クラウドプラットフォームネイティブサービスを使用
- 高可用性とロードバランシング
- 監視とログ収集

## 監視とメンテナンス

### ヘルスチェック
```bash
# すべてのサービス状態を確認
make status

# サービスログを表示
make logs

# サービスアクセスアドレスを監視
make monitor
```

### データバックアップ
```bash
# PostgreSQL をバックアップ
make backup-postgres

# MySQL をバックアップ
make backup-mysql

# MongoDB をバックアップ
make backup-mongodb
```

### トラブルシューティング
1. **サービス起動失敗**: Docker 状態とポート使用状況を確認
2. **データ損失**: データボリュームとバックアップを確認
3. **ネットワーク問題**: ネットワーク設定とファイアウォールを確認
4. **パフォーマンス問題**: リソース使用状況を監視

## デプロイメントガイド

### Railway デプロイメント
1. Railway プロジェクトを作成
2. データベースとキャッシュサービスを追加
3. MinIO と RabbitMQ をデプロイ
4. 環境変数を設定
5. アプリケーションサービスをデプロイ

### その他のクラウドプラットフォーム
- **AWS**: RDS、ElastiCache、S3 などのサービスを使用
- **Google Cloud**: Cloud SQL、Memorystore、Cloud Storage などを使用
- **Azure**: Azure Database、Redis Cache、Blob Storage などを使用

## 更新ログ

### v1.0.0
- 初期バージョンリリース
- すべてのコアサービスのサポート
- 完全な Makefile 管理
- Railway デプロイメントサポート

