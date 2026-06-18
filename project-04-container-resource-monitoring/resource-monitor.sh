#!/bin/bash

REPORT="capacity-report.txt"

echo "===================================" > $REPORT
echo "Container Capacity Report" >> $REPORT
echo "===================================" >> $REPORT
echo "Date: $(date)" >> $REPORT
echo "" >> $REPORT

echo "Running Containers" >> $REPORT
echo "-----------------------------------" >> $REPORT

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" >> $REPORT

echo "" >> $REPORT

echo "Container Resource Usage" >> $REPORT
echo "-----------------------------------" >> $REPORT

docker stats --no-stream >> $REPORT

echo "" >> $REPORT
echo "Report Generated Successfully" >> $REPORT

echo "Report saved to $REPORT"
