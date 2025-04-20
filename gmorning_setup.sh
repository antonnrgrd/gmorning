
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

    if [ ! -d "/home/$user/.config/autostart" ]; then
	mkdir "/home/$user/.config/autostart"
	chown "$user:" "/home/$user/.config/autostart"
    fi
    # Bad practice to leave in old code as out-commented, but in case using .profile decides to start working again, it's more
    # elegant to use this approach, so we will "save" it for later, just in case.
    # grep -v "gnome-terminal -- \"gmorning.sh\""  "/home/$user/.profile" > tmpfile && mv tmpfile "/home/$user/.profile"
    # sudo echo "gnome-terminal -- \"gmorning.sh\"" >> "/home/$user/.profile"
    if [ -f "/home/$user/.config/autostart/gmorning.desktop" ]; then
	echo "File /home/$user/.config/autostart/gmorning.desktop already exists. Overwrite it with the contents of the gmorning script [y/n] ?"
	read selection
	if [ "$selection" = "y" ]; then
	    echo "[Desktop Entry]
Type=Application
Exec=gnome-terminal -- \"gmorning.sh\"
Hidden=false
NoDisplay=false X-GNOME-Autostart-enabled=true
Name[en_US]=Terminal
Name=Terminal Comment[en_US]=Start Terminal on startup
Comment=Start Terminal on startup" > "/home/$user/.config/autostart/gmorning.desktop"
	    chown "$user" "/home/$user/.config/autostart/gmorning.desktop"
	    echo "Overwrote /home/$user/.config/autostart/gmorning.desktop"
	else
	    echo "Skipped overwriting contents of /home/$user/.config/autostart/gmorning.desktop. Note that as a consequence, gmorning might not work."
	fi
	
    else
	echo "[Desktop Entry]
Type=Application
Exec=gnome-terminal -- \"gmorning.sh\"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Terminal
Name=Terminal
Comment[en_US]=Start Terminal on startup
Comment=Start Terminal on startup" > "/home/$user/.config/autostart/gmorning.desktop"
	chown "$user" "/home/$user/.config/autostart/gmorning.desktop"
    fi
    chmod +x gmorning.sh ; cp gmorning.sh /bin/
}

gmorning_setup_script
