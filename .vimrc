set nocompatible
syntax on               " syntax colorful
set number              " enable row numbers
set encoding=utf-8

set wildmenu
set showcmd

set ignorecase
set smartcase           " ignore case if search is all lowercase

set cindent
"set noexpandtab
set expandtab
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set scrolloff   =4
set cino=:0,+0,(2,J0,{1,}0,>4,)1,m2

set cursorline
"highlight CursorLine cterm=none ctermbg=15 ctermfg=0

filetype plugin indent on

"set t_Co=256

" macros
nnoremap j gj
nnoremap k gk
"change tabs
nnoremap m gT
nnoremap , gt

" plugins

call plug#begin('~/.vim/bundle')
"Plug 'godlygeek/csapprox'
Plug 'flazz/vim-colorschemes'
Plug 'altercation/vim-colors-solarized'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'rhysd/clever-f.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'EinfachToll/DidYouMean'
"Plug 'Konfekt/FastFold'
Plug 'matze/vim-move'
"Plug 'junegunn/limelight.vim'
"Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-peekaboo'            "display register values
Plug 'xuhdev/vim-latex-live-preview'

Plug 'airblade/vim-gitgutter'

"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'markonm/traces.vim'                "real time preview of substitutions

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugin config
nmap <F8> :TagbarToggle<CR>

let g:livepreview_previewer='zathura'
let g:livepreview_engine='pdflatex --shell-escape '

let g:NERDDefaultAlign='left'
let g:NERDAltDelims_c=1
let g:NERDAltDelims_java=1

    "color scheme
set termguicolors
set background=dark
"colorscheme solarized, alduin, slate, wombat
"colorscheme solarized8_dark_high
"let g:airline_theme='solarized'
colorscheme gruvbox
let g:airline_theme='wombat'


    " gitgutter
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_removed_above_and_below = '{{'
let g:gitgutter_sign_modified_removed = 'ww'
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermbg=0 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermbg=0 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermbg=0 ctermfg=1
" set updatetime=600
set updatetime=100

" filetype config

function! SettingsSh()
    map <F5> :!./%<CR>
endfunction

function! SettingsC()
    set cindent
    set noexpandtab
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
    set cino=:0,+0,(2,J0,{1,}0,>2,)1,m2

    nnoremap <F5> :wa <CR> :!gcc -Wall % -o %:r; ./%:r <CR>
    nnoremap <F6> :wa <CR> :!make <CR>
endfunction

function SettingsPython()
    nnoremap <F5> :wa <CR> :!python % <CR>
    nnoremap <F4> :wa <CR> :!python2 % <CR>
endfunction

function! SettingsLatex()
    nnoremap <F5> :wa <CR> :!pdflatex --shell-escape % <CR>
    nnoremap <F4> :wa <CR> :!xelatex --shell-escape % <CR>
    nnoremap <F3> :wa <CR> :!zathura %:r.pdf <CR>
    set foldmethod=manual
    set foldcolumn=0
    set regexpengine=1
    "set colorcolumn=80
    "highlight ColorColumn ctermbg=DarkGrey guibg=lightgrey

    "syn sync minlines=10
    "syn sync maxlines=50

    :NoMatchParen
    setlocal updatetime=1000
    inoremap {<CR> {<CR><CR>}<ESC>kcc

    set conceallevel=2
    set concealcursor=vc
    let g:tex_conceal="adgms"
    highlight Conceal NONE
endfunction

function! SettingsMarkdown()
    set textwidth=100
    set formatoptions+=awt
endfunction

autocmd filetype sh call SettingsSh()
autocmd filetype c call SettingsC()
autocmd filetype python call SettingsPython()
autocmd filetype tex call SettingsLatex()
autocmd filetype markdown call SettingsMarkdown()



" status bar

"set statusline=
"set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
"set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
"set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
"set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
"set statusline+=\ %n\           " buffer number
"set statusline+=%#Visual#       " colour
"set statusline+=%{&paste?'\ PASTE\ ':''}
"set statusline+=%{&spell?'\ SPELL\ ':''}
"set statusline+=%#CursorIM#     " colour
"set statusline+=%R                        " readonly flag
"set statusline+=%M                        " modified [+] flag
"set statusline+=%#Cursor#               " colour
"set statusline+=%#CursorLine#     " colour
"set statusline+=\ %t\                   " short file name
"set statusline+=%=                          " right align
"set statusline+=%#CursorLine#   " colour
"set statusline+=\ %Y\                   " file type
"set statusline+=%#CursorIM#     " colour
"set statusline+=\ %3l:%-2c\         " line + column
"set statusline+=%#Cursor#       " colour
"set statusline+=\ %3p%%\                " percentage
"set laststatus=2

