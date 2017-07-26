#!/bin/sh
git config --global user.name "Mike Sinn"
git config --global user.email m@quantimodo.com

SDK_PATH="qm-skds"
rm ${SDK_PATH}.zip
rm -Rf ${SDK_PATH}
mkdir ${SDK_PATH}

echo "Clone swagger-codegen..."
#git clone https://github.com/swagger-api/swagger-codegen

cd /vagrant
echo "Updating maven packages..."
./run-in-docker.sh mvn package

echo "Generate v1 SDKs"
for i in "javascript" "android" "go" "java" "objc" "php" "python" "ruby" "swift"
do
    echo "Generating $i SDK"
    ./run-in-docker.sh generate -i docs/swaggger/swagger.json -l ${i} -o ${SDK_PATH}/${i}
done

echo "Creating combined zip file"
zip -r ${SDK_PATH}.zip ${SDK_PATH} > /dev/null

if [ -f ${SDK_PATH}.zip ];
    then
       echo "SDK's are ready"
       exit 0
    else
       echo "SDK generation FAILED"
       exit 1
fi