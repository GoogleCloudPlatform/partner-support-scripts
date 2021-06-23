#!/bin/python3

import subprocess
acctlist = subprocess.run(['gcloud','alpha','billing','accounts','list'],stdout=subprocess.PIPE).stdout
account_list = acctlist.stdout.decode('utf-8')

#gcloud alpha billing accounts list
#gcloud alpha billing projects list
#  01762E-6EE9CE-714D5E (test sub account)
#  00E8D1-836E20-B87285 (enterprise X)
# 512  gcloud alpha billing accounts list | head 
#  513  gcloud alpha billing accounts list | grep bss
#  514  gcloud alpha billing accounts list | grep 00E573-78146C-E7FC89
#  515  gcloud alpha billing accounts list | grep 00E8D1-836E20-B87285
#  516  gcloud alpha billing accounts list | grep bss
#  517  gcloud alpha billing projects list 00E8D1-836E20-B87285
#  518  gcloud alpha billing projects list 01762E-6EE9CE-714D5E
#  519  gcloud alpha billing projects list 00E8D1-836E20-B87285 -w
#  520  gcloud alpha billing projects list 00E8D1-836E20-B87285 --filter svant
#  521  gcloud alpha billing projects list 00E8D1-836E20-B87285 --format=json
#  522  gcloud alpha billing projects list 00E8D1-836E20-B87285
#  523  gcloud alpha billing accounts list -filter=Customer
#  524  gcloud alpha billing accounts list
#  525  gcloud alpha billing accounts list | grep Customer
#  526  gcloud alpha billing projects list 01382E-07CCE9-615E10 -filter=bssnyder
#  527  gcloud alpha billing projects list 01382E-07CCE9-615E10 --filter=bssnyder