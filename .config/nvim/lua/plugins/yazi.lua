return {
  "mikavilpas/yazi.nvim",

  version = "*",
  event = "VeryLazy",

  dependencies = {
    {
      "nvim-lua/plenary.nvim",
      lazy = true,
    },
  },

  keys = {
    {
      "<leader>-",
      mode = {
        "n",
        "v",
      },

      "<cmd>Yazi<cr>",

      desc = "Open Yazi at current file",
    },

    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",

      desc = "Open Yazi in working directory",
    },

    {
      "<C-Up>",
      "<cmd>Yazi toggle<cr>",

      desc = "Resume last Yazi session",
    },
  },

  opts = {
    open_for_directories = false,

    keymaps = {
      show_help = "<F1>",
    },
  },
}
