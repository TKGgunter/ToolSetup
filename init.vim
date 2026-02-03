" Turn off neovim color scheme and termguicolors
set notermguicolors
colorscheme vim

" Change the leader key to the space bar.
let mapleader = ' '

 " Shows commands at the bottom of the screen.
set showcmd

" Turn on syntax highlighting
syntax on

" Turn on spell check 
set spell
highlight SpellBad ctermbg=None ctermfg=208 cterm=underline,bold
" Turn off SpellCap highlighting.
" SpellCap highlights words that vim believes should have a leading capital
" letter but do not.
highlight clear SpellCap

" Turns off $ at the end of each line.
set nolist

" Highlight term which is searched
set hlsearch

" Set line number
" And set the for ground color
set number
hi LineNr ctermfg=darkgrey

" Turn off selectable side numbers
" this may not work well for ghostty right now. I should create ticket to fix
" this.
set mouse=a

" If this many milliseconds nothing is typed the swap file is updated.
set updatetime=10

" Turns on wild menu.
set wildmenu

" Setting indent configs
set tabstop=2
set shiftwidth=4
set expandtab
set softtabstop=4

" Sets the cursor to previous position when the file was last closed.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Use the syntax when folding code.
set foldmethod=syntax

" Open file un-folded
set foldlevelstart=99


" ''''''''''''''''''''''''''''''''
" Status Bar
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=darkcyan ctermbg=white
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=darkcyan ctermbg=black
hi                  statusline guifg=#8fbfdc guibg=black ctermfg=darkcyan ctermbg=black

" For some reason ctermfg and ctermbg needed to be reversed to get nvim and
" vim aligned.
highlight StatusLine2 ctermfg=237 ctermbg=250 guifg=#ffffff guibg=#0000ff

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
set statusline+=\ ln:\ %02l/%L\ (%3p%%)\       " Line number / total lines, percentage of document
set statusline+=%#Cyan#\ %{g:modes[mode()]}\   " The current mode

hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none gui=none
" The following helps adjust the color scheme of the statusline when the cursor is not window 
au WinLeave * setlocal statusline=%#Cyan#\ %<%F%m%r%h%w\ %#StatusLine2#│\ %Y\ │%=│\ ln:\ %02l/%L\ (%3p%%)\ %#Cyan#\ %{g:modes[mode()]}
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


" Set todo high lighting
highlight Todo ctermbg=None ctermfg=lightyellow cterm=underline,bold

" Set float window color
" 237 is a darkgrey
highlight NormalFloat ctermfg=grey ctermbg=237


" These are terminal short cut commands.
" Disable insert mode after process exits, so the buffer can't be closed by
" accident. This is NeoVim specific!
augroup Term
  autocmd!
  autocmd TermClose * ++nested stopinsert | au Term TermEnter <buffer> stopinsert
augroup end

function! s:TermEnter(_)
  if getbufvar(bufnr(), 'term_insert', 0)
    startinsert
    call setbufvar(bufnr(), 'term_insert', 0)
  endif
endfunction

function! <SID>TermExec(cmd)
  let b:term_insert = 1
  execute a:cmd
endfunction

augroup Term
  autocmd CmdlineLeave,WinEnter,BufWinEnter * call timer_start(0, function('s:TermEnter'), {})
augroup end

tnoremap <silent> <C-W>.      <C-W>
tnoremap <silent> <C-W><C-.>  <C-W>
tnoremap <silent> <C-W><C-\>  <C-\>
tnoremap <silent> <C-W>N      <C-\><C-N>
tnoremap <silent> <C-W>:      <C-\><C-N>:call <SID>TermExec('call feedkeys(":")')<CR>
tnoremap <silent> <C-W><C-W>  <cmd>call <SID>TermExec('wincmd w')<CR>
tnoremap <silent> <C-W>h      <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W>j      <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W>k      <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W>l      <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W><C-H>  <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W><C-J>  <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W><C-K>  <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W><C-L>  <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W>gt     <cmd>call <SID>TermExec('tabn')<CR>
tnoremap <silent> <C-W>gT     <cmd>call <SID>TermExec('tabp')<CR>
"'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


