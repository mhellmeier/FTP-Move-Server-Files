#!/bin/sh

# ******************
# ***** SOURCE *****
# ******************

read -p "Do you want to use SSH (1) or FTP (2) for the connection to the source host? [1/2]: " sourceConnectionMode

# FTP connection
if [ "$sourceConnectionMode" = "2" ]
then
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
	read -p "[Source] Whole path to download: " sourceFtpDownloadPath

	echo 
	echo "Downloading files and folders ..."

	# recreate download directory
	rm -rf tmpDownload
	mkdir tmpDownload
	cd tmpDownload

	# download files
	cutDirsNumber=$(echo "$sourceFtpDownloadPath" | tr -cd "/" | wc -c)
	cutDirsNumber=$((cutDirsNumber + 1))
	wget -r -N -l inf -q --show-progress -np -nH --cut-dirs $cutDirsNumber --user=$sourceFtpUsername --password=$sourceFtpPassword ftp://$sourceFtpHostName/$sourceFtpDownloadPath

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
if [ "$destinationConnectionMode" = "2" ]
then
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
	read -p "[Source] Whole path to upload: " destinationFtpUploadPath

	localFilePath=$(pwd)

	echo 
	echo "Uploading files and folders ..."
	echo 
	
	ncftpput -R -v -u "$destinationFtpUsername" -p "$destinationFtpPassword" $destinationFtpHostName $destinationFtpUploadPath $localFilePath/*

	cd ..
	rm -rf tmpDownload

	echo 
    echo "Successful uploaded files and folders to destination host!"
else
    echo "SSH connection will be implemented soon ..."
	exit 0
fi

exit 0
