#!/bin/bash

function doAll_playbooks() {
	if [[ -z $1 ]]; then
		echo "ERROR: doAll_playbooks() requires a relative path to a directory containing playbooks"
		return 1
	fi

	MY_PATH="$PWD/$1"
	#MY_PATH="$PWD/$(dirname -- "${BASH_SOURCE[0]}")" # if this is called with a relative path, it will be relative to the calling script

	echo -e "MY_PATH:\t$MY_PATH"

	list=$(ls -gGm1 $MY_PATH/*.yaml)
	list=(${list//".yaml /"/ })

	for i in "${list[@]}"; do
		if [[ $i == *"all.bash"* ]]; then
			echo -e "skipping:\t$i"
			continue
		else
			pb="${i/"/./"/"/"}"
			##. $pb
			echo -e "running:\t$pb"
			do_playbooks "$pb"
		fi

	done
}

function do_playbooks() {
	if [[ -z $1 ]]; then
		echo "ERROR: do_playbooks() requires a relative path to a playbook"
		return 1
	fi
	playbook="$1"
	#playbook="${BASH_SOURCE[0]/".bash"/".yaml"}"
	heading="== 🚧🚧🚧 applying '$playbook' to localhost ... =="

	count=${#heading}
	filler=''
	n=0
	while [ $n -lt $((count + 3)) ]; do
		n=$((n + 1))
		filler="${filler}="
	done

	echo -e "$filler\n$heading\n$filler"

	ansible-playbook "$playbook" -i "Ansible/hosts.yaml"
}
