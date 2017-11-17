date "+%G-%m-%d %H:%M:%S"
echo "p12目录:"$1
echo "p12密码:"$2
importResult=$(openssl pkcs12 -in "$1" -nodes -passin pass:"$2" | openssl x509 -noout -subject)
echo $importResult
#判断证书是否正确
if [[ "$importResult" != "" ]];then
#openssl pkcs12 -in "$1" -nodes -passin pass:"$2" | openssl x509 -noout -enddate
expDate=$(openssl pkcs12 -in "$1" -nodes -passin pass:"$2" | openssl x509 -noout -enddate)
expDate=${expDate#*notAfter=}
expDate=${expDate%GMT*}
echo "证书有效期:"$expDate
export LANG=en_US.UTF-8
#有个坑爹的空格
expirationDate=$(date -j -f '%b %d %T %Y ' "$expDate" +%s)
currentDate=$(date +%s)
#echo "~~~~~~~~~"$currentDate
#echo "~~~~~~~~~"$expirationDate
if [ $expirationDate -gt $currentDate ];then
security import "$1" -k "/Users/"$USER"/Library/Keychains/login.keychain" -P "$2" -T /usr/bin/codesign
else
echo "当前证书过期，删除过期文件！"
cerSHA1=$(openssl pkcs12 -in "$1" -nodes -passin pass:"$2" | openssl x509 -noout -fingerprint)
cerSHA1=${cerSHA1#*Fingerprint=}
cerSHA1=$(echo "$cerSHA1" | sed "s/://g")
echo "被删除证书的SHA1="$cerSHA1
#security delete-certificate -c NAME
security delete-certificate -Z $cerSHA1
fi

else
echo "证书导入失败！"
fi

#echo "time"$x
#p12证书
#echo "p12证书目录:"$3
##p12证书的密码 没密码填""
#echo "p12证书的密码:"$4
##entitlements文件
#echo "entitlements目录:"$5
##info.plist
#echo "info.plist目录:"$6

##签名目录
#ipaPath=${basePath}"/ipaResign"
#rm -rf ${ipaPath}
#mkdir ${ipaPath}
##拷贝ipa
#zipPath=${ipaPath}"/unsignPackage.zip"
#cp $1 ${zipPath}
##解压缩zip
#cd ${ipaPath}
#unzip ${zipPath}
##替换embedded.mobileprovision
#cd ${ipaPath}"/Payload"
#appPath=`find ${ipaPath}'/Payload' -name '*.app'`
#cp $2 ${appPath}"/embedded.mobileprovision"
#echo ${appPath}"/embedded.mobileprovision"
##获取DeveloperName
#cer=${ipaPath}"/package.p12"
#cp $3 ${cer}
#echo ${cer}
##p12密码
#pwd=$4
#
#security import $3 -k "/Users/"$pcName"/Library/Keychains/login.keychain" -P $pwd -T /usr/bin/codesign
#tmpStr=$(openssl pkcs12 -in ${cer} -nodes -passin pass:$pwd | openssl x509 -noout -subject)
#leftRightStr=${tmpStr#*iPhone}
#developerName="iPhone${leftRightStr%%/*}"
#echo $developerName
##重签名
#entitlePlist=${ipaPath}"/entitlements.plist"
#cp $5 ${entitlePlist}
##替换info.plist
#info=$6
#if [ "$info" != "" ]
#then
##企业签名
#cp $info ${appPath}"/info.plist"
#cp $basePath"/ResourceRules.plist" ${appPath}"/ResourceRules.plist"
#echo ${appPath}"/info.plist"
#codesign -f -s "$developerName" --resource-rules ${appPath}"/ResourceRules.plist" --entitlements $entitlePlist $appPath"/"
#else
#codesign -f -s "$developerName" --entitlements $entitlePlist $appPath
#fi
#
##压缩ipa
#cd $ipaPath
## Payload/ 打包这个目录很重要
#zip -r $ipaPath"/resigned.ipa" Payload/
#rm -rf $ipaPath"/unsignPackage.zip"
##echo $entitlePlist
#
#open -R $ipaPath"/resigned.ipa"



