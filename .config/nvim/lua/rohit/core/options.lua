vim.cmd("let g:netrw_liststyle = 3")
local opt = vim.opt

--nubmer
opt.relativenumber = true
opt.number = true

--tab & space
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true


opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cousor settings
opt.cursorline = true

-- color scheme
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split window
opt.splitright = true
opt.splitbelow = true


