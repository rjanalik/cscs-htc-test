#!/usr/local/bin/bash

#SBATCH -N 2
#SBATCH --ntasks-per-node 1
#SBATCH --time 00:10:00
#SBATCH -p normal
#SBATCH -A csstaff

# Set up journal in order to recover and rerun failed jobs
RESTORE_JOB=$1
if [ -n "$RESTORE_JOB" ]; then
    export JOURNAL=~/.hq-journal-${RESTORE_JOB}
else
    export JOURNAL=~/.hq-journal-${SLURM_JOBID}
fi

# Make sure every SLURM job creates its own server
# in case of running multiple SLURM jobs simultaneously
export HQ_SERVER_DIR=~/.hq-server-${SLURM_JOBID}

# Start HyperQueue server and workers
hq server start --journal=${JOURNAL} &
#sleep 10  # hq version <=0.23
hq server wait --timeout=120  # hq version >0.23
if [ "$?" -ne 0 ]; then
    echo "Server did not start, exiting ..."
    exit 1
fi
srun hq worker start &

# Submit some jobs
# Submit them only if we are not restarting failed jobs
if [ -z "$RESTORE_JOB" ]; then
    hq submit --resource "cpus=1" --array 1-300 ./task.sh;
    hq submit --resource "gpus/nvidia=1" --array 1-16 ./task.sh;
fi

# Wait for all jobs to finish
hq job wait all

# Stop HyperQueue workers and server
hq server stop

# Cleanup
rm -rf ${HQ_SERVER_DIR}

# Everything finished correctly, we can delete the journal
rm -rf ${JOURNAL}

echo
echo "Everything done!"
