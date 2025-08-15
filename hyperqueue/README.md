# HyperQueue

## Setup
Download HyperQueue from the official site
```bash
cd ~/bin
wget https://github.com/It4innovations/hyperqueue/releases/download/v0.23.0/hq-v0.23.0-linux-arm64-linux.tar.gz
tar -zxf hq-v0.23.0-linux-arm64-linux.tar.gz
rm hq-v0.23.0-linux-arm64-linux.tar.gz
```

Make `hq` available
```bash
export PATH=~/bin:$PATH
```

## Run tests
```bash
sbatch job.sh
```

This runs an sbatch job that does the following steps. I want to do everything in a batch job that is self-contained, without any manual setup before or cleanup after.
- Start HyperQueue server on the first compute node
- Start HyperQueue workers on each compute node (using `srun`)
- Submit jobs
- Wait for the jobs to finish
- Stop all HyperQueue workers
- Stop HyperQueue server

If the SLURM job fails, e.g. it is killed because of time limit, the unfinished HyperQueue jobs/tasks can be restarted by passing ID of the failed job as an agrument to `job.sh`. If this is repeated multiple times, the ID of the first job should be used.
```bash
sbatch job.sh <failed-job-id>
```

## Notes
This example shows some useful use-cases but does not cover everything HyperQueue offers. For complete list of features, refer to the HyperQueue documentation https://it4innovations.github.io/hyperqueue/stable/.

In order to allow running several independent SLURM jobs with HyperQueue, `HQ_SERVER_DIR` has to be set to an unique dir.

If the SLURM job fails, e.g. it is killed because of time limit, the unfinished HyperQueue jobs/tasks can be restarted. This is done by setting `--journal` when starting the HyperQueue server. We can either create a new file when submitting new jobs, or pass an existing file to restart unfinished jobs/tasks. If we are restarting the jobs, we should not submit them again, hence the `if` around `hq submit`.

New version of HyperQueue (nightly build at the moment) has a command `hq server wait`. With older versions we need to sleep for few seconds to give the server enough time to start before starting workers and submitting jobs.
