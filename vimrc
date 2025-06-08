" Color tango dark scheme
" Some syntax changes are added to .vim/after/syntax/syncolor.vim
" get colors for 256 https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
" Where to find lsp settings ~/.local/share/vim-lsp-settings/settings.json
" machines.
" Try to install mypy. Determine what python install pylsp is being run under.
" /home/thothgunter/.local/share/vim-lsp-settings/servers/pylsp-all/venv/bin/python3 -m pip install pylsp-mypy
"
" Install Ag
"
" Opens all project changes in vim at once in tabs
" vim -p $(git status -s | cut -d ' ' -f3)

let mapleader = ' '
set showcmd " Shows commands at the bottom of the screen.
syntax on

" Turns off $ at the end of each line.
set nolist
set hlsearch
set number
" Turn of selectable side numbers
" this doesn't work well for ghostty right now. I should create ticket to fix
" this.
set mouse=a
set signcolumn=number
" highlight SignColumn ctermbg=None


let ls_a_list = split(glob("`ls -a`")) 
if index(ls_a_list, "src/") >- 0
    set path+=src/**
endif
if index(ls_a_list, "test/") >- 0
    set path+=test/**
endif
" if index(let_a_list, ".git/") >= 0 
"     set path+=**
" endif
set wildmenu

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible    " Be iMproved
endif

"""""""""""""""""""""""""""""""""""
" NETRW
" Settings for file viewer.
let g:netrw_keepdir = 0
let g:netrw_liststyle = 3

" NOTE Vim should NOT track netrw, the file browser, to determine the current
" directory.
let g:netrw_keepdir = 1
"""""""""""""""""""""""""""""""""""


" Required:
" setlocal shiftwidth=4 tabstop=4 softtabstop=4 seems redundant with the
" settings below.
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 textwidth=100 smarttab expandtab nolist foldmethod=indent
autocmd TerminalOpen * setlocal nospell

filetype plugin indent on
set tabstop=2
set shiftwidth=4
set expandtab
set softtabstop=4

" ''''''''''''''''''''
" different cursor styles t_SI is insert mode
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"

" TODO what does this do? I think this should open the file with cursor at the
" previous position.
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Combines a selected text with a combined uni-code character.
function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

command! -range -nargs=0 Overline call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough call s:CombineSelection(<line1>, <line2>, '0336')

vnoremap ss : Strikethrough<CR>
nmap oo o<Esc>k
nmap OO O<Esc>k


" I think these tags are causing cpu spikes when opening rust repos. If we use an lsp is this necessary.
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" TODO Maybe clean up some time
set foldmethod=syntax
set foldlevelstart=99

if has('gui_running')
    colorscheme evening
" set guifont=Ubuntu\ Mono\ 13
" set guioptions -=T
endif




" ''''''''''''''''''''''''''''''''
" Status Bar
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=darkcyan ctermbg=white
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=darkcyan ctermbg=black
hi                  statusline guifg=#8fbfdc guibg=black ctermfg=darkcyan ctermbg=black

highlight StatusLine2 ctermfg=250 ctermbg=237 guifg=#ffffff guibg=#0000ff

let g:modes={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ "\<C-V>" : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ "\<C-s>" : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set laststatus=2

set statusline=
set statusline+=%#Cyan#\ %<%F%m%r%h%w\         " File path, modified, readonly, helpfile, preview
set statusline+=%#StatusLine2#│                " Separator
set statusline+=\ %Y\                          " FileType
set statusline+=│                              " Separator
set statusline+=%=                             " Right Side
set statusline+=│%{count}                      " Separator and count
set statusline+=\ ln:\ %02l/%L\ (%3p%%)\       " Line number / total lines, percentage of document
set statusline+=%#Cyan#\ %{g:modes[mode()]}\   " The current mode

hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" The following helps adjust the color scheme of the statusline when the cursor is not window 
au WinLeave * setlocal statusline=%#Cyan#\ %<%F%m%r%h%w\ %#StatusLine2#│\ %Y\ │%=│%{count}\ ln:\ %02l/%L\ (%3p%%)\ %#Cyan#\ %{g:modes[mode()]}
" ''''''''''''''''''''''''''''''''


" ''''''''''''''''''''''''''''''''
" Sets up the cursor column.
highlight CursorColumn guibg=#404040 ctermbg=23
" Set the cursor column only when in an active buffer
augroup CursorColumn
    au!
    au VimEnter * setlocal cursorcolumn
    au WinEnter * setlocal cursorcolumn
    au BufWinEnter * setlocal cursorcolumn
    au BufWinLeave * setlocal nocursorcolumn
    au WinLeave * setlocal nocursorcolumn
augroup END


" reset the cursor on start (for older versions of vim, usually not required)
augroup resetCursorOnStart
    au!
    autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
" ''''''''''''''''''''''''''''''''

" Asks vim to resync syntax highlight when changing buffers.
" The original problem was comment and string highlighting breaking and never
" fixing itself. This should provide an auto correction. If not working well
" increase minlines.
autocmd BufEnter * syntax sync minlines=30


call plug#begin()
    Plug 'xolox/vim-misc'
    " TODO remove vim-notes and replace with bash scripts
    Plug 'xolox/vim-notes'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'kaarmu/typst.vim'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'airblade/vim-gitgutter'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'madox2/vim-ai'
call plug#end()

nmap <Leader>lh : LspHover<CR>
nmap <Leader>b : Buffers<CR>
nmap <Leader>t : Vexplore<CR>
nmap <Leader>f : Ag<CR>
nmap <Leader>e : LspNextError<CR>
nmap <Leader>ep: LspPreviousError<CR>
nmap <Leader>d : LspDocumentDiagnostics<CR>
" We may want to set this based on file type. This is the side column which
" lsp and git uses to display problems.
    
highlight SpellBad ctermbg=None ctermfg=208 cterm=underline,bold
set spell

highlight Pmenu ctermfg=255 ctermbg=239 guifg=#ffffff guibg=#0000ff
hi Folded ctermbg=None cterm=bold
hi LineNr ctermfg=darkgrey

" Notes directory
let g:notes_directories = ['~/.vim/plugged/vim-notes/misc/notes/user', '~/Documents/vim-notes']

command OpenNotes execute 'Files' g:notes_directories[0]
" Command to compile code and place the errors in a buffer at the bottom of
" the screen. We may not want to use this for rust cargo because of the VimCargo tool.
" nnoremap <F9> :wa <bar> :compiler gcc <bar> :silent! make %:r <CR> :cw <CR>
" autocmd FileType rust :compiler rustc :make build

" TODO what does this do? And why do we want it?
let g:notes_conceal_url = 0
let g:notes_conceal_code = 0

" lsp settings
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_text_edit_enabled = 1
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_prefix = " ‣ "
let g:lsp_diagnostics_virtual_text_wrap = "truncate"
let g:ls_diagnostics_enabled = 1
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_signs_error = {'text': 'X'}
let g:lsp_diagnostics_signs_warning = {'text': 'W'}
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_echo_cursor = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 200
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_float_max_width = 50
let g:lsp_diagnostics_highlights_delay = 50
let g:lsp_diagnostics_signs_delay = 50

" NOTE
" This highlights the bit of code that has an error.
highlight LspWarningHighlight term=underline cterm=underline gui=underline
highlight LspErrorHighlight ctermfg=Red term=underline cterm=underline,bold gui=underline
highlight LspErrorText ctermfg=Red ctermbg=None cterm=bold,underline

let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" AI model config
let s:vim_ai_endpoint_url = "http://localhost:8080/v1/chat/completions"
let s:vim_ai_model = "llama"
let s:vim_ai_chat_prompt =<< trim END
>>> system

You are Qwen, created by Alibaba Cloud. You are a helpful assistant.

You will work in tandem with a human engineer on code generation, debugging and optimization.

Assume all unknown symbols are properly initialized elsewhere. If their type or purpose is unclear, provide a reasonable assumption or ask clarifying questions.

Use the appropriate syntax identifier after ``` (e.g., python, javascript, html). Default to plaintext if the language is unclear.

If the input is incomplete or ambiguous, provide the most logical interpretation and suggest improvements or ask for clarifications.

Provide concise, well-structured answers with clear code examples.
END

let s:vim_ai_chat_config = #{
\  provider: "openai",
\  options: #{
\    model: s:vim_ai_model,
\    initial_prompt: s:vim_ai_chat_prompt,
\    endpoint_url: s:vim_ai_endpoint_url,
\    auth_type: 'none',
\    max_tokens: 0,
\    max_completion_tokens: 0,
\    request_timeout: 60,
\  },
\}
let g:vim_ai_chat = s:vim_ai_chat_config

" Toggle when debugging
" let g:lsp_log_file = expand('~/vim-lsp.log')
