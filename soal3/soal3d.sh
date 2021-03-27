#!/bin/bash

# masuk ke directory
cd /home/yoursemicolon/Documents/sisop-2021/modul-1/soal-shift-modul-1-B05-2021/Soal3

# setting password
setPassword=$(date +"%d%m%Y")

# zip file
zip -P "$setPassword" Koleksi.zip Kucing_* Kelinci_*
