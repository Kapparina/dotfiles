return {
  {
    "catppuccin/nvim",

    name = "catppuccin",
    priority = 1000,
    lazy = false,

    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        diffview = true,
        harpoon = true,
        markdown = true,
        noice = true,
        nvim_surround = true,
        treesitter_context = true,
        rainbow_delimiters = true,
        which_key = true,
      },
    },

    config = function(_, opts)
      require("catppuccin").setup(opts)

      local function set_theme()
        if vim.o.background == "dark" then
          vim.cmd.colorscheme(
            "catppuccin-mocha"
          )
        else
          vim.cmd.colorscheme(
            "catppuccin-latte"
          )
        end
      end

      set_theme()

      vim.api.nvim_create_autocmd(
        "OptionSet",
        {
          pattern = "background",

          callback = function()
            set_theme()
            vim.cmd("mode")
          end,
        }
      )
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "echasnovski/mini.icons",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",

    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },
}
