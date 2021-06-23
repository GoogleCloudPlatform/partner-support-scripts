#!/bin/sh

# Written By: Brian Snyder (bssnyder@) version 1 6/17/21 - First Stab
#                                      version 2 6/22/21 - "join" queries to get project number
#                                      version 3 6/23/21 - Show master information

# NOTE: All these commands run under the permissions of the identity that runs it.
#       Proper permissions to see billing and project information are required.

# Cache full project list that running user can see
gcloud projects list > /tmp/project-list.txt


#Title
echo "BILLING ACCOUNT ID   PROJECT ID                                 PROJECT NAME                    PROJECT #      MASTER ID"

#      get billing account list user can see | kill hdr line | cut everything but billing IDs
gcloud alpha billing accounts list --format="value(name,masterBillingAccount)" | while read billid mastid
do 
   projlist=`gcloud alpha billing projects list --billing-account=$billid --format="value(projectId)"`

   #Uncomment this block if you want to see empty billing accounts
   #if [ -z "$projlist" ]; then #empty
    #echo "Billing ID is $billid has no projects"
   #fi

   for projid in $projlist
   do
      output=`grep -w $projid /tmp/project-list.txt`
      if [ $? -ne 0 ]; then #error
        #echo "$billid $projid not found - you dont have permissions to see info" 
        : #uncomment above line if you want see permission issues
      else #success
        echo "$billid $output $mastid"
      fi
    done
done