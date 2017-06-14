# Pingdom Monitor Status Dashboard

This is a simple bash script requesting the Pingdom API using your credentials set in `credentials` file. It's able to show up to 100 services in the status grid. The order of services in the grid reflects the order of the api response. If the current status of a service is not `up` this service will be shown in `red` and the terminal bell rings every second. The display will be updated every 60 seconds (a countdown counter shows the time until the next update request).

## Requirements

- xterm
- bash
- tput
- curl
- jq

## Pingdom Credentials

Please, set your Pingdom credentials in the `credentials` file.

## Scaling

An scaling factor has to be set in `scaling_factor` file defining the size of the status icons in the grid.

## Starting Monitor Dashboard

The `start_monitor.sh` script will open an xterm in fullscreen (foreground) and runs until SIGTERM showing the current status (updated every minute) of your services in Pingdom.
