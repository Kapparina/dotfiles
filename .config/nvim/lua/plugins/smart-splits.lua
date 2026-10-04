return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,

  opts = {
    ignored_buftypes = {
      "nofile",
      "quickfix",
      "prompt",
    },

    ignored_filetypes = {
      "NvimTree",
    },

    default_amount = 3,

    at_edge = "wrap",

    float_win_behavior = "previous",

    move_cursor_same_row = false,

    cursor_follows_swapped_bufs = false,

    resize_mode = {
      quit_key = "<ESC>",

      resize_keys = {
        "h",
        "j",
        "k",
        "l",
      },

      silent = false,

      hooks = {
        on_enter = nil,
        on_leave = nil,
      },
    },

    ignored_events = {
      "BufEnter",
      "WinEnter",
    },

    multiplexer_integration = "wezterm",

    disable_multiplexer_nav_when_zoomed = true,

    kitty_password = nil,

    log_level = "info",
  },

  keys = {
    {
      "<A-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "Resize split left",
    },

    {
      "<A-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "Resize split down",
    },

    {
      "<A-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "Resize split up",
    },

    {
      "<A-l>",
      function()
        require("smart-splits").resize_right()
      end,
      desc = "Resize split right",
    },

    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Move to left split",
    },

    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Move to lower split",
    },

    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Move to upper split",
    },

    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "Move to right split",
    },

    {
      "<C-\\>",
      function()
        require("smart-splits").move_cursor_previous()
      end,
      desc = "Move to previous split",
    },

    {
      "<leader><leader>h",
      function()
        require("smart-splits").swap_buf_left()
      end,
      desc = "Swap buffer left",
    },

    {
      "<leader><leader>j",
      function()
        require("smart-splits").swap_buf_down()
      end,
      desc = "Swap buffer down",
    },

    {
      "<leader><leader>k",
      function()
        require("smart-splits").swap_buf_up()
      end,
      desc = "Swap buffer up",
    },

    {
      "<leader><leader>l",
      function()
        require("smart-splits").swap_buf_right()
      end,
      desc = "Swap buffer right",
    },
  },
}