" Creates a terminal on the left side of the terminal
" and places the cursor there.
command -nargs=0 Vterm :vert term

" Creates a split and in the new upper buffer places a terminal
" and places the cursor in the new buffer
command -nargs=0 Hterm :hor term


" Plug in manager is Vim-plug
" https://github.com/junegunn/vim-plug
"
" to install in nvim
"
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
call plug#begin()
  " lsp default configs for a number of langs
  Plug 'neovim/nvim-lspconfig'
  " nice fuzzy search and dependencies
  " install ripgrep to search dir
  " sudo apt-get install ripgrep
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim' ", { 'tag': '0.1.8' }  NOT SURE WHY THIS VERSION WAS NEEDED
  " Ai assistant
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'olimorris/codecompanion.nvim'
  " markdown renderer and mini-icons for pretty-ness
  Plug 'echasnovski/mini.nvim'
  Plug 'MeanderingProgrammer/render-markdown.nvim'
  " gitgutter
  Plug 'airblade/vim-gitgutter'
  " better support than default lsp integration with rust-analyser 
  Plug 'mrcjkb/rustaceanvim'
  " Unit test tools
  Plug 'antoinemadec/FixCursorHold.nvim'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'nvim-neotest/neotest'
  " oil for buffer based dir viewing
  Plug 'stevearc/oil.nvim'
  " # d2 - for creating uml diagrams.
  " :help d2-vim
  "
  " # Useful commands
  " <Leader>d2  # to create an ascii preview
  " <Leader>rd2  # to replace text with ascii preview
  Plug 'terrastruct/d2-vim'
  " # python lsp
  " install basedpyright for lsp support.
  "
  " pip install basedpyright
  "
  " I find basedpyright works more frequency then pyright.
  " basedpyright allows takes on the responsibility of installing and up
  " keeping npm, something I am not interested in doing.
  "
  " # python formatting and syntax suggestions
  " pip install ruff

  " render image in buffer
  Plug '3rd/image.nvim'
call plug#end()

" Turning on icons used by markdown
lua << EOF
require("mini.icons").setup()
EOF

" Set up markdown rendering
lua << EOF
require('render-markdown').setup({
    code = {
        conceal_delimiters = false,
        border = 'thin',
    },
    heading = {
        width = 'block',
    }
})
-- Set up the `3rd/image` to render images
require('image').setup()
EOF

lua << EOF
require("oil").setup({
    view_options = {
        show_hidden = true 
    }
})
EOF

" require ai helper
" TODO choose ai based off of env
lua << EOF
require("codecompanion").setup({
  interactions = {
      chat = {
          adapter = "ollama"
      },
      inline = {
          adapter = "ollama"
      }
  },
  adapters = {
    http = {
    llama3 = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
        schema = {
          model = {
            default = "llama3:latest",
          },
          num_ctx = {
            default = 16384,
          },
          num_predict = {
            default = -1,
          },
        },
      })
    end,
    },
  },
})
EOF

" Turn off lsp syntax
lua << EOF
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
});
EOF

" adding a border to hover
" doesn't seem to work
lua << EOF
vim.lsp.handlers["textDocument/hover"] = function(_, result, _)
    vim.lsp.util.open_floating_preview(result.contents, "markdown", { border = "rounded" })
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, _)
    vim.lsp.util.open_floating_preview(result.contents, "plaintext", { border = "rounded" })
end
EOF

