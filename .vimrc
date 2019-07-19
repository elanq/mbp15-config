set encoding=utf-8

let mapleader = ","               " set leader key to comma

syntax on                         " show syntax highlighting
filetype plugin indent on
set hidden
set tags=./.tags;,tags;
set autowrite
set backspace=indent,eol,start
set history=500
set autoread
set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set shiftwidth=2
set expandtab                     " use spaces, not tab characters
set nocompatible                  " don't need to be compatible with old vim
set re=1                          "set regex engine to old one. apparently it's faster for ruby files
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set cursorline                    " highlight current line
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set ttimeoutlen=0                 " decrease timeout for faster insert with 'O'
set foldmethod=indent             " fold by syntax is really slow
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
set smarttab
set rtp+=/usr/local/opt/fzf       " use fzf in vim
set lazyredraw
set linespace=8
set splitright
set guioptions=                   "remove any gui in macvim
set foldlevelstart=99            "don't atomatically fold large file
set updatetime=100               " useful for go info
"improve syntax speed
set nocursorcolumn
"set nocursorline
set relativenumber
syntax sync minlines=256

autocmd Colorscheme * highlight FoldColumn guifg=bg guibg=bg
let NERDTreeMinimalUI = 1

"ale  Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
" Enable integration with airline.

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1

let g:airline_powerline_fonts=1
let g:airline_theme='minimalist'
let g:ackprg = 'rg --vimgrep'

"vim markdown
let vim_markdown_preview_toggle=1
let vim_markdown_preview_hotkey='<C-m>'

" set dark background and color scheme
" set up some custom color
highlight clear SignColumn
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_added = '❖'
let g:gitgutter_highlight_lines=0
highlight GitGutterAdd guifg = '#A3E28B'
highlight GitGutterChange guifg = '#A3E28B'
highlight GitGutterDelete guifg = '#A3E28B'
highlight GitGutterChangeDelete guifg = '#A3E28B'

" ale linter
let g:ale_linters = {
\  'ruby': ['rubocop'],
\  'go': ['govet','errcheck'],
\}
let g:ale_go_gometalinter_options="--fast"
let g:ale_lint_delay = 1000
let g:ale_lint_on_enter = 0

" vim-go specific command

" fzf plugin related action
if executable("fzf")
  " we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)
  nmap ; :Buffers<CR>
  nmap <Leader>f :FZF<CR>
  " nmap <Leader>g :Tags<CR>
  " nmap <leader>F :Lines<CR> conflicted with JSONPrettify
endif
" map ale error navigation
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)
" Map space " unmap ex mode: 'Type visual to go into Normal mode.'
nnoremap Q <nop>
" fast saving
map <Leader>w :w!<cr>
" ack to current cursor
noremap <silent> <Leader>a :Rg <C-R><C-W><cr>
" map . in visual mode
vnoremap . :norm.<cr>
" map git commands
map <leader>l :Lines<cr>
"map <leader>d :!clear && git diff %<cr>
" set fold to space
nnoremap <space> za
vnoremap <space> za
" turn off ycm
"let g:ycm_auto_trigger=0
"nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
" turn on ycm
"nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>
" easymotion
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
" navigate tabs
map <leader>m :tabprevious<cr>
map <leader>. :tabnext<cr>
map <leader>t :tabnew<cr>
" clear the command line and search highlighting
noremap <C-l> :nohlsearch<CR>
" toggle tree
map <leader>e :NERDTreeToggle<cr>
map <leader>n :call RenameFile()<cr>
map <leader>F :call JSONPrettify()<cr>

"macvim specific command
if has("gui_macvim")
  colorscheme neodark
  " autochange folder to current buffer
  "http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
  "autocmd BufEnter * if expand("%:p:h") !~ '/^tmp|^eq' | silent! lcd %:p:h | endif

  " Switch to specific tab numbers with Command-number
  noremap <D-1> :tabn 1<CR>
  noremap <D-2> :tabn 2<CR>
  noremap <D-3> :tabn 3<CR>
  noremap <D-4> :tabn 4<CR>
  noremap <D-5> :tabn 5<CR>
  noremap <D-6> :tabn 6<CR>
  noremap <D-7> :tabn 7<CR>
  noremap <D-8> :tabn 8<CR>
  noremap <D-9> :tabn 9<CR>
  " Command-0 goes to the last tab
  noremap <D-0> :tablast<CR>

  if executable("rg")
    " Use rg over grep
    " why? because somehow in Macvim fzf doesn't look really good (glitchy
    " look?)
    let g:ctrlp_user_command = 'rg --files %s'
    let g:ctrlp_use_caching = 0
    map <leader>f :CtrlP<cr>
  endif
endif

"nvim specific command
if has("nvim")
  " neocomplete like
  set completeopt+=noinsert
  " deoplete.nvim recommend
  set completeopt+=noselect
  " use tab to forward cycle
  "inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
  "exit terminal with nvim
  tnoremap <Esc> <C-\><C-n>
endif

" check white space on save
autocmd BufWritePre * %s/\s\+$//e
autocmd! User FzfStatusLine call <SID>fzf_statusline()

" rename current file, via Gary Bernhardt
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" prettify json file
function! JSONPrettify()
  exec ':%!python3 -m json.tool'
endfunction

function! CheckError()
  "exec ':Denite coc-diagnostic'
  exec 'CocList diagnostics'
endfunction

" custom fzf status line color
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

" custom focus mode
let s:focus_mode = 0

function! ToggleFocusMode()
  if s:focus_mode == 0
    exec 'AirlineToggle'
    "set showtabline=0
    let s:focus_mode = 1
    set noruler
    set norelativenumber
    set laststatus=0
    set foldcolumn=3
  else
    set ruler
    set laststatus=2
    exec 'AirlineToggle'
    let s:focus_mode = 0
    set relativenumber
    set foldcolumn=0
  endif
endfunction

" CoC vim
" use <tab> for trigger completion and navigate next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" use <C-space> for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
noremap <leader>h :Goyo <cr>
noremap <leader>H :Goyo 200 <cr>
noremap <leader>E :call CheckError() <cr>
" Nerdtree settings
let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible
let g:fzf_colors = {
    \ 'fg':      ['fg', 'GruvboxGray'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'GruvboxRed'],
    \ 'fg+':     ['fg', 'GruvboxGreen'],
    \ 'bg+':     ['bg', 'GruvboxBg1'],
    \ 'hl+':     ['fg', 'GruvboxRed'],
    \ 'info':    ['fg', 'GruvboxOrange'],
    \ 'prompt':  ['fg', 'GruvboxBlue'],
    \ 'header':  ['fg', 'GruvboxBlue'],
    \ 'pointer': ['fg', 'Error'],
    \ 'marker':  ['fg', 'Error'],
    \ 'spinner': ['fg', 'Statement'],
    \ }
