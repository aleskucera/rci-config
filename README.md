# RCI Cluster Configuration

A collection of wrapper scripts for the [RCI cluster](https://login.rci.cvut.cz/) at CTU Prague. The cluster uses SLURM; this repo provides short, interactive commands for the common workflows (submitting jobs, opening Jupyter, tunneling, etc.) so you don't have to remember raw `sbatch` / `srun` / `squeue` invocations.

## Example

Instead of the raw SLURM flow:

```bash
$ squeue -u <username>
    JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
    7261076   gpufast     bash <username>  R       0:14      1 n21
$ scancel 7261076
```

You pick a job interactively:

```bash
$ cancel-job

Jobs for user <username>:
            JOBID PARTITION NAME USER ST TIME NODES NODELIST(REASON)
[1]       7261076   gpufast bash ...

Enter the number of the job to cancel: 1
Job 7261076 has been cancelled.
```

## Repository structure

```
.
├── commands/
│   ├── rci/           # Commands to run on the cluster (login / compute nodes)
│   └── local/         # Commands to run on your own machine
├── envs/
│   └── base.sh        # Default module set (used when a project has no .env / .venv)
├── jobs/              # Jinja2 templates for SLURM batch scripts
├── src/
│   └── create_job_file.py   # Renders the Jinja2 template for run-jupyter
├── configure_rci.sh   # One-time setup on the cluster
└── configure_local.sh # One-time setup on your machine
```

## Setup

### On RCI

Clone into `$HOME` (the path matters — scripts assume `~/rci-config`):

```bash
cd ~
git clone <repo-url> rci-config
bash rci-config/configure_rci.sh
```

This makes the commands executable and adds `~/rci-config/commands/rci` to your `PATH`. Start a new shell (or `source ~/.bashrc`) afterwards.

### Locally

```bash
git clone <repo-url> rci-config
bash rci-config/configure_local.sh
```

Prompts once for your RCI username, exports it as `$RCI_USER`, and adds `commands/local` to your `PATH`.

## Project layout on RCI

Put each project in `~/projects/<name>/`. The scripts look there and auto-detect the environment in this order:

1. `~/projects/<name>/.env` — a shell file that's `source`d (`ml …` calls, `source .venv/bin/activate`, etc.)
2. `~/projects/<name>/.venv/bin/activate` — a Python virtualenv (works with `uv`, `venv`, `virtualenv`)
3. Fallback — prompts for the base modules (`envs/base.sh`) or a Singularity image

Singularity images go in `/mnt/personal/<user>/singularity/<project>.sif`.

## Commands (on RCI)

| Command | What it does |
|---|---|
| `my-jobs` | Lists your queued / running SLURM jobs. |
| `interactive-job` | Starts an interactive shell on a compute node. Auto-detects `.env` / `.venv` and activates it; picks from live availability; supports `any-gpu` / `any-cpu`. Remembers last settings. |
| `connect-job` | Attaches a shell to an already-running job (`srun --overlap`). |
| `cancel-job` | Cancels one of your jobs. |
| `job-logs` | Finds and `tail -f`'s the log file of a running job. |
| `run-jupyter` | Submits a Jupyter notebook as a SLURM batch job. Prints the SSH tunnel command to run locally. Remembers last settings. |

### Partition selection

`interactive-job` and `run-jupyter` query `sinfo` at startup and show only partitions that allow interactive jobs (time limit ≤ 4h). Two virtual options are added:

- `any-gpu` — picks whichever fast GPU partition has the most idle nodes right now
- `any-cpu` — same for CPU partitions

GPU vs CPU is detected from each partition's GRES field, so new partitions added to the cluster appear automatically.

### Remembering settings

After your first run, both `interactive-job` and `run-jupyter` save your choices (project, partition, GPUs, memory, CPUs) to `~/.interactive-job-last` / `~/.run-jupyter-last`. Subsequent runs offer to reuse them with a single Enter.

## Commands (locally)

| Command | What it does |
|---|---|
| `ssh-rci` | Opens an SSH session to `login3.rci.cvut.cz` using `$RCI_USER`. |
| `rci-tunnel [node] [port]` | Opens an SSH tunnel from your machine to a compute node. Called with no args it prompts interactively. `run-jupyter` prints the exact invocation you can copy-paste. |

## Typical workflow: remote Jupyter

On RCI:

```bash
$ run-jupyter
# (select project, partition, resources — or reuse last)
# ... job starts ...
On your local machine, run:
    rci-tunnel n22 9999
```

Locally:

```bash
$ rci-tunnel n22 9999
```

Then open `http://localhost:9999` in your browser.

## Home directory layout

```
~/
├── .bashrc
├── rci-config/                # This repo — MUST be cloned here
├── projects/
│   ├── project-1/             # Uses RCI modules via .env
│   │   ├── .env
│   │   └── ...
│   ├── project-2/             # Uses uv / venv
│   │   ├── .venv/
│   │   ├── pyproject.toml
│   │   └── ...
│   └── project-3/             # Uses a Singularity container in /mnt/personal
│       └── ...
```

Personal storage (`/mnt/personal/<user>`) is used for datasets and Singularity images:

```
/mnt/personal/<user>/
└── singularity/
    ├── project-3.sif
    └── base.sif               # Optional fallback image
```
