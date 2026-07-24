-- ~/.config/nvim/lua/plugins/ai.lua
-- Assistants IA conservés : Codeium (complétion inline) et CodeCompanion (chat & actions)
return {
  -- Codeium : Moteur d'IA inline
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_chat         = true,
        enable_local_search = true,
        enable_index        = true,
        filetypes = {
          python     = true,
          lua        = true,
          javascript = true,
          typescript = true,
          rust       = true,
          go         = true,
          ["*"]      = false,
        },
      })
    end,
  },

  -- CodeCompanion : Assistant IA conversationnel et édition inline
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "stevearc/dressing.nvim",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat toggle<CR>", mode = { "n", "v" }, desc = "CodeCompanion Chat Toggle" },
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>ae", "<cmd>CodeCompanion<CR>",            mode = { "n", "v" }, desc = "CodeCompanion Inline Edit" },
      { "<leader>ap", "<cmd>CodeCompanionChat Add<CR>",    mode = "v",          desc = "CodeCompanion Add to Chat" },
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
        opts = {
          log_level = "ERROR",
          send_code = true,
        },
      })
    end,
  },
}