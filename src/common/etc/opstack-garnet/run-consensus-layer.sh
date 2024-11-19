#! /bin/sh

cd /data

/usr/local/bin/op-node \
  --l1=https://rpc.ankr.com/eth_holesky \
  --l1.beacon.ignore \
  --l2=http://opstack-garnet-op-geth:8551 \
  --l2.jwt-secret=/data/geth/jwtsecret \
  --metrics.enabled \
  --plasma.enabled \
  --plasma.da-server=https://da.garnetchain.com \
  --rpc.addr=0.0.0.0 \
  --rpc.port=8547 \
  --rpc.enable-admin \
  --p2p.bootnodes=enr:-J64QM3nCEvp4MQhkZrjnst7X9pzUL7ikW3jL5VXsHMbqw0PCDxEctBPAOGluJgg4-2xk4WeDRPV60_zl52_9cHSceiGAZFS5fg8gmlkgnY0gmlwhCLxekOHb3BzdGFja4SthQEAiXNlY3AyNTZrMaEDb4HiEkpCzMLwzTAGG6pqwxX-7cAKLI_FzZz8EuycauODdGNwgiQGg3VkcIIkBg,enr:-J64QJZJo5gi8EaDBk_qWvhTe1ioAFiSEriXN0XlCEKcpiSSASBBITr1v8vEMBZA4PdHjdwFYlnclDgk4YDLBuYV-oKGAY6lSMgZgmlkgnY0gmlwhAP7R1eHb3BzdGFja4SthQEAiXNlY3AyNTZrMaECvgC27BLpm7ZNcclZOYDJhcTFuuTsJzfvafzbHPlllwaDdGNwgiQGg3VkcIIkBg \
  --rollup.config=/config/rollup.json
