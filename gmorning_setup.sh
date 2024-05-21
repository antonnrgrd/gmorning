
function gmorning_setup_script ()
{
    read -p "Please enter a URL for the city you want to get weather updates on " url
    if [ ! -d "/etc/gmorning/" ]; then
	sudo mkdir "/etc/gmorning/"
	chmod 755 "/etc/gmorning/"
	fi
    echo "$url" > "/etc/gmorning/city_url.txt"
    chmod 755 "/etc/gmorning/city_url.txt"
}

#function gmorning_set_url ()
#{
#
#}

gmorning_setup_script
