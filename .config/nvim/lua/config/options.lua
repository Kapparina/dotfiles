vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = false
vim.opt.smartcase = true

vim.opt.errorbells = false
vim.opt.showmode = true
vim.opt.swapfile = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"
vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

vim.opt.completeopt = "menuone,noselect"
vim.opt.termguicolors = true

-- OSC52 clipboard support
-- Uncomment if needed.
--
-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end
--
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = paste,
--     ["*"] = paste,
--   },
-- }
