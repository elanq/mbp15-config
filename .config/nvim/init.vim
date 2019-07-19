call plug#begin('~/.local/share/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline'
Plug 'ayu-theme/ayu-vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'airblade/vim-gitgutter'
Plug 'gf3/molotov'
Plug 'mileszs/ack.vim'
Plug 'sebdah/vim-delve'
Plug 'junegunn/fzf.vim'
"Plug 'yuttie/hydrangea-vim'
Plug 'w0rp/ale'
Plug 'wakatime/vim-wakatime'
Plug 'Shougo/denite.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/goyo.vim'
Plug 'fatih/vim-go'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'morhetz/gruvbox'
"Plug 'majutsushi/tagbar'
"Plug 'jodosha/vim-godebug'
"Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'nerdypepper/agila.vim'
call plug#end()

set termguicolors
let ayucolor="dark"
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
source ~/.config/nvim/golang.vim
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

