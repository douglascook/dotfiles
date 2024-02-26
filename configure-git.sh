# Merge when pulling from remote if it has diverged from local
git config --global pull.rebase false

# Better way to display merge conflicts. 
# See vimwiki https://github.com/douglascook/vimwiki/blob/master/dev/git.md#merge-conflict-diffs
git config --global merge.conflictstyle zdiff3

# Improved diff algorithm.
# See https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
git config --global diff.algorithm histogram

# Better detection of renamed files.
git config --global diff.renames copies
