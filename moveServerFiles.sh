#!/bin/bash

# ******************
# ***** SOURCE *****
# ******************

# Collect information and source credentials
read -p "Do you want to use SSH / SFTP (1) or FTP (2) for the connection to the source host? [1/2]: " sourceConnectionMode

read -p "[Source] Host name / URL / IP: " sourceHostName

read -p "[Source] Username: " sourceUsername

stty -echo
printf "[Source] Password: "
read sourcePassword
stty echo

echo
read -p "[Source] Path to download recursively ('/' for current directory): " sourceDownloadPath

read -p "Do you want to transfer the folder itself (1) or only the content of $sourceDownloadPath (2)? [1/2]: " sourceDownloadMode
echo 

if [[ $sourceDownloadPath != /* ]]; then 
	sourceDownloadPath="/"$sourceDownloadPath
fi
if [[ $sourceDownloadPath != */ ]]; then 
	sourceDownloadPath=$sourceDownloadPath"/"
fi

# Recreate download directory
rm -rf tmpDownload
mkdir tmpDownload
cd tmpDownload

echo "Trying to connect to source host ..."

# FTP connection
if [[ $sourceConnectionMode == "2" ]]; then

	ftp -n $sourceHostName <<END_SCRIPT
quote USER $sourceUsername
quote PASS $sourcePassword
ls
quit
END_SCRIPT

	echo "Downloading files and folders from $sourceDownloadPath ..."

	# Download files
	sourceCutDirsNumber=$(echo "$destinationUploadPath" | tr -cd "/" | wc -c)
	if [[ $sourceDownloadPath != "/" ]]; then 
		sourceCutDirsNumber=$((sourceCutDirsNumber + 1))
	fi

	if [[ $sourceDownloadMode == "2" ]]; then
		sourceCutDirsNumber=$((sourceCutDirsNumber + 1))
	fi

	wget -r -N -l inf -q --show-progress -np -nH --cut-dirs $sourceCutDirsNumber ftp://$sourceUsername:$sourcePassword@$sourceHostName$sourceDownloadPath

# SSH / SFTP connection
else
	if [[ $sourceDownloadMode == "2" ]]; then
		if [[ $sourceDownloadPath != *\* ]]; then 
			sourceDownloadPath=$sourceDownloadPath"*"
		fi
	fi

	echo "Downloading files and folders from $sourceDownloadPath ..."

	sshpass -p "$sourcePassword" scp -r -v -o "StrictHostKeyChecking=no" $sourceUsername@$sourceHostName:$sourceDownloadPath $PWD

fi

echo
echo "Successful downloaded files and folders from source host!"

# *****************
# ** DESTINATION **
# *****************

echo
read -p "Do you want to use SSH / SFTP (1) or FTP (2) for the connection to the destination host? [1/2]: " destinationConnectionMode

read -p "[Destination] Host name / URL / IP: " destinationHostName

read -p "[Destination] Username: " destinationUsername

stty -echo
printf "[Destination] Password: "
read destinationPassword
stty echo

echo
read -p "[Source] Path to upload ('/' for current directory): " destinationUploadPath
echo 

echo "Trying to connect to destination host ..."

if [[ $destinationUploadPath != /* ]]; then 
	destinationUploadPath="/"$destinationUploadPath
fi
if [[ $destinationUploadPath != */ ]]; then 
	destinationUploadPath=$destinationUploadPath"/"
fi

# FTP connection
if [[ $destinationConnectionMode == "2" ]]; then

	ftp -n $destinationHostName <<END_SCRIPT
quote USER $destinationUsername
quote PASS $destinationPassword
ls
quit
END_SCRIPT

	echo "Uploading files and folders to $destinationUploadPath ..."
	echo 
	
	lftp -e "set ftp:ssl-allow no; mirror -R $PWD/ $destinationUploadPath ; quit" -u $destinationUsername,$destinationPassword $destinationHostName
# SSH / SFTP connection
else
	echo "Uploading files and folders to $destinationUploadPath ..."

	sshpass -p "$destinationPassword" scp -r -v -o "StrictHostKeyChecking=no" $PWD/* $destinationUsername@$destinationHostName:$destinationUploadPath

	exit 0
fi

echo 
echo "Successful uploaded files and folders to destination host!"

echo "Deleting temporary download folder ..."

cd ..
rm -rf tmpDownload

echo "Done!"

exit 0
