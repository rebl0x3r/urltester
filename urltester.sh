#!/bin/bash
# Simple URL Test Script

# Colors

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"
MAGENTA="\e[35m"

# Variables

file=""
path=$(pwd)
useragent="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36"

# Banner

clear
echo -e "${BOLD}${GREEN}"
figlet UrlTester
echo -e "			${MAGENTA}by @MrBlackx"
echo -e "                                   ${BLUE}v${RED}0${BLUE}.${RED}5"
echo ""
echo -e "${RED}[!] ATLEAST NOT ALL LINKS WITH PATHS ARE WORKING"
echo ""
echo ""
# File Checker

file_checker(){
  if [ -f bad_con.txt ]; then
    rm bad_con.txt
  fi
  if [ -f dead.txt ]; then
    rm dead.txt
  fi
  if [ -f live.txt ]; then
    rm live.txt
  fi
  if [ -f ddos_guard.txt ]; then
    rm ddos_guard.txt
  fi
  if [ -f redirects.txt ]; then
    rm redirects.txt
  fi
}

file_checker

# Listing All Files (For Check)

sleep 0.5
echo -e "${GREEN}[*] ${BLUE}Listing files."
sleep 0.5
echo -e "${CYAN}"
ls *.txt
echo ""
echo -ne "${YELLOW}[*] ${BLUE}Select file(${RED}urls.txt${BLUE}):${CYAN} "
read file
echo

# Configure Url List

echo -e "${GREEN}[*] ${BLUE}Configuring file..."
sleep 1
echo ""
awk '!a[$0]++' $file >> url.txt
if [ -f urls.txt ]
then
  rm urls.txt
fi 
mv url.txt urls.txt
sleep 0.5
echo -e "${GREEN}[i] ${BLUE}Done."
sleep 0.5
echo ""
sleep 0.5
echo -ne "${YELLOW}[>] ${BLUE}Press [ENTER] to continue"
read continue

# Removing All /

# BETA!

#while read line
#do
#  echo "$line" | cut -f1-3 -d"/" >> url.txt
#done < urls.txt

#if [ -f urls.txt ]
#then
#  rm urls.txt
#fi  
#mv url.txt urls.txt

# Please do not unmark it.

# Configuration

echo -e "${GREEN}[i] ${BLUE}Loading Configuration"
sleep 0.4
echo ""
echo -e "${GREEN}[*] ${BLUE}File selected -: \n${YELLOW}$file\n"
echo -e "${GREEN}[*] ${BLUE}Useragent selected -: \n${YELLOW}$useragent\n"
echo -e "${GREEN}[*] ${BLUE}Path -: \n${YELLOW}$path\n"

#cat $file | egrep -o 'https?://[^ ]+' > urls.txt
#file="urls.txt"

# Start Tester

echo -ne "${GREEN}[i] ${BLUE}Press ${RED}[ENTER] ${BLUE}To Start"
read continue
echo ""
echo ""
while IFS= read -r line
do
  code=$(curl -IskL --max-time 10 -H "$useragent" $line | head -n1 | awk '{print $2}')
  if [[ "$code" == 301 ]]; then
    echo -e "${GREEN}[>>] ${BLUE}Website ${GREEN}Live ${BLUE}but redirects: ${CYAN}$line"
    if [ -f redirects.txt ]; then
      echo $line >> redirects.txt
    else
      touch redirects.txt
      echo $line >> redirects.txt
    fi
  elif [[ "$code" == 302 ]]; then
    if [ -f live.txt ]; then
      echo $line >> live.txt
    else
      touch live.txt
      echo $line >> live.txt
    fi
  elif [[ "$code" == 200 ]]; then
    echo -e "${GREEN}[+] ${BLUE}Website ${GREEN}Live ${BLUE}: ${CYAN}$line "
    if [ -f live.txt ]; then
      echo $line >> live.txt
    else
      touch live.txt
      echo $line >> live.txt
    fi

  elif [[ "$code" == "" ]]; then
    html=$(curl -sk --max-time 10 -H "$useragent" $line | head -n1)
    if [[ "$html" == "<!DOCTYPE HTML>" ]]; then
      echo -e "${YELLOW}[-] ${BLUE}Website ${YELLOW}Live But Bad Connection${BLUE} : ${CYAN}$line "
      if [ -f bad_con.txt ]; then
        echo $line >> bad_con.txt
      else
        touch bad_con.txt
        echo $line >> bad_con.txt
      fi
    fi

  elif [[ "$code" == 403 ]]; then
    test=$(curl -Isk --max-time 10 -H "$useragent" $line | head -n2 | tail -1 | awk '{print $2}')
    if [[ "$test" == "ddos-guard" ]]; then
      echo -e "${MAGENTA}[-] ${BLUE}Live But Detected ${MAGENTA} DDoS Guard${BLUE} : ${CYAN}$line "
      if [ -f ddos_guard.txt ]; then
        echo $line >> ddos_guard.txt
      else
        touch bad_con.txt
        echo $line >> ddos_guard.txt
      fi
    fi
  elif [[ "$code" == 503 ]]; then
    echo -e "${YELLOW}[-] ${BLUE}Website ${YELLOW}Live But Bad Connection${BLUE} : ${CYAN}$line "
    if [ -f bad_con.txt ]; then
      echo $line >> bad_con.txt
    else
      touch bad_con.txt
      echo $line >> bad_con.txt
    fi

  else
    echo -e "${RED}[!] ${BLUE}Website ${RED}Dead ${BLUE}: ${CYAN}$line "
    if [ -f dead.txt ]; then
      echo $line >> dead.txt
    else
      touch dead.txt
      echo $line >> dead.txt
    fi
  fi
done < "$file"

echo -ne "${GREEN}[i] ${BLUE}Clear your url file ?[Y/N]:${YELLOW} "
read xxx

if [[ "$xxx" == "Y" || "$xxx" == "y" ]]; then
  echo "" > $file
else
  exit
fi

# End

echo ""
echo -ne "${GREEN}[i] ${BLUE}Press [ENTER] To Exit"
read exit
