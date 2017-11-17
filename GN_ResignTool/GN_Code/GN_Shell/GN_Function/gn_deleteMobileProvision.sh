date "+%G-%m-%d %H:%M:%S"
#安装授权文件
uuid=$(grep -a -o "[a-zA-Z0-9]\{8\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{4\}-[a-zA-Z0-9]\{12\}" "$1")
echo "被删除授权文件UUID:"$uuid
#将改名后的授权文件拷贝至指定目录
rm "/Users/"$USER"/Library/MobileDevice/Provisioning Profiles/"${uuid}".mobileprovision"
