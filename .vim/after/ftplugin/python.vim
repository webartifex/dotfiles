" Set the search path to the folder of the current file and its sub-folders
setlocal path=.,**
" Exclude Python's compiled files from searches
setlocal wildignore=*/__pycache__/*,*.pyc


" TODO: This does not work, maybe because we spell out imports
" as project-local imports (e.g. from lalib.fields import base)?
" Include *.py files imported as modules when searching.
" Source: https://www.youtube.com/watch?v=Gs1VDYnS-Ac
set include=^\\s*\\(from\\\|import\\)\\s*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)
" 1) import foo.bar -> foo/bar.py
" 2) from foo import bar as var -> foo/bar.py or foo.py
function! PyInclude(fname)
    let parts = split(a:fname, ' import ')  " 1) [foo.bar] or 2) [foo, bar]
    let left = parts[0]  " 1) foo.bar or 2) foo
    if len(parts) > 1
        let right = parts[1]  " only 2) bar
        let joined = join([left, right], '.')
        let fpath = substitute(joined, '\.', '/', 'g') . '.py'
        let found = glob(fpath, 1)
        if len(found)
            return found
        endif
    endif
    return substitute(left, '\.', '/', 'g') . '.py'
endfunction
setlocal includeexpr=PyInclude(v:fname)
setlocal define=^\\s*\\<\\(def\\|class\\)\\>


" Number of spaces used for each step of auto-indent
set shiftwidth=4

" Number of spaces a <Tab> counts for in the file
set tabstop=4

" Number of spaces a <Tab> counts for in editing mode
set softtabstop=4

" Change <Tab>s into spaces
set expandtab

" Copy indent from previous line when starting a new line
set autoindent

" Use indent according to the syntax of the open file
set smartindent

" Auto-wrap lines after 88 characters, which is PEP8's limit plus 10%,
" a more relaxed boundary which occasionally may be used
set textwidth=88


" Make column 80 red to indicate PEP8's maximum allowed line length
set colorcolumn=80

" Additionally, give every character beyond 80 columns a red background
highlight ColorColumn ctermbg=DarkRed
call matchadd('ColorColumn', '\%80v', 100)
match ErrorMsg '\%>80v.\+'


" Show line numbers by default for .py files
let g:show_numbers=1
