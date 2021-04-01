# Laporan Resmi Soal Shift 1
Dikerjakan oleh Kelompok B05
* Amanda Rozi Kurnia 05111940000094
* Melanchthon Bonifacio Butarbutar 05111940000097
* Nadia Tiara Febriana 05111940000217

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


<a name="soal2"></a>
## Soal 2


<a name="soal3"></a>
## Soal 3

<a name="soal3a"></a>
### Soal 3a
**Perintah** <br>
Pada soal 3a, diperintahkan untuk mengunduh 23 gambar dari https://loremflickr.com/320/240/kitten dan menyimpan log-nya ke file ```Foto.log```. Jika ada gambar yang sama maka harus dihapus dan tidak perlu mengunduh gambar lagi untuk menggantinya. Gambar-gambar tersebut disimpan dengan nama ```Koleksi_XX``` berurutan tanpa ada nomor yang hilang (contoh: Koleksi_01, Koleksi_02, dst).

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

### Soal 3b
**Perintah** <br>
Jalankan script [soal 3a](#soal3a) dengan cronjob **sehari sekali pada jam 8 malam** dan **tanggal 2 empat hari sekali**. Masukkan file unduh beserta ```Foto.log``` ke folder dengan nama sesuai tanggal unduh dengan format ```DD-MM-YYYY```.

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


### Soal 3c

### Soal 3d

### Soal 3e
