return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",

  dependencies = {
    "nvim-lua/plenary.nvim",

    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",

      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },

  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    })

    pcall(
      telescope.load_extension,
      "fzf"
    )

    local function find_git_root()
      local current_file =
        vim.api.nvim_buf_get_name(0)

      local current_dir
      local cwd = vim.fn.getcwd()

      if current_file == "" then
        current_dir = cwd
      else
        current_dir =
          vim.fn.fnamemodify(
            current_file,
            ":h"
          )
      end

      local git_root =
        vim.fn.systemlist(
          "git -C "
            .. vim.fn.escape(current_dir, " ")
            .. " rev-parse --show-toplevel"
        )[1]

      if vim.v.shell_error ~= 0 then
        print(
          "Not a git repository. Searching current working directory"
        )

        return cwd
      end

      return git_root
    end

    local function live_grep_git_root()
      local git_root = find_git_root()

      if git_root then
        builtin.live_grep({
          search_dirs = {
            git_root,
          },
        })
      end
    end

    local function live_grep_open_files()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end

    vim.api.nvim_create_user_command(
      "LiveGrepGitRoot",
      live_grep_git_root,
      {}
    )

    vim.keymap.set(
      "n",
      "<leader>fr",
      builtin.oldfiles,
      {
        desc = "[F]ind [R]ecently opened files",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>fb",
      builtin.buffers,
      {
        desc = "[F]ind existing [B]uffers",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>/",
      function()
        builtin.current_buffer_fuzzy_find(
          themes.get_dropdown({
            winblend = 10,
            previewer = false,
          })
        )
      end,
      {
        desc = "Fuzzily search current buffer",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>fw",
      live_grep_open_files,
      {
        desc = "[F]ind [W]ord in open files",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>ss",
      builtin.builtin,
      {
        desc = "[S]earch [S]elect Telescope",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>gf",
      builtin.git_files,
      {
        desc = "Search [G]it [F]iles",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sf",
      builtin.find_files,
      {
        desc = "[S]earch [F]iles",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sh",
      builtin.help_tags,
      {
        desc = "[S]earch [H]elp",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sw",
      builtin.grep_string,
      {
        desc = "[S]earch current [W]ord",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sg",
      builtin.live_grep,
      {
        desc = "[S]earch by [G]rep",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sG",
      live_grep_git_root,
      {
        desc = "[S]earch by [G]rep on Git Root",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sd",
      builtin.diagnostics,
      {
        desc = "[S]earch [D]iagnostics",
      }
    )

    vim.keymap.set(
      "n",
      "<leader>sr",
      builtin.resume,
      {
        desc = "[S]earch [R]esume",
      }
    )
  end,
}
