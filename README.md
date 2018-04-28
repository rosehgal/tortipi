# Tor-Ti-Pi
```
       _==/          i     i          \==_
     /XX/            |\___/|            \XX\
   /XXXX\            |XXXXX|            /XXXX\
  |XXXXXX\_         _XXXXXXX_         _/XXXXXX|
 XXXXXXXXXXXxxxxxxxXXXXXXXXXXXxxxxxxxXXXXXXXXXXX
|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                             BATMAN uses TOR
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                 Do You ?
|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|
 XXXXXX/^^^^"\XXXXXXXXXXXXXXXXXXXXX/^^^^^\XXXXXX
  |XXX|       \XXX/^^\XXXXX/^^\XXX/       |XXX|
    \XX\       \X/    \XXX/    \X/       /XX/
       "\       "      \X/      "      /" 

```
TorTiPi is a tool to setup the **Tor based wifi hotspot**  on Raspberry Pi Model 3. This tool can also work with the other models on Raspberry but would require exteranl wifi  adapter plugged into RP, which would be helpful to create access point.  
At this point **TTP** provides extremly simple but complete setup to create Tor network access point.  
I will not mention that why should one use [Tor](https://en.wikipedia.org/wiki/Tor_(anonymity_network)) if you are curious to know [this blog post](https://www.eff.org/deeplinks/2014/06/why-you-should-use-tor) is a good read.  
**If you really want to get your hands dirty with anonymity**, then lets gets started.    

Let `TorTiPi` do it.
---
TorTiPi setups everything for you. But How ??  
```bash
git clone https://github.com/r0hi7/tortipi.git
cd tortipi
chmod +x setup.sh
./setup.sh
```
Only 4 simple commands. :smile:  
At the end of the installation, a Access point named as **TorTiPi** will be up and its default password would be **changeme**.
If you want to change deafult password, TorTiPi simplifies that too for you.  

Changing the Configurations.
---
The [hostapd.config](/hostapd.config) file in this repo needs to be changed before the running setup script.
```
interface=wlan0
ssid=TortiPi
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=changeme
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```
If you notice the content are very simple key value pair. For our concern we need to focus on **ssid** and **wpa_passphrase**. The first one specifies the name of your wifi hotspot and the latter one chnages the password for AP.
Once the changes have been made, save the file and run `./setup.sh`.  
If you have already ran setup script. Donot rerun the script after changing. Rather modify the file `/etc/hostapd/hostapd.conf`. This file also have same parameter as to the one in [hostapd.config](/hostapd.config). After making the changes restart the hostapd service.  
`service hostapd restart`
