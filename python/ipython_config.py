"""This needs to go in ~/.ipython/profile_default after creating the profile."""

c = get_config()

c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']

# display output of all expressions in a cell instead of last only (default)
c.InteractiveShell.ast_node_interactivity = 'all'
