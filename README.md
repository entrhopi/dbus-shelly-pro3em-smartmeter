# dbus-shelly-3em-smartmeter
Integrate Shelly 3EM smart meter into [Victron Energies Venus OS](https://github.com/victronenergy/venus)

## Purpose
With the scripts in this repo it should be easy possible to install, uninstall, restart a service that connects the Shelly 3EM to the VenusOS and GX devices from Victron.
Idea is pasend on @RalfZim project linked below.



## Inspiration
This project is my first on GitHub and with the Victron Venus OS, so I took some ideas and approaches from the following projects - many thanks for sharing the knowledge:
- https://github.com/RalfZim/venus.dbus-fronius-smartmeter
- https://github.com/victronenergy/dbus-smappee
- https://github.com/Louisvdw/dbus-serialbattery
- https://community.victronenergy.com/idea/114716/power-meter-lib-for-modbus-rtu-based-meters-from-a.html - [Old Thread](https://community.victronenergy.com/questions/85564/eastron-sdm630-modbus-energy-meter-community-editi.html)

## How it works
### My setup
- Shelly Pro 3EM with latest firmwar
  - 3-Phase installation (normal for Germany)
  - Connected to LAN Network "A"
  - IP 172.16.3.251/24  
- Victron Energy Multiplus 2 with Venus OS
  - No other devices from Victron connected
  - Connected to LAN Network "A"
  - IP 192.168.3.50/24

### Details / Process
As mentioned above the script is inspired by @RalfZim fronius smartmeter implementation.
So what is the script doing:
- Running as a service
- connecting to DBus of the Venus OS `com.victronenergy.grid.http_40` or `com.victronenergy.pvinverter.http_40`
- After successful DBus connection Shelly 3EM is accessed via REST-API - simply the /status is called and a JSON is returned with all details
  A sample JSON file from Shelly 3EM can be found [here](docs/shelly3em-status-sample.json)
- Serial/MAC is taken from the response as device serial
- Paths are added to the DBus with default value 0 - including some settings like name, etc
- After that a "loop" is started which pulls Shelly 3EM data every 750ms from the REST-API and updates the values in the DBus

Thats it 😄

### Pictures
![Tile Overview](img/venus-os-tile-overview.PNG)
![Remote Console - Overview](img/venus-os-remote-console-overview.PNG) 
![SmartMeter - Values](img/venus-os-shelly3em-smartmeter.PNG)
![SmartMeter - Device Details](img/venus-os-shelly3em-smartmeter-devicedetails.PNG)




## Install & Configuration
### Get the code
Just grap a copy of the main branche and copy them to `/data/dbus-shelly-pro3em-smartmeter`.
After that call the install.sh script.

The following script should do everything for you:
```
opkg update
opkg install git
git clone https://github.com/entrhopi/dbus-shelly-pro3em-smartmeter.git /data/dbus-shelly-pro3em-smartmeter
/data/dbus-shelly-pro3em-smartmeter/install.sh
```
⚠️ Check configuration after that - because service is already installed an running and with wrong connection data (host, username, pwd) you will spam the log-file

### Change config.ini
Within the project there is a file `/data/dbus-shelly-pro3em-smartmeter/config.ini` - just change the values - most important is the host, username and password in section "ONPREMISE". More details below:

| Section  | Config vlaue | Explanation |
| ------------- | ------------- | ------------- |
| DEFAULT  | AccessType | Fixed value 'OnPremise' |
| DEFAULT  | SignOfLifeLog  | Time in minutes how often a status is added to the log-file `current.log` with log-level INFO |
| DEFAULT  | CustomName  | Name of your device - usefull if you want to run multiple versions of the script |
| DEFAULT  | DeviceInstance  | DeviceInstanceNumber e.g. 40 |
| DEFAULT  | Role | use 'GRID' or 'PVINVERTER' to set the type of the shelly 3EM |
| DEFAULT  | Position | Available Postions: 0 = AC, 1 = AC-Out 1, AC-Out 2 |
| DEFAULT  | LogLevel  | Define the level of logging - lookup: https://docs.python.org/3/library/logging.html#levels |
| ONPREMISE  | Host | IP or hostname of on-premise Shelly 3EM web-interface |
| ONPREMISE  | Username | Username for htaccess login - leave blank if no username/password required |
| ONPREMISE  | Password | Password for htaccess login - leave blank if no username/password required |

## Used documentation
- https://github.com/victronenergy/venus/wiki/dbus#grid   DBus paths for Victron namespace GRID
- https://github.com/victronenergy/venus/wiki/dbus#pv-inverters   DBus paths for Victron namespace PVINVERTER
- https://github.com/victronenergy/venus/wiki/dbus-api   DBus API from Victron
- https://www.victronenergy.com/live/ccgx:root_access   How to get root access on GX device/Venus OS

## Discussions on the web
This module/repository has been posted on the following threads:
- https://community.victronenergy.com/questions/125793/shelly-3em-smartmeter-with-venusos-cerbo-gx.html
