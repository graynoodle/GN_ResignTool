
date "+%G-%m-%d %H:%M:%S"
echo "授权文件目录:"$1

#安装授权文件
uuid=$(grep -a -o "[a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\}" "$1")
echo "授权文件UUID:"$uuid
#将改名后的授权文件拷贝至指定目录
cp "$1" "/Users/"$USER"/Library/MobileDevice/Provisioning Profiles/"${uuid}".mobileprovision"
security cms -D -i "$1"

