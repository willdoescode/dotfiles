call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'tomasiser/vim-code-dark'
Plug 'nanotech/jellybeans.vim'
Plug 'preservim/nerdcommenter'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'voldikss/vim-floaterm'
Plug 'shime/vim-livedown'
Plug 'luochen1990/rainbow'
Plug 'preservim/tagbar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" Allows undo even after saving and closing a file
if has('persistent_undo')
  set undofile
  set undodir=$HOME/.config/nvim/undo
  endif

set number relativenumber
set mouse=a
set tabstop=2
set softtabstop=2
set shiftwidth=2

let mapleader = "\<Space>"
let g:NERDTreeShowHidden=1
let g:go_fmt_autosave = 1
let g:dracula_colorterm = 0
let g:rainbow_active = 1
let NERDTreeMinimalUI=1

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <Leader>sc :noh <CR>
nnoremap S :%s//gI<Left><Left><Left>
nnoremap \<Tab> :e# <CR>
nnoremap <Leader>s :Files <CR>

xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

nmap <F8> :TagbarToggle<CR>
nmap <Leader>w <plug>NERDCommenterToggle
vmap <Leader>w <plug>NERDCommenterToggle

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

imap jj <Esc>

colorscheme dracula

hi Normal guibg=NONE ctermbg=NONE
function! NERDTreeToggleInCurDir()
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    if (expand("%:t") != '')
      exe ":NERDTreeFind"
    else
      exe ":NERDTreeToggle"
    endif
  endif
endfunction

map <Leader>f :call NERDTreeToggleInCurDir()<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
autocmd VimEnter * :call NERDTreeToggleInCurDir()
autocmd VimEnter * wincmd p

filetype plugin indent on

" Generate new tagbar types with :TagBarGetTypeConfig <lang> 
" Open tagbar with F8

let g:tagbar_type_rust = {
    \ 'kinds' : [
        \ 'n:module:1:0',
        \ 's:struct',
        \ 'i:trait',
        \ 'c:implementation:0:0',
        \ 'f:function',
        \ 'g:enum',
        \ 't:type alias',
        \ 'v:global variable',
        \ 'M:macro',
        \ 'm:struct field',
        \ 'e:enum variant',
        \ 'P:method',
        \ '?:unknown',
    \ ],
\ }

let g:tagbar_type_go = {
    \ 'kinds' : [
        \ 'p:packages:0:0',
        \ 'i:interfaces:0:0',
        \ 'c:constants:0:0',
        \ 's:structs',
        \ 'm:struct members:0:0',
        \ 't:types',
        \ 'f:functions',
        \ 'v:variables:0:0',
        \ '?:unknown',
    \ ],
\ }

let g:tagbar_type_python = {
    \ 'kinds' : [
        \ 'i:modules:1:0',
        \ 'c:classes',
        \ 'f:functions',
        \ 'm:members',
        \ 'v:variables:0:0',
        \ '?:unknown',
    \ ],
\ }
