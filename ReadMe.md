The package is for dumping server stats to a file (ISPmanager compatible format).
The stats include CPU, memory, disk, and network usage. The package is designed to be used with cron.

Add cron:
```
*/30 * * * * /bin/bash /root/metricServer/dump_server_stats.sh
```
