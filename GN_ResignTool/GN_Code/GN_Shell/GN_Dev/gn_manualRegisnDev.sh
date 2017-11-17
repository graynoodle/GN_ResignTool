
date "+%G-%m-%d %H:%M:%S"
basePath=$(dirname $0)
#ipa目录        $1
#echo "ipa目录"$1
#授权文件目录    $2
#p12证书目录    $3
#p12证书的密码   $4
#entitlements   $5
#bundleId        $6
#application-identifier     $7
#输出文件名
outputFile="/Users/"$USER"/Desktop/DEV_"$6".ipa"
rm -rf $outputFile
#签名目录
ipaPath=${basePath}"/viewInfoPlist"
if [ ! -d "$ipaPath" ]; then
mkdir ${ipaPath}
fi
appPath=`find ${ipaPath}'/Payload' -name '*.app'`
infoplist=$appPath"/Info.plist"
# 这里的-f参数判断$myFile是否存在
if [ -f "$infoplist" ]; then
echo "ipa has been unzipped"
else
#拷贝ipa
zipPath=${ipaPath}"/unsignPackage.zip"
echo "zipPath目录:"$zipPath
cp "$1" ${zipPath}
cd $ipaPath
#解压缩zip
unzip ${zipPath}

appPath=`find ${ipaPath}'/Payload' -name '*.app'`
infoplist=$appPath"/Info.plist"

fi
#拷贝查看过的info.plist
tInfoplist=$ipaPath"/Info.plist"
cp "$tInfoplist" $infoplist

#获取DeveloperName
tmpStr=$(openssl pkcs12 -in "$3" -nodes -passin pass:"$4" | openssl x509 -noout -subject)
leftRightStr=${tmpStr#*iPhone}
developerName="iPhone${leftRightStr%%/*}"
echo $developerName

#替换embedded.mobileprovision
cd ${ipaPath}"/Payload"
appPath=`find ${ipaPath}'/Payload' -name '*.app'`
cp "$2" ${appPath}"/embedded.mobileprovision"
echo ${appPath}"/embedded.mobileprovision"

#dev签名
codesign -f -s "$developerName" --entitlements "$5" $appPath

#压缩ipa
cd $ipaPath
# Payload/ 打包这个目录很重要
zip -q -r $outputFile Payload/
#echo $entitlePlist
open -R $outputFile

rm -rf $ipaPath"/unsignPackage.zip"


