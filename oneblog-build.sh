#!/bin/bash

#${WORKSPACE}/oneblog-build.sh ${WORKSPACE} ${version}
projectdir=$1/blog-web/target
newversion=$2
builddir=$1
env=bixby-cndev
reponame=oneblog

cp $projectdir/blog-web-${newversion}.Beta.jar ${builddir}

#newversion=`ls -tr blog-web-*.jar|tail -1|awk -F '-' '{print $3}'|cut -d '.' -f 1-3`

echo $newversion
cd ${builddir}
#version_old=`aws --profile dr ecr list-images  --repository-name xy1219.zhao/baidu-token-dr|jq .imageIds[0].imageTag|sed -n 's#"##gp'`
oldversion=`grep 'blog-web-*.*jar' Dockerfile |tail -1|awk -F '-' '{print $4}'|cut -d '.' -f 1-3 `
#curl -X GET http://10.82.254.142:5000/v2/baidu-token-dr/tags/list

echo "============================Dcoker-image-build-push========================================"

sed -i "s/$oldversion/$newversion/g" Dockerfile
newport=`grep 'EXPOSE' Dockerfile|awk -F ' ' '{print $2}'`

docker build -t xy1219.zhao/oneblog:latest .
echo;echo;echo "===================== [STEP 3-2] run container =====================";echo;echo
docker run -d -p $newport:$newport $reponame:latest

cat <<EOF > pipeline-init.json
{
    "dockerImageTag" : "$newversion",
    "dockerRepoUrl" : "$reponame",
    "dockerport" : "$newport"
}
EOF

docker tag xy1219.zhao/oneblog:latest 10.82.254.142:5000/oneblog:$newversion
docker push 10.82.254.142:5000/oneblog:$newversion

#$(aws --profile bixby-cndev ecr get-login --no-include-email --region cn-north-1)
awsloginCmd=`aws --profile ${env} ecr get-login --region cn-north-1 | sed -e 's/-e none//g'`
sh ${awsloginCmd}

docker tag xy1219.zhao/oneblog:latest 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/oneblog:$newversion
docker push 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/oneblog:$newversion

docker tag xy1219.zhao/oneblog:latest 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/oneblog:latest
docker push 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/oneblog:latest

version_old=`aws --profile ${env} ecr list-images  --repository-name xy1219.zhao/oneblog|jq .imageIds[0].imageTag`

echo $version_old
#docker tag xy1219.zhao/baidu-token-dr:$version 081396032000.dkr.ecr.cn-northwest-1.amazonaws.com.cn/xy1219.zhao/baidu-token-dr:v$version

#docker push 081396032000.dkr.ecr.cn-northwest-1.amazonaws.com.cn/xy1219.zhao/baidu-token-dr:v$version

echo "============================xy1219.zhao/oneblog========================================"
curl -X GET http://10.82.254.142:5000/v2/oneblog/tags/list
