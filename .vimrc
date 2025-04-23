scriptencoding utf-8
set nocompatible
set encoding=utf-8 fileencoding=utf-8
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
if has("autocmd")
  filetype plugin indent on
  syntax on
endif
set backspace=indent,eol,start
set incsearch
"set ignorecase
"set smartcase
set scrolloff=2
set wildmode=longest,list
"set wildmode=full
set autochdir
set ruler
set tabpagemax=256

"au FileType c,cpp setlocal comments-=://
"au FileType c,cpp setlocal comments+=f://
au FileType c,cpp setlocal comments+=:///

au FileType python,verilog setlocal ts=4 sts=4 sw=4 et

au FileType html,htmldjango setlocal tabstop=2 softtabstop=2 shiftwidth=2

au FileType tex setlocal ts=2 sts=2 sw=2 et

if has('gui_running')
    set background=dark
    let g:solarized_termtrans=1
    colorscheme solarized
else
    set background=dark
    colorscheme torte
endif

function! Wrap(width)
  let &tw=a:width
  let &cc=a:width+1
endfunction

function! NoWrap()
  set textwidth=0 cc=0
endfunction

set splitright

set tags=tags;/
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

let g:lasttab = 1
nmap <Leader>tt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

execute pathogen#infect()

" stolen from Saleem

"set hlsearch
" unhighlight the search results when the keyboard is idle
"autocmd CursorHold,CursorHoldI * nohls | redraw

syntax sync fromstart " parse from the beginning to get accurate syntax highlighting

if (&termencoding == "utf-8") || has("gui_running")
  if (v:version >= 700)
    set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
  else
    set list listchars=tab:»·,trail:·,extends:…
  endif
else
  if (v:version >= 700)
    set list listchars=tab:>-,trail:.,extends:>,nbsp:_
  else
    set list listchars=tab:>-,trail:.,extends:>
  endif
endif

map <C-K> :pyf /usr/local/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:pyf /usr/local/share/clang/clang-format.py<cr>
