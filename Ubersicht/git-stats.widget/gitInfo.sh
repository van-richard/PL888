#!/bin/bash

repoPathList="git-stats.widget/repoPathList.txt"

# if [ -z "${repoPathList}" ]; then
#   printf "\n\tList of repository paths are not found ...\n"
#   exit 1
# fi

function gitStatus {
	local repoPath=${1}
	local n_origin string
	local n_remote string
	# Compare commits
	# 	Returns 2 numbers (n_commits_origin \t n_commits_remote)
	local n_commits=$( git -C ${repoPath} rev-list --count --left-right origin/main...main )
	local n_origin=$( echo ${n_commits} | awk '{print $1}' )
	local n_remote=$( echo ${n_commits} | awk '{print $2}' )
	if [ "${n_origin}" -gt "${n_remote}" ]; then
		echo "Your branch is ahead of 'origin/main' by ${n_remote} commit."
		# echo "ahead"
	elif [ "${n_origin}" -lt "${n_remote}" ]; then
		# echo "behind"
		echo "Your branch is ahead of 'origin/main' by ${n_remote} commit."
	elif [ "${n_origin}" -eq "${n_remote}" ]; then
		# echo "clean"
		echo "Your branch is up to date with 'origin/master'."
	fi 
}

function gitDict {
	local repoPath=${1}
	local repository=$(basename ${repoPath})
	local active=$(git -C ${repoPath} branch | grep "\*" | sed 's/\* //')
	local branch=$(echo $(git -C ${repoPath} for-each-ref --format='%(refname:short)' refs/heads/ | grep -v "${active}" ))
	local status=$(gitStatus ${repoPath})
	# Formatting issues .......
	printf "
\t{\n\
\t\"repository\": \"%s\",\n\
\t\"branch\": \"%s\",\n\
\t\"branch_active\": \"%s\",\n\
\t\"status\": \"%s\"\n\
\t}" "${repository}" "${branch}" "${active}" "${status}"
}

echo "tmp file" > git-stats.widget/list.tmp
for repo in $(cat ${repoPathList}); do
	if [ "${repo}" == "$(head -n 1 ${repoPathList})" ]; then
		printf "[\n$(gitDict ${repo}) ,"
		echo "$(gitDict ${repo})" >> git-stats.widget/list.tmp
		continue
	elif [ "${repo}" == "$(tail -n 1 ${repoPathList})" ]; then
		printf "$(gitDict ${repo})\n]"
		echo "$(gitDict ${repo})" >> git-stats.widget/list.tmp
		break
	else 
		printf "$(gitDict ${repo}) ,"
		echo "$(gitDict ${repo})" >> git-stats.widget/list.tmp
		continue
	fi
	echo "$(gitDict ${repo})" >> git-stats.widget/list.tmp
done


