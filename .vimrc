"====================
" Pathogen
"====================
"runtime bundle/pathogen/autoload/pathogen.vim
"call pathogen#infect()

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'ervandew/supertab'

Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'

Bundle 'tpope/vim-fugitive'

Bundle 'Lokaltog/vim-powerline.git'

Bundle 'L9'
Bundle 'FuzzyFinder'


"====================
" Basic Options
"====================
set nocompatible
set showcmd
set ttyfast
" set directory=~/.vim_swap
" set backupdir=~/.vim_swap
set nowritebackup " to make it work better with dropbox
set viminfo='100,f0
set scrolloff=20
set cursorline
set et sw=4 ts=4
let mapleader = ","
filetype plugin on
filetype indent on
syntax on

set autoindent
"set smartindent
"set cindent
set smarttab

set incsearch
set ignorecase
set smartcase
if &t_Co > 2 || has("gui_running")
	syntax on
	" set nohls
	set hls
endif

set spellfile=~/.vim/spellfile.add
set spelllang=en_us

set wildmenu
set wildmode=list:longest

set laststatus=2

" set textwidth=80
" set ofu=syntaxcomplete#Complete
" set completeopt=longest,menuone
" highlight Pmenu guibg=brown gui=bold
" highlight Pmenu ctermbg=238 gui=bold

"====================
" Command Mappings
"====================
nnoremap <silent> <F8> :TlistToggle<CR>

map <F2> :NERDTreeToggle<CR>

nmap ;; :w<CR>

map Y y$

"====================
" Colors
"====================
set t_Co=256
let g:solarized_termcolors=16
set background=dark
" colorscheme solarized
colorscheme molokai

"====================
" Shortcuts
"====================
ab #d #define
ab #i #include
ab #b /***********************************************
ab #l /*---------------------------------------------*/
ab #e <space>***********************************************/
ab #e <space>***********************************************/
ab CB [ ]

map ,c, <esc><up>o/***********************************************<cr><space>*<cr>*<esc>JA<cr>*<cr>***********************************************/<up><up><up>

"====================
" NERD Commenting
"====================
let NERDShutUp = 1
let NERDSpaceDelims = 1

"====================
" SuperTab
"====================
let g:SuperTabDefaultCompletionType = "context"
" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

"====================
" Save and load views
"====================
" au BufWinLeave *.* mkview
" au BufWinEnter *.* silent loadview

"====================
" Python
"====================
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd FileType python set ts=4 et sw=4
autocmd FileType python set foldmethod=indent
autocmd FileType python set foldlevel=2
autocmd FileType python set updatetime=500
" autocmd FileType python compiler pylint
" au BufWritePost *.py !pyflakes % 
" autocmd FileType python nnoremap <silent> <F10> :!pyflakes %<CR>
autocmd FileType python nnoremap <silent><buffer><leader>pr :w! <cr> :!python %<cr>
autocmd FileType python nnoremap <silent><buffer><leader>pf :!pyflakes %<cr>
autocmd FileType python nnoremap <silent><buffer><leader>pl :!pylint %<cr>

"====================
" C/C++
"====================
autocmd FileType c nnoremap <silent><buffer><leader>m :make<cr>
au BufNewFile,BufRead *.cu set ft=cu

"====================
" Javascript
"====================
autocmd FileType javascript nnoremap <silent><buffer><leader>m :make<cr>
"Super duper hackjob to make my hacky makefiles not get owned by the :make
"command's error catching
" autocmd FileType javascript set errorformat=%f:%l:\ ERROR\ -\ %mR
autocmd FileType javascript set errorformat=%f:%l:\ asdfalskdfja;sldfkjasflj
" boxvine.js:16: WARNING - dangerous use of this in static method boxvine.Document

