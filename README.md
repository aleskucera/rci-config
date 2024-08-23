# RCI Cluster Configuration

Welcome to the configuration repository for the RCI Cluster at the Czech Technical University in Prague. The RCI Cluster is an HPC (High Performance Computing) infrastructure primarily designed for use by RCI researchers.

One of the challenges of using the cluster is the inability to install custom software. This repository aims to address this issue by providing configuration files and scripts that allow users to install and utilize custom software on the cluster. This can be particularly helpful for students and researchers who are new to the cluster environment.

## Example

Instead of executing multiple commands to manage jobs on the cluster, users can simplify the process using custom commands provided in this repository. For instance, instead of:

```bash
$ squeue -u <username>
    JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    7261076   gpufast     bash <username>  R       0:14      1 n21
$ scancel 7261076
Job 7261076 has been cancelled.
```
Users can use the custom command `cancel-job` for a more interactive experience:

```bash
$ cancel-job

Jobs for user <username>:
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
[1]            7261076   gpufast     bash <username>  R       1:21      1 n21

Enter the number of the job to cancel: 1
Job 7261076 has been cancelled.
```

## Overview

The documentation is divided into several parts:

- [Repository Structure](#repository-structure): Describes the organization of the repository.
- [Cluster Workflow](#cluster-workflow): Explains the typical workflow on the cluster.
- [Cluster Configuration](#cluster-configuration): Details the configuration settings for the cluster.
- [Usage](#usage): Provides instructions on how to use the commands and scripts provided.

## Repository Structure

The repository is structured as follows:

- `commands`: Contains scripts and commands essential for cluster operations.
- `envs`: Includes script files for loading modules on the cluster.
- `jobs`: Contains template files for submitting jobs.
- `src`: Holds the source code for cluster configuration.
- `run.sh`: Main script for configuring the cluster.

## Cluster Workflow

The configuration provided here is mainly used for a specific workflow on the cluster. All projects should be stored in the `/home/<user>/projects` directory. Each project requires its environment setup, which can be achieved by using a script to load necessary modules, like so:

```bash
ml PyTorch-Geometric/2.3.1-foss-2022a-CUDA-11.7.0
ml torchvision/0.16.0-foss-2022a-CUDA-11.7.0
ml PyTorch-Lightning/2.1.0-foss-2022a-CUDA-11.7.0
```

To load the modules specified in the `.env` file as stated above use the following command

```bash
source <path_to_project>/.env
```

The script is then stored in the `.env` file in the project directory. Alternatively, users can utilize custom Singularity containers stored in the `/mnt/personal/<user>/singularity` directory, following a specific structure.

### Home directory - `/home/<user>`

    .
    ├── ...
    ├── .bashrc
    ├── rci-config              # THE REPOSITORY MUST BE CLONED HERE!
    ├── projects
    │   ├── project-1           # First project (Using RCI modules)
    │   │   ├── .env            # The file for loading the modules
    │   │   ├── ...
    │   ├── project-2           # Second project (Using custom singularity container)
    │   │   ├── ...             # This project does not use RCI modules, the singularity 
    │   └── ...                 # is stored in the personal storage
    └── ...

### Personal storage - `/mnt/personal/<user>`

The personal storage is used typically for storing datasets, singularity containers and other large files.

    .
    ├── ...
    ├── singularity
    │   ├── project-2.sif    # The singularity container for the project-2
    │   └── ...
    └── ...

## Cluster Configuration

To configure the cluster (which involves making executables from the custom commands), use the `configure_rci.sh` script.

```bash
bash configure_rci.sh
```

## Usage

This repository provides the following commands for use:

- `cancel-job`: Allows the user to interactively cancel a job.
- `connect-job`: Allows the user to connect to running interactive job.
- `interactive-job`: Allows the user to create and specify hardware needed for interactive job.
- `my-jobs`: Lists the user's jobs.
- `run-jupyter`: Executes a Jupyter notebook on the cluster, accessible from the user's computer.
