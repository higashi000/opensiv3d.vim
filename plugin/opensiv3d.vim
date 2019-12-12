if exists('g:loaded_opensiv3d')
  finish
endif
let g:loaded_opensiv3d = 1

let s:save_cpo = &cpo
set cpo&vim

command! OpenSiv3dInit call opensiv3d#ProjectInit()
command! OpenSiv3dAdd call opensiv3d#AddSourceFile()
command! OpenSiv3dBuild call opensiv3d#Build()

let &cpo = s:save_cpo
unlet s:save_cpo
