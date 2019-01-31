" vi: foldmethod=marker
syntax enable
let root_path=expand('<sfile>:p:h')
let &runtimepath .= ',' . root_path

" ================================================================================
" basic settings
" ================================================================================
silent! set nocompatible
silent! set term=xterm-256color
set autoread
set number
set mouse=a
set splitbelow
set updatetime=2000
set wildignore+=*/tmp/*,*.so,*.swp,*.png,*.jpg,*.jpeg,*.gif,*.zip,*.rar,*.class,*.jar,*.pyc,*.pyd
set signcolumn=yes

" basic keymappings
function! CleanClose()
    let todelbufNr = bufnr("%")
    let newbufNr = bufnr("#")
    if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
        exe "b".newbufNr
    else
        bnext
    endif

    if (bufnr("%") == todelbufNr)
        new
    endif
    exe "bd".todelbufNr
endfunction
nmap < :bprev!<CR>
nmap > :bnext!<CR>
nmap X :call CleanClose()<CR>

" encoding
set encoding=utf-8
set fileencodings=utf-8,cp936,ucs-bom

" listchar
set list
set listchars=tab:‣\ ,trail:·,precedes:«,extends:»

" status
set laststatus=3
set noshowmode    " disable current mode in command line (conflict with echodoc.vim)
set shortmess+=c  " disable completion message in command line (conflict with echodoc.vim)

" indent
set autoindent
set cindent
set expandtab
set shiftwidth=4
set smartindent
set smartindent
set smarttab
set softtabstop=4
set tabstop=4

" backup
set backup
let &backupdir=root_path . '/vimbackup'
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

" ================================================================================
" plugins
" ================================================================================
let g:plug_url_format='git@github.com:%s.git'
if !filereadable(root_path . '/autoload/plug.vim')
    let vimplug_vim_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    call system('curl -fLo ' . root_path . '/autoload/plug.vim --create-dirs ' . vimplug_vim_url)
endif
call plug#begin(root_path . '/plugged')

" dependencies
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'roxma/nvim-yarp'

" sensible & eunuch
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'

" colorschemes
Plug 'flazz/vim-colorschemes'
au User AfterPlug set termguicolors
au User AfterPlug set background=dark
au User AfterPlug set colorcolumn=100,110,120
au User AfterPlug colorscheme monokai-phoenix
au User AfterPlug hi link MatchTag Search

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
au User AfterPlug let g:airline_theme='molokai'
au User AfterPlug let g:airline#extensions#tabline#enabled=1
au User AfterPlug let g:airline#extensions#anzu#enabled=0
au User AfterPlug let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#formatter='unique_tail_improved'

" coc
call system('rm -f  ' . $HOME . '/.config/nvim/coc-settings.json')
call system('ln -sf ' . root_path . '/coc-settings.json ' . $HOME . '/.config/nvim/coc-settings.json')
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/jsonc.vim'
Plug 'neoclide/coc-neco'
Plug 'shougo/neco-vim'
Plug 'richox/language-server-wrappers'
au User AfterPlug let g:coc_snippet_next = '<tab>'
au User AfterPlug inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
au User AfterPlug inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
au User AfterPlug inoremap <expr><CR>    pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
au User AfterPlug inoremap <expr><C-x><C-o> coc#refresh()
au User AfterPlug nmap <silent> gd <Plug>(coc-definition)
au User AfterPlug nmap <silent> gt <Plug>(coc-type-definition)
au User AfterPlug nmap <silent> gi <Plug>(coc-implementation)
au User AfterPlug nmap <silent> gr <Plug>(coc-references)
au User AfterPlug nmap <silent> gn <Plug>(coc-rename)
au User AfterPlug nmap <silent> gf <Plug>(coc-format)
au User AfterPlug nmap <silent> ga <Plug>(coc-codeaction-selected)
au User AfterPlug nmap <silent> gh :silent call CocActionAsync('doHover')<CR>
au User AfterPlug au CursorMoved * silent call CocActionAsync('highlight')
au User AfterPlug hi CocHighlightText guibg=#005050
au User AfterPlug hi CocErrorHighlight guibg=#800000
au User AfterPlug hi CocWarningHighlight guibg=#505000
au User AfterPlug hi CocHintSign guifg=#074540
au User AfterPlug nmap <Leader>g :CocList grep<CR>
au User AfterPlug nmap <Leader>m :CocList mru -A<CR>
au User AfterPlug nmap <Leader>ff :CocList files<CR>
au User AfterPlug nmap <Leader>fg :CocList gfiles<CR>

" nerdtree
Plug 'scrooloose/nerdtree'
au User AfterPlug nmap <Leader>n :NERDTreeToggle<CR>
au User AfterPlug let g:NERDTreeWinSize=36
au User AfterPlug let g:NERDTreeMouseMode=2
au User AfterPlug let g:NERDTreeCascadeSingleChildDir=1
au User AfterPlug let g:NERDTreeCascadeOpenSingleChildDir=1

" nerdcommenter
Plug 'scrooloose/nerdcommenter'

" devicons
Plug 'ryanoasis/vim-devicons'

" indentline
Plug 'yggdroot/indentline'
Plug 'lukas-reineke/indent-blankline.nvim'

" startify
Plug 'mhinz/vim-startify'
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) . " " . entry_path'
endfunction

" vista
Plug 'liuchengxu/vista.vim'
au User AfterPlug nmap <Leader>v :Vista!!<CR>
au User AfterPlug let g:vista#renderer#enable_icon = 1
au User AfterPlug let g:vista_default_executive = 'coc'
au User AfterPlug let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
au User AfterPlug let g:vista#renderer#icons = {
            \ "function": "\uf794",
            \ "variable": "\uf71b",
            \ }

" ranger
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
au User AfterPlug let g:ranger_map_keys=0
au User AfterPlug nmap <Leader>r :Ranger<CR>

" markdown
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'godlygeek/tabular'
au User AfterPlug let g:vim_markdown_folding_disabled=1
au User AfterPlug let g:vim_markdown_conceal=''

" markdown-preview
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'}
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'tyru/open-browser.vim'
au User AfterPlug let g:mkdp_path_to_chrome='open -a Google\\ Chrome'

" a
Plug 'vim-scripts/a.vim'
au User AfterPlug let g:alternateExtensions_js='css,less,sass,scss'
au User AfterPlug let g:alternateExtensions_css='js'
au User AfterPlug let g:alternateExtensions_less='js'
au User AfterPlug let g:alternateExtensions_sass='js'
au User AfterPlug let g:alternateExtensions_scss='js'

" stripper
Plug 'itspriddle/vim-stripper'

" textobj
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'

" expand-region & multiple-cursors
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
map + <Plug>(expand_region_expand)
map _ <Plug>(expand_region_shrink)
au User AfterPlug let g:multi_cursor_use_default_mapping=0
au User AfterPlug let g:multi_cursor_start_word_key=')'
au User AfterPlug let g:multi_cursor_select_all_word_key='*'
au User AfterPlug let g:multi_cursor_next_key=')'
au User AfterPlug let g:multi_cursor_prev_key='('
au User AfterPlug let g:multi_cursor_skip_key='_'
au User AfterPlug let g:multi_cursor_quit_key='<Esc>'
function! Multiple_cursors_before()
endfunction
function! Multiple_cursors_after()
endfunction

" easy-align
Plug 'junegunn/vim-easy-align'
au User AfterPlug vmap <Leader>a :EasyAlign<CR>

" vim-move
Plug 'matze/vim-move'
au User AfterPlug let g:move_map_keys=0
au User AfterPlug nmap <S-Up>    <Plug>MoveLineUp
au User AfterPlug nmap <S-Down>  <Plug>MoveLineDown
au User AfterPlug vmap <S-Up>    <Plug>MoveBlockUp
au User AfterPlug vmap <S-Down>  <Plug>MoveBlockDown
au User AfterPlug vmap <S-Left>  <Plug>MoveBlockLeft
au User AfterPlug vmap <S-Right> <Plug>MoveBlockRight

" incsearch
Plug 'haya14busa/incsearch.vim'
au User AfterPlug map / <Plug>(incsearch-forward)
au User AfterPlug map ? <Plug>(incsearch-backward)

" anzu
Plug 'osyo-manga/vim-anzu'
au User AfterPlug nmap N <Plug>(anzu-mode-N)
au User AfterPlug nmap n <Plug>(anzu-mode-n)
au User AfterPlug nmap # <Plug>(anzu-sharp-with-echo)
au User AfterPlug nmap * <Plug>(anzu-star-with-echo)

" match tags always
Plug 'valloric/matchtagalways'
au User AfterPlug let g:mta_use_matchparen_group=0
au User AfterPlug let g:mta_set_default_matchtag_color=0

" git-blame
Plug 'zivyangll/git-blame.vim'

" tmuxline
Plug 'edkolev/tmuxline.vim'

" echodoc
Plug 'shougo/echodoc.vim'
au User AfterPlug let g:echodoc_enable_at_startup=1

" promptline
Plug 'edkolev/promptline.vim'
au User AfterPlug let g:promptline_preset={
            \   'a': [],
            \   'c': [promptline#slices#cwd()],
            \   'z': [promptline#slices#vcs_branch()],
            \ }

" vim-rest-console
Plug 'diepm/vim-rest-console'
au User AfterPlug let g:vrc_auto_format_uhex=1
au User AfterPlug let g:vrc_auto_format_response_enabled=1
au User AfterPlug let g:vrc_split_request_body=0
au User AfterPlug let g:vrc_allow_get_request_body=1
au User AfterPlug let g:vrc_curl_opts={
            \   '--include': '',
            \   '--location': '',
            \   '--show-error': '',
            \   '--silent': ''
            \ }
au User AfterPlug let g:vrc_trigger='<C-j>'
au User AfterPlug let g:vrc_header_content_type='application/json; charset=utf-8'
au User AfterPlug let g:vrc_response_default_content_type='application/json'

" vim-rooter
Plug 'airblade/vim-rooter'
let g:rooter_cd_cmd="lcd"
let g:rooter_change_directory_for_non_project_files='current'

" vim-localvimrc
Plug 'embear/vim-localvimrc'
au User AfterPlug let g:localvimrc_sandbox=0
au User AfterPlug let g:localvimrc_ask=0

" vim-floaterm
Plug 'voldikss/vim-floaterm'
au User AfterPlug nmap <Leader>t :FloatermToggle<CR>

" languages & filetypes
Plug 'juleswang/css.vim'
Plug 'tasn/vim-tsx'
Plug 'modille/groovy.vim'
Plug 'autowitch/hive.vim'
Plug 'derekwyatt/vim-scala'
Plug 'udalov/kotlin-vim'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'aklt/plantuml-syntax'
Plug 'udalov/javap-vim'
Plug 'hashivim/vim-terraform'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'herringtondarkholme/yats.vim'
Plug 'dylon/vim-antlr'
Plug 'fatih/vim-go'
Plug 'galooshi/vim-import-js'
Plug 'elzr/vim-json'
Plug 'richox/vim-json-line-format'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'groenewege/vim-less'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'uarun/vim-protobuf'
Plug 'richox/vim-search-maven'
Plug 'cespare/vim-toml'
Plug 'posva/vim-vue'
Plug 'sukima/xmledit'
Plug 'othree/yajs.vim'
au User AfterPlug let g:javap_prg="jad -p"
au User AfterPlug let g:vim_json_syntax_conceal=0

call plug#end()
do User AfterPlug
