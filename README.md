# speedtest
Speedtest container that publishes MQTT messages for Home Assistant, but can be used with any MQTT Broken

## Quick Setup
Grab the `docker-compose.yml` update the env variables according to your env and run ```docker-compose up -d```  

## Build Image
Ensure you have the `build` directory containing `Dockerfile, entrypoint.sh, healthchech.sh, build.sh`  

Run the `build.sh` to build with tag latest or use the -t parameter to specify at tag version  
Alternatively run: `docker build -t neokhajitt/speedtest:latest .`  


## Contribution
If you have any feature requests or found bugs, log them on `https://github.com/NEoKhajitt/speedtest`
You are welcome to fork and make updates, create a PR and lets have a look at it.  

## Security
Have a look at [trivy-report.sarif](trivy-report.sarif)