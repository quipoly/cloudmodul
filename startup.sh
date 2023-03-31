#!/bin/bash

sudo docker run -d -p 9090:9090 -v /home/yannic/prometheus.yml:/etc/prometheus/prometheus.yml -v prom:/etc/prometheus/ --name prometheus-yannnnnnic prom/prometheus
sudo docker run -d -p 3000:3000 --name grafana -v grafana:/etc/grafana/ grafana/grafana