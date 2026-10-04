return {
  {
    "mason-org/mason-lspconfig.nvim",

    dependencies = {
      {
        "mason-org/mason.nvim",
        config = true,
      },

      {
        "j-hui/fidget.nvim",
        opts = {},
      },

      "folke/lazydev.nvim",
    },
  },
}
