#!/usr/bin/env bash

set -a       # Activate automatic export
source .env  # Load variables from .env file
set +a       # Deactivate automatic export

printf "\nBegin setup\n"

# Sonarr

# Set Sonarr root folder
curl -s -o /dev/null -w "\nSet Sonarr root folder: HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/sonarr/api/v3/rootfolder" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${SONARR_APIKEY}" \
            --data '{"path": "'${PATH_TO_DATA}'/media/tv"}'

# Set Sonarr download client
curl -s -o /dev/null -w "\nSet Sonarr download client: HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/sonarr/api/v3/downloadclient" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${SONARR_APIKEY}" \
            --data '
            {
                "enable": true,
                "protocol": "torrent",
                "priority": 1,
                "removeCompletedDownloads": true,
                "removeFailedDownloads": true,
                "name": "qBittorrent",
                "fields": [
                    {
                    "name": "host",
                    "value": "gluetun"
                    },
                    {
                    "name": "port",
                    "value": "20216"
                    },
                    {
                    "name": "useSsl",
                    "value": false
                    },
                    {
                    "name": "urlBase"
                    },
                    {
                    "name": "username",
                    "value": "admin"
                    },
                    {
                    "name": "password",
                    "value": "adminadmin"
                    },
                    {
                    "name": "tvCategory",
                    "value": "tv"
                    },
                    {
                    "name": "tvImportedCategory"
                    },
                    {
                    "name": "recentTvPriority",
                    "value": 0
                    },
                    {
                    "name": "olderTvPriority",
                    "value": 0
                    },
                    {
                    "name": "initialState",
                    "value": 0
                    },
                    {
                    "name": "sequentialOrder",
                    "value": false
                    },
                    {
                    "name": "firstAndLast",
                    "value": false
                    },
                    {
                    "name": "contentLayout",
                    "value": 2
                    }
                ],
                "implementationName": "qBittorrent",
                "implementation": "QBittorrent",
                "configContract": "QBittorrentSettings",
                "infoLink": "https://wiki.servarr.com/sonarr/supported#qbittorrent",
                "tags": []
                }'


# Radarr

# Set Radarr root folder
curl -s -o /dev/null -w "\nSet Radarr root folder: HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/radarr/api/v3/rootfolder" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${RADARR_APIKEY}" \
            --data '{"path": "'${PATH_TO_DATA}'/media/movies"}'

# Set Radarr download client
curl -s -o /dev/null -w "\nSet Radarr download client: HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/radarr/api/v3/downloadclient" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${RADARR_APIKEY}" \
            --data '
            {
                "enable": true,
                "protocol": "torrent",
                "priority": 1,
                "removeCompletedDownloads": true,
                "removeFailedDownloads": true,
                "name": "qBittorrent",
                "fields": [
                    {
                    "name": "host",
                    "value": "gluetun"
                    },
                    {
                    "name": "port",
                    "value": "20216"
                    },
                    {
                    "name": "useSsl",
                    "value": false
                    },
                    {
                    "name": "urlBase"
                    },
                    {
                    "name": "username",
                    "value": "admin"
                    },
                    {
                    "name": "password",
                    "value": "adminadmin"
                    },
                    {
                    "name": "movieCategory",
                    "value": "movies"
                    },
                    {
                    "name": "movieImportedCategory"
                    },
                    {
                    "name": "recentMoviePriority",
                    "value": 0
                    },
                    {
                    "name": "olderMoviePriority",
                    "value": 0
                    },
                    {
                    "name": "initialState",
                    "value": 0
                    },
                    {
                    "name": "sequentialOrder",
                    "value": false
                    },
                    {
                    "name": "firstAndLast",
                    "value": false
                    },
                    {
                    "name": "contentLayout",
                    "value": 0
                    }
                ],
                "implementationName": "qBittorrent",
                "implementation": "QBittorrent",
                "configContract": "QBittorrentSettings",
                "infoLink": "https://wiki.servarr.com/radarr/supported#qbittorrent",
                "tags": []
                }'

