function! EcSofttabstop(config)
  set softtabstop=2
endfunction

call editorconfig#AddNewHook(function('EcSofttabstop'))
