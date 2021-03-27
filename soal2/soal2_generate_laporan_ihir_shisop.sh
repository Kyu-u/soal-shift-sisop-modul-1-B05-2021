#!/bin/bash
#awk 'BEGIN {FS="\t"} 
#export LC_ALL=C #buat mesin baca (,) jadi (.)

#NOMER_2a
# $(nomer) = kolom ke (nomer)
# rumus profit percentage = (profit/cost price)*100
#$21=profit
#$18=sales
#1=RowID
export LC_ALL=C
awk 'BEGIN {FS="\t"; KeuntunganMaks=0}
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
    print "Transaksi terakhir dengan profit percentage terbesar yaitu ", IDmaks, " dengan persentase ", KeuntunganMaks, "%\n"
}
' /Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv >> hasil.txt


#NOMER_2b
#nama pelanggan=$7
# $2=orderID 
# $10=city

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

#NOMOR_2c
export LC_ALL=C #buat mesin baca (,) jadi (.)
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
    for(x in segment){
        if(Min>segment[x])
        {
            Min=segment[x]
            SegMin=x
        }
    }
    printf ("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n", SegMin, Min)
   #printf("%d %.1f \n", segment, Min)
}' /Users/nadiatiara/praktikum_sisop/soal2/Laporan-TokoShiSop.tsv >> hasil.txt


#NOMOR_2d
#NR = Number of Row
export LC_ALL=C #buat mesin baca (,) jadi (.)
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
