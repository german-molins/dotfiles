""" PRELIMINARIES

" check if g:nd_themes is defined
if !exists('g:nd_themes')
  echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
  echomsg "g:nd_themes must be added to vimrc to define a theme schedule."
  finish
endif

" initialize variables for current theme and background state
let s:current_theme = ''
let s:current_back = ''
let s:current_airline = ''
let s:current_lightline = ''

" check latitude/time format in vimrc, initialize sun data if needed
if exists('g:nd_latitude')

  if !matchstr(g:nd_latitude, '^-65$\|^-62.5$\|^-60$\|^-57.5$\|^-55$\|^-50$\|
        \^-45$\|^-40$\|^-30$\|^-20$\|^-10$\|^0$\|^10$\|^20$\|^30$\|^40$\|
        \^45$\|^50$\|^55$\|^57.5$\|^60$\|^62.5$\|^65$')
    echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
    echomsg "g:nd_latitude (in vimrc) is not set to one of these values:"
    echomsg " "
    echomsg "[north temperate] 30 40 45 50 55 57.5 60 62.5 65"
    echomsg "[tropics] -20 -10 0 10 20"
    echomsg "[south temperate] -65 -62.5 -60 -57.5 -55 -50 -45 -40 -30"
    finish
  endif

  for i in range(0,len(g:nd_themes)-1)
    if matchstr(g:nd_themes[i][0], '^sunrise+0$') == ''
          \ && matchstr(g:nd_themes[i][0], '^sunrise+[0-9]*/[0-9]*$') == ''
          \ && matchstr(g:nd_themes[i][0], '^sunset+0$') == ''
          \ && matchstr(g:nd_themes[i][0], '^sunset+[0-9]*/[0-9]*$') == ''
      echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
      echomsg "Theme start times are not provided (in vimrc) in 'sun-relative"
      echomsg "time mode' format (sunrise+N/N, sunset+N/N)."
      echomsg " "
      echomsg "('Sun-relative time mode' is active because variable"
      echomsg " g:nd_latitude is set. Either fix the time format or switch to"
      echomsg "'absolute time mode' by removing g:nd_latitude from vimrc.)"
      finish
    endif
  endfor

  for i in range(0,len(g:nd_themes)-1)
    if split (g:nd_themes[i][0], '+')[1] != 0
      if split(split (g:nd_themes[i][0], '+')[1], '/')[0] /
            \ split(split (g:nd_themes[i][0], '+')[1], '/')[1] >= 1
        echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
        echomsg "At least one theme start time has too large an offset from"
        echomsg "sunrise/sunset (offset size must be less than 1)."
        finish
      endif
    endif
  endfor

  call sun#NdSundata()

else
  for i in range(0,len(g:nd_themes)-1)
    if matchstr(g:nd_themes[i][0], '^[0-9].:[0-9].$') == ''
          \ && matchstr(g:nd_themes[i][0], '^[0-9]:[0-9].$') == ''
      echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
      echomsg "Theme start times are not provided (in vimrc) in 'absolute time"
      echomsg "mode' format (H:MM/HH:MM)."
      echomsg " "
      echomsg "('Absolute time mode' is active because variable g:nd_latitude"
      echomsg "is not set. Either fix the time format or switch to"
      echomsg "'sun-relative time mode' by adding g:nd_latitude to vimrc.)"
      finish
    endif
  endfor

  for i in range(0,len(g:nd_themes)-1)
    if split (g:nd_themes[i][0], ':')[0] > 23
          \ || split (g:nd_themes[i][0], ':')[1] > 59
        echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
        echomsg "At least one theme start time has too large a value for"
        echomsg "hours (max value: 23) or minutes (max value: 59)."
        finish
    endif
  endfor

endif

if exists('g:nd_timeshift')
  if matchstr(g:nd_timeshift, '^-[0-9]*$\|^[0-9]*$') == ''
    echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
    echomsg "g:nd_timeshift (in vimrc) must be an integer."
    finish
  endif
  if g:nd_timeshift < -1439 || g:nd_timeshift > 1439
    echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
    echomsg "g:nd_timeshift (in vimrc) is too large (maximum magnitude: 1439)."
    finish
  endif
endif



""" PREPARE THEME TIMING

" convert start-times to minutes-after-midnight
let s:themetime = []
for i in range(0,len(g:nd_themes)-1)

  if exists('g:nd_latitude')

    if split (g:nd_themes[i][0], '+')[0] == 'sunrise'
      if split (g:nd_themes[i][0], '+')[1] == 0
        let s:minutes = g:nd_sunrise_minutes
      else
        let s:minutes = g:nd_sunrise_minutes + g:nd_daylength /
              \ split(split (g:nd_themes[i][0], '+')[1], '/')[1] *
              \ split(split (g:nd_themes[i][0], '+')[1], '/')[0]
      endif
    elseif split (g:nd_themes[i][0], '+')[0] == 'sunset'
      if split (g:nd_themes[i][0], '+')[1] == 0
        let s:minutes = g:nd_sunset_minutes
      else
        let s:minutes = g:nd_sunset_minutes + g:nd_nightlength /
              \ split(split (g:nd_themes[i][0], '+')[1], '/')[1] *
              \ split(split (g:nd_themes[i][0], '+')[1], '/')[0]
      endif
    endif

    if s:minutes > 1439
      let s:minutes = s:minutes - 1440
    endif

  else
    let s:minutes = split (g:nd_themes[i][0], ':')[0] * 60 +
          \ split (g:nd_themes[i][0], ':')[1]
  endif

  call add(s:themetime, s:minutes)