# Prowlarr

# Set Prowlarr indexer (flaresolverr) CURRENTLY NOT WORKING
curl -s -m 180 -o /dev/null -w "\nSet Prowlarr indexer (flaresolverr) CURRENTLY NOT WORKING: HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/prowlarr/api/v1/indexer" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${PROWLARR_APIKEY}" \
            --data '{
                        "onHealthIssue": false,
                        "supportsOnHealthIssue": false,
                        "includeHealthWarnings": false,
                        "name": "FlareSolverr",
                        "fields": [
                            {
                            "name": "host",
                            "value": "http://flaresolverr:8191/"
                            },
                            {
                            "name": "requestTimeout",
                            "value": 180
                            }
                        ],
                        "implementationName": "FlareSolverr",
                        "implementation": "FlareSolverr",
                        "configContract": "FlareSolverrSettings",
                        "infoLink": "https://wiki.servarr.com/prowlarr/supported#flaresolverr",
                        "tags": [
                            1
                        ]
                    }'

# Set Prowlarr application (Radarr)
curl -s -o /dev/null -w "\nSet Prowlarr application (Radarr): HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/prowlarr/api/v1/applications" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${PROWLARR_APIKEY}" \
            --data '{
                        "syncLevel": "fullSync",
                        "enable": true,
                        "fields": [
                            {
                            "name": "prowlarrUrl",
                            "value": "http://prowlarr:9696"
                            },
                            {
                            "name": "baseUrl",
                            "value": "http://radarr:7878"
                            },
                            {
                            "name": "apiKey",
                            "value": "'${RADARR_APIKEY}'"
                            },
                            {
                            "name": "syncCategories",
                            "value": [
                                2000,
                                2010,
                                2020,
                                2030,
                                2040,
                                2045,
                                2050,
                                2060,
                                2070,
                                2080,
                                2090
                            ]
                            },
                            {
                            "name": "syncRejectBlocklistedTorrentHashesWhileGrabbing",
                            "value": false
                            }
                        ],
                        "implementationName": "Radarr",
                        "implementation": "Radarr",
                        "configContract": "RadarrSettings",
                        "infoLink": "https://wiki.servarr.com/prowlarr/supported#radarr",
                        "tags": [],
                        "name": "Radarr"
                        }'

# Set Prowlarr application (Sonarr)
curl -s -o /dev/null -w "\nSet Prowlarr application (Sonarr): HTTP %{http_code}\n" "http://${SERVER_AUTOCONFIG_HOST}:${SERVER_PORT}/prowlarr/api/v1/applications" \
            --header "Content-Type: application/json" \
            --header "X-Api-Key: ${PROWLARR_APIKEY}" \
            --data '{
                        "syncLevel": "fullSync",
                        "enable": true,
                        "fields": [
                            {
                            "name": "prowlarrUrl",
                            "value": "http://prowlarr:9696"
                            },
                            {
                            "name": "baseUrl",
                            "value": "http://sonarr:8989"
                            },
                            {
                            "name": "apiKey",
                            "value": "'${SONARR_APIKEY}'"
                            },
                            {
                            "name": "syncCategories",
                            "value": [
                                2000,
                                2010,
                                2020,
                                2030,
                                2040,
                                2045,
                                2050,
                                2060,
                                2070,
                                2080,
                                2090
                            ]
                            },
                            {
                            "name": "syncRejectBlocklistedTorrentHashesWhileGrabbing",
                            "value": false
                            }
                        ],
                        "implementationName": "Sonarr",
                        "implementation": "Sonarr",
                        "configContract": "SonarrSettings",
                        "infoLink": "https://wiki.servarr.com/prowlarr/supported#sonarr",
                        "tags": [],
                        "name": "Sonarr"
                        }'


printf "\nSetup finished\n"