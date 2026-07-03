htb() {
    local box_name="${(L)1}"
    local box_ip="$2"
    local box_dir="$HOME/htb/$box_name"

    if [ -z "$box_name" ] || [ -z "$box_ip" ]; then
        echo "[!] Usage: htb <box_name> <box_ip>"
        return 1
    fi

    local lhost="$(ip -4 addr show tun0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"

    if [ -z "$lhost" ]; then
        echo "[!] VPN is not connected"
        return 1
    fi

    echo "[*] Pinging box..."
    local ping_output="$(ping -c 1 -W 2 "$box_ip" 2>/dev/null)"
    local box_ttl="$(echo "$ping_output" | grep -oP 'ttl=\d+' | awk -F'=' '{print $2}')"

    if [ -z "$box_ttl" ]; then
        echo "[!] $box_name is not reachable"
        return 1
    fi

    local box_os="Unknown"

    if [ "$box_ttl" -le 64 ]; then
        box_os="Linux"
    elif [ "$box_ttl" -le 128 ]; then
        box_os="Windows"
    fi

    if grep -qiw "$box_name" /etc/hosts; then
        echo "[*] Updating $box_name.htb IP in /etc/hosts..."
        sudo sed -i -E "s/^.*\b$box_name\.htb\b.*/$box_ip ${box_name}.htb/I" /etc/hosts
    else
        echo "[*] Adding $box_name.htb to /etc/hosts..."
        echo "$box_ip ${box_name}.htb" | sudo tee -a /etc/hosts > /dev/null
    fi

    echo "[*] Preparing work directory..."
    mkdir -p $box_dir/{nmap,scans,exploits,content}
    cd $box_dir || return 1

    echo "export BOX='$box_name' RHOST='$box_ip'; export LHOST='$lhost'" > "$HOME/.custom_env"

    source "$HOME/.custom_env"

    local R='\033[1;31m'
    local W='\033[1;37m'
    local NC='\033[0m'

    echo -e "${R}[*]-----------------------------------------[*]${NC}"
    echo -e "    Box Name   : ${W}$box_name${NC}"
    echo -e "    Box OS     : ${W}$box_os${NC} (TTL $box_ttl)"
    echo -e "    RHOST      : ${W}$box_ip${NC}"
    echo -e "    LHOST      : ${W}$lhost${NC}"
    echo -e "    Workdir    : ${W}$box_dir${NC}"
    echo -e "${R}[*]-----------------------------------------[*]${NC}"
}