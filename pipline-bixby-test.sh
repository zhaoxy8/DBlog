#!/bin/bash

set -e

checkPass=0
env=bixby-cndev

dockerImageTag=` cat pipeline-init.json | jq -r .dockerImageTag `
dockerRepoUrl=` cat pipeline-init.json | jq -r .dockerRepoUrl `
dockerImageId=` cat pipeline-init.json | jq -r .dockerImageId `
dockerport=` cat pipeline-init.json | jq -r .dockerport `

sleep 60

echo;echo;echo "===================== [STEP 1-3] container test =====================";echo;echo
if [[ $dockerRepoUrl =~ "baidu" ]]
then
    http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://localhost:8080/viv/healthcheck`
	echo "http_code:" ${http_code}
	if [ ${http_code} -ne 200 ]; then
		checkPass=1
	fi
elif [[ $dockerRepoUrl =~ "jd" ]]
then
    http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://localhost:5060/bixby/healthcheck`
	echo "http_code:" ${http_code}
	if [ ${http_code} -ne 200 ]; then
		checkPass=1
	fi
elif [[ $dockerRepoUrl =~ "blog" ]]
then
    http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code}  http://localhost:8443`
	echo "http_code:" ${http_code}
	if [ ${http_code} -ne 200 ]; then
		checkPass=1
	fi
else
    echo "Don't have"${dockerRepoUrl}
fi

if [ ${checkPass} -ne 0 ]; 
then
	echo "${dockerImageId} have some bug issue"
    docker stop $dockerImageId
	docker rm -f $dockerImageId
	exit 1
else
    echo "${dockerImageId} test is ok!"
    docker stop $dockerImageId
	docker rm -f $dockerImageId
fi

echo;echo;echo "===================== [STEP 1-4] push image to ECR =====================";echo;echo
docker tag xy1219.zhao/$dockerRepoUrl:latest 10.82.254.142:5000/$dockerRepoUrl:$dockerImageTag
docker push 10.82.254.142:5000/$dockerRepoUrl:$dockerImageTag

#$(aws --profile bixby-cndev ecr get-login --no-include-email --region cn-north-1)
awsloginCmd=`aws --profile ${env} ecr get-login --region cn-north-1 | sed -e 's/-e none//g'`
sh ${awsloginCmd}

docker tag xy1219.zhao/$dockerRepoUrl:latest 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$dockerRepoUrl:$dockerImageTag
docker push 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$dockerRepoUrl:$dockerImageTag || checkPass=1
if [ ${checkPass} -ne 0 ]; then
    exit 1
fi

docker tag xy1219.zhao/$dockerRepoUrl:latest 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$dockerRepoUrl:latest
docker push 077516810609.dkr.ecr.cn-north-1.amazonaws.com.cn/xy1219.zhao/$dockerRepoUrl:latest || checkPass=1
if [ ${checkPass} -ne 0 ]; then
    exit 1
fi

dockerImageTag_old=`aws --profile ${env} ecr list-images  --repository-name xy1219.zhao/$dockerRepoUrl|jq .imageIds[0].imageTag`

echo $dockerImageTag_old
#docker tag xy1219.zhao/baidu-token-dr:$dockerImageTag 081396032000.dkr.ecr.cn-northwest-1.amazonaws.com.cn/xy1219.zhao/baidu-token-dr:v$dockerImageTag
#docker push 081396032000.dkr.ecr.cn-northwest-1.amazonaws.com.cn/xy1219.zhao/baidu-token-dr:v$dockerImageTag

echo "============================xy1219.zhao/$dockerRepoUrl========================================"
curl -X GET http://10.82.254.142:5000/v2/$dockerRepoUrl/tags/list
