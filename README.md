# ansible-control-node

Docker container designed as an Ansible control node on Windows hosts. To use the Ansible control node, you can directly start a parametrized Docker container or use the PowerShell helper module [PSAnsibleControlNode](https://www.powershellgallery.com/packages/PSAnsibleControlNode) to start the Docker container.

For the docker run, two important volume mounts must be provided. The Ansible repository must be mounted to `/ansible` and the callers SSH folder to `/tmp/.ssh` to have the keys in the container. Please be aware of the special normalization for Windows paths without a drive colon and replacing `\` with `/`.

```bash
docker run -it --rm -v /C/Workspace/AnsibleKeys:/tmp/.ssh:ro -v /C/Workspace/AnsibleRepo:/ansible claudiospizzi/ansible-control-node:latest
```

As an alternative, the command `Start-AnsibleControlNode` can be used. By default, it will start an Ansible control node in the current directory. Specify a different directory if required.

```powershell
# Download and install the module
Install-Module -Name 'PSAnsibleControlNode'

# Start the ansible control node with the current working directory and the keys
# of the user home directory are used.
Start-AnsibleControlNode

# Start the ansible control node with custom repo and key path.
Start-AnsibleControlNode -RepositoryPath 'C:\Workspace\AnsibleRepo' -KeyPath 'C:\Workspace\AnsibleKeys'
```
