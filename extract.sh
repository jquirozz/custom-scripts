# sudo apt update && sudo apt install xclip -y

extract() {
    if [ -z "$1" ] || [ ! -f "$1" ]; then
        echo "[!] Usage: extract <nmap_grep_file>"
        return 1
    fi

    local ports="$(grep -oP '\d{1,5}/open' "$1" | cut -d'/' -f1 | paste -sd, -)"

    if [ -z "$ports" ]; then
        echo "[!] No open ports found"
        return 1
    fi

    echo "[*] Open ports: $ports"
    echo -n "$ports" | xclip -sel clip 2>/dev/null
    echo "[*] Ports copied to clipboard"
}