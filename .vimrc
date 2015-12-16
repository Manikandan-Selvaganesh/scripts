syntax on
set number
set wildmode=longest,list,full
set cursorline
set wildmenu
set hlsearch
set directory=~/.vim/swap,.
set nocompatible              " be iMproved
filetype off                  " required!
autocmd BufWritePre * :%s/\s\+$//e
set wrap
set linebreak
" note trailing space at end of next line
set showbreak=>\ \ \
let g:Powerline_symbols = 'fancy'
set rtp+=~/.vim/bundle/Vundle.vim/
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set laststatus=2
set t_Co=256
let g:Powerline_mode_V="V·LINE"
let g:Powerline_mode_cv="V·BLOCK"
let g:Powerline_mode_S="S·LINE"
let g:Powerline_mode_cs="S·BLOCK"
let g:airline_powerline_fonts = 1
colorscheme desert
" let Vundle manage Vundle
" required!
"autocmd vimenter * if !argc() NERDTree | endif
" My bundles here:
"
" original repos on GitHub
" set the runtime path to include Vundle and initialize
set runtimepath^=~/.vim/bundle/ctrlp.vim
set rtp+=/home/Manikandan/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'altercation/vim-colors-solarized'
filetype indent plugin on     " required!
set tabstop=8 shiftwidth=8 expandtab
cmap w!! w !sudo tee %
" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction
" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = Chomp(system("git ls-files | dmenu -i -l 20 -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction
map <c-t> :call DmenuOpen("tabe")<cr>
map <c-f> :call DmenuOpen("e")<cr>
nmap ,f :FufFileWithCurrentBufferDir<CR>
nmap ,b :FufBuffer<CR>
nmap ,t :FufTaggedFile<CR>
set backspace=indent,eol,start
autocmd FileType sml map <silent> <buffer> <leader><space> <leader>cd:w<cr>:!sml %<cr>
" SML make code {{{
autocmd FileType sml setlocal makeprg=rlwrap\ sml\ -P\ full\ '%'
"  }}}
let g:zipPlugin_ext = '*.zip,*.jar,*.xpi,*.ja,*.war,*.ear,*.celzip,*.oxt,*.kmz,*.wsz,*.xap,*.docx,*.docm,*.dotx,*.dotm,*.potx,*.potm,*.ppsx,*.ppsm,*.pptx,*.pptm,*.ppam,*.sldx,*.thmx,*.crtx,*.vdw,*.glox,*.gcsx,*.gqsx'

if has("cscope")
     set cscopetag
     set csto=0
     if $CSCOPE_DB != ""
           cs add $CSCOPE_DB
     endif
     set cscopeverbose
endif
set pastetoggle=<F2>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
set tags=./tags;/
nmap <F15> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
  \:!cscope -b -i cscope.files -f cscope.out<CR>
  \:cs reset<CR>
