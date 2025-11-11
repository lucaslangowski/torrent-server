# Torrent server setup guide

1. [Gluetun](#gluetun)
1. [qBittorrent](#qbittorrent)
1. [Sonarr](#sonarr)
1. [Radarr](#radarr)
1. [Prowlarr](#prowlarr)
1. [Bazarr](#bazarr)
1. [Flaresolverr](#flaresolverr)
1. [Nginx](#nginx)

---

This is a quickstart guide, check out the documentation links for each app to set them up to your liking. \
A lot of advanced options are not described here, see this as a starting point.

Requirements:

- Linux
- Curl
- Docker
- An external docker volume called `postgres_volume`
- Current user must have R W X privileges on all files/folders of this project
- File and folder structure as described below
- VPN (NordVPN, ProtonVPN...)

**Gluetun is the only container that needs to be setup before running the docker compose file**, because you need a VPN (ProtonVPN, Wireguard..) \
The rest of the setup is done through the webUIs.

1. Setup Gluetun
2. Setup .env file. **DO NOT CHANGE API KEYS UNLESS YOU KNOW WHAT YOU'RE DOING**
3. Run docker compose file. Startup might take a couple of minutes.
4. Run setup.sh script. It will connect the apps between each other.
5. Enjoy! Check out documentation listed below to configure the apps to your liking.

Once the docker-compose file is running the containers can be accessed at *http://**host**[:80])/**container_name***

## File and Folder Structure

The containers must have permissions to the following folders and their content.

    data
    ├── torrents
    │   ├── books
    │   ├── movies
    │   ├── music
    │   └── tv
    └── media
        ├── books
        ├── movies
        ├── music
        └── tv

> The location of `data` on yout machine is not important.

## Gluetun

VPN container to hide the torrent client traffic from your ISP. \
Allows advanced setup like port forwarding and automatic port forwarding update in qBittorrent.

**You need a VPN provider to make it work**.

**The containers env variables are setup for ProtonVPN. Modify if necessary.**

It is important to read the [Gluetun wiki](https://github.com/qdm12/gluetun-wiki) to set it up properly. A lot of VPN providers are supported.

> `config.toml` defines certain API endpoints that will be
> exposed to get some information about the app (status, ip, forwarded
> port...).
>
> - GET http://[HOST]/gluetun/v1/openvpn/portforwarded
> - GET http://[HOST]/gluetun/v1/openvpn/status
> - GET http://[HOST]/gluetun/v1/openvpn/settings
> - GET http://[HOST]/gluetun/v1/publicip/ip

## qBittorrent

Torrent client. All incoming traffic comes from Gluetun.

**Default login is `admin` and password `adminadmin`** \
**If you wish to change it you need also to change download client settings in Sonarr & Radarr**

This [torrent optimizing calculator](https://infinite-source.de/az/az-calc.html) tells you the optimal qBittorrent configuration depending on your internet connection. **Speeds are in kb/s and kB/s**.

> Custom theme [VueTorrent](https://github.com/VueTorrent/VueTorrent) is enabled (modern and mobile friendly). \
> **QBITTORRENT NEEDS TO BE RESTARTED TO APPLY THEME**

> `categories.json` sets categories that allows files to be saved in preset folders on download.

### Documentation

- [Docker image](https://docs.linuxserver.io/images/docker-qbittorrent/) (provided by linuxserver)

- [qBittorrent wiki](https://github.com/qbittorrent/qBittorrent/wiki)

## Sonarr

**Automatically download and manage TV series**. \
When episodes are downloaded (torrent/tv folder), Sonarr creates a symbolic link (media/tv folder) to seed the file while allowing it to be renamed.

Documentation

- [Docker image](https://docs.linuxserver.io/images/docker-sonarr/) (provided by linuxserver)
- [Servarr wiki](https://wiki.servarr.com/en/sonarr) (detailed docs)
- [TRaSH guide](https://trash-guides.info/Sonarr/) **HIGHLY RECOMMENDED**

## Radarr

**Automatically download and manage movies**. \
When movies are downloaded (torrent/movies folder), Radarr creates a symbolic link (media/movies folder) to seed the file while allowing it to be renamed.

Documentation

- [Docker image](https://docs.linuxserver.io/images/docker-radarr/) (provided by linuxserver)
- [Servarr wiki](https://wiki.servarr.com/en/radarr) (detailed docs)
- [TRaSH guide](https://trash-guides.info/Radarr/) **HIGHLY RECOMMENDED**

## Prowlarr

**Indexer manager for -arr applications.**

Documentation

- [Docker image](https://docs.linuxserver.io/images/docker-prowlarr/) (provided by linuxserver)
- [Servarr wiki](https://wiki.servarr.com/en/prowlarr) (detailed docs)
- [TRaSH guide](https://trash-guides.info/Prowlarr/) **HIGHLY RECOMMENDED**

## Bazarr

**Automatically download and manage subtitles.**

Documentation

- [Docker image](https://docs.linuxserver.io/images/docker-bazarr/) (provided by linuxserver)
- [Bazarr wiki](https://wiki.bazarr.media/) (detailed docs)
- [TRaSH guide](https://trash-guides.info/Prowlarr/) **HIGHLY RECOMMENDED**

## Flaresolverr

**Proxy server to bypass websites protected by Cloudfare.**
**Currently not working**

Documentation

- [Docker image](https://hub.docker.com/r/flaresolverr/flaresolverr)
- [Flaresolverr Github](https://github.com/FlareSolverr/FlareSolverr) (docs)
- [Flaresolverr wiki](https://github.com/FlareSolverr/FlareSolverr/wiki) (docs)

## Nginx

Reverse proxy server. Used to hide applications ports and use paths instead.

Applications can be accessed at *http://**host**/**container_name***

> Set the server hostname in .env file. Default is localhost

Example: <http://localhost/radarr>

Documentation

- [Docker image](https://hub.docker.com/_/nginx)
- [Nginx docs](https://nginx.org/en/docs/)
