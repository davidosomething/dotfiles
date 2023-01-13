" ----------------------------------------------------------------------------
" Special highlights
" ----------------------------------------------------------------------------

" misspellings
match Error 'targett'
match Error 'plugn'

" Highlight VCS conflict markers
" https://bitbucket.org/sjl/dotfiles/src/83aac563abc9d0116894ac61db2c63c9a05f72be/vim/vimrc?at=default&fileviewer=file-view-default#vimrc-233
match Error '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
