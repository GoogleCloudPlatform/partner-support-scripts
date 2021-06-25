#!/bin/sh

# Copyright 2021 Google LLC

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    https://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

# Written By: Brian Snyder (bssnyder@) version 1 6/17/21 - First Stab
#                                      version 2 6/22/21 - "join" queries to get project number
#                                      version 3 6/23/21 - Show Parent Billing information
#                                      version 4 6/25/21 - Updates and script arguments

# NOTE: All these commands run under the permissions of the identity that runs it.
#       Proper permissions to see billing and project information are required.

printempty=0
printpermerr=0

while getopts ":hep" opt ; do
    case $opt in
        h)
        echo "./list-projects -h <help> -e <show empty billing accounts> -p <show permission errors>"
        exit 1
        ;;
        e)
        echo "Printing empty billing accounts"
        printempty=1
        ;;
        p)
        echo "Printing permission errors"
        printpermerr=1
        ;;
        *)
        echo "./list-projects -h <help> -e <show empty billing accounts> -p <show permission errors>"
        exit 1
        ;;
    esac
done

# Cache full project list that running user can see
gcloud projects list > /tmp/project-list.txt

#Title line
echo "BILLING ACCOUNT ID   PROJECT ID                                 PROJECT NAME                    PROJECT #      PARENT ID"

#      get billing account list user can see | kill hdr line | cut everything but billing IDs
gcloud alpha billing accounts list --format="value(name,masterBillingAccount)" --sort-by masterBillingAccount | while read billid mastid
do 
   projlist=`gcloud alpha billing projects list --billing-account=$billid --format="value(projectId)"`

   if [ "$printempty" -eq 1 ]; then
    if [ -z "$projlist" ]; then 
        echo "$billid NO PROJECTS ASSIGNED                                                                        $mastid"
    fi
   fi

   for projid in $projlist
   do
      output=`grep -w $projid /tmp/project-list.txt`
      if [ $? -ne 0 ]; then #error
        if [ "$printpermerr" -eq 1 ]; then
            echo "$billid $projid PERMISSION ERROR - NO DETAILS AVAILABLE                                         $mastid" 
        fi
      else #success
        echo "$billid $output $mastid"
      fi
    done
done