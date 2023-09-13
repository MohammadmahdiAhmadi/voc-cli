#!/usr/bin/bash

lang_code="fa"
user_api_key=""

# List of RTL languages
RTL_LANGUAGES=("fa" "ar" "arc" "arz" "ckb" "dv" "ha" "he" "khw" "ksh" "ps" "sd" "ur" "uz_AF" "yi")

# Get the selected text from the clipboard
text=$(xsel -o)

# Translate the text using 'trans' command
translation=$(trans -b :$lang_code "$text")

# Check if the input language code is in the RTL languages list
if [[ " ${RTL_LANGUAGES[@]} " =~ " $lang_code " ]]; then
    translation=$(echo "$translation" | rev)
fi

# Display a notification with the translation
notify-send --icon=info --app-name="Voc Translator" "$text" "$translation"

# If a user API key is provided, send data to the API
if [ -n "$user_api_key" ]; then
    api_url='https://backvoc.fesenjoon.xyz/api/v1/voc/new/'
    curl -s --location "$api_url" \
    --header 'USER-API-KEY: '$user_api_key'' \
    --header 'Content-Type: application/json' \
    --data '{
        "word": "'"$text"'",
        "translation": "'"$translation"'",
        "dest_lang": "'"$lang_code"'"
    }' > /dev/null 2>&1
fi
