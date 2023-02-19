These are the scripts and config files I use to stand up minecraft servers.

# notes
screen is required, as the systemd file starts the minecraft process in a screen session.

# installation procedure

Create the minecraft user.

``sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft``

Create the server directory. 

``mkdir ~minecraft/$SERVERNAME``

Download the jar and do the initial server start.

    cd ~minecraft/$SERVERNAME
    wget https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/396/downloads/paper-<version>.jar
    ln -s paper-<version>.jar server.jar
    java -Xmx1024M -Xms1024M -jar server.jar nogui

Use [this address](https://papermc.io/downloads) to get the latest paper version.

Install the systemd script.

    sudo cp minecraft@.service /etc/systemd/system
    sudo systemctl daemon-reload
    sudo systemctl enable minecraft@$SERVERNAME

This assumes that your server is in its own directory in the minecraft user's home directory, like the following.

```
/opt/minecraft/server1
/opt/minecraft/server2
```

Copy the server.conf file to the server's directory, and edit according to your memory requirements.

Start the server.

``systemctl start minecraft@$SERVERNAME``

# file notes

## server.conf
server.conf is a configuration file that abstracts the memory allocation and jar name for specific servers, so they can be customized outside of the systemd unit file. Put them in your minecraft server's main directory (~minecraft/servername) and edit MCMAXMEM and JAR to your liking.

I generally keep the JAR variable as is and make a symbolic link from the actual jar name to server.jar.

## minecraft@.service
This is the systemd unit file for minecraft. This controls what actions are done when systemctl is used to interact with the minecraft service.

It allows for each server to act as its own service, so stopping `minecraft@server1` won't affect 'minecraft@server2', if it's running. Each server (service) must be enabled to start on boot.
