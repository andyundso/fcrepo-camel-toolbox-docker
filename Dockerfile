FROM maven:3-openjdk-11 as dependencies

WORKDIR /app

RUN git clone https://github.com/fcrepo-exts/fcrepo-camel-toolbox && \
cd fcrepo-camel-toolbox && \
mvn clean install

FROM openjdk:11 AS app

WORKDIR /app

ENV FEDORA_BASE_URL=http://localhost:8080/fcrepo/rest \
  FEDORA_AUTH_USERNAME=fedoraAdmin \
  FEDORA_AUTH_PASSWORD=fedoraAdmin \
  JMS_BROKER_URL=tcp://localhost:61616 \
  JMS_USERNAME=fedoraAdmin \
  JMS_PASSWORD=fedoraAdmin \
  TRIPLE_STORE_ENABLED=true \
  TRIPLE_STORE_BASE_URL=http://localhost:3030/test \
  SOLR_INDEXER_ENABLED=true \
  SOLR_INDEXER_BASE_URL=http://localhost:8983/solr/

RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 && \
  mv confd-0.16.0-linux-amd64 /usr/local/bin/confd && \
  chmod +x /usr/local/bin/confd && \
  mkdir /etc/confd

COPY --from=dependencies /app/fcrepo-camel-toolbox/fcrepo-camel-toolbox-app/target/fcrepo-camel-toolbox-app-6.0.0-SNAPSHOT-driver.jar fcrepo-camel-toolbox.jar

COPY confd/ /etc/confd
COPY start.sh .

CMD ["/app/start.sh"]
