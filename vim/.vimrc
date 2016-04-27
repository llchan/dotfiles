if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'kshenoy/vim-signature'
" Plug 'powerline/powerline'  " replaced by vim-airline, less deps
" Plug 'scrooloose/nerdcommenter'  " replaced by vim-commentary
Plug 'scrooloose/syntastic'
Plug 'sirver/ultisnips'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'twerth/ir_black'
Plug 'valloric/YouCompleteMe', {'do': './install.py'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

call plug#end()

" filetype off
" filetype plugin indent off

" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()

" Plugin 'VundleVim/vundle.vim'

" Plugin 'tpope/vim-fugitive'
" Plugin 'tpope/vim-surround'
" Plugin 'scrooloose/nerdcommenter'
" Plugin 'scrooloose/nerdtree'
" " Plugin 'ervandew/supertab'
" Plugin 'kien/ctrlp.vim'
" Plugin 'wgibbs/vim-irblack'
" Plugin 'MarcWeber/vim-addon-mw-utils'
" Plugin 'tomtom/tlib_vim'
" Plugin 'honza/vim-snippets'
" " Plugin 'garbas/vim-snipmate'
" Plugin 'Lokaltog/vim-powerline'
" Plugin 'Lokaltog/vim-easymotion'
" " Plugin 'Shougo/neocomplcache'
" Plugin 'godlygeek/tabular'
" Plugin 'majutsushi/tagbar'
" " Plugin 'Rip-Rip/clang_complete'
" Plugin 'vim-scripts/google.vim'
" Plugin 'vim-scripts/JavaScript-Indent'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'scrooloose/syntastic'
" Plugin 'avakhov/vim-yaml'
" Plugin 'jeetsukumaran/vim-buffergator'
" Plugin 'airblade/vim-gitgutter'
" " Plugin 'SirVer/ultisnips'
" Plugin 'MarcWeber/ultisnips'
" Plugin 'kchmck/vim-coffee-script'
" Plugin 'nono/vim-handlebars'
" Plugin 'othree/html5.vim'
" Plugin 'digitaltoad/vim-jade'
" Plugin 'groenewege/vim-less'
" Plugin 'tpope/vim-abolish'
" Plugin 'tpope/vim-repeat'
" Plugin 'hynek/vim-python-pep8-indent'
" Plugin 'mileszs/ack.vim'
" Plugin 'derekwyatt/vim-fswitch'
" " Plugin 'Townk/vim-autoclose'
" Plugin 'kien/rainbow_parentheses.vim'
" Plugin 'maxbrunsfeld/vim-yankstack'

" call vundle#end()

set rtp+=$GOROOT/misc/vim

" filetype plugin indent on

let mapleader = ","

"--------------------
" Basic Setup
"--------------------
set nocompatible
syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8
set autoindent
set colorcolumn=81
" let &colorcolumn=join(range(81,999), ",")
set modeline

"--------------------
" Whitespace
"--------------------
set nowrap
set ts=4 sw=4 sts=4 et
set backspace=indent,eol,start    " backspace through everything in insert mode
" au BufWrite * silent! %s/\s\+$//ge

"--------------------
" Menu
"--------------------
set wildmenu
set wildmode=list:longest,full

"--------------------
" List Characters
"--------------------
set list
" set nolist
" set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
" set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
" set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
set listchars=tab:▸\ ,trail:⋅
" set showbreak=↪

"--------------------
" File Ignores
"--------------------
set wildignore+=*.swp
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/](\.waf|\.git$|\.hg$|\.svn$|vendor|node_modules|bower_components)',
            \ 'file': '\v(core\..*\.\d\+|\.lock.*|\.o|\.so|\.cc)$',
            \ }

let g:ctrlp_root_markers = ['.vim-ctrlp-root']
" let g:ctrlp_working_path_mode='r'

"--------------------
" Searching
"--------------------
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

"--------------------
" Backup and swap files
"--------------------
set backupdir=~/.vim/backup/    " where to put backup files.
" set nobackup
" set nowritebackup
set backupcopy=yes
set directory=~/.vim/swap/      " where to put swap files.

