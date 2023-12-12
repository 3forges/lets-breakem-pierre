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


```bash

kafka_connect_s3    | Using BOOTSTRAP_SERVERS=0.0.0.0:9092
kafka_connect_s3    | Plugins are loaded from /kafka/connect
kafka_connect_s3    | The CONFIG_STORAGE_TOPIC variable must be set to the name of the topic where connector configurations will be stored.
kafka_connect_s3    | This topic must have a single partition, be highly replicated (e.g., 3x or more) and should be configured for compaction.
kafka_connect_s3 exited with code 1

```

et hop avec ma config, j'ai du nouveau:

```bash
Utilisateur@Utilisateur-PC MINGW64 ~
$ curl http://redpanda-0.pesto.io:18082/brokers | jq .
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    15  100    15    0     0     66      0 --:--:-- --:--:-- --:--:--    66
{
  "brokers": [
    0
  ]
}

Utilisateur@Utilisateur-PC MINGW64 ~
$ curl http://redpanda-0.pesto.io:19644/v1/brokers | jq .
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   449  100   449    0     0  76256      0 --:--:-- --:--:-- --:--:-- 89800
[
  {
    "node_id": 0,
    "num_cores": 1,
    "internal_rpc_address": "redpanda-0",
    "internal_rpc_port": 33145,
    "membership_status": "active",
    "is_alive": true,
    "disk_space": [
      {
        "path": "/var/lib/redpanda/data",
        "free": 7574007808,
        "total": 20956397568
      }
    ],
    "version": "v23.2.6 - 1bbbce0186acb251a12458d0cd2c10ad7d6d93a3",
    "maintenance_status": {
      "draining": false,
      "finished": false,
      "errors": false,
      "partitions": 0,
      "eligible": 0,
      "transferring": 0,
      "failed": 0
    }
  }
]

Utilisateur@Utilisateur-PC MINGW64 ~

```