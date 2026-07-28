-- ~/.config/nvim/lua/plugins/ai.lua
-- Assistants IA conservés : Copilot (complétion inline) et CodeCompanion (chat & actions)
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = {
        enabled = false,
      },
    },
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
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat toggle<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Chat Toggle",
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
      },
      {
        "<leader>ae",
        "<cmd>CodeCompanion<CR>",
        mode = { "n", "v" },
        desc = "CodeCompanion Inline Edit",
      },
      {
        "<leader>ap",
        "<cmd>CodeCompanionChat Add<CR>",
        mode = "v",
        desc = "CodeCompanion Add to Chat",
      },
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
        display = {
          chat = {
            window = {
              layout = "vertical",
              width = 0.35,
            },
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
