#!/bin/bash
listOfChangedFiles=()

while (1); # Scope Loop
do
  echo "\n"
  select network in "private" "protected" "public" "exit";
  do
    if [ $network == "exit" ]; then
      break
    fi
    # else ask the stack
    echo "\n"
    
    while (1); # Stack Loop
    do
			read -p "Enter the stack name or empty to exit: " stack
			if [ ${stack:-"n"} == "n" ]; then
				break
			fi
			mkdir -p $SECRETS_DIR/$network/$stack/
			echo "\n"
			listOfChangedFiles+="\$SECRETS_DIR/$network/$stack.env\n"
			while (1); # File Loop
			do
				read -p "Enter the ENV key/name or empty to exit: " name
				read -sp "Enter the ENV value for $name: " value
				if [ ${name:-"n"} == "n" ]; then
					break;
				fi
				echo "\n$name = \"$value\"" >> $SECRETS_DIR/$network/$stack.env
			done 
    done
  done
done

# ensuring all created secrets are only visible to root
echo "refreshing permissions"
sudo chown root:root $SECRETS_DIR
sudo chmod 600 $SECRETS_DIR
history -c

# END and output
echo "All Done!!! - Here is a list of env files added\n\n"
echo ${listOfChangedFiles[@]}