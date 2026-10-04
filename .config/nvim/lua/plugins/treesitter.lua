return {
  "nvim-treesitter/nvim-treesitter",

  lazy = false,
  build = ":TSUpdate",

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },

  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "c",
        "cpp",
        "go",
        "lua",
        "python",
        "rust",
        "tsx",
        "javascript",
        "typescript",
        "vimdoc",
        "vim",
        "bash",
        "query",
      },

      auto_install = true,
      sync_install = false,

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,

        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = "<C-s>",
          node_decremental = "<M-Space>",
        },
      },
    })
  end,
}
