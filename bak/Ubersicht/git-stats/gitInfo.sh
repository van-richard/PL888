#!/bin/bash

cwd="git-stats"
repoPathList="${cwd}/repoPathList.txt"

function gitStatus {
	local repoPath=${1}
	local n_origin string
	local n_remote string
	# Compare commits
	# 	Returns 2 numbers (n_commits_origin \t n_commits_remote)
	if  [[ "${repoPath}" == *"ccats"* ]]; then
		local n_commits=$( git -C ${repoPath} rev-list --count --left-right origin/master...master )
	else
		local n_commits=$( git -C ${repoPath} rev-list --count --left-right origin/main...main )
	fi
	local n_origin=$( echo ${n_commits} | awk '{print $1}' )
	local n_remote=$( echo ${n_commits} | awk '{print $2}' )
	if [ "${n_origin}" -gt "${n_remote}" ]; then
		# echo "Your branch is behind of 'origin/main' by ${n_remote}."
		# echo "behind"
		printf "status\tbehind\ncommits\t${n_remote}\ncolor\t#tff3131\nicon\tbehind"
	elif [ "${n_origin}" -lt "${n_remote}" ]; then
		# echo "Your branch is ahead of 'origin/main' by ${n_remote} commit."
		# echo "behind"
		printf "status\tahead\ncommits\t${n_remote}\ncolor\t#8fce00\nicon\tahead"
	elif [ "${n_origin}" -eq "${n_remote}" ]; then
		# echo "clean"
		# echo "Your branch is up to date with 'origin/master'."
		printf "status\tclean\ncommits\t0\ncolor\t#ffffff\nicon\tclean"
	fi

}

function gitDict {
	local repoPath=${1}
	local base=$(basename $(dirname ${repoPath}))
	local repository=$(basename ${repoPath})
	local dirRepo="${base}/${repository}"
	# local branch=$(echo $(git -C ${repoPath} for-each-ref --format='%(refname:short)' refs/heads/ | grep -v "${active}" ))
	local branch=$(git -C ${repoPath} branch | grep "\*" | sed 's/\* //')
	local status=$(gitStatus ${repoPath} | grep "status" | awk '{print $2}')
	local commits=$(gitStatus ${repoPath} | grep "commits" | awk '{print $2}')
	local icon=$(gitStatus ${repoPath} | grep "icon" | awk '{print $2}')
	local color=$(gitStatus ${repoPath} | grep "color" | awk '{print $2}')
	# local n_modified=$(git -C ${repoPath} status | grep "modified" | wc -l | awk '{print $2}')
	# local n_untracked=$(git -C ${repoPath} status | grep "untracked" | wc -l | awk '{print $2}')
	# Formatting issues .......
	printf "
\t{\n\
\t\"repository\": \"%s\",\n\
\t\"branch\": \"%s\",\n\
\t\"status\": \"%s\",\n\
\t\"n_commits\": \"%s\",\n\
\t\"icon\": \"%s\",\n\
\t\"color\": \"%s\",\n\
\t\"modified\": \"%s\",\n\
\t\"untracked\": \"%s\"\n\
\t}" "${dirRepo}" "${branch}" "${status}" "${commits}" "${icon}" "${color}" #"${n_modified}" "${n_untracked}"
}

echo "tmp file" > ${cwd}/list.tmp
for repo in $(cat ${repoPathList}); do
	if [ "${repo}" == "$(head -n 1 ${repoPathList})" ]; then
		printf "[\n$(gitDict ${repo}) ,"
		echo "$(gitDict ${repo})" >> ${cwd}/list.tmp
		continue
	elif [ "${repo}" == "$(tail -n 1 ${repoPathList})" ]; then
		printf "$(gitDict ${repo})\n]"
		echo "$(gitDict ${repo})" >> ${cwd}/list.tmp
		break
	else 
		printf "$(gitDict ${repo}) ,"
		echo "$(gitDict ${repo})" >> ${cwd}/list.tmp
		continue
	fi
	echo "$(gitDict ${repo})" >> ${cwd}/list.tmp
done


