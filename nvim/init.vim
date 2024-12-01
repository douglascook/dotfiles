" install plug if its not already there
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" -------------------------- PLUGIN SETUP ---------------------------------
call plug#begin()

" From original vimrc
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-unimpaired'
Plug 'ryanoasis/vim-devicons'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'airblade/vim-gitgutter'

Plug 'vimwiki/vimwiki'

" New for neovim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'stevearc/conform.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'S1M0N38/love2d.nvim'

call plug#end()

lua <<EOF
  ----------------------------- Set up nvim-cmp -------------------------------
  local cmp = require 'cmp'

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },
    window = {},
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn['vsnip#available'](1) == 1 then
          feedkey('<Plug>(vsnip-expand-or-jump)', '')
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
          feedkey('<Plug>(vsnip-jump-prev)', '')
        end
      end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  ----------------------------- Set up lspconfig -------------------------------
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- LUA
  require 'lspconfig'.lua_ls.setup {
    settings = {
      capabilities = capabilities,
      handlers = {['textDocument/publishDiagnostics'] = function(...) end  }
    }
  }

  -- Enable plugin that adds Love2D to LSP path.
  require 'love2d'.setup{}

  -- Show diagnostics for current line only in floating window
  vim.cmd('autocmd CursorHold * lua vim.diagnostic.open_float()')
  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '>>',
        [vim.diagnostic.severity.WARN] = '~~',
        [vim.diagnostic.severity.INFO] = '--'
      }
    }
  })
  vim.o.updatetime = 150

  -- TODO should be able to just use LSP?
  -- Setup conform plugin for autoformatting
  local conform = require 'conform'
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters = {
      stylua = {
        append_args = { "--column-width=88" }
      }
    }
  })

  -- ELIXIR
  require 'lspconfig'.elixirls.setup{
    cmd = { "/usr/local/Cellar/elixir-ls/0.24.1/bin/elixir-ls" };
  }

  ----------------------------- Set up treesitter -----------------------------
  require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
      'elixir',
      'lua',
    },
    -- Seems like highlighting is not entirely enabled by default?
    highlight = {
      enable = true
    },
  }

EOF


" ----------------------------- NORMAL STUFF ------------------------------

colorscheme seoul256
set number			               " show line numbers

" use space as leader
nnoremap <space> <Nop>
let mapleader=" "

set tabstop=2
set shiftwidth=2
set expandtab			             " use spaces for tabs
set softtabstop=2              " for deleting multiple spaces at a time if they were a tab?

set linebreak                  " stops lines from wrapping in the middle of words
set breakindent                " use same level indentation on wrapped lines
set colorcolumn=80             " highlight at 80 characters
set winwidth=90                " set current pane to width 90 (if less) when moving into it
set cursorline                 " highlight current line
set guicursor=a:blinkon0       " disable cursor blink in GUIs
set scrolloff=8                " keep 3 lines visible around current line when scrolling
set termguicolors              " use full 24-bit colours
set guifont=Hack\ Nerd\ Font\ Mono:h14

set hidden                     " allow modified buffers to be hidden without saving changes
set history=1000               " remember more previous commands
set synmaxcol=200              " only do syntax highlighting on first columns for speedup with very long lines

set wildmenu                   " fix autocomplete for opening files with :e
set wildmode=longest:full,list:full

set hlsearch                   " start highlighting matches as they are typed
set incsearch
set smartcase                  " case insensitive search unless capitals are specified
set ignorecase

set backupdir=~/.vim/backup//  " put all swap files and backups in one folder
set directory=~/.vim/swp//
set updatetime=500             " write swap files every 500ms, dictates git-gutter update rate

set modelines=0                " fix potential vulnerability https://www.cvedetails.com/cve/CVE-2007-2438/
set encoding=utf-8
set ttyfast
set lazyredraw
set autoread                   " reload buffer automatically if file changed outside vim

set noerrorbells               " disable error noises/flashes
set novisualbell
set vb t_vb=

set foldmethod=syntax
set nofoldenable               " start with all folds open

" diff in vertical splits by default, don't fold until 4 cols nested
set diffopt=filler,vertical,foldcolumn:4

" set working directory
cd ./

" reload vimrc automatically when it is saved
augroup reload_vimrc
  autocmd! bufwritepost ~/.config/nvim/init.vim source %
augroup END

" syntax highlighting slows down loading for larger files
augroup large_files
  autocmd Filetype json if getfsize(@%) > 1000 | setlocal syntax=off foldmethod=indent | endif
augroup END

" open help in full height vertical split on the right
cnoreabbrev h vert bo h

" ---------------------------- SHORTCUT MAPPINGS ----------------------------
" can't have inline commments here, whitespace after the mapping is added to it!

" get rid of highlighting
nnoremap <leader><space> :noh<CR>

" saving
nnoremap <leader>s :w<CR>
cnoreabbrev W w
" strip all trailing whitespace and save
nnoremap <leader>a :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:w<CR>

" quitting
nnoremap <leader>q :q<CR>

" get rid of annoying f1 help popup
:nmap <F1> <nop>
:imap <F1> <nop>

" add a python breakpoint
function! InsertBreakpoint()
    let trace = expand("breakpoint()")
    execute "normal o".trace
endfunction

nnoremap <leader>p :call InsertBreakpoint()<CR>

" JSON pretty-print contents of buffer
nnoremap <leader>j :% ! python -m json.tool --indent=2<CR>
" python 3.9 onwards
nnoremap <leader>jl :% ! python -m json.tool --json-lines --indent=2<CR>

" colour schemes
nnoremap <F2> :colorscheme wombat256mod<CR>
nnoremap <F4> :colorscheme solarized<CR>
nnoremap <F6> :colorscheme seoul256<CR>
nnoremap <F10> :let &background = ( &background == "dark"? "light" : "dark" )<CR>

" Use silver searcher for grepping if available
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m
endif


" ----------------------------- PLUGINS -----------------------------

" NERDTREE
let g:NERDTreeWinSize = 40
let g:NERDTreeChDirMode = 2 " change vim working dir when nerdtree root changes
let g:NERDTreeCascadeSingleChildDir = 0 " don't collapse single child nodes by default
let g:NERDTreeIgnore = ['\.vim$', '\~$', '__pycache__$[[dir]]']

map <leader>n :NERDTreeToggle<CR>
map <leader>m :NERDTreeFind<CR>


" LIGHTLINE
set laststatus=2 " always display the status bar, even with single pane

" Use relative paths, path only for inactive split
let g:lightline = {
   \'active': {
   \  'left': [['mode', 'paste'],
   \           ['readonly', 'relativepath', 'modified']],
   \  'right': [['lineinfo'],
   \            ['percent'],
   \            ['fileformat', 'fileencoding', 'filetype']]
   \},
   \'inactive': {
   \  'left': [['relativepath']],
   \  'right': [[]],
   \},
   \'colorscheme': 'seoul256',
\}

" FZF
nmap <C-p> :Files<CR>
nmap <C-j> :Buffers<CR>


" VIM WIKI
let g:vimwiki_folding = 'expr' " enable folding
let g:vimwiki_global_ext = 0 " don't enable for random markdown files!
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" LOVE2D
nnoremap <leader>r :LoveRun<CR>
nnoremap <leader>t :LoveStop<CR>