endfor

" cycle theme list if necessary
while s:themetime[-1] < s:themetime[0]
  let g:nd_themes_temp = []
  let s:themetime_temp = []
  call add(g:nd_themes_temp, g:nd_themes[-1])
  call add(s:themetime_temp, s:themetime[-1])
  for i in range(0,len(g:nd_themes)-2)
    call add(g:nd_themes_temp, g:nd_themes[i])
    call add(s:themetime_temp, s:themetime[i])
  endfor
  let g:nd_themes = g:nd_themes_temp
  let s:themetime = s:themetime_temp
endwhile

" append 'end-of-day time'
call add(s:themetime, 1440)

" define 'view theme schedule' function
function! NdSchedule()
  new | setlocal buftype=nofile
  call setline (1,'THEME SCHEDULE') | put = '==============' | put = ''
  put = 'start time      theme name' | put = '----------      ----------------'
  for i in range(0,len(g:nd_themes)-1)
    let s:hshow = s:themetime[i] / 60
    let s:mshow = s:themetime[i] - s:hshow * 60
    if len(s:hshow) == 1
      let s:hshow = ' ' . s:hshow
    endif
    if len(s:mshow) == 1
      let s:mshow = '0' . s:mshow
    endif
    put = s:hshow . ':' . s:mshow . '           ' .
          \ g:nd_themes[i][1] . ' (' . g:nd_themes[i][2] . ')'
  endfor
  1
endfunction


" check if themes are in consecutive order
for i in range(0,len(g:nd_themes)-1)
  if s:themetime[i] >= s:themetime[i+1]
    echomsg "NIGHT-AND-DAY PLUGIN - USER CONFIGURATION ERROR"
    echomsg "Theme times (in g:nd_themes) are not in consecutive order."
    call NdSchedule()
    finish
  endif
endfor


""" DEFINE SWITCH FUNCTIONS (for switching theme/background if necessary)

" lightline theme switching
function! NdSetLightlineColorscheme(name)
    let g:lightline = { 'colorscheme': a:name }
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction

" switch to scheduled theme if not already active
function! NdThemeSwitch(proposed_theme)
  if a:proposed_theme != s:current_theme
    call xolox#colorscheme_switcher#switch_to(a:proposed_theme)
    let s:current_theme = a:proposed_theme
  endif
endfunction

" switch to scheduled background state if not already active
function! NdBackgroundSwitch(proposed_back)
  if a:proposed_back != s:current_back
    if a:proposed_back == 'dark'
      exec 'set background=dark'
      let s:current_back = 'dark'
    else
      exec 'set background=light'
      let s:current_back = 'light'
    endif
  endif
endfunction

" switch to scheduled airline theme if not already active
function! NdAirlineSwitch(proposed_airline)
  if exists(':AirlineTheme')
    if a:proposed_airline != s:current_airline
      exec 'AirlineTheme ' . a:proposed_airline
      let s:current_airline = a:proposed_airline
    endif
  endif
endfunction

" switch to scheduled lightline theme if not already active
function! NdLightlineSwitch(proposed_lightline)
  if a:proposed_lightline != s:current_lightline
    call NdSetLightlineColorscheme(a:proposed_lightline)
    let s:current_lightline = a:proposed_lightline
  endif
endfunction



""" DEFINE CHECK FUNCTION (for detecting which theme/bg state should be active)

function! NdThemeCheck(timer)

  " get current time (in minutes-after-midnight)
  let s:timenow = strftime ("%H") * 60 + strftime ("%M")

  " if start-time of first theme is later than current time, select last theme
  if s:timenow < s:themetime[0]
    call NdThemeSwitch(g:nd_themes[-1][1])
    call NdBackgroundSwitch(g:nd_themes[-1][2])
    if exists('g:nd_themes[-1][3]')
      if exists('g:nd_airline') && exists('g:loaded_airline')
        if g:nd_airline == 1
          call NdAirlineSwitch(g:nd_themes[-1][3])
        endif
      endif
      if exists('g:nd_lightline') && exists('g:loaded_lightline')
        if g:nd_lightline == 1
          call NdLightlineSwitch(g:nd_themes[-1][3])
        endif
      endif
    endif

  else
    " otherwise, select theme with latest start-time before current time
    for i in range(0,len(g:nd_themes)-1)
      if s:timenow + 1 > s:themetime[i] && s:timenow < s:themetime[i+1]
        call NdThemeSwitch(g:nd_themes[i][1])
        call NdBackgroundSwitch(g:nd_themes[i][2])
        if exists('g:nd_themes[i][3]')
          if exists('g:nd_airline') && exists('g:loaded_airline')
            if g:nd_airline == 1
              call NdAirlineSwitch(g:nd_themes[i][3])
            endif
          endif
          if exists('g:nd_lightline') && exists('g:loaded_lightline')
            if g:nd_lightline == 1
              call NdLightlineSwitch(g:nd_themes[i][3])
            endif
          endif
        endif
      endif
    endfor
  endif

endfunction


""" RUN PLUGIN

" run immediately
call NdThemeCheck('')

" run continuously
if has ('timers')
  call timer_start(100, 'NdThemeCheck', {'repeat': -1})
else
  autocmd CursorHold * call NdThemeCheck('')
endif
