import os
import jinja2
import argparse

my_parser = argparse.ArgumentParser(description='Run a jupyter notebook job')

# Add the arguments
my_parser.add_argument('--port', '-p',
                       type=int,
                       required=True,
                       help='the port to use for the jupyter notebook')
my_parser.add_argument('--project_name', '-n',
                       type=str,
                       required=True,
                       help='the name of the project')
my_parser.add_argument('--number_of_cpus', '-c',
                       type=int,
                       required=True,
                       help='the number of cpus to use')
my_parser.add_argument('--env_file', '-e',
                       type=str,
                       required=True,
                       help='the environment file to use')
my_parser.add_argument('--project_dir', '-d',
                       type=str,
                       required=True,
                       help='the project directory')
my_parser.add_argument('--node_file', '-f',
                          type=str,
                          required=True,
                          help='the node file to use')
my_parser.add_argument('--log_dir', '-l',
                            type=str,
                            required=True,
                            help='the log directory to use')
my_parser.add_argument('--log_file', '-lf',
                            type=str,
                            required=True,
                            help='the log file to use')

# Parse the arguments
args = my_parser.parse_args()

# Access the arguments
port = args.port
log_dir = args.log_dir
env_file = args.env_file
log_file = args.log_file
node_file = args.node_file
project_dir = args.project_dir
project_name = args.project_name
number_of_cpus = args.number_of_cpus

# Load the template
file_path = os.path.abspath(__file__)
template_path = os.path.join(os.path.dirname(file_path), "..", "jupyter-jobs", "template.j2")
template_string = open(template_path).read()
template = jinja2.Template(template_string)

# Render the template with the provided arguments
rendered_template = template.render(port=port,
                                    project_name=project_name,
                                    number_of_cpus=number_of_cpus,
                                    env_file=env_file,
                                    project_dir=project_dir,
                                    node_file=node_file,
                                    log_dir=log_dir,
                                    log_file=log_file)

# Create the job file
job_file_path = f"jupyter-jobs/{project_name}.sh"
with open(job_file_path, "w") as job_file:
    job_file.write(rendered_template)



