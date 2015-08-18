" Update speed, default: 20
let g:Cmd2_loop_sleep = 5
" Require at least 0 chars typed
let g:Cmd2__suggest_min_length = 0
" Only take suggests on tab
let g:Cmd2__suggest_enter_suggest = 0
" Cancel completion on <Esc> (instead of cancelling entire command)
let g:Cmd2__suggest_esc_menu = 1
" always use Cmd2
"nmap : :<F8>
nmap <F8> :<F8>
" Press F8 in cmdmode to use Cmd2
cmap <F8> <Plug>(Cmd2Suggest)
