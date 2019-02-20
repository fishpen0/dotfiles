set number

if $TERM_PROGRAM =~ "iTerm"
  " Set the title of the Terminal to the currently open file
  function! SetTerminalTitle()
      let titleString = expand('%:t')
      if len(titleString) > 0
          let &titlestring = expand('%:t')
          " this is the format iTerm2 expects when setting the window title
          let args = "\033]1;".&titlestring."\007"
          let cmd = 'silent !echo -e "'.args.'"'
          execute cmd
          redraw!
      endif
  endfunction
autocmd BufEnter * call SetTerminalTitle()
endif