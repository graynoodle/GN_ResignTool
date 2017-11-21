
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
ipaPath=${basePath}"/viewInfoPlist"
infoplist="Payload/*.app/Info.plist"

if [ ! -d "$ipaPath" ]; then
mkdir ${ipaPath}
fi
#拷贝ipa
zipPath=${ipaPath}"/unsignPackage.zip"
#echo "zipPath目录:"$zipPath

cp "$1" ${zipPath}
#解压缩zip
cd $ipaPath
#unzip ${zipPath}
#解压指定文件

unzip $zipPath "$infoplist" -d tmp

tInfoplist="tmp/"$infoplist
#替换bundleId
plutil -replace CFBundleIdentifier -string "$6" $tInfoplist
#替换teamId
plutil -replace application-identifier -string "$7"".""$6" "$5"
#替换com.apple.developer.team-identifier
#plutil -replace "team-identifier" -string "$7" "$5"
#sed -i "" 's/'team-identifier'/'com.apple.developer.team-identifier'/g' "$5"
#替换keychain-access-groups
plutil -remove "keychain-access-groups".0 "$5"
plutil -replace "keychain-access-groups".0 -string "$7"".""$6" "$5"
#替换com.apple.developer.team-identifier
#修改debug模式 输出日志
plutil -replace Ourpalm_Debugmodel -bool "Yes" $tInfoplist
#plutil -replace com.apple.developer.team-identifier -string "$7" "$5"
mv $tInfoplist $ipaPath"/Info.plist"
infoplist=$ipaPath"/Info.plist"
open -R "$infoplist"
open "$infoplist"

rm -rf $ipaPath"/unsignPackage.zip"
rm -rf $ipaPath"/tmp"

#fi



