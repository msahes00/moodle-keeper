# get the latest rclone image
FROM rclone/rclone:latest AS rclone

# use the official alpine python image as the base image
FROM python:3.9-alpine3.19

# copy the rclone binary from the rclone image
COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone


# install dependencies
RUN apk add --no-cache ffmpeg

# install python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt \
 && rm /app/requirements.txt

# add the scripts to the image
COPY scripts /app
RUN chmod +x /app/*


# set the mount point for the data volume and the working directory
VOLUME /data
WORKDIR /data

# configure rclone to use the data volume
ENV RCLONE_CONFIG=/data/.rclone.conf

# run the init script
ENTRYPOINT [ "python", "/app/init.py" ]