return {
  "tpope/vim-surround",

  "tpope/vim-sleuth",

  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,

    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },

    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },

  {
    "jinh0/eyeliner.nvim",

    opts = {
      highlight_on_key = true,
    },
  },

  {
    "folke/which-key.nvim",
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  {
    "mbbill/undotree",

    keys = {
      {
        "<leader>u",
        "<cmd>UndotreeToggle<cr>",
        desc = "Toggle undo tree",
      },
    },
  },
}
