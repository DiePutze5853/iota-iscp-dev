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

1) Create a server with a hosting provider of your choice <br />

2) Create the following subdomains and configurations for your domain:<br />
    
     -**sc.YourDomainName.com** <br />
          ->A-Record: your IPv4 address <br />
          ->AAAA-Record: your IPv6 address <br />

    -**traefik.sc.YourDomainName.com** <br />
          ->CNAME: sc.YourDomainName.com <br />
     
    -**evm.wasp.sc.YourDomainName.com** <br />
          ->CNAME: sc.YourDomainName.com <br />
    
    -**api.wasp.sc.YourDomainName.com** <br />
      ->CNAME: sc.YourDomainName.com <br />
    
    -**wasp.sc.YourDomainName.com** <br />
      ->CNAME: sc.YourDomainName.com <br />
    
    -**api.goshimmer.sc.YourDomainName.com** <br />
      ->CNAME: sc.YourDomainName.com <br />

    -**goshimmer.sc.YourDomainName.com** <br />
      ->CNAME: sc.YourDomainName.com <br />
  
  3) Install Docker and Docker Compose on your server<br />
    
## Installation <br />
#### Clone Repo to /opt <br />
```cd /opt``` <br />
```git clone --recursive https://github.com/DiePutze5853/iota-iscp-dev-preconfigured services``` <br />
    
#### Traefik Setup <br />
```cd services/traefik``` <br />
```chmod +x generate_config.sh``` <br />
```./generate_config.sh``` <br />
```docker network create --ipv6 --subnet fd8b:20d3:7f65:72ae::/64 traefik-v2-proxy``` <br />
```docker-compose up -d``` <br />
<br />
#### ISCP Setup<br />
```cd ../iscp```<br />
```nano iota-sc.conf```<br />
    ->change with your domain name<br />
```cd deps/wasp-cli```<br />
```nano docker-entrypoint.sh```<br />
    ->change --chainid value if you need want<br />
```cd ../data```<br />
```nano wasp-cli.json```<br />
    ->change wasp and goshimmer api to your domain name <br />
```cd ..```<br />
```docker-compose up -d```<br />
  
    
<!-- Troubleshooting -->    
## Troubleshooting

<!-- CONTACT -->
## Contact

 [@anti_cfb](https://twitter.com/anti_cfb)

**Discord Handles**
    
[@die_Putze5853#7514](https://iotamemes.com/user/60d6d91344b33b9241c5bd56)
    
**@unrecognized_User**    
    
Support me on my IOTA adventures:
iota1qr4fepyj67vunhtdadrmxhfxctewj0362z7qzsfn0x5lult5dv3ucumpf63
    
<!-- ACKNOWLEDGMENTS -->
## Acknowledgments<br />
**@Pathin** <br />
for doing the majority of the work and patiently teaching me lots of stuff I needed to learn.
    
**Support [@Pathin](https://iotamemes.com/user/61ae33c6d2a182ef4a19b85d)**
iota1qrtfzfeu6rwhe5s8yelvre20lhw8uwcr9nd9e7ugdvhnlw2psseyg8eh0vr
<p align="right">(<a href="#top">back to top</a>)</p>



