# Mjollnir

## Run it

```bash
git clone git@github.com:3forges/lets-breakem-pierre.git
cd ./lets-breakem-pierre/

git checkout feature/first/tutorial/dbt

cd ./experiments/first

chmod +x ./utils/shell/*.sh
# ./utils/shell/launch.sh
./utils/shell/relaunch.sh
```

* To find out infos about the kafka brokers: 

```bash
curl http://redpanda-0.pesto.io:19644/v1/brokers | jq .
```


### The Kafka connect

* https://medium.com/@ongxuanhong/dataops-01-stream-data-ingestion-with-redpanda-56b7fd768887


```bash


```