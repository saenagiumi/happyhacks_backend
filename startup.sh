#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# AWSコンソール画面で作成したRDSに対して、マイグレーションを実行する
# (データベース自体は作成されているので、マイグレーションファイルでテーブルを作成する)
rails db:migrate RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"