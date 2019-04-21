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
    sed -i "s/$oldport/8080/g" Dockerfile
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
ImageId=`docker run -d -p $newport:$newport xy1219.zhao/$reponame:latest`
echo $ImageId
cat <<EOF > pipeline-init.json
{
    "dockerImageTag" : "$version",
    "dockerRepoUrl" : "$reponame",
    "dockerImageId" : "$ImageId",
    "dockerport" : "$newport"
}
EOF
