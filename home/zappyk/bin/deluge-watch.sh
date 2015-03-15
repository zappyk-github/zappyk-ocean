#command="ls -l incomings* completed* download* torrents*"
 command="ls -d incomings* completed* download* torrents* | xargs"
 command="for dir in \$($command); do echo \"\$dir:\"; du -shc \"\$dir\"/* 2>/dev/null; echo; done; df -hT /"
 command="pwd && echo && $command"

dir=${1:-$(dirname $0)} && cd "$dir" && watch -n 3 "$command"
