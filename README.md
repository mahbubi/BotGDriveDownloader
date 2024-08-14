# BotGDriveDownloader
Bot Downloader From Google Drive to Your local PC/Laptop/Device

How To Use
1. Untuk Download file gunakan format: /download <id> <NamaFile> <episode> Untuk Mendownload <br>
Ex : /download 1lzNHnvxxxLsyJXXb6eWZLThvDaYkKWm8 NamaFile 1
```
Contoh URL :
https://drive.usercontent.google.com/download?id=1lzNHnvxxxLsyJXXb6eWZLThvDaYkKWm8&export=download&authuser=0

id di ambil dari id=1lzNHnvxxxLsyJXXb6eWZLThvDaYkKWm8
```
2. Untuk List File yang ada gunakan /list untuk melihat daftar file
3. Untuk Menghapus File yang ada gunakan /delete <nomor_file> untuk mendelete file. (Sebelum Menghapus File Harap Melihat List file terlebih dahulu untuk mengetahui nomor file)


How to deploy

1. exec command chmod +x bot.sh untuk mengubah permission script
2. Update Variable Token dan Chat_ID 
3. Update Variable path '''/Path/to/save/file''' ke file yang di tuju
4. Update Variable '''ExecStart=/path/save/bot.sh''' pada file botdownloadergdrive.service sesuai dengan path disimpannya file bot.sh
5. Pindahkan file botdownloadergdrive.service ke /etc/systemd/system/
6. Exec Command:
```
sudo systemctl daemon-reload
sudo systemctl enable botdownloadergdrive.service
sudo systemctl start botdownloadergdrive.service
```