"--------------------
" UI + Colorscheme
"--------------------
set equalalways
set number            " Show line numbers
set ruler             " Show line and column number
set laststatus=2
set cursorline
set t_Co=256
set background=dark
colorscheme ir_black
hi CursorLine     guifg=NONE        guibg=#121212     gui=NONE      ctermfg=NONE        ctermbg=NONE        cterm=underline
hi Pmenu          guifg=#f6f3e8     guibg=#444444     gui=NONE      ctermfg=black       ctermbg=darkgray    cterm=NONE
hi PmenuSel       guifg=#000000     guibg=#cae682     gui=NONE      ctermfg=black       ctermbg=darkmagenta cterm=NONE
hi Search         guifg=NONE        guibg=NONE        gui=underline ctermfg=black       ctermbg=magenta     cterm=NONE
hi ColorColumn    guifg=NONE        guibg=#121212     gui=NONE      ctermfg=NONE        ctermbg=0           cterm=NONE

"--------------------
" Mappings
"--------------------
" sudo write
cmap w!! %!sudo tee > /dev/null %

" Swap two words
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

" Underline the current line with '='
nmap <silent> <leader>ul :t.\|s/./=/g\|:nohls<cr>

" Toggle text wrapping
nmap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

" Toggle hlsearch
nmap <leader>h :set hlsearch! hlsearch?<CR>

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Toggle paste
map <leader>p :set invpaste!<CR>:set paste?<CR>

" Make Y act more like C and D
map Y y$

" Toggle list characters
noremap <leader>sl :set list!<CR>

" Close/open quickfix window
map <leader>qc :cclose<cr>
map <leader>qo :copen<cr>

" Move cursor with wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

map <leader>tc :Tabularize /,\zs<cr>

" camelCase <-> underscore
" map <leader>x_ :s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g<cr>
" map <leader>xc :s#_\(\l\)#\u\1#g<cr>
" map <leader>xC :s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g<cr>

map <leader>r :RainbowParenthesesToggle<cr>

"--------------------
" Plugin Settings
"--------------------
let NERDShutUp = 1
let NERDSpaceDelims = 1

map <leader>n :NERDTreeToggle<CR><C-w>=
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabContextDefaultCompletionType = "<c-n>"

" let g:syntastic_mode_map = {'mode': 'passive'}

" let g:clang_use_library = 1
" let g:clang_library_path = "/home/lchan/lib"
" let g:clang_complete_copen = 1
" let g:clang_complete_auto = 0

" let g:snips_trigger_key = '<C-\>'
" imap <C-\> <Plug>snipMateNextOrTrigger

" let g:UltiSnips = {}
" let g:UltiSnips.always_use_first_snippet = 1
let g:UltiSnipsExpandTrigger = '<C-J>'

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview

map <leader>pc :CtrlPClearAllCaches<cr>

au FileType jade setl ts=2 sw=2 sts=2 et
au FileType javascript setl ts=2 sw=2 sts=2 et
au FileType coffee setl ts=2 sw=2 sts=2 et
au FileType html setl ts=2 sw=2 sts=2 et
au FileType html5 setl ts=2 sw=2 sts=2 et
au FileType coffee setl ts=2 sw=2 sts=2 et
au FileType less setl ts=2 sw=2 sts=2 et
au FileType css setl ts=2 sw=2 sts=2 et

au FileType cpp let c_no_curly_error=1
au FileType cpp nmap <silent> <leader>m :FSHere<cr>

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkgray',    'firebrick3'],
    \ ]

" netrw (:E)
let g:netrw_liststyle=3


"--------------------
" airline
"--------------------
let g:airline_left_sep=''   " '║' '╟' '░' '▌' '▶' '»'
let g:airline_right_sep=''  " '║' '╢' '░' '▐' '◀' '«'
let g:airline#extensions#wordcount#enabled = 0  " disable word count
" let g:airline#extensions#tabline#enabled = 1  " show tabline
