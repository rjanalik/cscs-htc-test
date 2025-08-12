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

## Problems
- Worker processes often don't start

## Questions
- Can I wait for the server and/or worker to start? I'd like to remove the `sleep xx` because I can never be sure that xx seconds is enough.
- Is it smart calling `srun ... &`? Can I do something better?
- How can I make the boilerplate as generic as possible?
- Can I wait for all jobs to finish? Waiting for one job at a time is complicated, and I don't know in advance how many jobs are in the queue.
