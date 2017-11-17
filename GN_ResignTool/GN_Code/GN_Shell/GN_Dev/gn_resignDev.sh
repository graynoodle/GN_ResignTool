date "+%G-%m-%d %H:%M:%S"
basePath=$(dirname $0)
#ipa目录        $1
#echo "ipa目录"$1
#授权文件目录    $2
#p12证书目录    $3
#p12证书的密码   $4
#entitlements   $5

#bundleId        $6
#teaimId     $7
#输出文件名
outputFile="/Users/"$USER"/Desktop/DEV_"$6".ipa"
rm -rf $outputFile
#签名目录
ipaPath=${basePath}"/ipaResign"
rm -rf ${ipaPath}
mkdir ${ipaPath}
#拷贝ipa
zipPath=${ipaPath}"/unsignPackage.zip"
echo "zipPath:"$zipPath

cp "$1" ${zipPath}
#解压缩zip
cd ${ipaPath}
unzip ${zipPath}
#替换embedded.mobileprovision
cd ${ipaPath}"/Payload"
appPath=`find ${ipaPath}'/Payload' -name '*.app'`
cp "$2" ${appPath}"/embedded.mobileprovision"
echo ${appPath}"/embedded.mobileprovision"
#获取DeveloperName
tmpStr=$(openssl pkcs12 -in "$3" -nodes -passin pass:"$4" | openssl x509 -noout -subject)
leftRightStr=${tmpStr#*iPhone}
developerName="iPhone${leftRightStr%%/*}"
echo $developerName

#替换bundleId
plutil -replace CFBundleIdentifier -string "$6" ${appPath}"/Info.plist"
#替换teamId
plutil -replace application-identifier -string "$7"".""$6" "$5"
#替换com.apple.developer.team-identifier
#修改debug模式 输出日志
plutil -replace Ourpalm_Debugmodel -bool "Yes" ${appPath}"/Info.plist"
#plutil -replace com.apple.developer.team-identifier -string "$7" "$5"
#dev签名
codesign -f -s "$developerName" --entitlements "$5" $appPath

#压缩ipa
cd $ipaPath
# Payload/ 打包这个目录很重要
zip -q -r $outputFile Payload/
rm -rf $ipaPath"/unsignPackage.zip"
#echo $entitlePlist
open -R $outputFile



