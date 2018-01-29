# TCLB for clusters
Scripts for compilation and running of TCLB solver on HPC clusters

## Introduction
The scripts are made to be general, but HPC clusters are very diverse. These
scripts for now work on clusters with SLURM queue system.

## Installation
### Getting the source
```bash
git clone https://github.com/CFD-GO/TCLB.git
cd TCLB
git clone https://github.com/CFD-GO/TCLB_cluster.git p
```

### Configuration
All the needed configuration and installation of R packages is done by:
```bash
p/config
```

### Compilation
As compulation on the main node is discouraged on many clusters, you can run `make`
in parallel on a node.
```bash
p/make d2q9
```

## Running cases
To run cases you can use the `run` script:
```bash
p/run [model] [case.xml] [number of cores/gpus] [options for sbatch (optional)]
```

You can use the script from a different directory then TCLB main dir, so for instance:
```
cd /scratch/blarbla/blarbla/some_important_research/
~/TCLB/p/run d2q9 mycase.xml 48
```

### Changeing options
You can change the default time (1h), name, etc by supplying additional options for sbatch like:
```
~/TCLB/p/run d2q9 mycase.xml 48 -J "new name" --time=24:00:00
```

## Notifications
The scripts support getting PushBullet notifications based on: https://github.com/llaniewski/my.prompt

## Cluster specific settings

In the `cluster` directory there are settings for specific clusters (like
prometheus and magnus). The first line of each file is a bash comment with
the pattern for hostname to match.

### Contributing

If you want to add support for another cluster, please add another file in
the `cluster` directory.
