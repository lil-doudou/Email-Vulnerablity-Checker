#!/bin/bash

function banner() {
  echo ""
  echo -e "  \033[0;31mThis Email-Vulnerablity-Checker\e Was Created By \e[1;32mBLACK-SCORP10 \e"
  echo ""
  echo -e "\e[1;34m               For Any Queries Join Me!!!\e[0m"
  echo -e "\e[1;32m           Telegram: https://t.me/BLACK-SCORP10 \e[0m"
  echo ""
  echo ""
}

# Check if the -h option was provided to show the help section
function usage() {

  echo ""
  echo "Usage: ./spfvuln.sh [-h] [-v] [-t targetfile] [-verbose] [domain]"
  echo "Check if a domain is vulnerable to email spoofing"
  echo ""
  echo "  -h | --help             Show this help section"
  echo "  -v                      Show the tool version"
  echo "  -t | --target <file>    Use a text file containing a list of domains to check"
  echo "  --verbose               Run the tool in verbose mode"
  echo "  domain                  The domain to check (if not using the -t option)"
  echo ""
  echo "Examples: $ ./spfvuln.sh example.com"
  echo "	  $ ./spfvuln.sh -t targets.txt"
  echo "	  $ ./spfvuln.sh -t targets.txt --verbose"
  echo "	  $ ./spfvuln.sh example.com --verbose"
  echo ""
  exit 0
}

function log() {
  echo -e "$@"
  if [[ ${VERBOSE} == 1 ]]; then
      echo "SPF record: $spf_record"
  fi
}

# Check if the -v option was provided to show the tool version
function version() {
  echo "Email-Vulnerablity-checker v1.0.1"
  exit 0  
}


function target() {
    # Check if a target file was provided
    if [ -z "$1" ]; then
      echo "Error: No target file provided, use -h for help"
      exit 1
    fi

    # Check if the target file exists
    if [ ! -f "$1" ]; then
      echo "Error: Target file not found, use -h for help"
      exit 1
    fi

    # Read the domains from the target file
    while IFS= read -r domain; do
      # Check if the domain is valid using a regular expression
      if ! [[ $domain =~ ^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$ ]]; then
        echo "Error: Invalid domain '$domain'"
        continue
      fi

      # Check if the domain has a SPF record
      spf_record=$(dig +short TXT "$domain" | grep "v=spf1")
      if [ -z "$spf_record" ]; then

        # Check if the -verbose option was provided to show the SPF record
          log "The domain '$domain' does not have a SPF record and is \033[0;31mvulnerable\e[0m to email spoofing"          
      else
        # Check if the -verbose option was provided to show the SPF record
          log "The domain '$domain' has a SPF record and is \e[1;32mnot vulnerable\e[0m to email spoofing"
      fi
    done < "$1"
}

function single_domain() {
  # Check if the domain is valid using a regular expression
  if ! [[ $1 =~ ^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$ ]]; then
    echo "Error: Invalid domain '$1'"
    exit 1
  fi

  # Check if the domain has a SPF record
  spf_record=$(dig +short TXT "$1" | grep "v=spf1")
  if [ -z "$spf_record" ]; then
    # Check if the -verbose option was provided to show the SPF record
      log "The domain '$1' does not have a SPF record and is \033[0;31mvulnerable\e[0m to email spoofing"
  else
    # Check if the -verbose option was provided to show the SPF record
      log "The domain '$1' has a SPF record and is \e[1;32mnot vulnerable\e[0m to email spoofing"
  fi
}

while [ $# -gt 0 ]; do
  case $1 in
    -h | --help)
      usage
      ;;
    --verbose)
      VERBOSE=1
      ;;
    -v | --version)
      version
      ;;
    -t | --target)
      target_file="$2"
      ;;
    *)
      domain="$1"
    ;;
  esac
  shift
done

banner

if [[ -n ${target_file} ]]; then
  target "$target_file"
fi

if [[ -n ${domain} ]]; then
  single_domain "$domain"
fi

exit 0

# This code is made and owned by BLACK-SCORP10.
# Feel free to contact me at https://t.me/BLACK-SCORP10