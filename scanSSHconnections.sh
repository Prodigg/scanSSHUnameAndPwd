#!/bin/bash

#Copyright © 2025 Raphael Sauer
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

echo "Scan for ssh with User and Password"
echo "Copyright © 2025 Raphael Sauer"
echo -e "\n\n"

read -p "User: " user
read -s -p "Password: " password

echo -e "\n${NC}[*] start Nmap scan..."
ipAdresses=`nmap 192.168.107.0/24 -T4 -p 22 --open | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

echo -e "${GREEN}[+] Nmap finished"

ipAdressCount=`echo "$ipAdresses" | wc -l`
echo -e "${NC}[*] ipAdresses Found: $ipAdressCount"

mapfile -t lines <<< "$ipAdresses"

for line in "${lines[@]}"; do
  echo -e "${NC}[*] trying ip Adress: $line"
  sshpass -p$password ssh -o StrictHostKeyChecking=accept-new $user@$line exit 2> /dev/null > /dev/null
  if [ "$?" -eq 0 ]; then
    echo -e "${GREEN}[+] connection succsessfull IP: $line"
    echo -e "${NC}[*] exiting..."
    exit 0
  else 
    echo -e "${RED}[-] connection failed..."
  fi   
done

echo -e "${RED}[-] no connection found..."
echo -e "${NC}[*] exiting..."
exit 255
