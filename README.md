# moodle-keeper
moodle-keeper is a simple wrapper around [Moodle-dl](https://github.com/C0D3D3V/Moodle-DL) for docker.

## Features
- Store the files in a volume or bind mount
- Automatic scheduled downloading
- Automatic uploading to cloud storage using rclone

## Usage
To use moodle-keeper, docker must be installed on the host machine.

### Configuration
Before running moodle-keeper, moodle-dl must be configured. Additionally, rclone can be configured to upload the files to a cloud service like Google Drive or Microsoft Onedrive.

* To configure moodle-dl, run the following commands:
    ```sh
    # Configure moodle-dl
    docker run -it --rm -v ./data:/data moodle-keeper moodle-dl --init
    docker run -it --rm -v ./data:/data moodle-keeper moodle-dl --config
    ```
    > For more details refer to the [Moodle-dl](https://github.com/C0D3D3V/Moodle-DL#readme) documentation

* To configure rclone, run the following command:
    ```sh
    # Configure rclone
    docker run -it --rm -v ./data:/data moodle-keeper rclone config
    ```
    > For more details refer to the [rclone](https://rclone.org/docs/) documentation

### Launching moodle-keeper
moodle-keeper can be launched as a one-time job or as a background service.

* To run moodle-keeper as a one-time job, run the following command:
    ```sh
    docker run -it --rm -v ./data:/data ghcr.io/msahes00/moodle-keeper:latest run-once
    ```

* To run moodle-keeper as a background service, run the following command:
    ```sh
    docker run -d --restart unless-stopped -v ./data:/data ghcr.io/msahes00/moodle-keeper:latest
    ```
    The service will run every day at 00:00 by default. To change the interval, set the `CRON_SCHEDULE` environment variable to a valid cron expression.
    > Here is a helper tool for choosing the intervals: [crontab.guru](https://crontab.guru/)

    By default, no remote is configured. To upload the files to a cloud service, set the `RCLONE_DEST` environment variable to the previously configured remote.

    Below is an example of running moodle-keeper as a background service with a custom cron schedule (once every minute) and a remote destination:
    ```sh
    docker run -d --restart unless-stopped -v ./data:/data \
    -e CRON_SCHEDULE="* * * * *" \
    -e RCLONE_DEST="remote:/path/to/upload" \
    ghcr.io/msahes00/moodle-keeper:latest
    ```

## Manually building the image
To build the image manually, clone the repository and run the following command:
```sh
# Clone the repository and cd into it
git clone https://github.com/msahes00/moodle-keeper.git
cd moodle-keeper

# Build the image and tag it
docker build -t moodle-keeper .
```

## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.