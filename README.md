# moodle-keeper
moodle-keeper is a simple wrapper around [Moodle-dl](https://github.com/C0D3D3V/Moodle-DL) for docker.

## Features
- Store the configuration and data inside a docker volume or bind mount
- Automatic scheduled downloading

## Usage
To use moodle-keeper, follow these steps:

#### 1. Obtain the image
Currently there are two ways to obtain the image: building or pulling a prebuilt one
* Build the image manually

```sh
# Clone the repository and cd into it
git clone https://github.com/msahes00/moodle-keeper.git
cd moodle-keeper

# Build the image and tag it
docker build -t moodle-keeper .
```
* Or pull the prebuit image
```sh
docker pull ghcr.io/msahes00/moodle-keeper:latest
```
> **IMPORTANT**: if you pull the image, use `ghcr.io/msahes00/moodle-keeper:latest`  
> rather than `moodle-keeper` in the commands below

#### 2. Create the configuration for moodle-dl:
> For more details refer to the [Moodle-dl](https://github.com/C0D3D3V/Moodle-DL#readme) documentation
```sh
docker run -it --rm -v ./data:/data moodle-keeper moodle-dl --init
docker run -it --rm -v ./data:/data moodle-keeper moodle-dl --config
```

#### 3. Run moodle-dl
	
* Once
```sh
docker run -it --rm -v ./data:/data moodle-keeper moodle-dl
```

* Periodically in the background.
```sh
docker run -d --restart=unless-stopped -v ./data:/data moodle-keeper
```
> By default is every day at midnight  
> The container will always restart until you manually stop it

To specify the interval manually, add the `CRON_SCHEDULE` environment variable with it.  
Below is an example for running the update once every minute
```sh
docker run -d --restart=unless-stopped -v ./data:/data -e CRON_SCHEDULE="* * * * *" moodle-keeper
```
> Here is a helper tool for choosing the intervals [crontab.guru](https://crontab.guru/)

## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.