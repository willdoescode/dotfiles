call plug#begin()
  Plug 'preservim/nerdcommenter'
  Plug 'Olical/conjure', {'tag': 'v4.24.0'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'morhetz/gruvbox'
  Plug 'jiangmiao/auto-pairs'
  Plug 'luochen1990/rainbow'
  Plug 'rhysd/vim-clang-format'
  Plug 'jackguo380/vim-lsp-cxx-highlight'
  Plug 'thinca/vim-quickrun'
  Plug 'idris-hackers/idris-vim'
  Plug 'ziglang/zig.vim'
call plug#end()

" The best theme
colorscheme gruvbox

" The best line numbers
set number relativenumber

" Why are default indents 8 spaced
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Click to move cursor 
set mouse=a

" Persistent undo and backup
set dir=~/.vim/swapfiles
set backup
set backupdir=~/.vim/backupfiles
set undofile
set undodir=~/.vim/undofiles

let g:rainbow_active = 1

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

