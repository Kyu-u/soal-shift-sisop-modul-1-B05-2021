#!/bin/bash

# masuk ke directory
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3

# setting password
settingPassword=$(date +"%m%d%Y")

# zip file
zip -q -r -P "$settingPassword" -m Koleksi.zip Kucing_* Kelinci_*
