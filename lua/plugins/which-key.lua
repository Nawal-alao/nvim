-- ~/.config/nvim/lua/plugins/which-key.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay    = 400,
    notify   = false,

    plugins = {
      marks     = true,
      registers = true,
      spelling  = {
        enabled     = true,
        suggestions = 20,
      },
      presets = {
        operators    = false,  -- désactivé pour éviter les conflits
        motions      = false,
        text_objects = true,
        windows      = true,
        nav          = true,
        z            = true,
        g            = true,
      },
    },

    win = {
      border   = "rounded",
      padding  = { 1, 2 },
      title    = true,
      title_pos = "center",
      zindex   = 1000,
      wo = { winblend = 10 },
    },

    layout = {
      width   = { min = 20 },
      spacing = 3,
    },

    icons = {
      breadcrumb = "»",
      separator  = "➜",
      group      = "+",
      ellipsis   = "…",
      mappings   = true,
      colors     = true,
    },

    show_help = true,
    show_keys = true,

    disable = {
      buftypes  = {},
      filetypes = { "TelescopePrompt" },
    },
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- ─── Groupes ──────────────────────────────────────────────────────────
    wk.add({
      { "<leader>a",       group = "AI (CodeCompanion / Codeium)" },
      { "<leader>b",       group = "Buffer" },
      { "<leader>c",       group = "Code" },
      { "<leader>D",       group = "Docstring" },
      { "<leader>d",       group = "Debug (DAP)" },
      { "<leader>dP",      group = "DAP Python" },
      { "<leader>e",       group = "Explorer" },
      { "<leader>f",       group = "Find / Telescope" },
      { "<leader>fg",      group = "Git (Telescope)" },
      { "<leader>g",       group = "Git" },
      { "<leader>gh",      group = "Git Hunks" },
      { "<leader>h",       group = "History" },
      { "<leader>l",       group = "LSP" },
      { "<leader>lw",      group = "LSP Workspace" },
      { "<leader>n",       group = "Noice / Nvim" },
      { "<leader>p",       group = "Python" },
      { "<leader>r",       group = "Rename" },
      { "<leader>S",       group = "Session" },
      { "<leader>s",       group = "Search/Replace" },
      { "<leader>t",       group = "Terminal" },
      { "<leader>u",       group = "UI Toggles" },
      { "<leader>w",       group = "Window" },
      { "<leader>x",       group = "Diagnostics" },
      { "<leader>z",       group = "Zen Mode" },
      { "<leader><tab>",   group = "Tabs" },
      { "g",               group = "Go to" },
      { "z",               group = "Fold" },
      { "]",               group = "Next" },
      { "[",               group = "Prev" },

      -- ─── Window management ──────────────────────────────────────────────
      { "<leader>ww", "<C-W>p",   desc = "Other Window" },
      { "<leader>wd", "<C-W>c",   desc = "Delete Window" },
      { "<leader>w-", "<C-W>s",   desc = "Split Below" },
      { "<leader>w|", "<C-W>v",   desc = "Split Right" },
      { "<leader>wh", "<C-W>h",   desc = "Go Left" },
      { "<leader>wj", "<C-W>j",   desc = "Go Down" },
      { "<leader>wk", "<C-W>k",   desc = "Go Up" },
      { "<leader>wl", "<C-W>l",   desc = "Go Right" },
      { "<leader>w=", "<C-W>=",   desc = "Balance Windows" },

      -- ─── UI toggles ─────────────────────────────────────────────────────
      { "<leader>uw", function()
          vim.wo.wrap = not vim.wo.wrap
          vim.notify("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"), vim.log.levels.INFO)
        end, desc = "Toggle Wrap" },
      { "<leader>ul", function()
          vim.wo.number = not vim.wo.number
          vim.notify("Line Numbers: " .. (vim.wo.number and "ON" or "OFF"), vim.log.levels.INFO)
        end, desc = "Toggle Line Numbers" },
      { "<leader>ur", function()
          vim.wo.relativenumber = not vim.wo.relativenumber
          vim.notify("Relative Numbers: " .. (vim.wo.relativenumber and "ON" or "OFF"), vim.log.levels.INFO)
        end, desc = "Toggle Relative Numbers" },
      { "<leader>us", function()
          vim.wo.spell = not vim.wo.spell
          vim.notify("Spell: " .. (vim.wo.spell and "ON" or "OFF"), vim.log.levels.INFO)
        end, desc = "Toggle Spell" },
    })
  end,
}