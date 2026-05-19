-- Leader key: pressed before custom shortcuts. Space is the standard choice.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true -- shows distance from cursor; makes 5j, 12k intuitive

-- Indentation
vim.opt.tabstop = 4       -- a tab looks like 4 spaces
vim.opt.shiftwidth = 4    -- >> and << shift by 4
vim.opt.expandtab = true  -- tab key inserts spaces, not tabs
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true -- /foo matches Foo
vim.opt.smartcase = true  -- ...unless you type /Foo, then it's case-sensitive
vim.opt.hlsearch = true   -- highlight matches
vim.opt.incsearch = true  -- highlight as you type

-- Quality of life
vim.opt.wrap = false          -- don't wrap long lines
vim.opt.scrolloff = 8         -- keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"    -- always show the sign column (prevents text jumping)
vim.opt.cursorline = true     -- highlight current line
vim.opt.termguicolors = true  -- 24-bit colors
vim.opt.undofile = true       --persistent undo across sessions
vim.opt.updatetime = 250      -- faster response for some plugins later
vim.opt.timeoutlen = 300      -- how long nvim waits for a key sequence

-- Splits: open in sensible places
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Clipboard: use system clipboard for yank/paste
vim.opt.clipboard = "unnamedplus"
