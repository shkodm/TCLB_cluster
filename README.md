# TCLB for Magnus
Scripts for compilation and running of TCLB at Magnus cluster

## Introduction
Magnus cluster uses SLURM queue. So, to see queue you use `squeue`, to run jobs you run `sbatch`.

Computing nodes have different architecture then the login node - so nothing compiled for computational nodes can be runned on the login node. That why you need to submit a job for more or less anything you want to do.
This includes configuration and compilation.

To ease the work with TCLB on Magnus, this repository of cluster-specific tools was created. If you clone it to `p` subdirectory, you can use it to compile and run TCLB with the below instructions.

## Installation
### Getting the source
```bash
git clone https://github.com/CFD-GO/TCLB.git
cd TCLB
git clone https://github.com/llaniewski/TCLB-Magnus.git p
```

### Configuration
All the needed configuration and installation of R packages is done by:
```bash
p/config
```

### Compilation
As R can be only executed on computational nodes, you cannot run `make` localy. Compilation (on 24 cores) can be executed using:
```bash
p/make d2q9
```

## Running cases
To run cases you can use the `run` script:
```bash
p/run [model] [case.xml] [number of cores]
```

You can use the script from a different directory then TCLB main dir, so for instance:
```
cd /scratch/blarbla/blarbla/some_important_research/
~/TCLB/p/run d2q9 mycase.xml 48
```

If I understand the accouting on Magnus it rarely makes sens to run on less then 24 cores, as they bill you for 24.
