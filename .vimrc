"leader
let mapleader="\\"

""检测操作系统
if(has("win32") || has("win95") || has("win64") || has("win16"))
  let g:iswindows=1
else
  let g:iswindows=0
endif  


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"F1-F10快捷键绑定
"<F3>在svn提交当前文件夹，并可添加注释
"<F4>在python文件添加头部
"<F5>单个文件编译并执行
"<F6>make,ctrl+F6 清理make
"<F7>gdb调试
"<F8>自动使用autopep8格式化当前文件
"<F9>
"<F10>无须重启即使vimrc配置生效
"<F11>添加helptags帮助文档
"<F12>generate ctags for current folder
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"<F3>在svn提交当前文件夹，并可添加注释
map <F3> :w<CR>:!svn ci -m ""<LEFT>

"<F4> 添加头部作者等信息
nmap <F4> :call SmartAddHeader()<cr>
function! SmartAddHeader()
    if &filetype=="python"
        normal gg
        normal O
        normal O
        call setline(1, "#!/usr/bin/env python")
        call append(1, "# -*- coding: utf-8 -*-")
        normal 3j
    endif
endf

"单个文件编译并执行
map <F5> :call Do_OneFileMake()<CR>
function! Do_OneFileMake()
  exec "w"
  if expand("%:p:h")!=getcwd()
    echohl WarningMsg | echo "Fail to make! This file is not in the current dir!" | echohl None
    return
  endif
  let sourcefileename=expand("%:t")
  if (sourcefileename=="" || (&filetype!="cpp" && &filetype!="c" && &filetype!="python"))
    echohl WarningMsg | echo "Fail to make! Please select the right file!" | echohl None
    return
  endif
  let deletedspacefilename=substitute(sourcefileename,' ','','g')
  if strlen(deletedspacefilename)!=strlen(sourcefileename)
    echohl WarningMsg | echo "Fail to make! Please delete the spaces in the filename!" | echohl None
    return
  endif
  if &filetype=="c"
    if g:iswindows==1
      set makeprg=gcc\ -o\ %<.exe\ %
    else
      set makeprg=gcc\ -o\ %<\ %
    endif
  elseif &filetype=="cpp"
    if g:iswindows==1
      set makeprg=g++\ -o\ %<.exe\ %
    else
      set makeprg=g++\ -o\ %<\ %
    endif
  elseif &filetype=="python"
    execute "!python %"
    return
"elseif &filetype=="cs"
"set makeprg=csc\ \/nologo\ \/out:%<.exe\ %
  endif
  if(g:iswindows==1)
    let outfilename=substitute(sourcefileename,'\(\.[^.]*\)$','.exe','g')
    let toexename=outfilename
  else
    let outfilename=substitute(sourcefileename,'\(\.[^.]*\)$','','g')
    let toexename=outfilename
  endif

  if filereadable(outfilename)
    if(g:iswindows==1)
      let outdeletedsuccess=delete(getcwd()."\\".outfilename)
    else
      let outdeletedsuccess=delete("./".outfilename)
    endif
    if(outdeletedsuccess!=0)
      set makeprg=make
      echohl WarningMsg | echo "Fail to make! I cannot delete the ".outfilename | echohl None
      return
    endif
  endif
  execute "silent make"
  set makeprg=make
  execute "copen"

  execute "normal :"
  if filereadable(outfilename)
    if(g:iswindows==1)
      execute "!".toexename
    else
      execute "!./".toexename
    endif
  endif
  exec "cw"
endfunction
"进行make的设置
map <F6> :call Do_make()<CR>
map <c-F6> :silent make clean<CR>
function! Do_make()
  set makeprg=make
  execute "silent make"
  execute "copen"
endfunction  

"<F7>  gdb调试
map <F7> :call Debug()<CR>
func!  Debug()
exec "w"
"把调试信息加到可执行文件中,
"如果没有-g，你将看不见程序的函数名、变量名，所代替的全是运行时的内存地址
exec "!gcc -g % -o %<"
exec "!gdb %<"
endfunc

"<F10> 改变.vimrc后无须重启vi即生效
map <F10> :w<cr>:so %<cr>

map <F11> :helptags ~/.vim/doc<cr>

