let s:save_cpo = &cpo
set cpo&vim

function! opensiv3d#MakeCMakeLists()
  let g:projectName = input('project name >> ')
  let homeENV = system('echo -n $HOME')

  let cmakeLists = ['cmake_minimum_required (VERSION 2.6)',
                  \ '',
                  \ 'find_package(PkgConfig)',
                  \ '',
                  \ 'project(' . g:projectName . ' CXX)',
                  \ 'enable_language(C)',
                  \ '',
                  \ 'set(CMAKE_CXX_COMPILER "clang++")',
                  \ 'set(CMAKE_CXX_FLAGS "-std=c++17 -Wall -Wextra -Wno-unknown-pragmas -fPIC -msse4.1 -D_GLFW_X11")',
                  \ 'set(CMAKE_CXX_FLAGS_DEBUG "-g3 -O0 -pg -DDEBUG")',
                  \ 'set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG -march=x86-64")',
                  \ 'set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-g3 -Og -pg")',
                  \ 'set(CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG -march=x86-64")',
                  \ '',
                  \ 'if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")',
                  \ '  add_compile_options ("-fcolor-diagnostics")',
                  \ 'elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")',
                  \ '  add_compile_options ("-fdiagnostics-color=always")',
                  \ 'endif()',
                  \ '',
                  \ 'pkg_check_modules(OPENCV4 REQUIRED opencv4)',
                  \ '',
                  \ 'include_directories(',
                  \ '"/usr/include"',
                  \ '"~/.cache/OpenSiv3D/Siv3D/include"',
                  \ '"~/.cache/OpenSiv3D/Siv3D/include/ThirdParty"', ')',
                  \ '',
                  \ 'set(SOURCE_FILES',
                  \ '  "src/Main.cpp"',
                  \ ')',
                  \ '',
                  \ 'add_executable(' . g:projectName . ' ${SOURCE_FILES})',
                  \ '',
                  \ 'target_link_libraries(' . g:projectName,
                  \ '${OPENCV4_LIBRARIES}',
                  \ '  -lOpenGL',
                  \ '  -lGLEW',
                  \ '  -lX11',
                  \ '  -langelscript',
                  \ '  -lpthread',
                  \ '  -ldl',
                  \ '  -ludev',
                  \ '  -lfreetype',
                  \ '  -lharfbuzz',
                  \ '  -lglib-2.0',
                  \ '  -lgobject-2.0',
                  \ '  -lgio-2.0',
                  \ '  -lpng',
                  \ '  -lturbojpeg',
                  \ '  -lgif',
                  \ '  -lwebp',
                  \ '  -lopenal',
                  \ '  -logg',
                  \ '  -lvorbis',
                  \ '  -lvorbisenc',
                  \ '  -lvorbisfile',
                  \ '  -lboost_filesystem',
                  \ '  -lavformat',
                  \ '  -lavcodec',
                  \ '  -lavutil',
                  \ '  -lswresample',
                  \ '',
                  \ '  ' . homeENV . '/.cache/OpenSiv3D/Linux/Build/libSiv3D.a',
                  \ ')']

  execute 'redir!>' . './CMakeLists.txt'
    for i in cmakeLists
      silent! echon i . "\n"
    endfor
  redir END
endfunction

function! opensiv3d#ProjectInit()
  call mkdir('src')
  execute 'redir!>' . 'src/Main.cpp'
    silent! echon '#include <Siv3D.hpp>' . "\n"
    silent! echon '' . "\n"
    silent! echon 'void Main() {' . "\n"
    silent! echon '  while (System::Update()) {' . "\n"
    silent! echon '  }' . "\n"
    silent! echon '}' . "\n"
  redir END
  call system('cp -r ~/.cache/OpenSiv3D/Linux/App/resources/ ./')
  call opensiv3d#MakeCMakeLists()
endfunction

function! opensiv3d#AddSourceFile()
  let nowCMakeLists = []

  if !filereadable('CMakeLists.txt')
    echo 'Can not found ./CMakeLists.txt'
    return
  endif

  for line in readfile('./CMakeLists.txt')
    call add(nowCMakeLists, line)
    if line == 'set(SOURCE_FILES'
      call add(nowCMakeLists, '  "' . expand('%') . '"')
    endif
  endfor

  execute 'redir!>' . './CMakeLists.txt'
    for i in nowCMakeLists
      silent! echon i . "\n"
    endfor
  redir END
endfunction

function! opensiv3d#CMake()
  call system('cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .')
  call system('make')
  call system('./' . g:projectName)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
