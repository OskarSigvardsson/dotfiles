# Run bashrc files from subdirectories. 
pushd `dirname ${BASH_SOURCE[0]}` > /dev/null
for FILE in $( ls -d */ | sed 's|/$||' | xargs find | grep "bashrc\.sh$" )
do
    source $FILE
done
popd > /dev/null
