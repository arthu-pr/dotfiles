# Shortcut that includes the default inventory and vault password file for ansible-playbook
# Feel free to update to your version. Prompt for host in playbook: https://github.com/arthu-pr/ansible-droplet#helpful-links

alias ansibleplaybook='ansible-playbook -i ~/.ansible/hosts.yml -e "@~/.ansible/secrets.yml" --vault-password-file ~/.ansible/vault_pass_file'
