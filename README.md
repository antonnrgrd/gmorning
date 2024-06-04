

# What is gmorning?
gmorning is a script that upon logging in for the first time after a reboot, will open up a terminal and print the three following pieces of information:

1. Current weather for a city of interest.
2. Latest international news from CNN.
3. The most active tickers on Yahoo Finance.

## How does it work?
When the setup script is run, the script will create a folder named gmorning in the /etc/ folder, that is to say, the following filepath is created

- /etc/gmorning/

In said folder, two text files are created
- city_url.txt
- tickers.txt

The city_url.txt is a text file contatining the url of a city that the user wants weather updates from.

The tickers.txt is also a text file, containing the ticker information scraped from Yahoo Finance.

Finally, the setup script adds a line to the provided user's .profile, that specifies that upon logging in after a reboot, a new terminal should be opened up and the script itself, gmorning.sh, should be run.

The gmorning.sh script itself is also added to /bin/, to make execution of the script more easy.

### How does the script execution work?

When logging in for the first time after boot, the setup in the targeted user's .profile will open up a new terminal and run the script itself. 

The script will run a curl against the city stored in the url, in the city_url.txt file and grep against the weather and temperature, printing them to standard output. The weather is color-coded to differentiate between the different type of weathers s.t for example, if it is sunny, the text is yellow, if it is rainy, blue and so forth.

Next, it will curl against cnn and grep against the latest global news.

Finally, it will curl against Yahoo Finance and fetch the most active tickers using grep. Like the weather, it color codes the last percentage-wise change in the value of the tickers. If it is a positive change, the value will be printed in a green color, if it is negative, it will be printed in a red color.

To simplify the pretty printing, the output is first saved to the tickers.txt file, then the column command is used to print it out again.

# Who is gmorning intended for ?
It it intended for Linux machines that are for personal use. It is not designed for servers or other types of setups where one computer is shared among several users.
## Setting up the script

To set up the script, first clone it from github:

```git clone https://github.com/antonnrgrd/gmorning```

Next, navigate into the folder and run the setup script:


```sudo bash gmorning_setup.sh```

You will then be prompted for two pieces of information. The first piece of information is the url of the city that you want the weather updates from :

![Screenshot from 2024-05-27 14-34-01](https://github.com/antonnrgrd/gmorning/assets/87760081/d1515014-4176-4cbe-a71a-23f5019e5fa2)


To do this, go to  [https://www.accuweather.com/](https://www.accuweather.com/) and find the city that you want weather updates from. Then copy + paste the url of the city as the first argument

![Screenshot from 2024-05-27 13-24-21](https://github.com/antonnrgrd/gmorning/assets/87760081/87e84e46-f467-4049-8348-93331219f799)

![Screenshot from 2024-05-27 17-06-00](https://github.com/antonnrgrd/gmorning/assets/87760081/8f2d730c-246e-4dee-915a-3ec03d496395)

Next, provide the username of the user that you want to set up. In my case, I am setting it up for myself, so i will provide my own username

![Screenshot from 2024-05-27 17-08-56](https://github.com/antonnrgrd/gmorning/assets/87760081/b8d1d7d3-15d9-402b-8431-f629028866f7)

To then smoketest the script, run


```gmorning.sh```

If it runs correctly, you should see something along the lines of this output

![Screenshot from 2024-05-27 17-10-23](https://github.com/antonnrgrd/gmorning/assets/87760081/3b87da3a-ee5d-47b0-bbef-a8299392171b)



