FROM grafana/grafana:7.0.0-beta3
ENV hostname=hn-my-grafana-docker
ENV name=grafana-docker
# Copy yml config file to image
COPY ./dashboard.yml /etc/grafana/provisioning/dashboards/dashboard.yml
COPY ./Chat-Dashboard.json /etc/grafana/provisioning/dashboards/Chat.json
COPY ./RabbitMQ-Dashboard.json /etc/grafana/provisioning/dashboards/Rabbitmq.json
COPY ./Prometheus_datasource.yml  /etc/grafana/provisioning/datasources/Prometheus.yaml 

# Certificate
COPY ./server.crt /etc/grafana/certs/server.crt
COPY ./server.key /etc/grafana/certs/server.key

# Expose port for conn with grafana
EXPOSE 3000