#! /bin/bash

# curl -sA "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" https://finance.yahoo.com/ | grep -Eo "\"regularMarketPrice\":{\"raw\":[0-9,\.]+" | grep -Eo "[0-9,\.][^,]+"

BLACK=`tput setaf 16`
RED=`tput setaf 1`
GREEN=`tput setaf 46`
ORANGE_BROWN=`tput setaf 3`
BLUE=`tput setaf 4`
PURPLE=`tput setaf 5`
CYAN=`tput setaf 6`
LIGHT_GRAY=`tput setaf 7`
DARK_GRAY=`tput setaf 8`
LIGHT_RED=`tput setaf 9`
LIGHT_GREEN=`tput setaf 10`
YELLOW=`tput setaf 11`
LIGHT_BLUE=`tput setaf 12`
LIGHT_PURPLE=`tput setaf 13`
LIGHT_CYAN=`tput setaf 14`
WHITE=`tput setaf 15 bold smul`
NOCOLOR=`tput init`

function color_test(){
    echo  "${BLACK}black, ${RED}red, ${GREEN}green"
    echo  "${ORANGE_BROWN}orange_brown, ${BLUE}blue, ${PURPLE}purple"
    echo  "${LIGHT_RED}light_red, ${LIGHT_GREEN}light_green, ${YELLOW}yellow"
    echo  "${LIGHT_GRAY}light_gray, ${DARK_GRAY}dark_grey, ${CYAN}cyan"
    echo  "${LIGHT_BLUE}light_blue, ${LIGHT_PURPLE}light_purple, ${LIGHT_CYAN}light_cyan"
    echo  "${WHITE}white"
    echo "${NOCOLOR}no_color"
}


function extract_temperature()
{
    temperature=$(echo "$1" | grep -Eo "\"temp\":\"[°0-9]+" | grep -Eo "[0-9°]+")
    echo "$temperature"
}

function extract_weather()
{
    weather=$(echo "$1" | grep -Eo "<span class=\"phrase\">[A-Za-z ]+" | grep -Eo ">[A-Za-z ]+" | grep -Eo "[A-Za-z ]+")
    echo "$weather"
}

function map_weather_to_color()
{
    weather=$(extract_weather "$1")
    weather="${weather,,}"
    if [[ "${weather,,}" =~ "sunny" ]]; then
	echo "${YELLOW}$weather$NOCOLOR"
    elif [[ "${weather,,}" =~ "snow" ]]; then
	echo "$CYAN$weather$NOCOLOR"
    elif [[ "${weather,,}" =~ "rain" ]]; then
	echo "$BLUE$weather$NOCOLOR"
    elif [[ "${weather,,}" =~ "cloud" ]]; then
	echo "${DARK_GRAY}$weather$NOCOLOR"
    elif [[ "${weather,,}" =~ "clear" ]]; then
	echo "$LIGHT_GREEN$weather$NOCOLOR"
    elif [[ "${weather,,}" =~ "fog" ]]; then
	echo "$LIGHT_GRAY$weather$NOCOLOR"
    else
	echo "$unknown weather: $weather"
    fi
}


