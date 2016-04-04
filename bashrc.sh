# Run bashrc files from subdirectories. 
cd `dirname ${BASH_SOURCE[0]}`
for FILE in $( ls -d */ | sed 's|/$||' | xargs find | grep "bashrc\.sh$" )
do
    echo $FILE
    source $FILE
done
