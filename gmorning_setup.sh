
function gmorning_setup_script ()
{
    read -p "Enter a URL for the city you want to get weather updates on " url
    read -p "Enter the id for the user you are setting this up for " user
    if [ ! -d "/etc/gmorning/" ]; then
	sudo mkdir "/etc/gmorning/"
	chmod 755 "/etc/gmorning/"
	fi
    echo "$url" > "/etc/gmorning/city_url.txt"
    chmod 755 "/etc/gmorning/city_url.txt"
    touch "/etc/gmorning/tickers.txt" ; chmod 766 "/etc/gmorning/tickers.txt"
    sudo -u "$user" crontab -l > current_user_cron
    sudo -u "$user" echo "@reboot gnome-terminal -- \"gmorning.sh\"" >> current_user_cron
    sudo -u "$user" crontab current_user_cron
    sudo -u "$user" rm -f current_user_cron
}

gmorning_setup_script
