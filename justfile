set dotenv-load
set positional-arguments

# list available recipes
default:
  just --list

# wrap terragrunt with dotenv loading
tg *args='':
  terragrunt $@

# initialize terragrunt project
init *args='':
  terragrunt init $@

# upgrade providers
upgrade *args='':
  terragrunt init -upgrade $@

# validate terragrunt project
validate *args='':
  terragrunt validate $@

# check for infrastructure drift
drift-check *args='':
  terragrunt plan -detailed-exitcode $@

# terragrunt output in json format (into output.json)
output-json:
	terragrunt output -json > output.json

# generate terraform graph and convert into svg format (requires graphviz)
graph:
	terragrunt graph -draw-cycles > graph.gv && dot -Tsvg graph.gv > graph.svg

# format tf and hcl files
fmt:
	terraform fmt -recursive && terragrunt hclfmt

# lint project (by tflint)
lint:
	tflint --init && tflint

# check if output.json file exists
check-output:
	test -f output.json

# run bitwarden installer playbook
bw-install: check-output
	bash -c "$(jq -r '.cmd_bitwarden_installer.value' output.json)"

# open a ssh session into app instance
connect *args='': check-output
	env -- $(jq -r '.cmd_ssh_to_app_instance.value' output.json) $@
