#!/bin/bash

# masuk ke directory
cd /home/yoursemicolon/Documents/sisop-2021/modul-1/soal-shift-modul-1-B05-2021/Soal3

# untuk menghitung file yang sudah ada di directory
count=1

# download file baru
for ((i=1; i<=23; i=i+1))
do
	wget -O "Koleksi_$count.jpg" -a "Foto.log" https://loremflickr.com/320/240/kitten

	# cek apakah ada yang sama
	for ((j=1; j<count; j=j+1))
	do
		check=$(cmp --silent "./Koleksi_$j.jpg" "./Koleksi_$count.jpg")
		status=$?
		if [ $status -eq 0 ]
		then
			# menghapus file yang sama
			rm "./Koleksi_$count.jpg"
			(( count-- ))
			break
		fi
	done
	(( count++ ))
done

# rename file untuk Koleksi_01..Koleksi_09
for i in {1..9}
do
	if [ -e "./Koleksi_$i.jpg" ]
	then
		mv "Koleksi_$i.jpg" "Koleksi_0$i.jpg"
	fi
done

