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


function strU8DiffLen() {
  local -i bytlen
  printf -v _ %s%n "$1" bytlen
 	return $(( bytlen - ${#1} ))
}

function print_heading() {
	if [[ -z $1 ]]; then
		echo "ERROR: print_heading requires a heading string!"
		return 1
	fi
	if [[ -n $2 ]]; then
		filler_char=$2
	else
		filler_char=''
	fi

	heading="$1"
	
	#count=`echo $heading | awk '{print length}'`

	printf -v _ %s%n "$heading" count

	#count=${#heading}

	filler=''
	n=0
	c1=(${#heading} + 2)
	c2=0
	#printf -v _ %s%n "$heading" c1
	while [ $c2 -lt $c1 ]; do
		n=$((n + 1))
		filler="${filler}${filler_char}"
		printf -v _ %s%n "$filler"  c2
		#c2=${#filler}
		echo $c1=$c2
	done
	echo -e "$filler\n$heading\n$filler"

}
