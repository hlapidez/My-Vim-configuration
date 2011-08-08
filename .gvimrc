" -------------------------------------------------------
" tux config (gvim only)
" -------------------------------------------------------

if has("win32")
  set guifont=Consolas
endif

set guioptions=aegit " shrink the window ;)
set mousehide        " hide the mouse when typing text

autocmd GUIEnter * simalt ~x	 " force full screen (Windows-only)

"colorscheme sean    " dark background, better coloring

" -------------------------------------------------------
" partially taken from the sample gvimrc:
" -------------------------------------------------------

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting if it wasn't on yet.
  if !exists("hlsearch")
    set hlsearch
  endif
  
endif
