subdom() {
    local sub="$1"

    if [ -z "$sub" ]; then
        echo "[!] Usage: subdom <subdomain_name>"
        return 1
    fi

    if [ -f "$HOME/.custom_env" ]; then
        source "$HOME/.custom_env"
    fi

    if [ -z "$RHOST" ] || [ -z "$BOX" ]; then
        echo "[!] Error: Environment variables not found"
        return 1
    fi

    local full_domain="${sub}.${BOX}.htb"

    if grep -qiw "$full_domain" /etc/hosts; then
        echo "[!] $full_domain already exists in /etc/hosts"
        return 0
    fi

    echo "[*] Adding $full_domain to /etc/hosts..."
    echo "$RHOST $full_domain" | sudo tee -a /etc/hosts > /dev/null
}