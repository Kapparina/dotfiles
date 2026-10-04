vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")

-- Below is the modeline
-- vim: ts=2 sts=2 sw=2 et
