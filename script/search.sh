#!/bin/bash
cd ../build 
# cmake ../ -DCMAKE_BUILD_TYPE=Debug
cmake ../ -DCMAKE_BUILD_TYPE=Release
make search 2>&1 | tee ../script/log.txt
cd ../script
log=`grep error log.txt`
if [ "$log" != "" ]; then
    exit
fi

hash_method="ITQ"
query_method="GQR"

# #audio
# num_tables=1
# codelength=16
# dataset="audio"
# base_format="fvecs"
# cardinality=53387
# dimension=192
# num_queries=200
# topk=20

# gist
codelength=16
num_tables=16
dataset="gist"
base_format="fvecs"
cardinality=1000000
dimension=960
num_queries=1000
topk=20

# #sift1m
# codelength=16
# num_tables=1
# dataset="sift1m"
# base_format="fvecs"
# cardinality=1000000
# dimension=128
# num_queries=1000
# topk=20


# #sift10m
# codelength=20
# num_tables=1
# dataset="sift10m"
# base_format="fvecs"
# cardinality=10000000
# dimension=128
# num_queries=1000
# topk=20

model_file="../learn/${hash_method}/hashingCodeTXT/${hash_method}model${dataset^^}${codelength}b_${num_tables}tb.txt"
base_file="../data/${dataset}/${dataset}_base.fvecs"
base_bits_file="../learn/${hash_method}/hashingCodeTXT/${hash_method}table${dataset^^}${codelength}b_${num_tables}tb.txt"
query_file="../data/${dataset}/${dataset}_query.fvecs"
benchmark_file="../data/${dataset}/${dataset}_groundtruth.ivecs"

../build/bin/search\
    --hash_method=$hash_method \
    --query_method=$query_method \
    --base_format=$base_format \
    --cardinality=$cardinality \
    --dimension=$dimension \
    --num_queries=$num_queries \
    --topk=$topk \
    --num_tables=$num_tables \
    --model_file=$model_file\
    --base_file=$base_file \
    --base_bits_file=$base_bits_file \
    --query_file=$query_file \
    --benchmark_file=$benchmark_file
