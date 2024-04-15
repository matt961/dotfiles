" assumes:
" - vim-plug is installed
" - nodejs (current LTS will be fine, use nvm.sh, `nvm install --lts`)
" - `:PlugInstall` after starting for the first time
" - ???

call plug#begin('~/.vim/plugged/')
" BEGIN PLUGINS
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rebelot/kanagawa.nvim'
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'yssl/QFEnter'
Plug 'morhetz/gruvbox'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'b0o/schemastore.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'mrcjkb/rustaceanvim'
" END PLUGINS
call plug#end()

set encoding=utf-8

let g:deoplete#enable_at_startup = 1

syntax on
filetype plugin indent on

set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

if exists('g:neovide')
	set guifont=GitLab\ Mono\ Medium:h10
  let g:neovide_cursor_animation_length=0.00
  let g:neovide_cursor_trail_length=0.00
  let g:neovide_refresh_rate=100
end


" Shows the highlight group of whatever's under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

set termguicolors
lua <<EOF
require('kanagawa').setup({
    compile = false,             -- enable compiling the colorscheme
    undercurl = true,            -- enable undercurls
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false},
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,         -- do not set background color
    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
    colors = {                   -- add/modify theme and palette colors
        palette = {},
        theme = {
          wave = {}, lotus = {}, dragon = {},
          all = {
            ui = {
              bg_gutter = "none",
            }
          }
      },
    },
    overrides = function(colors) -- add/modify highlights
        return {}
    end,
    theme = "wave",              -- Load "wave" theme when 'background' option is not set
    background = {               -- map the value of 'background' option to a theme
        dark = "wave",           -- try "dragon" !
        light = "lotus"
    },
})
EOF

colorscheme kanagawa
set background=dark

" fix ale warnings
hi ALEWarning cterm=undercurl ctermbg=none

" fix Todo color
hi Todo ctermfg=154 guifg=#afff00

" airline
autocmd VimEnter * AirlineTheme zenburn
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_a = ""
let g:airline_section_z = ""
let g:airline_section_error = ""
let g:airline_section_warning = ""
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#nvimlsp#enabled = 1
" end airline

set foldmethod=syntax
set foldlevelstart=20
set nu
set noet
set hlsearch
set linebreak
set linespace=2
set modeline

autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 

autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 textwidth=79 autoindent fileformat=unix

nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
set splitbelow splitright

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

let g:autofmt_autosave = 1

" ALE stuff
let g:ale_lint_delay = 1000

let g:ale_fixers = {'python': ['autopep8'], 'rust': ['rustfix'], 'javascript': ['eslint'], 'yaml': ['yamlfix']}

let g:ale_linters = {'python': ['flake8'], 'rust': ['rls'], 'javascript': ['eslint']}
" end ALE stuff

" vim-dispatch
autocmd FileType python let b:dispatch = 'python -m unittest %'
" end vim-dispatch

" vim-javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete
" end vim-javacomplete2

" markdown
autocmd FileType markdown setlocal textwidth=80
" end markdown

" neovim-terminal
nnoremap tt :vsplit term://bash<CR>
nnoremap <M-t> :split term://bash<CR>
nnoremap <M-T> :tabnew term://bash<CR>

augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert

    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber

    " " allows you to use Ctrl-c on terminal window
    " autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END

" LanguageClient
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rustup', 'run', 'stable', 'rls'],
"     \ 'javascript': ['javascript-typescript-stdio'],
"     \ 'javascript.jsx': ['javascript-typescript-stdio'],
" 	\ 'python': ['pyls'],
"     \ 'java': ['java', '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044', '-Declipse.application=org.eclipse.jdt.ls.core.id1', '-Dosgi.bundles.defaultStartLevel=4', '-Declipse.product=org.eclipse.jdt.ls.core.product', '-Dlog.level=ALL', '-noverify', '-Xmx1G', '-jar', '~/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.5.200.v20180922-1751.jar', '-configuration', '~/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux', '-data']}

" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
"end LanguageClient

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" START coc.nvim
"
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" " Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" " Or use `complete_info` if your vim support it, like:
" " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" " Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" " Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"     let hoverwin = coc#float#get_float_win()
"     let hasscroll = coc#float#has_scroll()
"     if hoverwin && hasscroll
"         call win_gotoid(hoverwin)
"     end
"   endif
" endfunction

" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" " Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" " Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" augroup terraform
"   autocmd!
"   autocmd FileType terraform autocmd BufWritePre * Format
" augroup end

" autocmd FileType ruby let b:coc_root_patterns = ['.vim']

" " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" " Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" " Create mappings for function text object, requires document symbols feature of languageserver.
" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)

" " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" " Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

" " Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" " use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" " Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Using CocList
" " Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>r  :<C-u>CocListResume<CR>

" inoremap <silent><expr> <c-space> coc#refresh()
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)
" " Remap keys for gotos
" nmap <silent> <a-d> <Plug>(coc-definition)
" nmap <silent> <c-t> <Plug>(coc-type-definition)
" nmap <silent> <a-i> <Plug>(coc-implementation)
" nmap <silent> <a-r> <Plug>(coc-references)

" nnoremap <silent> <c-s>  :exe 'CocList -I --normal --input='.expand('<cword>').' symbols'<CR>

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" let g:coc_filetype_map = {
"       \ 'yaml.ansible': 'yaml',
"       \ }
"
" END coc.nvim

" fzf
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
let g:fzf_preview_window = 'right:70%'
let g:fzf_buffers_jump = 1

" NERDTree mappings
nnoremap <silent> <M-n>f :NERDTreeFind<CR>
nnoremap <silent> <M-n>o :NERDTreeToggle<CR>
nnoremap <silent> <M-n>n :NERDTreeFocus<CR>

" Lua for LSP here
set completeopt=menu,menuone,noselect

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" NOTE: You can use other key to expand snippet.

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsnip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

lua <<EOF
local cfgdir = vim.fn.stdpath('config')
local extralua = vim.fs.normalize(cfgdir .. "/extra.lua")
vim.cmd{cmd = 'luafile', args = {extralua}}
EOF
