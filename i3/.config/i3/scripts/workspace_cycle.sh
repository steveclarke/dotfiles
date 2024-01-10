#!/usr/bin/env bash

# Check if a group number is provided
if [ $# -eq 0 ]; then
	echo "No group number provided"
	exit 1
fi

group_number=$1

# Define the workspace groups
declare -A workspace_groups
workspace_groups[1]="1:Main 2:Dev 3:Game 10:Misc"
workspace_groups[2]="4:Prod 5:DevL 6:DB"
workspace_groups[3]="7:DevR 8:Chat 9:Music"

# Check if the provided group number is valid
if [ -z "${workspace_groups[$group_number]}" ]; then
	echo "Invalid group number: $group_number"
	exit 1
fi

# Get the workspaces for the specified group
workspaces=(${workspace_groups[$group_number]})

# File to keep track of the current workspace index for each group
state_file="/tmp/workspace_cycle_state_$group_number"

# Read the last workspace index for the group, default to 0
index=$(cat "$state_file" 2>/dev/null || echo 0)

# Calculate the next workspace index
next_index=$(((index + 1) % ${#workspaces[@]}))

# Switch to the next workspace
i3-msg workspace "${workspaces[$next_index]}"

# Save the new index for the group
echo $next_index >"$state_file"
