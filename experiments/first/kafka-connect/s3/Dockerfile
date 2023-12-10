# https://medium.com/@ongxuanhong/dataops-01-stream-data-ingestion-with-redpanda-56b7fd768887
FROM debezium/connect

RUN curl -O https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-s3/versions/10.3.1/confluentinc-kafka-connect-s3-10.3.1.zip \
    && unzip confluentinc-kafka-connect-s3-10.3.1.zip \
    && mv confluentinc-kafka-connect-s3-10.3.1 /kafka/connect/ \
    && rm confluentinc-kafka-connect-s3-10.3.1.zip