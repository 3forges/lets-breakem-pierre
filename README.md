# Mjollnir

## Run it

```bash
git clone git@github.com:3forges/lets-breakem-pierre.git
cd ./lets-breakem-pierre/

git checkout feature/first/tutorial/dbt

cd ./experiments/first

chmod +x ./utils/shell/*.sh
# ./utils/shell/docker.pull.sh
# ./utils/shell/launch.sh
./utils/shell/relaunch.sh
```

* To find out infos about the kafka brokers: 

```bash
curl http://redpanda-0.pesto.io:19644/v1/brokers | jq .
```

### The Kafka connect

* https://medium.com/@ongxuanhong/dataops-01-stream-data-ingestion-with-redpanda-56b7fd768887

We can completely self-code from scratch processes such as creating topics on Redpanda to contain streaming events, writing scripts to read data from this topic, and saving it on MinIO. Instead, we have Kafka connect with a lot of connectors that support connecting from source to sink, saving us the time of complicated installation, by just focusing on setting up and running the job.

* To read the data out, we just need to create a connector for Kafka connect. This connector is named `io.debezium.connector.mysql.MySqlConnector`. Detailed setup information can be found [here](https://docs.confluent.io/cloud/current/connectors/cc-mysql-source.html#how-should-we-connect-to-your-data) :

```bash
curl --request POST \
  --url http://localhost:8083/connectors \
  --header 'Content-Type: application/json' \
  --data '{
  "name": "src-brazillian-ecommerce",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbz",
    "database.server.id": "184054",
    "database.include.list": "brazillian_ecommerce",
    "topic.prefix": "dbserver1",
    "schema.history.internal.kafka.bootstrap.servers": "redpanda:9092",
    "schema.history.internal.kafka.topic": "schema-changes.brazillian_ecommerce"
  }
}'
```
* Running a mysql query :

```bash

# docker exec -it mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE}

docker-compose -f docker-compose-infra-services.yml exec -it mysql-db mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE} ${MYSQL_SCRIPT}


mysql> create database brazillian_ecommerce;
Query OK, 1 row affected (0.00 sec)
mysql> use brazillian_ecommerce;
Database changed
mysql> CREATE TABLE olist_orders_dataset (
    ->     order_id varchar(32),
    ->     customer_id varchar(32),
    ->     order_status varchar(16),
    ->     order_purchase_timestamp varchar(32),
    ->     order_approved_at varchar(32),
    ->     order_delivered_carrier_date varchar(32),
    ->     order_delivered_customer_date varchar(32),
    ->     order_estimated_delivery_date varchar(32),
    ->     PRIMARY KEY (order_id)
    -> );
Query OK, 0 rows affected (0.01 sec)
mysql> show tables;
+--------------------------------+
| Tables_in_brazillian_ecommerce |
+--------------------------------+
| olist_orders_dataset           |
+--------------------------------+
1 row in set (0.00 sec)
```

* https://github.com/ongxuanhong/de01-stream-ingestion-redpanda-minio
