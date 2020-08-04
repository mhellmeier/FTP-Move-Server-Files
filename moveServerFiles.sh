#!/bin/bash

# ******************
# ***** SOURCE *****
# ******************

read -p "Do you want to use SSH (1) or FTP (2) for the connection to the source host? [1/2]: " sourceConnectionMode

# FTP connection
if [[ $sourceConnectionMode == "2" ]]; then
	read -p "[Source] Host name / URL / IP: " sourceFtpHostName

	read -p "[Source] Username: " sourceFtpUsername

	stty -echo
	printf "[Source] Password: "
	read sourceFtpPassword
	stty echo
	printf "\n"

    echo "Trying to connect to source host and display files ..."

ftp -n $sourceFtpHostName <<END_SCRIPT
quote USER $sourceFtpUsername
quote PASS $sourceFtpPassword
ls
quit
END_SCRIPT

	echo
	read -p "[Source] Path to download recursively ('/' for current directory): " sourceFtpDownloadPath
	echo 
	if [[ $sourceFtpDownloadPath != /* ]]; then 
		sourceFtpDownloadPath="/"$sourceFtpDownloadPath
	fi
	if [[ $sourceFtpDownloadPath != */ ]]; then 
		sourceFtpDownloadPath=$sourceFtpDownloadPath"/"
	fi

	echo "Downloading files and folders ..."

	# recreate download directory
	rm -rf tmpDownload
	mkdir tmpDownload
	cd tmpDownload

	# download files
	sourceCutDirsNumber=$(echo "$destinationFtpUploadPath" | tr -cd "/" | wc -c)
	if [[ $sourceFtpDownloadPath != "/" ]]; then 
		sourceCutDirsNumber=$((sourceCutDirsNumber + 1))
	fi
	wget -r -N -l inf -q --show-progress -np -nH --cut-dirs $sourceCutDirsNumber ftp://$sourceFtpUsername:$sourceFtpPassword@$sourceFtpHostName$sourceFtpDownloadPath

	echo
    echo "Successful downloaded files and folders from source host!"
else
    echo "SSH connection will be implemented soon ..."
    exit 0
fi

# *****************
# ** DESTINATION **
# *****************

echo
read -p "Do you want to use SSH (1) or FTP (2) for the connection to the destination host? [1/2]: " destinationConnectionMode

# FTP connection
if [[ $destinationConnectionMode == "2" ]]; then
	read -p "[Destination] Host name / URL / IP: " destinationFtpHostName

	read -p "[Destination] Username: " destinationFtpUsername

	stty -echo
	printf "[Destination] Password: "
	read destinationFtpPassword
	stty echo
	printf "\n"

    echo "Trying to connect to destination host and display files ..."

	ftp -n $destinationFtpHostName <<END_SCRIPT
quote USER $destinationFtpUsername
quote PASS $destinationFtpPassword
ls
quit
END_SCRIPT

	echo
	read -p "[Source] Path to upload ('/' for current directory): " destinationFtpUploadPath
	echo 
	
	if [[ $destinationFtpUploadPath != /* ]]; then 
		destinationFtpUploadPath="/"$destinationFtpUploadPath
	fi
	if [[ $destinationFtpUploadPath != */ ]]; then 
		destinationFtpUploadPath=$destinationFtpUploadPath"/"
	fi

	localFilePath=$(pwd)

	echo "Uploading files and folders ..."
	echo 
	
	lftp -e "set ftp:ssl-allow no; mirror -R $localFilePath/ $destinationFtpUploadPath ; quit" -u $destinationFtpUsername,$destinationFtpPassword $destinationFtpHostName

	cd ..
	rm -rf tmpDownload

	echo 
    echo "Successful uploaded files and folders to destination host!"
else
    echo "SSH connection will be implemented soon ..."
	exit 0
fi

exit 0
