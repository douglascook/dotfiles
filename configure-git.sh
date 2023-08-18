# Merge when pulling from remote if it has diverged from local
git config --global pull.rebase false

# Better way to display merge conflicts. 
# See vimwiki https://github.com/douglascook/vimwiki/blob/master/dev/git.md#merge-conflict-diffs
git config --global merge.conflictstyle zdiff3
