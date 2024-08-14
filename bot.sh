#!/bin/bash

TOKEN="<BOT_Token>"
CHAT_ID="<CHat_ID_Telegram>"
API_URL="https://api.telegram.org/bot$TOKEN"
OFFSET_FILE="/tmp/telegram_offset"

list_files() {
    local i=1
    for file in /Path/to/save/file/*; do
        echo "$i. ${file##*/}"  # Mengambil nama file saja tanpa path lengkap
        ((i++))
    done
}

send_message() {
    local text="$1"
    curl -s -X POST "$API_URL/sendMessage" -d chat_id="$CHAT_ID" -d text="$text"
}

download_file() {
    local id="$1"
    local name="$2"
    local episode="$3"
    local filename="$name-$episode.mkv"
    send_message "Memulai Proses Download File $filename "
    curl -L "https://drive.usercontent.google.com/download?id=$id&confirm=xxx" -o "/Path/to/save/file/$filename"
    send_message "File $filename sudah terdownload"
    list_files > /tmp/file_list
    send_message "Menampilkan List file yang terdapat di /Path/to/save/file/"
    send_message "$(cat /tmp/file_list)"
}

delete_file() {
    local number="$1"
    filename=$(sed -n "${number}p" /tmp/file_list | cut -d ' ' -f2-)  # Memperoleh nama file dari nomor yang dipilih
    file_to_delete="/Path/to/save/file/$filename"  # Menyusun jalur lengkap file untuk dihapus
    if [[ -f "$file_to_delete" ]]; then
        rm "$file_to_delete"
        send_message "File $filename berhasil dihapus."
    else
        send_message "Nomor file tidak valid."
    fi
}

process_updates() {
    local offset
    if [[ -f "$OFFSET_FILE" ]]; then
        offset=$(cat "$OFFSET_FILE")
    else
        offset=0
    fi

    updates=$(curl -s "$API_URL/getUpdates?offset=$offset")
    echo "$updates" | jq -c '.result[]' | while read update; do
        update_id=$(echo "$update" | jq '.update_id')
        message=$(echo "$update" | jq -r '.message.text')

        if [[ $message =~ ^/download ]]; then
            id=$(echo "$message" | cut -d' ' -f2)
            name=$(echo "$message" | cut -d' ' -f3)
            episode=$(echo "$message" | cut -d' ' -f4)
            download_file "$id" "$name" "$episode"
        elif [[ $message =~ ^/list ]]; then
            list_files > /tmp/file_list
            files=$(cat /tmp/file_list)
            if [ -n "$files" ]; then
                send_message "List file yang terdapat di Directory /Path/to/save/file/ :\n$files"
            else
                send_message "File Kosong atau Telah dihapus"
            fi
        elif [[ $message =~ ^/delete ]]; then
            list_files > /tmp/file_list
            file_list=$(cat /tmp/file_list)
            send_message "List file yang dapat dihapus:\n$file_list"
            number=$(echo "$message" | cut -d' ' -f2)
            delete_file "$number"
        else
            send_message "Perintah tidak dikenal. Gunakan format: /download <id> <nama> <episode> Untuk Mendownload. Atau"
            send_message "Gunakan /list untuk melihat daftar file. Atau"
            send_message "Gunakan format: /delete <nomor_file> untuk mendelete file."
        fi
        echo $((update_id + 1)) > "$OFFSET_FILE"
    done
}

while true; do
    process_updates
    sleep 5
done
