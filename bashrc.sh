# Run bashrc files from subdirectories. 
for FILE in $( ls -d */ | sed 's|/$||' | xargs find | grep "bashrc\.sh$" )
do
    source $FILE
done
