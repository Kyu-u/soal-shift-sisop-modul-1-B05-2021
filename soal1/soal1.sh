#!/bin/bash


# REVISI

#1a

grep -o "[E|I].*" syslog.log 

#1b

grep -o "ERROR.*" syslog.log | cut -d "(" -f1 | rev | cut -d "R" -f1 | rev | sort | uniq -c





#simpan semua occurence error ke dalam variable
permission=$(grep "Permission denied while closing ticket" syslog.log | wc -l)
noticket=$(grep "Ticket doesn't exist" syslog.log | wc -l)
tried=$(grep "Tried to add information to closed ticket" syslog.log | wc -l)
timeout=$(grep "Timeout while retrieving information" syslog.log | wc -l)
connectionfailed=$(grep "Connection to DB failed" syslog.log | wc -l)
modified=$(grep "The ticket was modified while updating" syslog.log | wc -l)


#echo nama error beserta jumlah occurencenya ke dalam file error_message
echo -n  "Permission denied while closing ticket, " >> error_message.csv
echo   $permission >> error_message.csv
echo -n  "Ticket doesn't exist, " >> error_message.csv
echo  $noticket >> error_message.csv
echo -n "Tried to add information to closed ticket, " >> error_message.csv
echo  $tried >> error_message.csv
echo -n "Timeout while retrieving information, " >> error_message.csv
echo  $timeout >> error_message.csv
echo -n "Connection to DB failed, " >> error_message.csv
echo  $connectionfailed >> error_message.csv
echo -n "The ticket was modified while updating, " >> error_message.csv
echo  $modified >> error_message.csv
cat error_message.csv
#gunakan ',' sebagai delimiter dan pisahkan string menjadi 2 field berdasarkan delimiter tersebut
#order column ke 2 yang berisi angka secara numeric reverse
sort -t, -k 2 -nr -o error_message.csv error_message.csv

#tambahkan Error,Count di awal file
sed -i '1i Error,Count' error_message.csv


#ganti setiap spasi dengan new line sehingga setiap line berisi hanya satu kata
tr ' ' '\n' < syslog.log > temp.txt

#kemudian grep kata yang mengandung ( dan ) kemudian remove ( dan ) nya sehingga didapatkan tiap username yang sudah diorder secara alphabet
grep -o "(.*)" temp.txt| tr -d  "(" | tr -d ")" | sort | uniq >> temp2.txt

#kemudian loop through setiap line di dalam file temp2.txt 
#untuk setiap line yang berisi user kita melakukan grep kembali dengan pattern atau keyword ERROR/INFO 
#dan user, hitung dan simpan dalam variable
#setelah itu print user sekarang dan jumlah error dan infonya ke dalam file user_statistic
while read user
do
	error=$(grep "ERROR.*($user)" syslog.log | wc -l)
	info=$(grep "INFO.*($user)" syslog.log | wc -l)
	echo "$user, INFO:$info, ERROR:$error"
	printf "%s,%d,%d\n" $user $info $error >> user_statistic.csv
done < temp2.txt

#tambahkan username info dan error di line pertama file
sed -i '1i Username,INFO,ERROR' user_statistic.csv



