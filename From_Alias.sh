#!/usr/bin/env bash
#20240216_2215_est_EJR
#Functions To Share From An Alias (For GitHub)

### FUNCTIONS: MISC #######################################################################################################################
e-bitchute-dl.ef() { rm /tmp/eviddl.tmp; local zurl; local zname; echo 'Enter Bitchute Video URL'; read zurl; wget -O /tmp/eviddl.tmp $zurl; local zvidurl=$(grep -oP '(?<=src=")[^"]+.mp4(?=")' /tmp/eviddl.tmp); rm /tmp/eviddl.tmp; echo $zvidurl | xclip -selection clipboard; echo 'Enter name without the extension:'; read zname; wget -O $zname.mp4 $zvidurl --no-check-certificate; }
e-yt2mp3.ef() { echo 'YT>>MP3: URL?'; read -e ytu; [ -z "$ytu" ] && exit 0; if [[ $ytu == *"list="* ]]; then ytu="${ytu%%&list=*}"; else ytu="$ytu"; fi; echo 'YT>>MP3: BaseName?'; read -e ytn; [ -z "$ytn" ] && exit 0; ytn="$ytn.mp3"; yt-dlp -f bestaudio -x --audio-format mp3 --audio-quality 0 --output "$ytn" "$ytu"; }
e-yt2mp4.ef() { echo 'YT>>MP3: URL?'; read -e ytu; [ -z "$ytu" ] && exit 0; if [[ $ytu == *"list="* ]]; then ytu="${ytu%%&list=*}"; else ytu="$ytu"; fi; echo 'YT>>MP4: BaseName?'; read -e ytn; [ -z "$ytn" ] && exit 0; ytn="$ytn.mp4"; yt-dlp -f best --output "$ytn" "$ytu"; }
e-av-joiner.ef() { local ztmp="/tmp/join.txt"; local input_files=$(zenity --title='Select AV Files To JOIN' --file-selection --multiple --separator=$'\n' --file-filter='*.*'); if [ $? == 1 ]; then return; fi; local outname=$(zenity --width=400 --height=200 --entry --title='NAME OUTPUT FILE' --text='Name Output File with ext:' --entry-text "name.ext"); if [ $? == 1 ]; then return; fi; local output_dir=$(zenity --file-selection --directory --title='Select Output Folder'); if [ $? == 1 ]; then return; fi; zenity --width=700 --height=700 --info --title='Files To Be Joined:' --text="$input_files\n---Destination---\n$output_dir/$outname"; if [ $? == 1 ]; then return; fi; echo -e "$input_files" >$ztmp; sed -i -e "s/^/file '/" $ztmp; sed -i -e "s/$/'/" $ztmp; ffmpeg -f concat -safe 0 -i $ztmp -c copy "${output_dir}/$outname"; rm $ztmp; }
e-io-vid2loudness-gui.ef() { local input=$(zenity --file-selection --title="Select Video File" --file-filter="Video files | *.mp4 *.avi *.mkv *.mov *.flv *.wmv *.webm *.m4v" --file-filter="All files | *"); if [ -z "$input" ]; then zenity --error --text="No file selected. Exiting."; return 1; fi; local vol; clear; echo 'Enter Volume Multiplier Number'; read vol; local old="${input%.${input##*.}}-OLD.${input##*.}"; mv "$input" "$old"; rm $input; ffmpeg -i "$old" -af volume="$vol" -c:v copy "$input"; rm "$old"; }
e-io-vid2trim-gui.ef() { local input=$(zenity --file-selection --title="Select Video to Chop"); if [[ -z "$input" ]]; then echo "No video selected. Aborting."; return 1; fi; local filename=$(basename "$input"); local extension="${filename##*.}"; local filename_noext="${filename%.*}"; local output="$input"; local old="$filename_noext-old.$extension"; mv "$input" "$old"; celluloid "$old" & sleep .5; local start_time=$(zenity --entry  --title='START?' --text='HH:MM:SS' --entry-text="00:00:00"); local end_time=$(zenity --entry --title='END?' --text='HH:MM:SS' --entry-text="$start_time"); pkill celluloid; ffmpeg -i "$old" -ss "$start_time" -to "$end_time" -c:v copy -c:a copy "$output"; rm "$old"; clear; echo "Done: $output"; }
e-opus4mp3.ef() { local ins=$(zenity --title='Selects MP3s To Convert To OPUS files' --file-selection --multiple --separator=$'\n' --file-filter="MP3 files | *.mp3"); [ $? == 1 ] && return; local odir=$(zenity --title='Output DIR ??' --file-selection --directory); [ $? == 1 ] && return; for i in $ins; do local bn=$(basename "$i" .mp3); local out="$odir/$bn.opus"; ffmpeg -i "$i" -c:a libopus -b:a 16k "$out"; echo '***** Converted $i to $out *****'; done; }
#
e-img-pdf2jpeg-gui.ef() { local input_files=$(zenity --file-selection --title="Select PDF files" --file-filter="PDF files | *.pdf" --multiple --separator=$'\n' 2>/dev/null); if [ -z "$input_files" ]; then echo "No PDF files selected."; return 1; fi; for i in $is; do opre="${i%.pdf}"; pdftoppm -jpeg "$i" "$opre"; done; }
e-img-pdf2png-gui.ef() { local input_files=$(zenity --file-selection --title="Select PDF files" --file-filter="PDF files | *.pdf" --multiple --separator=$'\n' 2>/dev/null); if [ -z "$input_files" ]; then echo "No PDF files selected." ;return 1; fi; for i in $input_files; do opre="${i%.pdf}"; pdftoppm -png "$i" "$opre"; done; }
e-img-pdf-gui.ef() { local input_files=$(zenity --file-selection --title="Select image files" --file-filter="Image files | *.png *.jpg *.jpeg" --multiple --separator=$'\n' 2>/dev/null); if [ -z "$input_files" ]; then echo "No image files selected."; return 1; fi; local output_file=$(zenity --file-selection --save --confirm-overwrite --title='Save: NAME.pdf'); if [ -z "$output_file" ]; then echo "No output file selected."; return 1; fi; img2pdf $input_files -o "$output_file"; }
e-img-stack-gui.ef() { local ins=$(zenity --file-selection --title='SELECT IMAGES (stack)' --file-filter="Image files | *.png *.jpg *.jpeg" --multiple --separator=$'\n' 2>/dev/null); [ -z "$ins" ] && return 1; local out=$(zenity --file-selection --save --confirm-overwrite --title='Save: NAME.EXT (png; jpg; etc..)'); [ -z "$out" ] && return 1; convert -append $ins "$out"; }
#
e-cat-file-to-clipboard.ef() { codetmp="$HOME/dir/somefile.txt"; cat "$codetmp" | xclip -selection clipboard; }
e-csv-combiner.ef() { rm /tmp/head.csv /tmp/nohead.csv /tmp/body.csv; zins=$(zenity --title='Select CSV Files' --file-selection --multiple --file-filter='CSV files | *.csv' --separator=' '); zout=$(zenity --title='Save Output Csv File' --file-selection --save --confirm-overwrite --file-filter='CSV files | *.csv'); if [ -z "$zins" ] || [ -z "$zout" ]; then zenity --error --text "File selection canceled."; return; fi; for i in ${zins}; do head -n 1 "$i" > /tmp/head.csv; done; for i in ${zins}; do tail -n +2 "$i" >> /tmp/nohead.csv; done; sort -u /tmp/nohead.csv -o /tmp/body.csv; cat /tmp/head.csv /tmp/body.csv > "$zout"; sed -i -e '$a\' "$zout"; rm /tmp/head.csv /tmp/nohead.csv /tmp/body.csv; }
e-url2githubpreview.ef() { local input_url; read -p "Enter the GitHub Url To Make into a URL: " input_url; local previewed_url="https://htmlpreview.github.io/?$input_url"; echo "Previewed URL: $previewed_url"; echo -n "$previewed_url" | xclip -selection clipboard; echo "URL copied to clipboard."; }
e-http-serve-gui.ef() { local directory; directory=$(zenity --file-selection --directory --title="Select a directory to serve" 2>/dev/null); if [[ -n "$directory" ]]; then cd "$directory" || return; python3 -m http.server; fi; }
#
e-iso2usb.ef() { local viso=$(zenity --title='IsoToUsb: Choose ISO' --file-selection --file-filter='*.iso *.ISO'); if [ $? -ne 0 ]; then zenity --error --text="No ISO file selected. Exiting."; return 1; fi; local vusb=$(zenity --title='IsoToUsb: Choose USB Device' --file-selection --directory); if [ $? -ne 0 ]; then zenity --error --text="No USB drive selected. Exiting."; return 1; fi; vusb=$(df -h "$vusb" | awk 'NR==2 {print $1}' | sed 's/[0-9]*$//'); zenity --question --text="Are you sure you want to write the ISO to $vusb?"; if [ $? -ne 0 ]; then zenity --info --text="Operation canceled. Exiting."; return 1; fi; echo -e "\n\n\n=== Writing Iso To Usb ===\nFrom: $viso\n  To: $vusb\n"; sudo dd if="$viso" of="$vusb" bs=4M status=progress; }
e-eject.ef() { echo "Drives available for ejection:"; lsblk -o NAME,SIZE,TYPE,MOUNTPOINT; read -p "Enter the drive you want to eject (e.g., sdd): " drive; [ -z "$drive" ] && echo "Drive selection canceled."; return 0; echo "Ejecting drive $drive..."; sudo eject "/dev/$drive"; while mount | grep -q "/dev/$drive"; do echo "Waiting for the drive to be unmounted..."; sleep 2; done; echo -e "We Safely Ejected The Drive:\n $drive\tPlease Continue To Rock on! 🎸"; }
e-efidel.ef() { clear; local LV1=''; local LV2=''; sudo efibootmgr; read -p "Enter the number of the boot entry you want to delete: " LV1; read -p "Are you sure you want to delete boot entry $LV1? (y/n): " LV2; if [ "$LV2" == "y" ] || [ "$LV2" == "Y" ]; then sudo efibootmgr -b "$LV1" -B; echo "Boot entry $LV1 has been deleted."; else echo "Operation canceled."; fi; }
e-duplicate-checker.ef() { clear; declare -A seen_files; for file in *; do [[ -f "$file" ]] || continue; checksum=$(md5sum "$file" | cut -d' ' -f1); if [[ ${seen_files[$checksum]} ]]; then echo "Found a duplicate: $file"; else seen_files[$checksum]=$file; fi; done; }
e-duplicate-deleter.ef() { clear; declare -A seen_files; for file in *; do [[ -f "$file" ]] || continue; checksum=$(md5sum "$file" | cut -d' ' -f1); if [[ ${seen_files[$checksum]} ]]; then echo "-----Deleting: $file-----"; sudo rm "$file"; else seen_files[$checksum]=$file; fi; done; }
#
e-install-androidinstaller-fpk() { read -p '===== Enter To Install OpenAndroidInstaller FlatPak =====' junk; sudo flatpak install -y flathub "org.openandroidinstaller.OpenAndroidInstaller"; }
e-install-bitcoincore-fpk() { read -p '===== Enter To Install BitcoinCore FlatPak =====' junk; sudo flatpak install -y flathub "org.bitcoincore.bitcoin-qt"; }
e-install-electrum-fpk() { read -p '===== Enter To Install Electrum FlatPak =====' junk; sudo flatpak install -y flathub "org.electrum.electrum"; }
e-install-appimg.ef() { # Install Apps
clear
if [ ! -d "$HOME/.local/share/applications/" ]; then mkdir -p "$HOME/.local/share/applications/"; fi
if [ ! -d "$HOME/.icons/" ]; then mkdir -p "$HOME/.icons/"; fi
local APPIMAGE
APPIMAGE=$(zenity --file-selection --title="Select an AppImage")
if [ -z "$APPIMAGE" ]; then clear; echo 'Error'; return; fi
local ICON_NAME="$(basename "${APPIMAGE%.*}").png"
7z e "$APPIMAGE" '*.png' -so > ~/.icons/"$ICON_NAME"
local DESKTOP_FILE="$HOME/.local/share/applications/$(basename "${APPIMAGE%.*}").desktop"
cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$(basename "${APPIMAGE%.*}")
Exec="$APPIMAGE" %U
Icon=$HOME/.icons/$ICON_NAME
Terminal=false
Type=Application
Categories=Utility;
EOL
chmod +x "$APPIMAGE"
update-desktop-database ~/.local/share/applications/
echo -e "------------------------------------------\n Icon extracted as:\n ~/.icons/$ICON_NAME\nDesktop entry created at:\n $DESKTOP_FILE\n------------------------------------------"
}
