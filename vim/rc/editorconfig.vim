" This works with vim-scripts/IndentTab
"
" softtabstop is for pressing tab within the line for alignment
" Editor Config overrides softtabstop to be the shiftwidth
" Undo that, and keep softtabstop at 2
" This way in PHP you can use mixed:
" - real tabs (one at a time with TAB) for indenting at beginning
" - spaces (two at a time with TAB) for alignment in middle of line
"
" e.g.
"
" ```php
" <?php
" $a = array(
" 	'key' =>    'value'
" 	'b'   =>    'value'
" );
" ?>
" ```

function! EcSofttabstop(config)
  set softtabstop=2
endfunction
call editorconfig#AddNewHook(function('EcSofttabstop'))

