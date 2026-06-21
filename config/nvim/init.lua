vim.cmd.colorscheme('vim')
vim.opt.background="light"
vim.api.nvim_set_hl(0, 'LineNr', {fg="#f040a0"})
vim.api.nvim_set_hl(0, 'CursorLine', {bg="#f7f7f7"})
vim.api.nvim_set_hl(0, 'CursorLineNr', {bg="#f4f4f4", fg="#f040a0", bold=true})
vim.api.nvim_set_hl(0, 'CursorColumn', {bg="#f8f8f8"})
vim.api.nvim_set_hl(0, 'Folded', {bg="#ff4faf", fg="#ffffff", bold=true})
vim.api.nvim_set_hl(0, 'Status1', {bg="#f040a0", fg="#ffffff", bold=true})
vim.api.nvim_set_hl(0, 'Status2', {bg="#f040a0", fg="#ffffff"})
vim.opt.list=true
vim.opt.listchars={trail="·",tab="» ",nbsp="␣",extends="›",precedes="‹"}
vim.opt.number=true
vim.opt.showbreak="↪ "
vim.opt.breakindent=true
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.termguicolors=true
vim.opt.laststatus=3
vim.opt.statusline="%#Status1#%y[%{&fileencoding?&fileencoding:&encoding}|%{&fileformat}]%r%m%#Status2# %F %= %l:%c %L"
vim.opt.cursorline=true
vim.opt.cursorcolumn=true
vim.opt.cursorlineopt="both"
vim.opt.foldmethod="marker"
vim.opt.foldopen={"percent","search"}
vim.opt.pumheight=16
vim.opt.equalalways=true
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.splitkeep="screen"
vim.opt.startofline=false
vim.opt.completeopt={'menuone','noselect','noinsert'}
vim.opt.shortmess:append "c"
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.smartindent=true
vim.opt.undofile=true
vim.opt.title=true
vim.g.loaded_perl_provider=0 -- not well supported on chimera
vim.opt.shell = '/home/linuxbrew/.linuxbrew/bin/yash'
vim.diagnostic.config({
  float = {
    source = True,
  },
})

-- print buffer
vim.keymap.set("n", "gbb", ":ls<CR>")
-- next buffer
vim.keymap.set("n", "gbn", function()
	return "m`" .. ":" .. vim.v.count .. "bn<CR>``"
end, { expr = true })
-- previous buffer
vim.keymap.set("n", "gbp", function()
	return "m`" .. ":" .. vim.v.count .. "bp<CR>``"
end, { expr = true })
-- goto buffer
vim.keymap.set("n", "gbg", function()
	return "m`" .. ":" .. vim.v.count .. "b<CR>``"
end, { expr = true })

-- disable line numbering in terminal mode
local vim_term =    vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
  group = vim_term
})
-- start insert mode when moving to a terminal window
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then vim.cmd('startinsert') end
  end,
  group = vim_term
})
-- prevents insert mode when the terminal process has exited
vim.api.nvim_create_autocmd('TermClose', {
  callback = function(ctx)
    vim.cmd('stopinsert')
    vim.api.nvim_create_autocmd('TermEnter', {
      command = 'stopinsert',
      buffer = ctx.buf,
    })
  end,
  nested = true,
  group = vim_term
})
local path_package = vim.fn.stdpath('data') .. '/site/'-- {{{
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		'git', 'clone', '--filter=blob:none',
		'https://github.com/echasnovski/mini.nvim', mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd('packadd mini.nvim | helptags ALL')
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end-- }}}
	require('mini.deps').setup({ path = { package = path_package } })-- {{{
		require("mini.deps").add({
			source = 'nvim-treesitter/nvim-treesitter',
			checkout = 'master',
			monitor = 'main',
			hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
		})
	require('mini.deps').add({
		source = 'kevinhwang91/nvim-fundo',
		depends = {'kevinhwang91/promise-async'}
	})
