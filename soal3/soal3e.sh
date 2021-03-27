#!/bin/bash

# masuk ke directory
cd /home/yoursemicolon/Documents/sisop-2021/modul-1/soal-shift-modul-1-B05-2021/Soal3

# setting password
setPassword=$(date +"%d%m%Y")

# unzip file
unzip -P "$setPassword" Koleksi.zip

# hapus file zip
rm "./Koleksi.zip"
