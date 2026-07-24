-- ~/.config/nvim/lua/plugins/conform.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  conform.nvim — Formatage asynchrone rapide                             ║
-- ║  Remplace none-ls pour le formatage (plus rapide, mieux maintenu)       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd   = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format (conform)",
    },
  },
  opts = {
    -- ─── Formateurs par filetype ──────────────────────────────────────────
    formatters_by_ft = {
      -- Python : ruff remplace black + isort (plus rapide, même résultat)
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_organize_imports", "ruff_format" }
        end
        -- Fallback sur black + isort si ruff absent
        return { "isort", "black" }
      end,

      lua        = { "stylua" },
      sh         = { "shfmt" },
      bash       = { "shfmt" },
      zsh        = { "shfmt" },
      markdown   = { "prettier" },
      json       = { "prettier" },
      jsonc      = { "prettier" },
      yaml       = { "prettier" },
      html       = { "prettier" },
      css        = { "prettier" },
      toml       = { "taplo" },
      ["_"]      = { "trim_whitespace" },  -- Fallback pour tous les autres
    },

    -- ─── Formatage automatique à la sauvegarde ────────────────────────────
    format_on_save = function(bufnr)
      -- Désactive pour les grands fichiers
      if vim.b[bufnr] and vim.b[bufnr].large_file then
        return nil
      end
      -- Désactive pour certains filetypes
      local disable_filetypes = { gitcommit = true, gitrebase = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end
      return {
        timeout_ms  = 3000,
        lsp_fallback = true,
      }
    end,

    -- ─── Configuration des formateurs ─────────────────────────────────────
    formatters = {
      ruff_format = {
        prepend_args = { "--line-length", "88" },
      },
      ruff_organize_imports = {
        prepend_args = { "--select", "I" },
      },
      black = {
        prepend_args = { "--line-length", "88", "--target-version", "py311" },
      },
      isort = {
        prepend_args = { "--profile", "black", "--line-length", "88" },
      },
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
      stylua = {
        prepend_args = {
          "--indent-type", "Spaces",
          "--indent-width", "2",
          "--column-width", "100",
        },
      },
    },

    -- Notifie en cas d'erreur de formatage
    notify_on_error = true,
    log_level = vim.log.levels.WARN,
  },
}
