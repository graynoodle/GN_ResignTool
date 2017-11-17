date "+%G-%m-%d %H:%M:%S"
echo "execute shell:"$1" see more in the Terminal"
cd `dirname $0`
rm gn_tmpShell.sh
echo "`dirname $0`/\"$1\" \"$2\" \"$3\" \"$4\" \"$5\" \"$6\" \"$7\" \"$8\"" > gn_tmpShell.sh
chmod 777 gn_tmpShell.sh
open -a Terminal gn_tmpShell.sh

