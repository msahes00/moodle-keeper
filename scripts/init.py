#!/usr/bin/env python3

import os
import sys
import subprocess
import argparse
from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.triggers.cron import CronTrigger

# the available commands that are exposed to the user
AVAILABLE_COMMANDS = ['moodle-dl', 'rclone', 'run-once']

# run a command and handle KeyboardInterrupt
def run_cmd(cmd):
    try:
        subprocess.run(cmd)
    except KeyboardInterrupt:
        sys.exit(1)

# run the main script file
def run_main_script():
    run_cmd(['/app/main.sh'])


def main():

    # parse the command line arguments
    parser = argparse.ArgumentParser(description='Moodle Keeper')
    parser.add_argument(
        'command',
        nargs='?',
        choices=AVAILABLE_COMMANDS,
    )
    parser.add_argument(
        'args',
        nargs=argparse.REMAINDER,
    )
    args = parser.parse_args()

    # special case: run the main script once
    if args.command == 'run-once':
        run_main_script()
        sys.exit(0)

    # run one of the available commands
    if args.command in AVAILABLE_COMMANDS:
        run_cmd([args.command, *args.args])

    # or run the cron job
    else:
        # get the schedule from env or use a default (every day at midnight)
        cron_schedule = os.getenv('CRON_SCHEDULE', '0 0 * * *')

        # set up the scheduler and start it, handling some exceptions
        print(f"Setting up cron job with schedule: {cron_schedule}")

        scheduler = BlockingScheduler()
        scheduler.add_job(run_main_script, CronTrigger.from_crontab(cron_schedule))

        try:
            scheduler.start()
        except (KeyboardInterrupt, SystemExit):
            scheduler.shutdown()


if __name__ == '__main__':
    main()