" Opens a terminal on the left side of the terminal window
nmap <Leader>vt : Vterm<CR>
" opens a list of open buffers in a preview menu.
nmap <Leader>b : Telescope buffers<CR>
" open a fuzzy search for the contents of files
nmap <Leader>f : Telescope live_grep<CR>
" Opens a hover virtual panel
" you can also do this with shift+k
nmap <Leader>lh : LspHover<CR>
" clear search
nmap <Leader>/ : noh<CR>

" Makes diagnostic column the same as number column
set signcolumn=number
" Setup diagnostics symbols
lua << EOF
vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✘',
        [vim.diagnostic.severity.WARN] = '▲',
        [vim.diagnostic.severity.HINT] = '⚑',
        [vim.diagnostic.severity.INFO] = '»',
      }
    },
});
EOF

" Open diagnostics on hover
lua << EOF
vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})
EOF

" Changing highlights for GitGutter
" au VimEnter * GitGutterSignsEnable

" Turn on gitgutter sign by default
let g:gitgutter_signs=1

" Turn off background of gitgutter
hi SignColumn ctermbg=None

" Set foreground color for added lines
hi GitGutterAdd ctermfg=green
" Set foreground color for changed lines
hi GitGutterChange ctermfg=yellow ctermbg=None

" hi GitGutterAddLineNr ctermfg=green ctermbg=None
" hi GitGutterChangeLineNr ctermfg=yellow ctermbg=None

au VimEnter * GitGutterLineHighlightsDisable 

" TODO
" - change markdown highlight colors to be more subtle
" - use line numbers instead of signs for git gutter
hi RenderMarkdownH1Bg ctermbg=darkgrey
hi RenderMarkdownCode ctermbg=236
hi RenderMarkdownH1Bg ctermbg=black


" change Pmenu colors to not purple
hi Pmenu ctermbg=darkgrey
hi PmenuKind ctermbg=darkgrey
hi PmenuExtra ctermbg=darkgrey
hi PmenuMatch ctermbg=darkgrey

" change special comment color from pink/purple to grey.
" When pink it creates significant visual noise that makes it harder to read
" the code through the docstrings
hi SpecialComment ctermfg=darkgray

" config ruff-lsp.
lua << EOF
require('lspconfig').ruff.setup {
    init_options = {
        settings = {
            args = {},
        }
    }
}
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

vim.lsp.enable("basedpyright")
-- TODO do we need this?
--[[
require('lspconfig').pyright.setup {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
}
]]
EOF


" Lsp Hover short command and set default settings
command -nargs=0 LspHover :lua vim.lsp.buf.hover({border='rounded'})

" Remap omnifunc(the lsp auto-complete function) to shift-tab. This is intended
" to move lsp complete to a more comfortable mapping, shift-tab. To navigate
" the autocomplete menu use the standard autocomplete navigation <C-N> and <C-P>.
inoremap <S-TAB> <C-x><C-o>

" Floating window helper
" https://www.statox.fr/posts/2021/03/breaking_habits_floating_window/
function! RememberShortCuts() abort
    let width = 50
    let height = 10

    let buf = nvim_create_buf(v:false, v:true)

    let ui = nvim_list_uis()[0]
    call nvim_buf_set_text(buf, 0, -1, 0, -1, ["'<C-w><C-w>' - jump to and from float window",
                                              \ "'%' - jump to opposite(open/close) bracket.",
                                              \ "'}' - jump to bottom of code block",
                                              \ "'<Leader>/' - clear search highlights",
                                              \ "'<Leader>b' - Telescope current buffers",
                                              \ "'<Leader>f' - Telescope live_grep",
                                              \ "'<Leader>rd2' - replace selected with  d2 ascii"],
                                              \ "'! pandoc -f asciidoc -t markdown' - call pandoc to convert"])

    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': height,
                \ 'col': (ui.width - width),
                \ 'row': 0,
                \ 'anchor': 'NW',
                \ 'style': 'minimal',
                \ }
    let win = nvim_open_win(buf, 1, opts)
endfunction

nmap <Leader>h :call RememberShortCuts()<CR>
