#!/bin/bash

# masuk ke directory
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3

# setting password
setPassword=$(date +"%m%d%Y")

# unzip file
unzip -q -P "$setPassword" Koleksi.zip

# hapus file zip
rm "./Koleksi.zip"