" map F12 to generate ctags for current folder:
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Other shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" show buffers
nmap zl :buffers<CR>

"ctrl+s save
map <c-s> :w<cr>
imap <c-s> <Esc>:w<cr>a


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 外观设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" startup windows size
"set lines=50 columns=108

" syntax
syntax enable
syntax on
" colors
colorscheme torte

" 设置行间距
" font
if g:iswindows 
    set linespace=1
    set guifont=Lucida\ Console:h13
    "set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
else 
    set guifont=Monaco\ for\ Powerline:h16
endif

" 下面5行用来解决gVim菜单栏和右键菜单乱码问题
set encoding=utf8
set langmenu=zh_CN.UTF-8
set imcmdline
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set guioptions-=m "不显示菜单. 
set guioptions-=T "不显示工具栏
" 解决gVim中提示框乱码
language message zh_CN.UTF-8

" 设定默认解码
set fileencodings=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936

" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" history文件中需要记录的行数
set history=100

" 在处理未保存或只读文件的时候，弹出确认
set confirm

" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!

" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-

set colorcolumn=100

""启动后最大化gVim
"if has('win32')
"au GUIEnter * simalt ~x
"else
"au GUIEnter * call MaximizeWindow()
"endif

"function! MaximizeWindow()
"silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
"endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文件设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype
filetype on
filetype plugin on

set fileformat=unix

" 不要备份文件
set nobackup

" 不要生成swap文件，当buffer被丢弃的时候隐藏它
setlocal noswapfile
set bufhidden=hide

" 增强模式中的命令行自动完成操作
set wildmenu

" 在状态行上显示光标所在位置的行号和列号
set ruler
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)

" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2

" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
"set mouse=a
set selection=inclusive
set selectmode=key

" 启动的时候不显示那个援助索马里儿童的提示
set shortmess=atI
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0

" 不让vim发出讨厌的滴滴声
"set noerrorbells

" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索和匹配
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 高亮显示匹配的括号
set showmatch

" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=2

" 在搜索的时候忽略大小写
set ignorecase

" 不要高亮被搜索的句子（phrases）
set hlsearch

" 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set incsearch

" 输入:set list命令是应该显示些啥？
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$

" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3

" 不要闪烁
set novisualbell

" statusline
"set statusline=\ %F%m%r%h%w\ %=\ [pos:%l:%v:%p%%]\ [%{&ff}\ %{&fenc!=''?&fenc:&enc}]\ \ [type:%Y]\ \  


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文本格式和排版
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动格式化
set formatoptions=tcrqn

" 继承前一行的缩进方式，特别适用于多行注释
set autoindent
" 为C程序提供自动缩进
set smartindent
"cindent:Vim可以很好的识别出C和Java等结构化程序设计语言，
"并且能用C语言的缩进格式来处理程序的缩进结构
set cindent

"设置Tab
set expandtab       " Use space to replace tab
set shiftwidth=4    " Auto indent width
"set tabstop=4    " Tab width,defalut is 8,do NOT change
"set softtabstop=4   " Mix space and tab to keep the text display beautifully

" 自动折行显示(只是显示)
set wrap

" 在行和段开始处使用制表符
set smarttab

" auto remove trailing whitespace
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"保证工作目录为当前目录,
autocmd BufEnter * execute ":silent! lcd " . expand("%:p:h")

" 只在下列文件类型被侦测到的时候显示行号，普通文本文件不显示
if has("autocmd")
autocmd FileType xml,html,c,cs,java,perl,shell,bash,cpp,python,vim,php,ruby set number
autocmd FileType xml,html vmap <C-o> <ESC>'<i<!--<ESC>o<ESC>'>o-->
autocmd FileType java,c,cpp,cs vmap <C-o> <ESC>'<o/*<ESC>'>o*/
"设置自动断行
"autocmd FileType html,text,php,vim,c,java,xml,bash,shell,perl,python setlocal textwidth=100
"autocmd Filetype html,xml,xsl source $VIMRUNTIME/plugin/closetag.vim
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif
endif " end has("autocmd")

