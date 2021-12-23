<div id="top"></div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/DiePutze5853/iota-iscp-dev-preconfigured">
    <img src="https://github.com/iotaledger/wasp/raw/master/WASP_logo_dark.png" alt="Logo" width="384" height="256">
  </a>

<h3 align="center">IOTA ISCP Development Container</h3>

<!-- GETTING STARTED -->
### Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

## Prerequisites

1) Create a server with a hosting provider of your choice
2) Create the following subdomains and configurations for your domain:
    
     -**sc.YourDomainName.com** 
          ->A-Record: your IPv4 address
          ->AAAA-Record: your IPv6 address

    -**traefik.sc.YourDomainName.com**
          ->CNAME: sc.YourDomainName.com
     
    -**evm.wasp.sc.YourDomainName.com**
          ->CNAME: sc.YourDomainName.com
    
    -**api.wasp.sc.YourDomainName.com**
      ->CNAME: sc.YourDomainName.com
    
    -**wasp.sc.YourDomainName.com**
      ->CNAME: sc.YourDomainName.com
    
    -**api.goshimmer.sc.YourDomainName.com**
      ->CNAME: sc.YourDomainName.com

    -**goshimmer.sc.YourDomainName.com**
      ->CNAME: sc.YourDomainName.com
  
  3) Install Docker and Docker Compose on your server
    
## Installation
#### Clone Repo to /opt 
```cd /opt```
```git clone --recursive https://github.com/DiePutze5853/iota-iscp-dev-preconfigured services```
    
#### Traefik Setup
```cd services/traefik```
```chmod +x generate_config.sh```
```./generate_config.sh```
```docker network create --ipv6 --subnet fd8b:20d3:7f65:72ae::/64 traefik-v2-proxy```
```docker-compose up -d```

#### ISCP Setup
```cd ../iscp```
```nano iota-sc.conf```
    ->change with your domain name
```cd deps/wasp-cli```
```nano docker-entrypoint.sh```
    ->change --chainid value if you need want
```cd ../data```
```nano wasp-cli.json```
    ->change wasp and goshimmer api to your domain name 
```cd ..```
```docker-compose up -d```
  
    
<!-- Troubleshooting -->    
## Troubleshooting

<!-- CONTACT -->
## Contact

[@anti_cfb](https://twitter.com/anti_cfb) 

    Discord Handles - @die_Putze5853#7514 or @unrecognized_User
            
<!-- ACKNOWLEDGMENTS -->
## Acknowledgments
@Pathin (Donate him:iota1qrtfzfeu6rwhe5s8yelvre20lhw8uwcr9nd9e7ugdvhnlw2psseyg8eh0vr)
    - for doing the majority of the work and patiently teaching me lots of stuff I needed to learn.
<p align="right">(<a href="#top">back to top</a>)</p>



