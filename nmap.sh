#!/bin/bash

# Check if IP address is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

# Function to run scan based on user's choice
run_scan() {
    ip=$1
    echo "Select protocol:"
    echo "1. UDP"
    echo "2. TCP"
    echo "======================================"
    echo "Select port range:"
    echo "a. All ports"
    echo "b. Top 100 ports"
    echo "c. Top 1000 ports"
    echo "d. Top 10000 ports"
    read -p "Enter your choice: " input
    a="${input:0:1}"
    b="${input:1:1}"
    echo -e "\e[1;35m================INITIAL SCAN================\e[0m"
   if [ "$a" = "1" ]; then
    case $b in
    a) echo -e "\033[32mRunning sudo nmap -sU -Pn -T4 -p- $ip\033[0m" && sudo nmap -sU -Pn -T4 -p- $ip | tee syn_scan_result.txt;;
    b) echo -e "\033[32mRunning sudo nmap -sU -Pn -T4 --top-ports 100 $ip\033[0m" && sudo nmap -sU -Pn -T4 --top-ports 100 $ip | tee syn_scan_result.txt;;
    c) echo -e "\033[32mRunning sudo nmap -sU -Pn -T4 --top-ports 1000 $ip\033[0m" && sudo nmap -sU -Pn -T4 --top-ports 1000 $ip | tee syn_scan_result.txt;;
    d) echo -e "\033[32mRunning sudo nmap -sU -Pn -T4 --top-ports 10000 $ip\033[0m" && sudo nmap -sU -Pn -T4 --top-ports 10000 $ip | tee syn_scan_result.txt;;
    *) echo "Wrong option input";;
    esac

   elif [ "$a" = "2" ]; then
    case $b in
    a) echo -e "\033[32mRunning sudo nmap -sS -Pn -T4 -p- $ip\033[0m" && sudo nmap -sS -Pn -T4 -p- $ip | tee syn_scan_result.txt;;
    b) echo -e "\033[32mRunning sudo nmap -sS -Pn -T4 --top-ports 100 $ip\033[0m" && sudo nmap -sS -Pn -T4 --top-ports 100 $ip | tee syn_scan_result.txt;;
    c) echo -e "\033[32mRunning sudo nmap -sS -Pn -T4 --top-ports 1000 $ip\033[0m" && sudo nmap -sS -Pn -T4 --top-ports 1000 $ip | tee syn_scan_result.txt;;
    d) echo -e "\033[32mRunning sudo nmap -sS -Pn -T4 --top-ports 10000 $ip\033[0m" && sudo nmap -sS -Pn -T4 --top-ports 10000 $ip | tee syn_scan_result.txt;;
    *) echo "Wrong option input";;
    esac

   else
    echo "Wrong option input"
   fi
   
   
       # Extract all open ports from the scan result and format as a comma-separated list
    case $a in
    1) open_ports=$(grep -oP '\d+/udp\s+open' syn_scan_result.txt | cut -d '/' -f 1 | paste -sd ',' -);;
    2) open_ports=$(grep -oP '\d+/tcp\s+open' syn_scan_result.txt | cut -d '/' -f 1 | paste -sd ',' -);;
    esac
    rm syn_scan_result.txt  # Remove temporary file
    run_detailed_scan $ip "$open_ports"
}

# Function to run detailed scan on open ports
run_detailed_scan() {
    echo -e "\e[1;35m===============DETAILED SCAN===============\e[0m"
    ip=$1
    open_ports=$2
    echo -e "\033[32mRunning sudo nmap -A -Pn -p $open_ports $ip\033[0m"
    sudo nmap -A -Pn -p $open_ports $ip
}

# Run script
run_scan $1
