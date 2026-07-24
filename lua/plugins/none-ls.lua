-- ~/.config/nvim/lua/plugins/none-ls.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  none-ls — Diagnostics uniquement (mypy, pylint)                        ║
-- ║  Le formatage est désormais géré par conform.nvim                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
return {
  "nvimtools/none-ls.nvim",
  event        = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local b       = null_ls.builtins

    local function python_cmd(cmd)
      local venv = os.getenv("VIRTUAL_ENV")
      if venv then
        local venv_cmd = venv .. "/bin/" .. cmd
        if vim.fn.executable(venv_cmd) == 1 then
          return venv_cmd
        end
      end
      return cmd
    end

    -- Construit la liste des sources disponibles dynamiquement
    local sources = {}

    -- ─── Mypy (type checking statique) ───────────────────────────────────────
    if vim.fn.executable(python_cmd("mypy")) == 1 then
      table.insert(sources, b.diagnostics.mypy.with({
        command    = python_cmd("mypy"),
        extra_args = {
          "--ignore-missing-imports",
          "--follow-imports=silent",
          "--show-column-numbers",
        },
      }))
    end

    -- ─── Pylint (linting complet, optionnel) ─────────────────────────────────
    -- NOTE: Ruff (via LSP) couvre déjà E/W/F/I/B. Pylint est conservé
    -- uniquement si vous avez besoin de ses règles spécifiques (C/R/W extra).
    -- Désactivez ci-dessous si ruff seul suffit.
    if vim.fn.executable(python_cmd("pylint")) == 1 then
      table.insert(sources, b.diagnostics.pylint.with({
        command    = python_cmd("pylint"),
        extra_args = { "--max-line-length=88" },
        -- Désactive les catégories couvertes par ruff pour éviter les doublons
        condition  = function()
          return vim.fn.executable("pylint") == 1
        end,
      }))
    end

    -- ─── Git signs code actions ───────────────────────────────────────────────
    table.insert(sources, b.code_actions.gitsigns)

    null_ls.setup({
      debug       = false,
      log_level   = "warn",
      border      = "rounded",
      sources     = sources,
      -- NOTE: on_attach ne gère plus le formatage (délégué à conform.nvim)
    })
  end,
}