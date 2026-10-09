if executable('hadolint')
  setlocal makeprg=hadolint\ --no-color\ %
  setlocal errorformat=%f:%l\ %m
endif
