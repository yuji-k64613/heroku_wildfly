#
# Create New App、Postgresアドオン
#
heroku create
heroku container:login
heroku addons
heroku addons:create heroku-postgresql:hobby-dev
heroku pg:info
heroku config
#
# DBのセットアップ
# postgresをがインストールされているホストから実行
#
heroku login
heroku pg:psql -a infinite-citadel-35183
CREATE TABLE PERSON (
        ID INTEGER,
        NAME VARCHAR,
        PRIMARY KEY(ID)
);
insert into PERSON values (1, 'TEST DATA');
insert into PERSON values (2, 'AAA BBB');
#
# ローカル環境でのDockerコンテナ生成(動作確認)
#
cd web
docker build -t herokuwildfly -f Dockerfile.web .
cd ..
#
# デプロイ、実行
#
heroku container:push web --recursive
heroku logs -t
heroku open
curl "http://$(heroku domains | grep herokuapp)/myapp/service/main/foo?id=1"
