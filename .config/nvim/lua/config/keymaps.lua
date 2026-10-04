vim.keymap.set("n", "<Leader>e", vim.cmd.Ex, {
  desc = "Explorer",
})

vim.keymap.set("x", "<leader>p", '"_dp')
vim.keymap.set({ "n", "x" }, "<leader>P", '"+p')
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "x" }, "<leader>Y", '"+Y')

vim.keymap.set(
  { "n", "x" },
  "<CR>",
  "<cmd>nohl<CR>",
  {
    silent = true,
    noremap = true,
  }
)

vim.keymap.set(
  { "n", "v" },
  "<Space>",
  "<Nop>",
  {
    silent = true,
  }
)

vim.keymap.set(
  "n",
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  {
    expr = true,
    silent = true,
  }
)

vim.keymap.set(
  "n",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  {
    expr = true,
    silent = true,
  }
)

vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  {
    desc = "Go to previous diagnostic message",
  }
)

vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  {
    desc = "Go to next diagnostic message",
  }
)

vim.keymap.set(
  "n",
  "<leader>lf",
  vim.diagnostic.open_float,
  {
    desc = "Open floating diagnostic message",
  }
)

vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  {
    desc = "Open diagnostics list",
  }
)
