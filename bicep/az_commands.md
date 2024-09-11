# azure cli commands for bicep stuff

### summary/sample commands:
```sh
az group create -n bicep-test -l australiasoutheast # create group for experiments (optional)

az deployment group validate --template-file main.bicep --mode Complete --group bicep-test
az deployment group what-if --template-file main.bicep --mode Complete --group bicep-test
az deployment group create --template-file main.bicep --mode Complete --group bicep-test

az deployment group export -n main -g bicep-test -o json > template.json
az bicep decompile --file template.json

az group delete -n bicep-test # clean up (optional)
```

## Checking templates:
```sh
az deployment group validate
```
- checks syntax of template.
- **does not check website host names** (ie `'Microsoft.Web/sites'`), names with dashes & underscores pass val but will fail on deployment.

```sh
az deployment group what-if
```
- use `what-if` in place of `create` to do a dry run
- when combined with `--mode` flag, shows things that will be deleted.

## Deploy a bicep template:
```sh
az deployment group create --template-file main.bicep --mode Complete
```
- Deploys resources described in the provided template file (ie `main.bicep`)
- `--mode Complete`: makes the resource group match the template *Completely*.
    - command will also **delete all resources** not present in the resource group.
    - resources 

## Get bicep for existing deployment
```sh
az deployment group list -g bicep-test
az deployment group export -n main -g bicep-test -o json > template.json
az bicep decompile --file template.json
