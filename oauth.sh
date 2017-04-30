#!/usr/bin/env sh

CODE="4/v6xr77ewYqhvHSyW6UJ1w7jKwAzu&amp"
CLEINTID="1234567890.apps.googleusercontent.com"
HEADER="Content-Type: application/x-www-form-urlencoded"
CLIENTSECRET="aBcDeFgHiJkLmNoPqRsTuVwXyZ"
REDIRECTURI="urn:ietf:wg:oauth:2.0:oob"

# I keep the ACCESS_TOKEN and the REFRESH_TOKEN in a file.
if [ -s ~/.google ];then
  ACCESS_TOKEN=$(cat ~/.gauth | grep access_token | awk -F"," '{print $2}' | tr -d ' ')
  REFRESH_TOKEN=$(cat ~/.gauth | grep refresh_token | awk -F"," '{print $2}' | tr -d ' ')
else
  # not used before
  NEWTOKEN=$(curl -s -d "code=$CODE&redirect_uri=$REDIRECTURI&client_id=$CLEINTID&scope=&client_secret=$CLIENTSECRET&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token)
  ACCESS_TOKEN=$(echo $NEWTOKEN | awk -F"," '{print $1}' | awk -F":" '{print $2}' | sed s/\"//g | tr -d ' ')
  REFRESH_TOKEN=$(echo $NEWTOKEN | awk -F"," '{print $4}' | awk -F":" '{print $2}' | sed s/\"//g | sed s/}// | tr -d ' ')
  echo access_token , $ACCESS_TOKEN > .google
  echo refresh_token , $REFRESH_TOKEN >> .google
fi
EXPIRED=$(curl -s https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$ACCESS_TOKEN | grep 'invalid_token')
if [ "$EXPIRED" ]
then
  echo "EXPIRED"
  REFRESHRETURN=$(curl -s -d "client_secret=$CLIENTSECRET&grant_type=refresh_token&refresh_token=$REFRESH_TOKEN&client_id=$CLEINTID" https://accounts.google.com/o/oauth2/token)
  ACCESS_TOKEN=$(echo $REFRESHRETURN | awk -F"," '{print $1}' | awk -F":" '{print $2}' | sed s/\"//g | tr -d ' ')
  echo access_token , $ACCESS_TOKEN > .gauth
  echo refresh_token , $REFRESH_TOKEN >> .gauth
fi
AUTH=$ACCESS_TOKEN
# now in your curl code to retrieve the google analytics data, you use --header "Authorization: OAuth $AUTH"
