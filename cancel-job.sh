#!/bin/bash

# Get the user's jobs queue
user_jobs=$(squeue -u $USER)

# Check if there are no jobs
if [ -z "$user_jobs" ]; then
    echo "No jobs found for user $USER"
    exit 1
fi

# Print jobs with line numbers, start from the second line
echo "Jobs for user $USER:"
echo "$user_jobs" | awk 'NR > 1 {print NR-1, $0}'

# Prompt the user to select a job
read -p "Enter the number of the job to cancel: " job_number

# Validate user input
if ! [[ "$job_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input: Please enter a number."
    exit 1
fi

# Extract the job ID corresponding to the selected number
job_id=$(echo "$user_jobs" | awk 'NR == '$job_number' {print $1}')

# Check if a valid job ID was obtained
if [ -z "$job_id" ]; then
    echo "Invalid job number."
    exit 1
fi

# Cancel the selected job
#scancel "$job_id"
echo "Job $job_id has been cancelled."