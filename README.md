# Laporan Resmi Soal Shift 1
Dikerjakan oleh Kelompok B05
* Amanda Rozi Kurnia 05111940000094
* Melanchthon Bonifacio Butarbutar 05111940000097
* Nadia Tiara Febriana 05111940000217

[Soal Shift 1](https://docs.google.com/document/d/1T3Y4o2lt5JvLTHdgzA5vRBQ0QYempbC5z-jcDAjela0/edit)

## Table of Contents
1. [Soal 1](#soal1)
2. [Soal 2](#soal2)
3. [Soal 3](#soal3)
   * [Soal 3a](#soal3a)
   * [Soal 3b](#soal3b)
   * [Soal 3c](#soal3c)
   * [Soal 3d](#soal3d)
   * [Soal 3e](#soal3e)

<a name="soal1"></a>
## Soal 1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky. <br>

**Soal 1a** <br>
Kumpulkan informasi dari file ```syslog.log```. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. <br>

**Source Code dan Penjelasan** <br>
```
grep -o "[E|I].*" syslog.log
```

Penyelesaian soal ini menggunakan regex ```"[E|I].*"``` yang bermaksud untuk memfilter line yang mengandung ```E``` atau ```I``` dan ```.*``` berarti hingga akhir.<br>
Dengan menggunakan ```grep -o``` hanya bagian line yang mengandung pattern akan ditampilkan.<br>

**Soal 1b** <br>
Tampilkan semua pesan error yang muncul beserta jumlah kemunculannya. <br>

**Source Code dan Penjelasan** <br>
```
grep -o "ERROR.*" syslog.log | cut -d "(" -f1 | rev | cut -d "R" -f1 | rev | sort | uniq -c
```

Sama seperti soal 1a, di sini menggunakan ```grep -o "ERROR.*"``` untuk memfilter line yang mengandung ```ERROR``` di depan. <br>
Kemudian menggunakan ```cut``` dengan delimiter ```-d "("``` untuk memisahkan line menjadi 2 field dan dengan adanya ```-f1```, ```cut``` akan memotong field pertama, yaitu field yang berisi ```<username>```. <br>
Untuk menghapus kata ```ERROR```, pertama digunakan ```rev``` untuk mereverse line sehingga ketika menggunakan ```cut -d "R" -f1``` kata tersebut berada di field 1. Kemudian direverse ke keadaan semula. <br>
Kemudian disort dan kemunculan unik dihitung dengan ```uniq -c```. <br>

**Soal 1c dan 1e** <br>
Tampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.<br>

Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak. <br>

**Source Code dan Penjelasan**
```
tr ' ' '\n' < syslog.log > temp.txt

grep -o "(.*)" temp.txt| tr -d  "(" | tr -d ")" | sort | uniq >> temp2.txt

while read user
do
	error=$(grep "ERROR.*($user)" syslog.log | wc -l)
	info=$(grep "INFO.*($user)" syslog.log | wc -l)
	echo "$user, INFO:$info, ERROR:$error"
	printf "%s,%d,%d\n" $user $info $error >> user_statistic.csv
done < temp2.txt

sed -i '1i Username,INFO,ERROR' user_statistic.csv
```
Pertama gunakan ```tr ' ' '\n' < syslog.log > temp.txt``` untuk mereplace semua spasi dalam file ```syslog.log``` dengan new line ```\n``` dengan output ke dalam file temp.txt. <br>
Kemudian dalam file baru mencari semua username dengan memfilter dengan ```grep -o "(.*)"```. <br>
```tr -d  "(" | tr -d ")"``` akan menghapus ```(``` dan ```)``` dari file sehingga hanya tersisa username dalam file. <br>
Setelah itu sort secara alphabet dengan ```sort | uniq```. Ini juga akan menghilangkan semua duplikat nama. <br>

```
while read user
do
	error=$(grep "ERROR.*($user)" syslog.log | wc -l)
	info=$(grep "INFO.*($user)" syslog.log | wc -l)
	echo "$user, INFO:$info, ERROR:$error"
	printf "%s,%d,%d\n" $user $info $error >> user_statistic.csv
done < temp2.txt
```
Bagian code ini akan melakukan iterasi melalui file ```temp2.txt``` yang berisi username dan untuk setiap user (line) akan menyimpan banyak kemunculan ke dalam variable. <br>
```
error=$(grep "ERROR.*($user)" syslog.log | wc -l)
info=$(grep "INFO.*($user)" syslog.log | wc -l)
```
Kemudian untuk setiap user akan ditampilkan kemunculan error dan info, serta dimasukkan ke dalam file ```user_statistic.csv```. <br>
```
echo "$user, INFO:$info, ERROR:$error"
printf "%s,%d,%d\n" $user $info $error >> user_statistic.csv
```
Terakhir, sesuai dengan format, tambahkan ```User,Info,Error``` ke line pertama ```user_statistic.csv```. <br>
```
sed -i '1i Username,INFO,ERROR' user_statistic.csv
```
**Soal 1d** <br>
Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak. <br>

**Source Code dan Penjelasan** <br>
```
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
```

Untuk setiap jenis pesan error simpan ke dalam variabel untuk menghitung banyaknya muncul. <br>
```
permission=$(grep "Permission denied while closing ticket" syslog.log | wc -l)
noticket=$(grep "Ticket doesn't exist" syslog.log | wc -l)
tried=$(grep "Tried to add information to closed ticket" syslog.log | wc -l)
timeout=$(grep "Timeout while retrieving information" syslog.log | wc -l)
connectionfailed=$(grep "Connection to DB failed" syslog.log | wc -l)
modified=$(grep "The ticket was modified while updating" syslog.log | wc -l)
```
Kemudian echo semua variabel ke dalam file ```error_message.csv```. <br>
```-n``` akan melakukan echo tanpa new line.
Setelah itu, untuk melakukan mengurutkan angka dari besar ke kecil digunakan ```sort```. <br>
```-t,``` akan memisahkan line berdasarkan delimiter ```,``` dan akan diurutkan berdasarkan ```k 2``` yaitu kolom ke-2 setelah dipisahkan <br> dan ```-nr``` untuk mengurutkan dari besar ke kecil. <br>
Yang terakhir, gunakan ```sed -i '1i Error,Count' error_message.csv``` untuk menambahkan ```Error,Count``` ke line pertama file. <br>







<a name="soal2"></a>
## Soal 2
Steven dan Manis mendirikan sebuah startup bernama **“TokoShiSop”**. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan ```“Laporan-TokoShiSop.tsv”.```

Karena kamu diminta untuk mencari beberapa kesimpulan yang ada pada soal nomor 2 dari data penjualan yang berformat file tsv (tab-separated values/file nilai yang dipisahkan oleh tab) bernama ```Laporan-TokoShisop.tsv``` . Kemudian, terdapat 4 perintah soal yang terbagi menjadi 2a, 2b, 2c, dan 2d di dalam script ```soal2_generate_laporan_ihir_shisop.sh``` . Lalu, hasil yang akan dtampilakan pada ```hasil.txt``` . <br>

**Nomor 2a** <br>
Pada nomor 2a, Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui **Row ID** dan **profit percentage** terbesar (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari *profit percentage*, yaitu: <br>
```Profit Persentage = (Profit/Cost Price)x100```

**Source Code dan Penjelasan** <br>
```
export LC_ALL=C
awk '
BEGIN {FS="\t"; KeuntunganMaks=0} 
{ 
    #rumus profit percentage
    PersentaseKeuntungan=($21/($18-$21))*100 
    {
        ID_Baris=$1

        if (KeuntunganMaks<=PersentaseKeuntungan)
        {
            IDmaks=ID_Baris 
            KeuntunganMaks=PersentaseKeuntungan
        }
    }
}
END{
    printf("Transaksi terakhir dengan profit percentage terbesar yaitu %s dengan persentase %d\n")
    #print "Transaksi terakhir dengan profit percentage terbesar yaitu ", IDmaks, " dengan persentase ", KeuntunganMaks, "%\n"
}
' /Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv > hasil.txt
```

Penyelesaian soal nomor 2 ini menggunakan 

```awk ‘ ‘```

Fungsi dasar **awk** adalah untuk mencari pola pada file per baris (atau unit teks lain) yang berisi pola tertentu. Ketika suatu baris sesuai dengan pola, awk melakukan aksi yang khusus pada baris tersebut Sehingga awk di import pada awal **shell script**. Karena file ```Laporan-TokoShisop.tsv``` berformaat **tsv(tab-separated value)** atau File nilai yang dipisahkan tab agar bisa membaca data antar kolom, maka digunakanlah 

```BEGIN {FS=”\t”}```

Kemudian, 

```export LC_ALL=C```

berfungsi untuk membaca titik (.) menjadi desimal pada file ```Laporan-TokoShisop.tsv ```. 

```KeuntunganMaks=0```

KeuntunganMaks dipakai sebagai perbandingan untuk membandingkan persentase keuntungan maksimum setiap baris data yang ada di file ```Laporan-TokoShisop.tsv``` .

Kemudian hal yang dilakukan yaitu menghitung profit percentage menggunakan rumus yang tersedia pada soal shift modul 1 yaitu

```Profit Persentage = (Profit/Cost Price)x100```

dimana costprice itu adalah ```(sales-profit)```. Kolom profit berada di kolom 21 atau``` $21``` , sedangkan kolom sales berada di kolom 18 atau ``` $18```. 

``` ID_Baris=$1```

Variabel diatas, berfungsi untuk menyimpan argumen pertama yaitu kolom 1 atau row ID yang berada pada file Laporan-TokoShisop.tsv .

```
if (KeuntunganMaks<=PersentaseKeuntungan)
        {
            IDmaks=ID_Baris 
            KeuntunganMaks=PersentaseKeuntungan
        }
```

Pada proses diatas setiap barisnya akan dilakukan perbandingan yaitu PersentaseKeuntungan akan lebih besar dari pada KeuntunganMaks kemudian nantinya akan tersimpan pada variabel KeuntunganMaks. IDmaks digunakan untuk menyimpan ID_Baris atau Row_ID yang berada pada kolom satu yang paling besar.

Lalu, akan dilakukan pencetakan variabel IDmaks dan KeuntunganMaks sesuai format soal shift modul.

```
{
    printf("Transaksi terakhir dengan profit percentage terbesar yaitu %s dengan persentase %d\n")
    #print "Transaksi terakhir dengan profit percentage terbesar yaitu ", IDmaks, " dengan persentase ", KeuntunganMaks, "%\n"
}
```


Kemudian, langkah terakhir adalah memanggil direktori dibawah ini untuk diarahkan ke file hasil.txt sebagai tempat keluarnya output.

```
/Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv > hasil.txt
```

**Nomor 2b** <br>
Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar **nama customer pada transaksi tahun 2017 di Albuquerque**.

**Source Code dan Penjelasan** <br>
```
awk 'BEGIN {FS="\t"}
{
    NamaCust=$7

    #utk cari nama customer di tahun 2017 dari Order_ID dan di kota Albuquerque
    if ($2~"2017" && ($10=="Albuquerque")) 
    {
        pelanggan[NamaCust]+=1 
    }
}
END{

    #untuk cetak nama2 pelanggannya
    print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"
    for (NamaPelanggan in pelanggan)
    {
        print NamaPelanggan
        #print"\n"
    }
   print "\n"
}' /Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv >> hasil.txt
```

Sama seperti nomor 2a, pada nomor 2b ini sama menggunakan awk.

```
if ($2~"2017" && ($10=="Albuquerque")) 
    {
        pelanggan[NamaCust]+=1 
    }
```

kondisi diatas dilakukan untuk mencari nama customer yang melalakukan transaksi pada tahun 2017 dan di kota Albuquerque. Setiap baris akan dilakukan pengecekan pada``` $2``` atau kolom dua untuk mencari tahun pada kolom ```Order ID``` dan pada ```$10``` atau kolom sepuluh untuk mencari kota Albuquerque pada kolom ```City```. Nama customer akan disimpan pada array ```pelanggan[NamaCust]```. Array tersebut menggunakan associative array dimana NamaCust sebagi index dan setiap jumlah nama bertambah maka itu dihitung sebagai value. 

Lalu, akan dilakukan pencetakan sesuai format soal shift modul. Iterasi semua nilai pada array pelanggan untuk menampilkan NamaPelanggan. Kemudian, langkah terakhir adalah memanggil direktori dibawah ini untuk diarahkan ke file hasil.txt sebagai tempat keluarnya output.

```
print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"
    for (NamaPelanggan in pelanggan)
    {
        print NamaPelanggan
        #print"\n"
    }
   print "\n"
}'/Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv >> hasil.txt
```

**Nomor 2c** <br>
TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen customer yang paling sedikit. Oleh karena itu, Clemong membutuhkan **segment customer** dan **jumlah transaksinya yang paling sedikit**.

**Source Code dan Penjelasan** <br>

```
export LC_ALL=C #buat mesin baca (.) jadi desimal
awk 'BEGIN {FS="\t"}
{
   #baca semua row tp kalau NR tidak sama dengan 1 gamau baca baris pertama
   if (NR!=1) 
   {
       segment[$8]+=1
   }
}
END{
   Min=5000
 
   #utk mencari segment customer dan jumlah transaksi yang paling sedikit
   for(x in segment){ #cek setiap element disetiap segment
       if(Min>segment[x])
       {
           Min=segment[x]
           SegMin=x
       }
   }
   printf ("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n", SegMin, Min)
  #printf("%d %.1f \n", segment, Min)
}' /Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv >> hasil.txt
```

Sama seperti nomor 2a, pada nomor 2c ini sama menggunakan ```awk``` dan``` LC_ALL=C```.

```
if (NR!=1) 
   {
       segment[$8]+=1
   }
```

Kondisi diatas digunakan untuk menghitung banyaknya segment. ```NR!=1``` maksudnya adalah untuk membaca semua baris kecuali baris pertama karena baris pertama adalah judul/header dan baris yang dibaca dimulai dari baris kedua. Array ```segment [$8]``` bermaksud sebagai index dan penghitung transaksi sebagai valuenya.

Kemudian, ```Min=5000 ```digunakan sebagai pembanding pertama agar data selanjutnya bisa berubah. Iterasi dibawah ini dilakukan untuk mengecek element disetiap segment untuk mencari segment customer dan jumlah transaksi paling sedikit. Jika jumlah transaksi dari segment lebih kecil dibandingkan Min, maka array ```segment[x]``` dan index ```[x] ```akan tersimpan pada variabel Min dan SegMin.

```
{
   Min=5000
 
   #utk mencari segment customer dan jumlah transaksi yang paling sedikit
   for(x in segment){ #cek setiap element disetiap segment
       if(Min>segment[x])
       {
           Min=segment[x]
           SegMin=x
       }
   }
```

Lalu, akan dilakukan pencetakan variabel SegMin dan Min sesuai format soal shift modul. Kemudian, langkah terakhir adalah memanggil direktori dibawah ini untuk diarahkan ke file hasil.txt sebagai tempat keluarnya output.

```
 printf ("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n", SegMin, Min)
```

**Nomor 2d** <br>
TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian, antara lain: Central, East, South, dan West. Manis ingin mencari **wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit** dan **total keuntungan wilayah tersebut**.

**Source Code dan Penjelasan** <br>
```
export LC_ALL=C #buat mesin baca (.) jadi desimal
awk '
BEGIN{FS="\t"}
{
   reg=$13
   profit=$21
 
   #baca semua row tp kalau NR tidak sama dengan 1 gamau baca baris pertama
   if (1!=NR)
   {
       Region[reg]+=profit
   }
}
END{
   UntungMin=999999
   for (x in Region)
   {
       #utk menghitung total keuntungan daru setiap wilayah bagian (region)
       if (Region[x]<UntungMin)
       {
           regMin=x
           UntungMin=Region[x]
           #regMin=x
       }
   }
   printf ("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.1f", regMin, UntungMin)
   printf ("\n\n")
}' /Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv >> hasil.txt
```

Sama seperti nomor 2a dan 2c, pada nomor 2d ini sama menggunakan ```awk``` dan ```LC_ALL=C```.

```
if (1!=NR)
   {
       Region[reg]+=profit
   }
```

Kondisi diatas mirip seperti dengan 2c. ```NR!=1``` maksudnya adalah untuk membaca semua baris kecuali baris pertama karena baris pertama adalah judul/header dan baris yang dibaca dimulai dari baris kedua. Pada 2d ini diminta untuk menghitung total keuntungan dari setiap wilayah bagian (region). Array ```Region [reg]``` bermaksud sebagai index dan profit sebagai valuenya. Setiap region profitnya dijumlahin.

Kemudian, ```UntungMin=999999``` nilai UntungMin harus lebih besar dari keuntungan dari masing-masing region agar nilainya bisa terproses. Iterasi dibawah ini dilakukan untuk mencari region dengan total keuntungan paling sedikit dengan menghitung setiap total keuntungan masing-masing region pada array Region. Apabila total keuntungan pada suatu region lebih kecil maka ```Region[x]``` dan index ```[x]``` akan tersimpan pada variabel ```regMin``` dan ```UntungMin```. 

```
{
   UntungMin=999999
   for (x in Region)
   {
       #utk menghitung total keuntungan daru setiap wilayah bagian (region)
       if (Region[x]<UntungMin)
       {
           regMin=x
           UntungMin=Region[x]
           #regMin=x
       }
   }
```

Lalu, akan dilakukan pencetakan variabel RegMin dan UntungMin sesuai format soal shift modul. Kemudian, langkah terakhir adalah memanggil direktori dibawah ini untuk diarahkan ke file hasil.txt sebagai tempat keluarnya output.
 
```
 printf ("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.1f", regMin, UntungMin)
   printf ("\n\n")
}'
```

**Nomor 2e** <br>
Agar mudah dibaca oleh Manis, Clemong, dan Steven, (e) kamu diharapkan bisa membuat sebuah script yang akan menghasilkan file “hasil.txt” yang memiliki format sebagai berikut:


Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.

```
Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst

Tipe segmen customer yang penjualannya paling sedikit adalah *Tipe Segment* dengan *Total Transaksi* transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah *Nama Region* dengan total keuntungan *Total Keuntungan (Profit)*
```

Pada soal 2e, diminta untuk membuat sebuah file txt bernama hasil.txt yang gunanya untuk menyimpan hasil script dari soal 2a, 2b, 2c, dan 2d. Berikut adalah isi dari file hasil.txt :


<a name="soal3"></a>
## Soal 3

<a name="soal3a"></a>
### Soal 3a
**Perintah** <br>
Pada soal 3a, diperintahkan untuk mengunduh 23 gambar dari https://loremflickr.com/320/240/kitten dan menyimpan log-nya ke file ```Foto.log```. Jika ada gambar yang sama maka harus dihapus dan tidak perlu mengunduh gambar lagi untuk menggantinya. Gambar-gambar tersebut disimpan dengan nama ```Koleksi_XX``` berurutan tanpa ada nomor yang hilang (contoh: Koleksi_01, Koleksi_02, dst).

<a name="sc3a"></a>
**Source code 3a**
```shell script
#!/bin/bash

# masuk ke directory
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3

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
```

**Penyelesaian** <br>
Pertama, masuk ke directory untuk memastikan file terunduh di tempat yang tepat.
```shell script
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3
```

Variabel ```count``` digunakan untuk men-tracking jumlah file yang telah ada di dalam directory (dengan catatan tidak ada file yang sama).

<a name="langkah-3a"></a>
Berikut langkah penyelesaian untuk soal 3a:
1. Dilakukan proses iterasi sebanyak 23 kali untuk mengunduh 23 file gambar.
    ```shell script 
    for ((i=1; i<=23; i=i+1))
    ```
2. Command ```wget``` untuk mengunduh file dari link https://loremflickr.com/320/240/kitten dan ```-O``` untuk me-rename file yang diunduh dengan format ```Koleksi_XX.jpg``` dan ```-a``` untuk menambahkan pesan output ke log file ```Foto.log``` tanpa overwriting.
    ```shell script
    wget -O "Koleksi_$count.jpg" -a "Foto.log" https://loremflickr.com/320/240/kitten
    ```
3. Untuk mengecek kesamaan file, dilakukan perbandingan antara file yang baru diunduh dengan file-file yang ada di dalam directory unduh. Digunakan ```cmp``` untuk membandingkan konten file dan ```--silent``` atau ```-s``` agar tidak menampilkan output dari proses perbandingan. 
4. Return value dari ```$(cmp --silent "./Koleksi_$j.jpg" "./Koleksi_$count.jpg")``` disimpan dalam statement ```status=$?```. Dilakukan pengkondisian, jika isi file sama maka file yang baru diunduh dihapus dengan ```rm```.
    ```shell script
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
    ```
5. Rename file sesuai format ```Koleksi_XX.jpg``` untuk file ke-1 sampai ke-9 dengan ```mv```. Cek eksistensi file terlebih dahulu dengan ```-e```.
    ```shell script
    for i in {1..9}
    do
            if [ -e "./Koleksi_$i.jpg" ]
            then
                    mv "Koleksi_$i.jpg" "Koleksi_0$i.jpg"
            fi
    done
    ```

<a name="soal3b"></a>
### Soal 3b
**Perintah** <br>
Jalankan script [soal 3a](#sc3a) dengan cronjob **sehari sekali pada jam 8 malam** dan **tanggal 2 empat hari sekali**. Masukkan file unduh beserta ```Foto.log``` ke folder dengan nama sesuai tanggal unduh dengan format ```DD-MM-YYYY```.

**Source code**
```shell script
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
```

**Crontab**
```shell script
# execute soal3b.sh
0 20 1-31/7,2-31/4 * * /bin/bash ~/soal-shift-sisop-modul-1-B05-2021/soal3/soal3b.sh
```

**Penyelesaian** <br>
Buat directory baru ```mkdir``` dengan format penamaan sesuai dengan tanggal unduh. Untuk mendapatkan tanggal unduh, gunakan command ```date``` dalam hal ini dengan statement ```newDir=$(date +"%d-%m-%Y")```. Jalankan [soal 3a](#sc3a) dengan ```bash```. Kemudian pindahkan ```mv``` seluruh file unduh serta ```Foto.log``` ke directory ```newDir```. Untuk cron-nya,
```shell script
0 20 1-31/7,2-31/4 * * /bin/bash ~/soal-shift-sisop-modul-1-B05-2021/soal3/soal3b.sh
```
**Dari kiri ke kanan** <br>
- 0 artinya cron dijalankan tiap menit 0 <br>
- 20 artinya cron dijalankan tiap jam 20:00 <br>
- 1-31/7 artinya cron dijalankan tiap 7 hari sekali, mulai dari tanggal 1 hingga tanggal 31 <br>
- 2-31/4 artinya cron dijalankan tiap 4 hari sekali, mulai dari tanggal 2 hingga tanggal 31 <br>
- \* \* artinya setiap bulan dan setiap hari <br>

<a name="soal3c"></a>
### Soal 3c
**Perintah** <br>
Undur juga gambar kelinci dari https://loremflickr.com/320/240/bunny. Gambar kucing dan kelinci diundah secara bergantian setiap hari. Nama folder diberi awalan ```Kucing_DD-MM-YYYY``` atau ```Kelinci_DD-MM-YYYY``` dengan ```DD-MM-YYYY``` adalah tanggal unduh.

**Source Code**
```shell script
#!/bin/bash

# masuk ke directory
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3

yesterdayDate=$(date -d yesterday +"%d-%m-%Y")
currentDate=$(date +"%d-%m-%Y")

# cek file yang di download kemarin
if [ -d "Kelinci_$yesterdayDate" ]
then
	flag=0
	directoryName="Kucing_$currentDate"
else
	flag=1
	directoryName="Kelinci_$currentDate"
fi

# download file
# untuk menghitung file yang sudah ada di directory
count=1

for ((i=1; i<=23; i=i+1))
do
	if [ $flag -eq 0 ]
	then
		 wget -O "Koleksi_$count.jpg" -a "Foto.log" https://loremflickr.com/320/240/kitten
	else
		wget -O "Koleksi_$count.jpg" -a "Foto.log" https://loremflickr.com/320/240/bunny
	fi

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

# buat directory baru dan pindahkan file
mkdir "$directoryName"
mv *.jpg "./$directoryName"
mv Foto.log "./$directoryName"
```

**Penyelesaian** <br>
Berikut adalah langkah penyelesaian soal 3c.
1. Karena tidak ada aturan urutan yang harus diunduh terlebih dahulu, maka disini kita unduh file kelinci di hari pertama. Untuk menentukan file yang diunduh di hari selanjutnya, cek nama folder yang diunduh kemarin (disini kita cek dengan folder kelinci).
	```shell script
	if [ -d "Kelinci_$yesterdayDate" ]
	```
	Jika ditemukan folder dengan nama ```Kelinci_$yesterdayDate```, maka hari ini kita akan mengunduh file kucing. Sebaliknya, jika tidak ada maka unduh file kelinci.
2. Buat folder baru dengan format ```Kucing_$currentDate``` atau ```Kelinci_$currentDate```.
3. Untuk proses selanjutnya, sama dengan [langkah penyelesaian soal 3a](langkah-3a). Yang berbeda hanyalah link website yang harus disesuaikan dengan file yang hari itu diunduh.
	```shell script
	if [ $flag -eq 0 ]
		then
	    # unduh file kucing
			 wget -O "Koleksi_$count.jpg" -a "Foto.log" https://loremflickr.com/320/240/kitten
		else
	    # unduh file kelinci
			wget -O "Koleksi_$count.jpg" -a "Foto.log" https://loremflickr.com/320/240/bunny
		fi
	```

<a name="soal3d"></a>
### Soal 3d
**Perintah** <br>
Pindahkan seluruh folder ke zip dengan nama ```Koleksi.zip``` dan beri password berupa tanggal hari ini dengan format ```MMDDYYYYY```.

**Source Code**
```shell script
#!/bin/bash

# masuk ke directory
cd ~/soal-shift-sisop-modul-1-B05-2021/soal3

# setting password
settingPassword=$(date +"%m%d%Y")

# zip file
zip -q -r -P "$settingPassword" -m Koleksi.zip Kucing_* Kelinci_*
```

**Penyelesaian** <br>
Gunakan command ```zip``` untuk men-zip folder ```Kucing_*``` dan ```Kelinci_*```. ```-q``` untuk menyembunyikan output dari ketika proses men-zip file. ```-r``` untuk mengarsipkan folder dan seluruh folder. ```-m``` untuk memindahkan folder ```Kucing_*``` dan ```Kelinci_*``` ke file ```Koleksi.zip```. ```-P``` atau ```--password``` untuk memberi password pada file ```Koleksi.zip``` berupa tanggal hari ini dengan format ```MMDDYYYY```.

<a name="soal3e"></a>
### Soal 3e
**Perintah** <br>
```zip``` file saat kuliah saja, yaitu jam 7 pagi sampai 6 sore dan file ter-```unzip``` saat tidak kuliah serta tidak ada file ```zip``` sama sekali.

**Source Code** <br>
```shell script
#!/bin/bash

# masuk ke directory
cd /home/yoursemicolon/Documents/sisop-2021/modul-1/soal-shift-modul-1-B05-2021/soal3

# setting password
setPassword=$(date +"%m%d%Y")

# unzip file
unzip -P "$setPassword" Koleksi.zip

# hapus file zip
rm "./Koleksi.zip"
```

**Crontab**
```shell script
# zip saat kuliah
0 7 * * 1-5 /bin/bash ~/soal-shift-sisop-modul-1-B05-2021/soal3/soal3d.sh

# unzip saat tidak kuliah
0 18 * * 1-5 /bin/bash ~/soal-shift-sisop-modul-1-B05-2021/soal3/soal3e.sh
```

**Penyelesaian** <br>
Untuk membuat file ter-```zip``` dan ter-```unzip``` secara otomatis pada jam kuliah, kita menggunakan ```cronjob```. Crontab untuk men-```zip``` file:
```shell script
# zip saat kuliah
0 7 * * 1-5 /bin/bash ~/soal-shift-sisop-modul-1-B05-2021/soal3/soal3d.sh
```
**Dari kiri ke kanan**
- 0 artinya zip pada menit ke nol
- 7 artinya pada jam 07:00
- \* \* artinya setiap hari dan setiap bulan
- 1-5 artinya pada weekdays atau senin-jumat

Untuk meng-```unzip``` file, gunakan command ```unzip -P```. ```-P``` atau ```--password``` untuk mengekstrak file ```zip``` yang mempunyai password. Kemudian, hapus file zip dengan ```rm```. Untuk crontabnya:
```shell script
# unzip saat tidak kuliah
0 18 * * 1-5 /bin/bash ~/soal-shift-sisop-modul-1-B05-2021/soal3/soal3e.sh
```
**Dari kiri ke kanan**
- 0 artinya unzip pada menit ke nol
- 18 artinya pada jam 18:00
- \* \* artinya setiap hari dan setiap bulan
- 1-5 artinya pada weekdays atau senin-jumat

**Kendala dalam pengerjaan soal 3**
1. Belum mengerti bagaimana cara menjalankan cronjob sehingga belum bisa mengecek kebenaran pengerjaan soal 3b dan 3e. Solusinya adalah ubah setting waktu pada linux dengan referensi berikut https://www.youtube.com/watch?v=HUX8pMEEj9g.
2. Belum paham mengenai command-command pada terminal. Solusinya adalah membaca banyak referensi, salah satunya https://linuxize.com/post/how-to-zip-files-and-directories-in-linux/.
