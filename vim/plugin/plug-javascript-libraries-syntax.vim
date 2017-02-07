" plugin/plug-javascript-libraries-syntax.vim

if !dko#IsPlugged('javascript-libraries-syntax.vim') | finish | endif

" the jquery lib causes funky highlighting in selectors
" e.g. in $('.ad-native-code'); the word native gets highlighted
"let g:used_javascript_libs = 'jquery,underscore,backbone,chai,handlebars'

let g:used_javascript_libs = 'underscore'
let g:used_javascript_libs .= ',backbone'
let g:used_javascript_libs .= ',chai'
let g:used_javascript_libs .= ',handlebars'
let g:used_javascript_libs .= ',jquery'
