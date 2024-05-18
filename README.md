# moodle-keeper
moodle-keeper is a simple wrapper around [Moodle-dl](https://github.com/C0D3D3V/Moodle-DL) for docker.

## Features
- Store the configuration and data inside a docker volume or bind mount
- Automatic scheduled downloading

## Usage
To use moodle-keeper, follow these steps:

1. Clone the repository:
```sh
git clone https://github.com/msahes00/moodle-keeper.git
```

2. Build the image and tag it:
```sh
docker build -t moodle-keeper .
```

3. Create the configuration for moodle-dl:
> For more details refer to the [Moodle-dl](https://github.com/C0D3D3V/Moodle-DL#readme) documentation
```sh
docker run -it --rm -v ./data:/data moodle-keeper moodle-dl --init
docker run -it --rm -v ./data:/data moodle-keeper moodle-dl --config
```

4. Run moodle-dl
	
* Once
```sh
docker run -it --rm -v ./data:/data moodle-keeper moodle-dl
```
* Periodically. By default is every day at midnight
```sh
docker run -it --rm -v ./data:/data moodle-keeper
```
* At a custom interval. This example will update it once every minute
```sh
docker run -it --rm -v ./data:/data -e cron_schedule="* * * * *" moodle-keeper
```
> The container uses cron internally to manage the intervals.  
> Here is a helper tool for choosing the intervals [crontab.guru](https://crontab.guru/)

## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.