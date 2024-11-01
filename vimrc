" Color tango dark scheme
" Some syntax changes are added to .vim/after/syntax/syncolor.vim
" get colors for 256 https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
" TODO look into timeoutlen for future improvements for key sequence timeouts.
" TODO add this file to github so that it can be easily used across mulitple
" Where to find lsp settings ~/.local/share/vim-lsp-settings/settings.json
" machines.
" Try to install mypy. Determine what python install pylsp is being run under.
" /home/thothgunter/.local/share/vim-lsp-settings/servers/pylsp-all/venv/bin/python3 -m pip install pylsp-mypy
"
" Install Ag

let mapleader = ' '
set showcmd " Shows commands at the bottom of the screen.
syntax on
set background=black

" Turns off $ at the end of each line.
set nolist
set hlsearch

if index(split(glob("`ls -a`")), ".git/") >= 0 
    set path+=**
set wildmenu

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible    " Be iMproved
endif


" Required:
setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 textwidth=100 smarttab expandtab nolist

filetype plugin indent on
set tabstop=2
set shiftwidth=4
set expandtab

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
autocmd FileType python setlocal foldmethod=indent
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
hi                  statusline guifg=#8fbfdc guibg=black ctermfg=darkcyan  ctermbg=black

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
set statusline+=%#Cyan#\ %<%F%m%r%h%w\           " File path, modified, readonly, helpfile, preview
set statusline+=%#StatusLine2#│                              " Separator
set statusline+=\ %Y\                          " FileType
set statusline+=│                                 " Separator
set statusline+=%=                             " Right Side
set statusline+=│%{count}                         " Separator and count
set statusline+=\ ln:\ %02l/%L\ (%3p%%)\       " Line number / total lines, percentage of document
set statusline+=%#Cyan#\ %{g:modes[mode()]}\    " The current mode

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
    Plug 'xolox/vim-notes'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'preservim/nerdtree'
    Plug 'kaarmu/typst.vim'
call plug#end()

highlight LspWarningHighlight term=underline cterm=underline gui=underline
highlight LspErrorHighlight ctermfg=Red term=underline cterm=underline,bold gui=underline
nmap <Leader>lh : LspHover<CR>
nmap <Leader>b : Buffers<CR>
nmap <Leader>nt : NERDTree<CR>
nmap <Leader>f : Ag<CR>
" We may want to set this based on file type. This is the side column which
" lsp and git uses to display problems.
set signcolumn=no
    
highlight SpellBad ctermbg=None ctermfg=208 cterm=underline,bold
set spell

highlight Pmenu ctermfg=255 ctermbg=239 guifg=#ffffff guibg=#0000ff

" Notes directory
let g:notes_directories = ['~/.vim/plugged/vim-notes/misc/notes/user', '~/Documents/vim-notes']

command OpenNotes execute 'Files' g:notes_directories[0]
" Command to compile code and place the errors in a buffer at the bottom of
" the screen. We may not want to use this for rust cargo because of the VimCargo tool.
" nnoremap <F9> :wa <bar> :compiler gcc <bar> :silent! make %:r <CR> :cw <CR>
" autocmd FileType rust :compiler rustc :make build

" TODO
let g:notes_conceal_url = 0
let g:notes_conceal_code = 0

" lsp settings
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_text_edit_enabled = 1
let g:lsp_diagnostics_echo_delay = 200
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 1
let g:lsp_diagnostics_virtual_text_prefix = " ‣ "

" let g:lsp_log_file = expand('~/vim-lsp.log')
