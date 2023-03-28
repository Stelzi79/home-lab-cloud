#!/bin/bash

. ./func/bash_funcs.bash

print_heading "~~ 👢🧪(bootstrap): Home Lab Cloud ~~" "~" 2

ansible-playbook -i inventory.yaml check_host.yaml
