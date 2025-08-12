#!/usr/local/bin/bash

#SBATCH -N 2
#SBATCH --ntasks-per-node 1
#SBATCH --time 00:10:00
#SBATCH -p normal
#SBATCH -A csstaff

#echo "$(hostname): ${SLURM_NODEID} ${SLURM_LOCALID}"

# Start HyperQueue server and workers
hq server start &
sleep 10
srun hq worker start &
sleep 10

# Submit some jobs
hq submit --resource "cpus=1" --array 1-300 ./task.sh;
hq submit --resource "gpus/nvidia=1" --array 1-16 ./task.sh;

# Wait for all jobs to finish
for i in `seq 1 2`; do
    hq job wait $i;
done

# Debugging: print all workers
# Sometimes workers do not start
hq worker list

# Stop HyperQueue workers and server
for i in `seq 1 ${SLURM_NNODES}`; do
    hq worker stop $i;
done
hq server stop

echo
echo "Everything done!"
