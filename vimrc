let root_path=expand('<sfile>:p:h')
let &rtp .= ',' . root_path

" ================================================================================
" basic settings
" ================================================================================
silent! set nocompatible
silent! set term=xterm-256color
set autochdir
set number
set mouse=a
set splitbelow
set updatetime=2000
set wildignore+=*/tmp/*,*.so,*.swp,*.png,*.jpg,*.jpeg,*.gif,*.zip,*.rar,*.class,*.jar,*.pyc,*.pyd
set signcolumn=yes

set encoding=utf-8
set fileencodings=utf-8,cp936,ucs-bom
set termencoding=utf-8

set list
set listchars=tab:‣\ ,trail:·,precedes:«,extends:»,eol:¬

set laststatus=2
set noshowmode    " disable current mode in command line (conflict with echodoc.vim)
set shortmess+=c  " disable completion message in command line (conflict with echodoc.vim)

set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4

set backup
let &backupdir=root_path . '/vimbackup'
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif

nmap < :bprev<CR>
nmap > :bnext<CR>
nmap X :bdel<CR>

" ================================================================================
" plugins
" ================================================================================
if !filereadable(root_path . '/autoload/plug.vim')
    let vimplug_vim_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    call system('curl -fLo ' . root_path . '/autoload/plug.vim --create-dirs ' . vimplug_vim_url)
endif

call plug#begin(root_path . '/plugged')
    func s:plug(name, owner, params)
        Plug a:owner . '/' . a:name, a:params
    endfunc

    " default config
    " {{{ ================================================================================
    call s:plug('vim-sensible', 'tpope', {})
    call s:plug('vim-sleuth', 'tpope', {})
    call s:plug('vim-colorschemes', 'flazz', {})
    call s:plug('ayu-vim', 'ayu-theme', {})

    " config colorscheme
    au User AfterPlug set termguicolors
    au User AfterPlug set background=dark
    au User AfterPlug set colorcolumn=100,110,120
    au User AfterPlug let ayucolor='mirage'
    au User AfterPlug colorscheme ayu
    " }}} ================================================================================

    " ui
    " {{{ ================================================================================
    call s:plug('indentline', 'yggdroot', {})
    call s:plug('vim-airline', 'vim-airline', {})
    call s:plug('vim-airline-themes', 'vim-airline', {})
    call s:plug('vim-startify', 'mhinz', {})
    call s:plug('vim-signify', 'mhinz', {})
    call s:plug('vim-devicons', 'ryanoasis', {})
    call s:plug('nerdtree', 'scrooloose', {})
    call s:plug('tagbar', 'majutsushi', {})
    call s:plug('fzf.vim', 'junegunn', {})
    call s:plug('fzf', 'junegunn', {'do': './install --all'})
    call s:plug('fzf-mru.vim', 'pbogut', {})

    " config indentline
    au User AfterPlug let g:indentLine_enabled=1
    au User AfterPlug let g:indentLine_color_term=238

    " config airline
    au User AfterPlug let g:airline_theme='ayu'
    au User AfterPlug let g:airline#extensions#tabline#enabled=1
    au User AfterPlug let g:airline#extensions#anzu#enabled=0
    au User AfterPlug let g:airline_powerline_fonts=1

    " config startify
    function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) . " " . entry_path'
    endfunction

    " config tagbar
    au User AfterPlug let g:tagbar_autoclose=1
    au User AfterPlug let g:tagbar_autofocus=1
    au User AfterPlug let g:tagbar_left=1
    au User AfterPlug let g:tagbar_autoshowtag=1
    au User AfterPlug let g:tagbar_sort=1
    au User AfterPlug let g:tagbar_compact=1
    au User AfterPlug let g:tagbar_width=28
    au User AfterPlug nmap <Leader>t :TagbarToggle<CR>

    " config nerdtree
    au User AfterPlug nmap <Leader>n :NERDTreeToggle<CR>

    " config fzf
    au User AfterPlug nmap <Leader>f :Files<CR>
    au User AfterPlug nmap <Leader>m :FZFMru<CR>
    " }}} ================================================================================

    " omni completion
    " {{{ ================================================================================
    if has('nvim')
        call s:plug('deoplete.nvim', 'shougo', {'do': ':UpdateRemotePlugins'})
    else
        call s:plug('nvim-yarp', 'roxma', {})
        call s:plug('vim-hug-neovim-rpc', 'roxma', {})
    endif
    call s:plug('neco-syntax', 'shougo', {})
    call s:plug('neco-vim', 'shougo', {})
    call s:plug('languageclient-neovim', 'autozimu', {'branch': 'next', 'do': 'sh install.sh'})
    call s:plug('language-server-wrappers', 'richox', {})

    " config deoplete
    au User AfterPlug set completeopt=menuone,noselect,noinsert
    au User AfterPlug let g:deoplete#enable_at_startup=1
    au User AfterPlug let g:deoplete#auto_complete_delay=300
    au User AfterPlug let g:deoplete#auto_complete_start_length=3
    au User AfterPlug call deoplete#custom#source('_', 'max_menu_width', 0)
    au User AfterPlug inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
    au User AfterPlug inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

    " config languageclient-neovim
    au User AfterPlug let g:LanguageClient_autoStart = 1
    au User AfterPlug let g:LanguageClient_autoStop = 1
    au User AfterPlug let g:LanguageClient_serverCommands = {
                \ 'c':          [root_path . '/plugged/language-server-wrappers/ls-cpp'],
                \ 'cpp':        [root_path . '/plugged/language-server-wrappers/ls-cpp'],
                \ 'python':     [root_path . '/plugged/language-server-wrappers/ls-python'],
                \ 'java':       [root_path . '/plugged/language-server-wrappers/ls-java'],
                \ 'javascript': [root_path . '/plugged/language-server-wrappers/ls-javascript'],
                \ 'typescript': [root_path . '/plugged/language-server-wrappers/ls-javascript'],
                \ 'go':         [root_path . '/plugged/language-server-wrappers/ls-go'],
                \ 'rust':       [root_path . '/plugged/language-server-wrappers/ls-rust'],
                \ 'php':        [root_path . '/plugged/language-server-wrappers/ls-php'],
                \ 'kotlin':     [root_path . '/plugged/language-server-wrappers/ls-kotlin'],
                \ 'vue':        ['vls'],
                \ }
    au User AfterPlug let g:LanguageClient_rootMarkers = ['.root', '.git', '.project.*', 'Cargo.toml', 'pom.xml']
    au User AfterPlug nmap gc  :call LanguageClient_contextMenu()<CR>
    au User AfterPlug vmap gc  :call LanguageClient_contextMenu()<CR>
    au User AfterPlug nmap ga  :call LanguageClient_textDocument_codeAction()<CR>
    au User AfterPlug nmap gd  :call LanguageClient_textDocument_definition()<CR>
    au User AfterPlug nmap gf  :call LanguageClient_textDocument_formatting()<CR>
    au User AfterPlug nmap gh  :call LanguageClient_textDocument_hover()<CR>
    au User AfterPlug nmap gi  :call LanguageClient_textDocument_implementation()<CR>
    au User AfterPlug nmap gn  :call LanguageClient_textDocument_rename()<CR>
    au User AfterPlug nmap gr  :call LanguageClient_textDocument_references()<CR>
    au User AfterPlug nmap gt  :call LanguageClient_textDocument_typeDefinition()<CR>
    au User AfterPlug vmap grf :call LanguageClient_textDocument_rangeFormatting()<CR>
    " }}} ================================================================================

    " markdown preview
    " {{{ ================================================================================
    call s:plug('markdown-preview.vim', 'iamcco', {})
    call s:plug('mathjax-support-for-mkdp', 'iamcco', {})

    " config markdown-preview
    let g:mkdp_path_to_chrome='open -a Google\\ Chrome'
    " }}} ================================================================================

    " languages & filetypes
    " {{{ ================================================================================
    call s:plug('a.vim', 'vim-scripts', {})
    call s:plug('groovy.vim', 'modille', {})
    call s:plug('hive.vim', 'autowitch', {})
    call s:plug('kotlin-vim', 'udalov', {})
    call s:plug('rust.vim', 'rust-lang', {})
    call s:plug('typescript-vim', 'leafgarland', {})
    call s:plug('vim-antlr', 'dylon', {})
    call s:plug('vim-go', 'fatih', {})
    call s:plug('vim-json', 'elzr', {})
    call s:plug('vim-json-line-format', 'axiaoxin', {})
    call s:plug('vim-protobuf', 'uarun', {})
    call s:plug('vim-search-maven', 'richox', {})
    call s:plug('vim-toml', 'cespare', {})
    call s:plug('vim-vue', 'posva', {})
    call s:plug('xmledit', 'sukima', {})
    call s:plug('yajs.vim', 'othree', {})

    " config vim-json
    au User AfterPlug let g:vim_json_syntax_conceal=0
    " }}} ================================================================================

    " edit
    " {{{ ================================================================================
    call s:plug('vim-easy-align', 'junegunn', {})
    call s:plug('vim-expand-region', 'terryma', {})
    call s:plug('vim-multiple-cursors', 'terryma', {})
    call s:plug('vim-stripper', 'itspriddle', {})
    call s:plug('vim-textobj-function', 'kana', {})
    call s:plug('vim-textobj-indent', 'kana', {})
    call s:plug('vim-textobj-parameter', 'sgur', {})
    call s:plug('vim-textobj-syntax', 'kana', {})
    call s:plug('vim-textobj-user', 'kana', {})
    call s:plug('vim-move', 'matze', {})

    " config expand-region
    map + <Plug>(expand_region_expand)
    map _ <Plug>(expand_region_shrink)

    " config multiple-cursors
    au User AfterPlug let g:multi_cursor_use_default_mapping=0
    au User AfterPlug let g:multi_cursor_start_word_key=')'
    au User AfterPlug let g:multi_cursor_select_all_word_key='*'
    au User AfterPlug let g:multi_cursor_next_key=')'
    au User AfterPlug let g:multi_cursor_prev_key='('
    au User AfterPlug let g:multi_cursor_skip_key='_'
    au User AfterPlug let g:multi_cursor_quit_key='<Esc>'
    function! Multiple_cursors_before()
        if exists('g:deoplete#disable_auto_complete')
           let g:deoplete#disable_auto_complete = 1
        endif
    endfunction
    function! Multiple_cursors_after()
        if exists('g:deoplete#disable_auto_complete')
           let g:deoplete#disable_auto_complete = 0
        endif
    endfunction

    " config easy-align
    au User AfterPlug vmap <Leader>a :EasyAlign<CR>

    " config vim-move
    au User AfterPlug let g:move_map_keys=0
    au User AfterPlug nmap <S-Up>    <Plug>MoveLineUp
    au User AfterPlug vmap <S-Up>    <Plug>MoveBlockUp
    au User AfterPlug nmap <S-Down>  <Plug>MoveLineDown
    au User AfterPlug vmap <S-Down>  <Plug>MoveBlockDown
    au User AfterPlug nmap <S-Left>  <Plug>MoveCharLeft
    au User AfterPlug vmap <S-Left>  <Plug>MoveBlockLeft
    au User AfterPlug vmap <S-Right> <Plug>MoveBlockRight
    au User AfterPlug nmap <S-Right> <Plug>MoveCharRight
    " }}} ================================================================================

    " search
    " {{{ ================================================================================
    call s:plug('vim-anzu', 'osyo-manga', {})
    call s:plug('incsearch.vim', 'haya14busa', {})
    call s:plug('matchtagalways', 'valloric', {})

    " config incsearch
    au User AfterPlug map / <Plug>(incsearch-forward)
    au User AfterPlug map ? <Plug>(incsearch-backward)

    " config anzu
    au User AfterPlug nmap N <Plug>(anzu-mode-N)
    au User AfterPlug nmap n <Plug>(anzu-mode-n)
    au User AfterPlug nmap # <Plug>(anzu-sharp-with-echo)
    au User AfterPlug nmap * <Plug>(anzu-star-with-echo)

    " config match tags
    au User AfterPlug let g:mta_use_matchparen_group=0
    au User AfterPlug let g:mta_set_default_matchtag_color=0
    " }}} ================================================================================

    " utils
    " {{{ ================================================================================
    call s:plug('echodoc.vim', 'shougo', {})
    call s:plug('git-blame.vim', 'zivyangll', {})
    call s:plug('promptline.vim', 'edkolev', {})
    call s:plug('tmuxline.vim', 'edkolev', {})
    call s:plug('vim-eunuch', 'tpope', {})
    call s:plug('vim-grepper', 'mhinz', {})
    call s:plug('vim-rest-console', 'diepm', {})

    " config vim-grapper
    au User AfterPlug nmap <Leader>g :Grepper<CR>

    " config echodoc
    au User AfterPlug let g:echodoc_enable_at_startup=1

    " config git-blame
    au User AfterPlug nmap gb :<C-u>call gitblame#echo()<CR>

    " config promptline
    au User AfterPlug let g:promptline_preset={
                \   'a': ['exit=$last_exit_code', 'jobs=\j'],
                \   'c': [promptline#slices#cwd()],
                \   'z': [promptline#slices#vcs_branch()],
                \ }

    " config vim rest controller
    au User AfterPlug let g:vrc_auto_format_uhex=1
    au User AfterPlug let g:vrc_auto_format_response_enabled=1
    au User AfterPlug let g:vrc_split_request_body=0
    au User AfterPlug let g:vrc_curl_opts={
                \   '--include': '',
                \   '--location': '',
                \   '--show-error': '',
                \   '--silent': ''
                \ }
    au User AfterPlug let g:vrc_trigger='<C-j>'
    au User AfterPlug let g:vrc_header_content_type='application/json; charset=utf-8'
    au User AfterPlug let g:vrc_response_default_content_type='application/json'
    " }}} ================================================================================
call plug#end()
do User AfterPlug

" vim: ft=vim foldenable foldmethod=marker
