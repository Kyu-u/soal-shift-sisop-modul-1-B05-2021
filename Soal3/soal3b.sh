#!/bin/bash

# masuk ke directory
cd /home/yoursemicolon/Documents/sisop-2021/modul-1/soal-shift-modul-1-B05-2021/Soal3

# buat directory baru
newDir=$(date +"%d+%m+%Y")
mkdir "$newDir"

# jalankan soal 3a
bash "./home/yoursemicolon/Documents/sisop-2021/modul-1/soal-shift-modul-1-B05-2021/Soal3/soal3a.sh"

# pindahkan semua file ke directory baru
mv *.jpg "./$newDir"
mv Foto.log "./$newDir"

