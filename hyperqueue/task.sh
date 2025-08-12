#!/usr/local/bin/bash

#ID=$1
ID=$HQ_TASK_ID

echo "$(date): start task $ID: $(hostname) CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES}"
sleep 30
echo "$(date): end task $ID: $(hostname) CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES}"
