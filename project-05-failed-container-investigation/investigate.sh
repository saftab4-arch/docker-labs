#!/bin/bash

REPORT="report.txt"

echo "==================================" > $REPORT
echo "Docker Investigation Report" >> $REPORT
echo "==================================" >> $REPORT

echo "" >> $REPORT
echo "Date: $(date)" >> $REPORT

for CONTAINER in $(docker ps -a --format "{{.Names}}")
do

echo "" >> $REPORT
echo "==================================" >> $REPORT
echo "Container: $CONTAINER" >> $REPORT
echo "==================================" >> $REPORT

echo "" >> $REPORT
echo "Status:" >> $REPORT

docker inspect $CONTAINER \
--format='{{.State.Status}}' >> $REPORT

echo "" >> $REPORT
echo "Exit Code:" >> $REPORT

docker inspect $CONTAINER \
--format='{{.State.ExitCode}}' >> $REPORT

echo "" >> $REPORT
echo "Configured CMD:" >> $REPORT

docker inspect $CONTAINER \
--format='{{.Config.Cmd}}' >> $REPORT

echo "" >> $REPORT
echo "Recent Logs:" >> $REPORT

docker logs $CONTAINER 2>&1 | tail -5 >> $REPORT

done

cat $REPORT
