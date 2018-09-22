#!/usr/bin/env bash

HOST_URL="${HOST_URL-http://127.0.0.1:8000}"
DJANGO_USERNAME="${DJANGO_USERNAME-admin}"
DJANGO_PASSWORD="${DJANGO_PASSWORD-admin}"
LOGIN_URL="${HOST_URL}/login/"


function print_ok() {
    line='------------------------------------------------------------'
    printf "%s %s-- [OK]\n" "$1" "${line:${#1}}"
}


function print_fail() {
    line='------------------------------------------------------------'
    printf "%s %s [FAIL]\n" "$1" "${line:${#1}}"
    exit 1
}


function test_page_title() {
    echo "Test: Go to $1"
    if curl -s -c /tmp/cookies.txt -b /tmp/cookies.txt "$1" | grep -q '<title>'"$2"'</title>' 
    then
        print_ok "title should be '$2'"
    else
        print_fail "title should be '$2'"
    fi
}


function test_login() {
    declare csrf_token=$(awk '{ if ($6 == "csrftoken") { print $7 }}'  /tmp/cookies.txt)
    echo "Test: Login"
    curl -s -c /tmp/cookies.txt -b /tmp/cookies.txt  \
            -F csrfmiddlewaretoken="$csrf_token" \
            -F username="$1" \
            -F password="$2" \
            -X POST $LOGIN_URL

   if [[ -z "$(awk '{ if ($6 == "sessionid") { print $7 }}' /tmp/cookies.txt)" ]]; 
   then
       print_fail 'Session should be open'
   else
       print_ok 'Session should be open'
   fi
}



test_page_title  "$LOGIN_URL"  'Log in | Django site admin'
test_login "$DJANGO_USERNAME"  "$DJANGO_PASSWORD"
test_page_title  "$HOST_URL"  'Site administration | Django site admin'


rm /tmp/cookies.txt

