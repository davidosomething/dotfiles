" plugin/plug-wilder.vim

if !dkoplug#IsLoaded('wilder.nvim') | finish | endif

call wilder#enable_cmdline_enter()
set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

"call wilder#set_option('modes', ['/', '?', ':'])
call wilder#set_option('modes', [':'])

" 'highlighter' : applies highlighting to the candidates
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ }))
