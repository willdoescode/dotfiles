call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'voldikss/vim-floaterm'
Plug 'shime/vim-livedown'
Plug 'luochen1990/rainbow'
Plug 'preservim/tagbar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'cespare/vim-toml'
Plug 'joshdick/onedark.vim'
Plug 'dag/vim-fish'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'
Plug 'junegunn/limelight.vim'
Plug 'wesQ3/vim-windowswap'
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki'
Plug 'mattn/emmet-vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'lervag/vimtex'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'pechorin/any-jump.vim'
call plug#end()

let g:onedark_terminal_italics = 1
let g:onedark_termcolors = 256
colorscheme onedark

" Allows undo even after saving and closing a fife
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/undo
endif

set number relativenumber
set mouse=a
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nocompatible

" When searching it will ignore case but if you search with an upercase it
" will suddenly start to care about the case
set ignorecase
set smartcase
set guifont=Fira\ Code:h13

" Leader key is now mapped to space
let mapleader = "\<Space>"
let g:go_fmt_autosave = 1
let g:rainbow_active = 1
let NERDTreeMinimalUI=1
let NERDTreeShowLineNumbers=0
let g:NERDTreeShowHidden=1
let g:NERDTreeHijackNetrw = 0
let g:windowswap_map_keys = 0
let g:limelight_conceal_ctermfg = 'gray'
let g:lightline = { 'colorscheme': 'onedark' }
let g:airline_theme='onedark'
let g:rustfmt_autosave = 0
let g:rust_clip_command = 'pbcopy'
let g:rust_recommended_style = 0
let delimitMate_expand_cr = 1
let g:user_emmet_install_global = 0
let g:go_fmt_command = "goimports"
let g:any_jump_search_prefered_engine = 'rg'
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Switches line nums to regular in insert mode
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

nnoremap <silent> <Up> :resize +2<CR>
nnoremap <silent> <Down> :resize -2<CR>
nnoremap <silent> <Left> :vertical resize +2<CR>
nnoremap <silent> <Right> :vertical resize -2<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <Leader>sc :noh<CR>
nnoremap S :%s///gI<Left><Left><Left><Left>
nnoremap <silent> \<Tab> :e#<CR>
nnoremap <Leader><Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>g :Rg<CR>
nnoremap <Leader>h :BLines<CR>
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <Leader>pw :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> <Leader><leader>w :call WindowSwap#EasyWindowSwap()<CR>
nnoremap <silent> <leader>pi :w<CR> :source %<CR> :PlugInstall<CR>
nnoremap <silent> <leader>pc :w<CR> :source %<CR> :PlugClean<CR>
nnoremap <silent> <leader>l :Limelight!!<CR>
nnoremap <silent> <leader>e :normal <C-y>, <CR><Left>i
nnoremap <silent> <Leader>t :call OpenTerminal()<CR>
" Only use in init.vim file so you don't have to restart vim to see changes
nnoremap <silent> <leader>sr :w<CR> :source %<CR>

" Sefect text and hold J or K to move it all up or down in a block
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv
nmap <F8> :TagbarToggle<CR>
nmap <Leader>w <plug>NERDCommenterToggle
" copy relative path and full path
nmap <silent> <leader>cr :let @+ = expand("%")<cr>
nmap <silent> <leader>cf :let @+ = expand("%:p")<cr>
map <Leader>; <plug>NERDCommenterToggle
map <silent> <Leader>f :call NERDTreeToggleInCurDir()<CR>
imap jj <Esc>

if has('nvim')
	fu! OpenTerminal()
		topleft split
		resize 30
		terminal
	endf
else
	fu! OpenTerminal()
		topleft split
		resize 30
		call term_start('fish', {'curwin' : 1, 'term_finish' : 'close'})
	endf
endif

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

function ExitGoyo()
	Limelight!
	" Makes terminal background clear again
	hi Normal guibg=NONE ctermbg=NONE
endfunction

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
autocmd User GoyoLeave call ExitGoyo()
autocmd FileType html,css EmmetInstall
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
autocmd Filetype tex setl updatetime=1
autocmd BufWritePost *.tex silent! execute "!pdflatex % >/dev/null 2>&1" | redraw!

" Set cursor back to line on vim exit
au VimLeave * set guicursor=v-c-sm:block,n-i-ci-ve:ver25,r-cr-o:hor20

filetype plugin indent on
filetype plugin on
syntax on

" Generate new tagbar types with :TagBarGetTypeConfig <lang> 
" Open tagbar with F8

source ~/.config/nvim/tagbar.vim

" Set vim to transparent before starting so no settings can change it
hi Normal guibg=NONE ctermbg=NONE
