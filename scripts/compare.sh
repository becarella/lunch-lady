#! /bin/bash

# compare your current checked out git branch to another branch on github
# default branch is master
# usage:
# ./compare.sh
# ./compare.sh staging
old=$1
if [ -z $1 ]; then
    echo "Comparing to master. If you want to compare to a different branch use:"
    echo "./script/compare branch_name"
    old='master'
fi
remote=$(git config --get remote.origin.url)
echo $remote
if [[ $remote =~ com[\/|:]([0-9a-zA-Z-]+\/[0-9a-zA-Z-]+)\.git ]]; then
    path=${BASH_REMATCH[1]}
    branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
    origin=$
    open https://github.com/$path/compare/$old...$branch?w=1
else
    echo "Couldn't determine your github url. Make sure remote.origin.url is set in your git config."
fi