function get_yahoo_finance_active_tickers()
{
    yahoo_finance=$(curl -sA "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" https://finance.yahoo.com/ | grep -Eo "fin-trending-tickers.+-- HTML_TAG_END" )
    active_tickers=$(echo "$yahoo_finance" | grep -Eo "symbol\":\"[\^A-Z\.]+\"" | cut -c 10- |  sed 's/.\{1\}$//' | head -n 5)
    active_tickers_value=$(echo "$yahoo_finance" |  grep -Eo "regularMarketPrice\":{\"raw\":[0-9\.,]+," | cut -c 28- |  sed 's/.\{1\}$//') 
    active_tickers_perct_change=$(echo "$yahoo_finance" | grep -Eo "regularMarketChangePercent\":{\"raw\":(-[\.,0-9]+|[\.,0-9]+),\"fmt\":\"(-[\.,0-9]+|[\.,0-9]+)%" | grep -Eo "\fmt\".+" | cut -c 7-)
    first_ticker_pct_change=$(echo "$active_tickers_perct_change" | sed '1q;d')
    second_ticker_pct_change=$(echo "$active_tickers_perct_change" | sed '2q;d')
    third_ticker_pct_change=$(echo "$active_tickers_perct_change" | sed '3q;d')
    fourth_ticker_pct_change=$(echo "$active_tickers_perct_change" | sed '4q;d')
    fith_ticker_pct_change=$(echo "$active_tickers_perct_change" | sed '5q;d')

    truncate -s 0 "/etc/gmorning/tickers.txt"
    echo  "TICKER|VALUE|LAST VALUE CHANGE" >> "/etc/gmorning/tickers.txt"
    echo "$(echo "$active_tickers" | sed '1q;d')|$(echo "$active_tickers_value" | sed '1q;d')|$(map_percentchange_to_color "$first_ticker_pct_change")" >> "/etc/gmorning/tickers.txt"
    echo "$(echo "$active_tickers" | sed '2q;d')|$(echo "$active_tickers_value" | sed '2q;d')|$(map_percentchange_to_color "$second_ticker_pct_change")" >> "/etc/gmorning/tickers.txt"
    echo "$(echo "$active_tickers" | sed '3q;d')|$(echo "$active_tickers_value" | sed '3q;d')|$(map_percentchange_to_color "$third_ticker_pct_change")" >> "/etc/gmorning/tickers.txt"
    echo "$(echo "$active_tickers" | sed '4q;d')|$(echo "$active_tickers_value" | sed '4q;d')|$(map_percentchange_to_color "$fourth_ticker_pct_change")" >> "/etc/gmorning/tickers.txt"
    echo "$(echo "$active_tickers" | sed '5q;d')|$(echo "$active_tickers_value" | sed '5q;d')|$(map_percentchange_to_color "$fith_ticker_pct_change")" >> "/etc/gmorning/tickers.txt"
    column "/etc/gmorning/tickers.txt" -t -s "|"
}

function map_percentchange_to_color()
{
  #  if [[ "$1" =~ "+" ]]; then
#	echo -e "$GREEN$1$NOCOLOR"
     if [[ "$1" =~ "-" ]]; then
	echo -e "$RED$1$NOCOLOR"
    else
	echo -e "$GREEN+$1$NOCOLOR"
    fi
}
function get_time_greeting()
{
    noon_threshold="$(date -d '12:00' +'%s')"
    evening_threshold="$(date -d '17:00' +'%s')"
    night_threshold="$(date -d '21:00' +'%s')"
    early_morning_threshold="$(date -d '04:00' +'%s')"
    current_time="$(date +'%s')" 
    if [ "${current_time}" -ge "${night_threshold}" ] || [ "${current_time}" -le "${early_morning_threshold}" ]; then
	echo "night"
    elif [ "${current_time}" -le "${noon_threshold}" ]  ; then
	echo "morning"
    elif [ "${current_time}" -le  "${evening_threshold}" ]; then
	echo "afternoon"
    elif [ "${current_time}" -le  "${night_threshold}" ]; then
	echo "evening"
    
    fi
    
	
}

function get_current_news()
{
    news=$(curl -sA "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" https://edition.cnn.com/world)
    current_news_line=$(echo "$news" | grep -En "<span class=\"container__headline-text\" data-editable=\"headline\">" | cut -c 70- | sed 's/.\{7\}$//' | head -n 10 | grep -vE "editable=\"headline\">")
    #current_news=$(echo "$news" | sed -n "${current_news_line},6000p" | grep -Eo "<span class=\"container__headline-text\" data-editable=\"headline\">[^<]+" | sed -n '3,8p' | cut -c 65-)
    echo "$current_news_line"
}

function gmorning ()
{
    if [ -d "/etc/gmorning/" ]; then
	city_url=$(cat /etc/gmorning/city_url.txt)
	city_txt=$(curl -sA "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" "$city_url")
	echo "Good $(get_time_greeting), $(whoami). Today's weather is currently $(map_weather_to_color "$city_txt"), with a temperature of $(extract_temperature "$city_txt") celsius"
	echo "Current major headlines are:"
	echo "--------------------------------"
	echo "$(get_current_news)"
	echo "--------------------------------"
	echo "Here are the most trending tickers on Yahoo Finance:"
	echo "$(get_yahoo_finance_active_tickers)"
    else
	echo "Couldn't find config file - please run gmorning_setup.sh first"
    fi
    

}


gmorning
#This will cause a prompt that warns the user when attempting to close the terminal, but this was the most elegant solution to prevent the terminal from automatically closing once the process terminates
$SHELL
