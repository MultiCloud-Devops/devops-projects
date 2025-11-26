Through bastion from local machine
----------------------------------
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ec2-user@<bastion-public-ip>"'
ansible-playbook -i inventory/hosts site.yaml

Below is the process that it does
---------------------------------
- Reads site.yml
- Looks at the hosts: ec2 group
- Connects to IPs in inventory/hosts
- Applies role cloudwatch_agent
- Runs tasks in order
- Copies template config
- Triggers handler → restarts CloudWatch agent
- Prints output

Note : Handlers will run only after all tasks complete their execution.