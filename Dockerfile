# use the official alpine python image
FROM python:3.9-alpine3.19


# install ffmpeg and cron
RUN apk add --no-cache ffmpeg busybox-openrc

# install moodle-dl
RUN pip install --no-cache-dir moodle-dl

# copy all the scripts and make any script executable
COPY . /app
RUN chmod +x /app/*.sh


# set the mount point for the data volume and the working directory
VOLUME /data
WORKDIR /data

# run the init script
ENTRYPOINT [ "/app/init.sh" ]