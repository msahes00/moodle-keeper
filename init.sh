#!/bin/sh

# get the first argument and shift it
command=$1
shift

# set the default cron schedule (every day at midnight)
if [ -z "$cron_schedule" ]; then
	cron_schedule="0 0 * * *"
fi


# expose the moodle-dl command for direct use
if [ "$command" = "moodle-dl" ]; then
	# run the moodle-dl script with any remaining arguments
	moodle-dl $@

# or start the cron job
else

	echo "Setting up cron job with schedule: $cron_schedule"
	echo

	# write the cron job to the crontab
	echo "$cron_schedule moodle-dl" | crontab -

	# start the cron daemon in the foreground
	crond -f
fi
