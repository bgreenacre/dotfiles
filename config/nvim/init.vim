" Author: Brian Greenacre
" Description: NeoVim settings.

if (!isdirectory(expand("$HOME/.local/share/nvim/site/autoload/plug.vim")))
  call system(expand("curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"))
endif

call plug#begin('~/.local/share/nvim/plugged')
" theme
Plug 'joshdick/onedark.vim'

" syntax
Plug 'sheerun/vim-polyglot'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'w0rp/ale'
" Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'tomtom/tcomment_vim'
Plug 'gko/vim-coloresque'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/unite.vim'
Plug 'mhinz/vim-sayonara'
Plug 'itmammoth/doorboy.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/NrrwRgn'

call plug#end()

" Vim Settings
set hidden
set termencoding=utf-8
set backspace=indent,eol,start
set fileencodings=ucs-bom,utf-8,default,latin1
set fileformats=unix,dos
set history=2000
set undolevels=2000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set ruler
set number
set mouse=a
set noerrorbells
set visualbell
set showmatch
set laststatus=2
set nowrap
set autoindent
set copyindent
filetype on
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set shiftround
set smartcase
set ignorecase
set smarttab
set hlsearch
set incsearch
set wmw=0
set wmh=0
set autoread
" change the mapleader from \ to ,
let mapleader=","
filetype plugin indent on
set pastetoggle=<F2>
set nopaste
nnoremap ; :
" set termguicolors
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
autocmd BufWritePre * %s/\s\+$//e
set noshowmode
set noswapfile
set conceallevel=0
set virtualedit=
set wildmenu
set wildmode=full
set autoread
set formatoptions+=t
set inccommand=nosplit
set shortmess=atIc
set isfname-==
set spell

"theme setting
syntax on
let g:onedark_terminal_italics=1
colorscheme onedark

" exit insert, dd line, enter insert
inoremap <c-d> <esc>ddi
inoremap <c-z> <esc>ui

" Make editing sudo required files easier
cmap w!! w !sudo tee % >/dev/null

" easy pasting
map <C-P> :set paste<Return>
map <C-A> :set nopaste<Return>

" Easy window navigation
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h
map <C-L> <C-W>l
map <C-E> <C-W>=
map <C-B> <C-W><bar>

" Copy to clipboard
vnoremap <C-c> "*y<CR>

let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'

" Align blocks of text and keep them selected
vmap < <gv
vmap > >gv
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <c-/> :TComment<cr>
nnoremap <silent> <esc> :noh<cr>
nnoremap <leader>e :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! s:PlaceholderImgTag(size)
  let url = 'http://dummyimage.com/' . a:size . '/000000/555555'
  let [width,height] = split(a:size, 'x')
  execute "normal a<img src=\"".url."\" width=\"".width."\" height=\"".height."\" />"
  endfunction
command! -nargs=1 PlaceholderImgTag call s:PlaceholderImgTag(<f-args>)

" MarkDown ------------------------------------------------------------------{{{

  noremap <leader>TM :TableModeToggle<CR>
  let g:table_mode_corner="|"

"}}}

" HTML ----------------------------------------------------------------------{{{

  autocmd Filetype html setlocal ts=2 sw=2 sts=2 expandtab

" }}}

" Javascript ----------------------------------------------------------------{{{

  autocmd FileType javascript set formatprg=prettier\ --stdin
  autocmd Filetype javascript setlocal ts=2 sw=2 sts=2 expandtab

" }}}

" Git -----------------------------------------------------------------------{{{

  set signcolumn=yes

" }}}

