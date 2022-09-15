# minecraft-stuff
These are my scripts and config files for minecraft servers.

# file specific notes

## minecraft@.service
Dependencies: screen, server.conf

Install the systemd unit file as follows.

```
sudo cp minecraft@.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable minecraft@servername
```
This assumes that your server(s) is in its own directory in ~minecraft, such as the following.
```
/opt/minecraft/server1
/opt/minecraft/server2
```
Start the server by running the following.
`sudo systemctl start minecraft@server1`

## server.conf
server.conf is a configuration file that abstracts the memory allocation and jar name for specific servers, so they can be customized outside of the systemd unit file. Put them in your minecraft server's main directory (~minecraft/servername) and edit MCMAXMEM and JAR to your liking.

I generally keep the JAR variable as is and make a symbolic link from the actual jar name to server.jar.
