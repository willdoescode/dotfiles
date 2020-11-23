"=============================================================================
" init.vim --- Language && encoding in SpaceVim
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:SYSTEM = SpaceVim#api#import('system')

"Use English for anything in vim
try
  if s:SYSTEM.isWindows
    silent exec 'lan mes en_US.UTF-8'
  elseif s:SYSTEM.isOSX
    silent exec 'language en_US.UTF-8'
  else
    let s:uname = system('uname -s')
    if s:uname ==# "Darwin\n"
      " in mac-terminal
      silent exec 'language en_US.UTF-8'
    elseif s:uname ==# "SunOS\n"
      " in Sun-OS terminal
      silent exec 'lan en_US.UTF-8'
    elseif s:uname ==# "FreeBSD\n"
      " in FreeBSD terminal
      silent exec 'lan en_US.UTF-8'
    else
      " in linux-terminal
      silent exec 'lan en_US.UTF-8'
    endif
  endif
catch /^Vim\%((\a\+)\)\=:E197/
  call SpaceVim#logger#error('Can not set language to en_US.utf8')
endtry

" try to set encoding to utf-8
if s:SYSTEM.isWindows
  " Be nice and check for multi_byte even if the config requires
  " multi_byte support most of the time
  if has('multi_byte')
    " Windows cmd.exe still uses cp850. If Windows ever moved to
    " Powershell as the primary terminal, this would be utf-8
    if exists('&termencoding') && !has('nvim')
      set termencoding=cp850
    endif
    setglobal fileencoding=utf-8
    " Windows has traditionally used cp1252, so it's probably wise to
    " fallback into cp1252 instead of eg. iso-8859-15.
    " Newer Windows files might contain utf-8 or utf-16 LE so we might
    " want to try them first.
    set fileencodings=ucs-bom,utf-8,gbk,utf-16le,cp1252,iso-8859-15,cp936
  endif

else
  if exists('&termencoding') && !has('nvim')
    set termencoding=utf-8
  endif
  set fileencoding=utf-8
  set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
endif
scriptencoding utf-8

let g:dracula_italic = 0

" should markdown preview get shown automatically upon opening markdown buffer
let g:livedown_autorun = 0

" should the browser window pop-up upon previewing
let g:livedown_open = 1

" the port on which Livedown server will run
let g:livedown_port = 1337

let g:rundir = "~/.cache/vimfiles/repos/github.com/ledesmablt/vim-run/"
let g:run_shell = $SHELL
let g:run_quiet_default = 0
let g:run_autosave_logs = 0
let g:run_nostream_default = 0
let g:run_browse_default_limit = 10


let g:codi#interpreters = {
                   \ 'python': {
                       \ 'bin': 'python3',
                       \ 'prompt': '^\(>>>\|\.\.\.\) ',
                       \ },
                   \ }

vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle



let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

let g:neomake_python_python_exe = 'python3'

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml, *.svelte'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'
let NERDTreeMinimalUI=1
nnoremap S :%s//gI<Left><Left><Left>
set ignorecase
set smartcase
set t_Co=256
set t_ut=
let g:NERDTreeShowHidden=1
let g:spacevim_disabled_plugins = ['vim-startify']
let g:signit_initials = 'WL'
let g:signit_name = 'William Lane'
let g:signit_extra_1 = 'https://github.com/willdoescode'

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
