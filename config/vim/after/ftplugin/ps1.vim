setlocal expandtab shiftwidth=4 softtabstop=4
setlocal makeprg=pwsh\ -NoProfile\ -File\ $HOME/.config/vim/bin/pssa.ps1\ %
setlocal errorformat=%f:%l:%c:\ %m
setlocal formatprg=pwsh\ -NoProfile\ -File\ $HOME/.config/vim/bin/psfmt.ps1
