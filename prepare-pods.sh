
generate(){
	REPLACE_UUID=$(uuidgen)
	REPLACE_UUID="${REPLACE_UUID//-/_}"
	printf "%s\n" "#import <Foundation/Foundation.h>" "@interface Dummy_$REPLACE_UUID : NSObject" "@end" "@implementation Dummy_$REPLACE_UUID" "@end"
}  

PWC_PODS_DIR="./mpos-ui/Pods"
PWC_PODS_POSTFIX="*dummy.m"
PWC_PODS_REPLACE_IF_FOUND="PodsDummy"

echo ""
echo ""
echo "### Replacing object names for all Pods ###"
echo ""

find $PWC_PODS_DIR -type f -name $PWC_PODS_POSTFIX -print0 | xargs -0 grep -l $PWC_PODS_REPLACE_IF_FOUND | while read line; do
    echo "replacing unmodified dummy file: $line"
    REPLACE_WITH=$(generate)
    echo "$(generate)" > "$line"
    #echo "replaced contents with"
    #echo "$REPLACE_WITH"
done

echo ""
echo "done!"
