set nocompatible                         " make the "m" in "Vim" work right
source $VIMRUNTIME/add-on-settings.vim   " external settings file for plug-ins :-)
source $VIMRUNTIME/passwords.vim         " passwords for some plug-in functions


" fixed MyDiff() according to vim.wikia.com/wiki/Running_diff
set diffexpr=MyDiff()
function MyDiff()
    let opt = ''
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    silent execute '!diff -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
endfunction

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all plain text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
  
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif


" -------------------------------------------------------
" tux: extra config (for both vim and gvim)
" -------------------------------------------------------

" --- brackets should be highlighted ---

set showmatch
set matchpairs=(:)
set matchpairs+=[:]
set matchpairs+={:}
set matchpairs+=<:>
set matchtime=3

" --- speed up loading of big files ---

let g:SaveUndoLevels = &undolevels
let g:BufSizeThreshold = 1000000
if has("autocmd")
  " Store preferred undo levels
  autocmd VimEnter * let g:SaveUndoLevels = &undolevels
  " Don't use a swap file for big files
  autocmd BufReadPre * if getfsize(expand("<afile>")) >= g:BufSizeThreshold | setlocal noswapfile | endif
  " Upon entering a buffer, set or restore the number of undo levels
  autocmd BufEnter * if getfsize(expand("<afile>")) < g:BufSizeThreshold | let &undolevels=g:SaveUndoLevels | else | set undolevels=-1 | endif
endif

" --- use the mouse if possible ---

if has("mouse")
  set mouse=a
endif

" --- more detailed, colored statusline ---

function DispCurrMode()
    let mymode = mode()
    if mymode ==? "i"
        return "Ins"
    elseif mymode ==? "v"
        return "Vis"
    elseif mymode ==? "s"
        return "Sel"
    elseif mymode ==? "R"
        return "Rpl"
    elseif mymode == ""
        return "Cpy"
    elseif mymode ==? "n"
        return "Cmd"
    else
        return mymode
    endif
endfunction

function DispFileType()
    let mytype = "[".&filetype."]"
    if strlen(&filetype) >? 0
        return mytype
    endif
    return "[plain]"
endfunction

hi User1 ctermbg=black ctermfg=yellow guibg=black guifg=yellow  " %1*
hi User2 ctermbg=black ctermfg=grey   guibg=black guifg=grey    " %2*
hi User3 ctermbg=black ctermfg=red    guibg=black guifg=red     " %3*

set laststatus=2          " always show statusline
set statusline=           " start with an empty one

set statusline+=\ [%n]                          " buffer number
set statusline+=\ %1*[%-.65F]%*                 " file name (max. 65 chars)
set statusline+=\ %2*%{DispFileType()}%m%3*%r%* " file type, modified, read-only (if applicable)
set statusline+=\ [%{&ff}]                      " file format
set statusline+=[%{strlen(&fenc)?&fenc:'none'}] " file encoding
set statusline+=\ %=                            " switch to the right
set statusline+=\ %l/%L,%-5c                    " current line/total lines,current column
set statusline+=\ [%{DispCurrMode()}]           " current mode as a 3-letter code
set statusline+=\ %P\                           " percentage of current file

if has("autocmd")
" --- highlight settings ---

    autocmd InsertLeave * se nocul   " highlight current line when in insert mode
    autocmd InsertEnter * se cul     " unhighlight current line when not in insert mode

" --- don't auto-complete comments ---

    autocmd FileType * setlocal fo-=cro

" --- code folding ---

    " auto-define folds but unfold them on startup
    autocmd Syntax * setlocal foldmethod=syntax
    autocmd Syntax * normal zR
    " code folding via Space when the file has folds
    autocmd Syntax * nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>

" --- no wrapping for all but plain text files ---

    autocmd Syntax * setlocal nowrap

" --- no auto-indentation for HTML files ---

    autocmd FileType html set noautoindent indentexpr=
endif

" --- indenting stuff: use Tab and/or > ---
" (highlighting single characters, too hard to fix, so what)

vnoremap > >gv
vnoremap < <gv
vmap <Tab> >
vmap <S-Tab> <

" --- tab navigation like Firefox ---

nmap <C-S-tab> :tabprevious<CR>
nmap <C-tab> :tabnext<CR>
map <C-S-tab> :tabprevious<CR>
map <C-tab> :tabnext<CR>
imap <C-S-tab> <Esc>:tabprevious<CR>
map <C-tab> <Esc>:tabnext<CR>
nmap <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>

" reserved for window switching, need to choose another hotkey:
"nmap <C-w> :q<CR>      "(Remark: tabpagenr('$')==1?) 
"imap <C-w> <Esc>:q<CR> "(Remark: tabpagenr('$')==1?)

" --- oh, BTW, Firefox: call it on demand ---

function! Browser()
    let $PATH = $PATH . ';c:\Program Files\Mozilla Firefox'
    " REMARK: Remember to set the path accordingly on other systems
    let line0 = getline(".")
    let line = matchstr(line0, "http[^ ]*")
    if line==""
        let line = matchstr (line0, "ftp[^ ]*")
    endif
    let line = escape(line, "#;|%")
    exec ':silent !firefox.exe ' . "\"" . line . "\""
endfunction
map ,w :call Browser()<CR>

" --- copying ---

set clipboard=unnamed  " yank to * instead of "
"set guioptions+=a     " visual mode selection automatically copies to clipboard

" --- remove highlights via <Esc> ---

nnoremap <Esc> :noh<CR><Esc>

" --- various settings ---

set nobackup writebackup  " temporary backups, deleted on successful saving
set autoindent            " auto indentation
set history=25            " keep 25 lines of command line history
"set showcmd              " display incomplete commands
set incsearch             " do incremental searching (type-ahead find)
set noshowmode            " mode is displayed in statusbar only :)
set fileencodings=ucs-bom,utf-8,default,latin1
                          " known file encodings for auto detection
set encoding=utf-8        " no ANSI-BOM bullshit
set number                " line numbers
set smarttab              " auto-replace <Tab> by blanks
set shiftwidth=4          " 4 characters for a tab should be enough
set expandtab             " no tabs anyway
set autoread              " automatically reload modified files
set foldlevelstart=20     " max. technically possible value for improved folding
set linebreak             " break lines at separators, not stupidly on textwidth
