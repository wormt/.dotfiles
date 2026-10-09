" docker compose files: validate config with :make
if expand('%:t') =~# 'compose\|docker-compose'
  setlocal makeprg=docker\ compose\ -f\ %\ config\ -q
endif