" NERDTree ------------------------------------------------------------------{{{
  let g:vimfiler_ignore_pattern = ""
  " map <silent> - :VimFiler<CR>
  let g:vimfiler_tree_leaf_icon = ''
  let g:vimfiler_tree_opened_icon = ''
  let g:vimfiler_tree_closed_icon = ''
  let g:vimfiler_file_icon = ''
  let g:vimfiler_marked_file_icon = '*'
  let g:vimfiler_expand_jump_to_first_child = 0
  " let g:vimfiler_as_default_explorer = 1
  call unite#custom#profile('default', 'context', {
              \'direction': 'botright',
              \ })
  call vimfiler#custom#profile('default', 'context', {
              \ 'explorer' : 1,
              \ 'winwidth' : 35,
              \ 'winminwidth' : 35,
              \ 'toggle' : 1,
              \ 'auto_expand': 0,
              \ 'parent': 1,
              \ 'explorer_columns': 'devicons:git',
              \ 'status' : 0,
              \ 'safe' : 0,
              \ 'split' : 1,
              \ 'hidden': 1,
              \ 'no_quit' : 1,
              \ 'force_hide' : 0,
              \ })
  augroup vfinit
  autocmd FileType vimfiler call s:vimfilerinit()
  augroup END
  function! s:vimfilerinit()
      set nonumber
      set norelativenumber
      nmap <silent><buffer><expr> <CR> vimfiler#smart_cursor_map(
            \ "\<Plug>(vimfiler_expand_tree)",
            \ "\<Plug>(vimfiler_edit_file)"
            \)
      nmap <silent> m :call NerdUnite()<cr>
      nmap <silent> r <Plug>(vimfiler_redraw_screen)
  endf
  " let g:vimfiler_ignore_pattern = '^\%(\.git\|\.DS_Store\)$'
  let g:webdevicons_enable_vimfiler = 0
  let g:vimfiler_no_default_key_mappings=1
  function! NerdUnite() abort "{{{
    let marked_files =  vimfiler#get_file(b:vimfiler)
    call unite#start(['nerd'], {'file': marked_files})
  endfunction "}}}
  map <C-t> :NERDTreeToggle<CR>
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  augroup ntinit
  autocmd FileType nerdtree call s:nerdtreeinit()
  augroup END
  function! s:nerdtreeinit()
      nunmap <buffer> K
      nunmap <buffer> J
  endf
  let NERDTreeShowHidden=1
  let NERDTreeHijackNetrw=0
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:NERDTreeWinSize=45
  let g:NERDTreeAutoDeleteBuffer=1
  let NERDTreeMinimalUI=1
  let NERDTreeCascadeSingleChildDir=1
  let g:NERDTreeHeader = 'hello'
  let g:NERDTreeShowIgnoredStatus = 0

  let g:NERDTreeDirArrowExpandable = ''
  let g:NERDTreeDirArrowCollapsible = ''
  let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''

"}}}

" Nvim terminal -------------------------------------------------------------{{{

  au BufEnter * if &buftype == 'terminal' | :startinsert | endif
  autocmd BufEnter term://* startinsert
  autocmd TermOpen * set bufhidden=hide

" }}}

" Vim-Devicons -------------------------------------------------------------0{{{

" }}}

" Code formatting -----------------------------------------------------------{{{

" ,f to format code, requires formatters: read the docs
  noremap <silent> <leader>f :Neoformat<CR>

" }}}

" vim-airline ---------------------------------------------------------------{{{

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline#extensions#ale#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#mike#enabled = 0
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline_powerline_fonts = 1
  " let g:airline_symbols.branch = ''
  let g:airline_theme='onedark'
  cnoreabbrev <silent> <expr> x getcmdtype() == ":" && getcmdline() == 'x' ? 'Sayonara' : 'x'
  tmap <leader>x <c-\><c-n>:bp! <BAR> bd! #<CR>
  nmap <leader>t :term<cr>
  nmap <leader>, :bnext<CR>
  tmap <leader>, <C-\><C-n>:bnext<cr>
  nmap <leader>. :bprevious<CR>
  tmap <leader>. <C-\><C-n>:bprevious<CR>
  tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
  tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
  tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
  tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
  tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
  tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
  tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
  tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
  tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  let g:airline#extensions#tabline#buffer_idx_format = {
        \ '0': '0 ',
        \ '1': '1 ',
        \ '2': '2 ',
        \ '3': '3 ',
        \ '4': '4 ',
        \ '5': '5 ',
        \ '6': '6 ',
        \ '7': '7 ',
        \ '8': '8 ',
        \ '9': '9 ',
        \}

"}}}

" Linting -------------------------------------------------------------------{{{

"}}}

" PHP -------------------------------------------------------------------{{{

" php syntax highlight config
function! PhpSyntaxOverride()
	hi! def link phpDocTags  phpDefine
	hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
	autocmd!
	autocmd FileType php call PhpSyntaxOverride()
augroup END

"}}}
