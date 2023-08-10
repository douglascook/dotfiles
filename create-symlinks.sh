# SHELL
ln -s /Users/douglas/dotfiles/shell/zshrc ~/.zshrc
ln -s /Users/douglas/dotfiles/shell/tigrc ~/.tigrc
# TODO looks like this was originally created via ohmyzsh fzf plugin, maybe just use that?
ln -s /Users/douglas/dotfiles/shell/fzf.zsh ~/.fzf.zsh

# VIM
ln -s /Users/douglas/dotfiles/vim/vimrc ~/.vimrc
ln -s /Users/douglas/dotfiles/vim/gvimrc ~/.gvimrc
mkdir -p ~/.vim/after/ftplugin
ln -s /Users/douglas/dotfiles/vim/after/ftplugin/python.vim ~/.vim/after/ftplugin/python.vim
ln -s /Users/douglas/dotfiles/vim/after/ftplugin/yaml.vim ~/.vim/after/ftplugin/yaml.vim

# PYTHON
ln -s /Users/douglas/dotfiles/python/pylintrc ~/.pylintrc
ln -s /Users/douglas/dotfiles/python/pdbrc ~/.pdbrc
# An ipython profile must have been created (with `ipython profile create`) for the target dir to exist
ln -s /Users/douglas/dotfiles/python/ipython_config.py ~/.ipython/profile_default/ipython_config.py
