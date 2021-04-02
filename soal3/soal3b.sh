#!/bin/bash

# masuk ke directory
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3

# buat directory baru
newDir=$(date +"%d-%m-%Y")
mkdir "$newDir"

# jalankan soal 3a
bash soal3a.sh

# pindahkan semua file ke directory baru
mv *.jpg "./$newDir"
mv Foto.log "./$newDir"

