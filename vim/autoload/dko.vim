function! dko#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction

function! dko#init_object(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction
