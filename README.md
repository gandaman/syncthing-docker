# ptimof/syncthing

A [syncthing](https://github.com/syncthing) Docker container.

This container is intended to be run on a server that will be shared by 
a group of people. Although this container can be used on a personal
workstation, it will not be very convenient. It's best to download a native
distribution for your machine from [Syncthing](http://syncthing.net).

## Building the image

	docker build -t ptimof/syncthing

Or just pull the latest from [Docker Hub](https://registry.hub.docker.com/u/ptimof/syncthing/):

	docker pull ptimof/syncthing

## Host system preparation

On the host machine, create the user and group `syncthing` with `UID` and `GID` of 800:

	groupadd -g 800 syncthing
	useradd -m -u 800 -g 800 syncthing

If 800 is already taken, or a different `UID`/`GID` is desired, the Dockerfile `useradd`
and `groupadd` commands will need to be modified to match.

## Creating the container

	docker create --name syncthing -p 8080:8080 -p 22000:22000 -p 21025:21025/udp -v /home/syncthing:/home/syncthing ptimof/syncthing

## Running the container

As `syncthing` is more intended as a personal file syncing system, configuration
is more like an application on a PC than a sysadmin-controlled machine.

Config files are located in `~/syncthing/.config/syncthing`, and files of note are:

* `config.xml`: the main configuration file
* `key.pem` and `cert.pem`: TLS files

This directory must be writable by the `syncthing` user on the host computer.

### Running for the first time

The very first run on a host system of this container will create two directoryies:

* `~/syncthing/.config/syncthing` (mode 700)
* `~/syncthing/Sync` (mode 700)

At this point, there are no active shares, but the admin UI is exposed to any IP,
and has no password. The very first activity that should immediately be done is
to set a username/password for the UI.

To run the admin UI, use a browser to connect to `http://[your_host]:8080/`

## Further configuration

The `Dockerfile` is configured to allow passing arguments directly to  `syncthing`.
Documentation on configuring `syncthing` is scarce (it is early in it's development
cycle). There should be no need to change the command line parameters as they stand,
however config and environment parametsr can be gleaned from the source for
for [syncthing](https://github.com/syncthing/syncthing/blob/master/cmd/syncthing/main.go).

The `config.xml` file, on the otherhand, appears to have a few tags that are not controlled
by the admin UI. The best place to decode this is on the
[Syncthing forum](https://discourse.syncthing.net).

## Workstation tips

* [Example setup scripts](https://github.com/syncthing/syncthing/tree/master/etc
* [Windows Tray](https://discourse.syncthing.net/t/syncthingtray-for-windows/586)
* [MacOS Menu Item](https://discourse.syncthing.net/t/syncthing-bar-for-os-x/1582)