"====================
" Java
"====================
"Set the error format for javac to be this thing
"Use :help errorformat-javac for info
autocmd BufWritePre *.java normal m`:%s/\s\+$//e ``
autocmd FileType java set efm=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
autocmd FileType java set ts=4 noexpandtab sw=4
" autocmd FileType java nnoremap <silent><buffer><leader>i :JavaImport<cr>
autocmd FileType java nnoremap <silent><buffer><leader>i :JavaImportMissing<cr>
autocmd FileType java nnoremap <silent><buffer><leader>fd :JavaSearch<cr>
autocmd FileType java nnoremap <silent><buffer><leader>au :Ant<space>upload<cr>
autocmd FileType java nnoremap <silent><buffer><leader>ab :Ant<space>build<cr>
autocmd FileType java nnoremap <silent><buffer><leader>ar :Ant<space>run<cr>
" autocmd FileType java nnoremap <silent><buffer><leader>jc :!javac<space>%<cr>
" autocmd FileType java nnoremap <silent><buffer><leader>jr :!java<space>%:t:r<cr>
autocmd FileType java nnoremap <silent><buffer><leader>jc :Javac<cr>
autocmd FileType java nnoremap <silent><buffer><leader>jr :Java<cr>
autocmd FileType java nnoremap <silent><buffer><leader>jf :JavaFormat<cr>
autocmd FileType java nnoremap <silent><buffer><leader>t :ProjectTree<cr>
autocmd FileType java nnoremap <silent><buffer><cr> :JavaSearchContext<cr>
autocmd FileType java nnoremap <silent><buffer><leader>f :lne<cr>
autocmd FileType java nnoremap <silent><buffer><leader>g :ll<cr>
autocmd FileType java nnoremap <silent><buffer><leader>e :lli<cr>
autocmd FileType java set tags=.tags;/ 
autocmd FileType java set foldmethod=indent
autocmd FileType java set foldlevel=1
autocmd FileType java set updatetime=500
" autocmd FileType java let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
" autocmd FileType java inoremap {      {}<Left>
" autocmd FileType java inoremap {<CR>  {<CR>}<Esc>O
" autocmd FileType java inoremap {{     {
" autocmd FileType java inoremap {}     {}
" autocmd FileType java inoremap (      ()<Left>

"====================
" TeX
"====================
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

autocmd FileType tex TTarget pdf
" autocmd FileType tex set foldmethod=marker
" autocmd BufRead *.tex set foldmethod=marker
" autocmd FileType tex set foldmarker=<<<,>>>
" autocmd BufRead *tex set foldmarker=<<<,>>>
" autocmd FileType tex let g:Tex_UseMakefile = 0
autocmd FileType tex let g:Tex_DefaultTargetFormat = 'pdf'

" autocmd FileType tex let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
" autocmd FileType tex let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
" autocmd FileType tex let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
" autocmd FileType tex let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'
" autocmd FileType tex let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode -output-directory ../build $*'
" autocmd FileType tex let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode $*'

autocmd FileType tex let g:Tex_MultipleCompileFormats = 'dvi,pdf'
autocmd FileType tex let g:Tex_ViewRuleComplete_pdf = 'evince $*.pdf &'

" autocmd FileType tex let g:Tex_IgnoredWarnings = g:Tex_IgnoredWarnings . "\ncontains only floats"
autocmd FileType tex let g:Tex_IgnoredWarnings = "Underfull\n".
			\"Overfull\n".
			\"specifier changed to\n".
			\"You have requested\n".
			\"Missing number, treated as zero.\n".
			\"There were undefined references\n".
			\"Citation %.%# undefined\n".
			\"contains only floats"
autocmd FileType tex let g:Tex_IgnoreLevel = 8

autocmd FileType tex set winaltkeys=no
autocmd FileType tex set cmdheight=2

autocmd FileType tex let g:Tex_FoldedSections = 'part,chapter,nextprob,nextprobhere,section,%%fakesection,subsection,subsubsection,paragraph'
autocmd FileType tex let g:Tex_Leader = ',,'
autocmd FileType tex let g:Tex_Leader2 = '`'

" autocmd FileType tex let g:Tex_Env_align = "\\begin{align*}\<CR><++>\<CR>\\end{align*}"
" autocmd FileType tex let g:Tex_Env_figure = "\\begin{figure}[<+htpb+>]\<CR>\\centering\<CR>\\includegraphics{<+figure+>}\<CR>\\caption{<+caption+>}\<CR>\\end{figure}<++>"
autocmd FileType tex let g:Tex_Env_figure = "\\begin{figure}[!htpb]\<CR>\\centering\<CR>\\includegraphics[width=<+width+>in]{<+figure+>}\<CR>\\caption{<+caption+>}\<CR>\\label{fig:<+label+>}\<CR>\\end{figure}"
autocmd FileType tex call IMAP('EAL', "\\begin{align*}\<CR><++>\<CR>\\end{align*}", 'tex')
autocmd FileType tex call IMAP('/bo', "_{<++>}^{<++>}<++>", 'tex')

autocmd FileType tex nnoremap <silent><buffer><leader>m :!make<cr>

" This is to make the latexmain shit work.  see:
" http://www.mail-archive.com/vim-latex-devel@lists.sourceforge.net/msg00922.html
let g:EclimMakeLCD = 0


"====================
" R and Rnw
"====================
au BufNewFile,BufRead *.R setfiletype r
au BufNewFile,BufRead *.Rnw setf noweb
autocmd FileType rnoweb nnoremap <silent><buffer><leader>m :!make<cr><cr>
autocmd FileType rnoweb let &l:commentstring='# %s'


au BufNewFile,BufRead *.j2 setfiletype jinja

"====================
" Notes to self
"====================
" + To make things silent, call :silent [command]
"