" 能够漂亮地显示.NFO文件
set encoding=utf-8 fileencodings=ucs-bom,utf-8,gbk,cp936
function! SetFileEncodings(encodings)
let b:myfileencodingsbak=&fileencodings
let &fileencodings=a:encodings
endfunction
function! RestoreFileEncodings()
let &fileencodings=b:myfileencodingsbak
unlet b:myfileencodingsbak
endfunction

au BufReadPre *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
au BufReadPost *.nfo call RestoreFileEncodings()

" 用空格键来开关折叠
set foldenable
set foldmethod=manual
autocmd FileType python setlocal foldmethod=indent
set foldlevel=99
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>


""""“”“”“”“”“”“”“”“插件开始”“”“”“”“”“”“”“”“”“”“”“”“”“”""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""ctag
" add current directory's generated tags file to available tags
set tags+=./tags
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""Taglist 
let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""zencoding
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""Neosnippet自动补全
"Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

if g:iswindows==1
    let g:neosnippet#snippets_directory="$VIM/vimfiles/bundle/vim-snippets/snippets"
else
    let g:neosnippet#snippets_directory="$HOME/.vim/vimfiles/bundle/vim-snippets/snippets"
endif
"let g:neosnippet#enable_snipmate_compatibility=1
let g:snips_author='GitFree'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:vimrc_author='GitFree'
let g:vimrc_email='pengzhao.lh@gmail.com'
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""markdown
let g:vim_markdown_folding_disabled=1
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""Visual-Mark.vim
let g:mwAutoLoadMarks = 1
nmap <S-F8> <Leader>m
nmap <S-C-F8> <Plug>MarkAllClear
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""syntastic
let g:syntastic_python_flake8_args="--ignore=E501"
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""neocomplcache
" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
"let g:acp_enableAtStartup = 0
" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_min_syntax_length = 3
" select first candidate auto
let g:neocomplcache_enable_auto_select = 0 
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder 
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" disable docstrings popup
set completeopt-=preview
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""jedi-vim
" If you are a person who likes to use VIM-buffers not tabs
let g:jedi#use_tabs_not_buffers = 0
" disable docstrings popup
autocmd FileType python setlocal completeopt-=preview

" use neocomplcache with jedi-vim
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.python = '[^. \t]\.\w*'
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""air-line
set laststatus=2
set t_Co=256

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

" configure whether buffer numbers should be shown.
let g:airline#extensions#tabline#buffer_nr_show = 1
" configure the formatting of filenames (see |filename-modifiers|)
let g:airline#extensions#tabline#fnamemod = ':p:t'
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""Fuzzyfinder
nmap zf :FufFile<CR>
nmap zb :FufBuffer<CR>
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""json-vim
let g:vim_json_syntax_conceal = 0
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""vim-autopep8
let g:autopep8_disable_show_diff=1
let g:autopep8_max_line_length=100
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""vim-bookmarks
let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
"""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""
""vundle
set nocompatible      " be iMproved
filetype off          " required!

if g:iswindows==1
    set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#rc('$VIM/vimfiles/bundle/')
else
    set rtp+=$HOME/.vim/vimfiles/bundle/vundle/
    call vundle#rc('$HOME/.vim/vimfiles/bundle/')
endif

" let Vundle manage Vundle required! 
Bundle 'gmarik/vundle'

" original repos on github
Bundle 'bling/vim-airline'
Bundle 'plasticboy/vim-markdown'
Bundle 'scrooloose/nerdcommenter'
Bundle 'davidhalter/jedi-vim'
Bundle 'Shougo/neocomplcache.vim'
Bundle 'Shougo/neosnippet'
Bundle 'honza/vim-snippets'
Bundle 'scrooloose/syntastic'
Bundle 'vim-scripts/FuzzyFinder'
Bundle 'hynek/vim-python-pep8-indent'
Bundle 'tell-k/vim-autopep8'
Bundle 'elzr/vim-json'
Bundle 'MattesGroeger/vim-bookmarks'
"Bundle 'dyng/ctrlsf.vim'

" vim-scripts repos
Bundle 'L9'
Bundle 'Mark--Karkat'
" non github repos
" git repos on your local machine (ie. when working on your own plugin)
filetype plugin indent on     " required!
"""""""""""""""""""""""""""""""""""""""""
