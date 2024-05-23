
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
    #A hack to make the script setup idempotent - remove the line in .profile that specifies to run the script before adding it 
    grep -v "gnome-terminal -- \"gmorning.sh\""  "/home/$user/.profile" > tmpfile && mv tmpfile "/home/$user/.profile"
    sudo echo "gnome-terminal -- \"gmorning.sh\"" >> "/home/$user/.profile"
}

gmorning_setup_script
