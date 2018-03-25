#!/bin/bash
PARAM=$(echo ${DATABASE_URL} | sed 's#postgres://\([^:]*\):\([^@]*\)@\(.*\)#\1 \2 \3#')
URL=$(echo "$PARAM" | awk '{print $3}')
USER=$(echo "$PARAM" | awk '{print $1}')
PASSWORD=$(echo "$PARAM" | awk '{print $2}')
sed -i "s#URL#${URL}#" /opt/jboss-cli.txt
sed -i "s#USER#${USER}#" /opt/jboss-cli.txt
sed -i "s#PASSWORD#${PASSWORD}#" /opt/jboss-cli.txt

# 起動
/opt/wildfly/bin//standalone.sh -Djboss.http.port=$PORT &

# 起動待ち
RET=1
while [ $RET != 0 ]
do
	sleep 3
	/opt/wildfly/bin/jboss-cli.sh --connect ls
	RET=$?
done

# ユーザ作成
/opt/wildfly/bin/add-user.sh -u admin -p password
# データソース作成
cat /opt/jboss-cli.txt | /opt/wildfly/bin/jboss-cli.sh
# デプロイ
/opt/wildfly/bin/jboss-cli.sh --connect 'deploy /root/myapp.war'

# exit対策
tail -f /dev/null
