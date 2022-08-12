#!/usr/bin/env bash

## Script to automate MatterMost Upgrades to some extend

## Vars
WorkDir="/tmp"
InstallPath="/opt"
AppDataLimit=2
DBLimit=2

# Goto WorkDir
cd ${WorkDir}

# Provide a URL for new MM version
echo "Provide a URL for the new MM version:"
read URL

# Downdload to WorkDir
echo "Downloading update file from ${URL}"
wget ${URL} -O ${WorkDir}/mattermost-latest.tar.gz

# Extract + Transform
echo "Extracting + transforming upgrade"
tar -xf mattermost*.gz --transform='s,^[^/]\+,\0-upgrade,'

# Stop Service
echo "stopping services"
systemctl stop mattermost

# Backups
echo "Doing Backups"
## DB 
echo "DB backups"
runuser -l postgres -c "pg_dump -F t mattermost > mmbackup_$(date +%Y-%m-%d).tar"
## App Data
echo "App Backups"
cd ${InstallPath}
tar czf mm_backup_$(date +%Y-%m-%d).tgz mattermost                                                                                                     
                                                                                                                                                       
## Check if pruning is needed                                                                                                                          
echo "Checking if backup pruning is needed"                                                                                                            
appBackupCount=$(ls /opt/mm_backup*|wc -l)                                                                                                             
dbBackupCout=$(ls -1 ~postgres/mmbackup*.tar|wc -l)                                                                                                    
if [  ${appBackupCount} -gt ${AppDataLimit} ]; then                                                                                                    
        echo "You have ${appBackupCount} backups of the MatterMost app data, would you like to prune this to ${AppDataLimit} [y|N]"                    
        read ans                                                                                                                                       
        if [ ${ans} == "y" || ${ans} -= "Y" ]; then                                                                                                    
                ## prune Stub                                                                                                                          
        fi                                                                                                                                             
fi                                                                                                                                                     
if [  ${dbBackupCout} -gt ${DBLimit} ]; then                                                                                                           
        echo "You have ${dbBackupCout} backups of the MatterMost app data, would you like to prune this to ${DBLimit} [y|N]"                           
        read ans                                                                                                                                       
        if [ ${ans} == "y" || ${ans} -= "Y" ]; then                                                                                                    
                toRemove=$(echo ${dbBackupCout} - ${DBLimit}|bc)                                                                                       
                rm `ls -1tr ~postgres/mmbackup*.tar|head -${toRemove}`                                                                                 
                ## prune Stub                                                                                                                          
        fi                                                                                                                                             
fi                                                                                                                                                     
                                                                                                                                                       
## Prepare the InstallPath dir                                                                                                                         
echo "Preparing the Install dir: ${InstallPath}"                                                                                                       
cd ${InstallPath}                                                                                                                                      
find mattermost/ mattermost/client/ -mindepth 1 -maxdepth 1 \! \( -type d \( -path mattermost/client -o -path mattermost/client/plugins -o -path mattermost/config -o -path mattermost/logs -o -path mattermost/plugins -o -path mattermost/data \) -prune \) | sort | sudo xargs rm -r                       
                                                                                                                                                       
## Copy in the upgrade                                                                                                                                 
echo "Copying Upgrade files"                                                                                                                           
cp -an ${WorkDir}/mattermost-upgrade/. ${InstallPath}/mattermost                                                                                       
                                                                                                                                                       
## Set Ownership                                                                                                                                       
echo "Setting Ownership"                                                                                                                               
chown -R mattermost:mattermost ${InstallPath}/mattermost                                                                                               
                                                                                                                                                       
## Start Service                                                                                                                                       
echo "starting services"                                                                                                                               
systemctl start mattermost                                                                                                                             
                                                                                                                                                       
## Cleanup temp files                                                                                                                                  
echo "Cleanup"                                                                                                                                         
rm -r ${WorkDir}/mattermost-upgrade                                                                                                                    
rm -i ${WorkDir}/mattermost*.gz    
