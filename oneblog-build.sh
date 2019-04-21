#!/bin/bash

#${WORKSPACE}/oneblog-build.sh ${WORKSPACE}/blog-web/target ${version} ${WORKSPACE}
projectdir=$1
newpackeage=$2
builddir=$3
env=bixby-cndev
checkPass=0

cp $projectdir/${newpackeage} ${builddir}

echo $newpackeage

#cd ${builddir}
#version_old=`aws --profile dr ecr list-images  --repository-name xy1219.zhao/baidu-token-dr|jq .imageIds[0].imageTag|sed -n 's#"##gp'`
oldpackeage=`grep 'ENTRYPOINT java' Dockerfile|awk -F ' ' '{print $4}'`

echo "============================[STEP 1-1]Dcoker-image-build========================================"
sed -i "s/$oldpackeage/$newpackeage/g" Dockerfile

#Port replace
oldport=`grep 'EXPOSE' Dockerfile|awk -F ' ' '{print $2}'`
if [[ $newpackeage =~ "baidu" ]]
then
    sed -i "s/$oldport/8443/g" Dockerfile
elif [[ $newpackeage =~ "jd" ]]
then
    sed -i "s/$oldport/5060/g" Dockerfile
elif [[ $newpackeage =~ "blog" ]]
then
    sed -i "s/$oldport/8443/g" Dockerfile
else
    sed -i "s/$oldport/8443/g" Dockerfile
fi



if [[ $newpackeage =~ "blog" ]]
then
    reponame="oneblog"
	version=`grep 'ENTRYPOINT java' Dockerfile|awk -F ' ' '{print $4}'|awk -F '-' '{print $3}'|cut -d '.' -f 1-3`
else
    reponame=`grep 'ENTRYPOINT java' Dockerfile|awk -F '-' '{print $3$4}'`
	version=`grep 'ENTRYPOINT java' Dockerfile|awk -F '-' '{print $5}'|cut -d '.' -f 1-3`
fi	

newport=`grep 'EXPOSE' Dockerfile|awk -F ' ' '{print $2}'`
docker build -t xy1219.zhao/$reponame:latest .
echo;echo;echo "===================== [STEP 1-2] run container =====================";echo;echo
docker run -d -p $newport:$newport xy1219.zhao/$reponame:latest

cat <<EOF > pipeline-init.json
{
    "dockerImageTag" : "$version",
    "dockerRepoUrl" : "$reponame",
    "dockerport" : "$newport"
}
EOF
echo;echo;echo "===================== [STEP 1-3] run container test =====================";echo;echo


echo;echo;echo "===================== [STEP 1-4] push image to ECR =====================";echo;echo
docker tag xy1219.zhao/$reponame:latest 10.82.254.142:5000/$reponame:$version
docker push 10.82.254.142:5000/$reponame:$version

#$(aws --profile bixby-cndev ecr get-login --no-include-email --region cn-north-1)
awsloginCmd=`aws --profile ${env} ecr get-login --region cn-north-1 | sed -e 's/-e none//g'`
sh ${awsloginCmd}

docker tag xy1219.zhao/$reponame:latest 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$reponame:$version
docker push 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$reponame:$version || checkPass=1
if [ ${checkPass} -ne 0 ]; then
    exit 1
fi

docker tag xy1219.zhao/$reponame:latest 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$reponame:latest
docker push 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$reponame:latest || checkPass=1
if [ ${checkPass} -ne 0 ]; then
    exit 1
fi

version_old=`aws --profile ${env} ecr list-images  --repository-name xy1219.zhao/$reponame|jq .imageIds[0].imageTag`

echo $version_old
#docker tag xy1219.zhao/baidu-token-dr:$version 081396032000.dkr.ecr.cn-northwest-1.amazonaws.com.cn/xy1219.zhao/baidu-token-dr:v$version

#docker push 081396032000.dkr.ecr.cn-northwest-1.amazonaws.com.cn/xy1219.zhao/baidu-token-dr:v$version

echo "============================xy1219.zhao/$reponame========================================"
curl -X GET http://10.82.254.142:5000/v2/$reponame/tags/list
