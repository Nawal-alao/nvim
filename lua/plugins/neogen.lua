-- ~/.config/nvim/lua/plugins/neogen.lua
return {
  "danymat/neogen",
  cmd  = "Neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>Df",  function() require("neogen").generate({ type = "func" })   end, desc = "Docstring Function" },
    { "<leader>Dc",  function() require("neogen").generate({ type = "class" })  end, desc = "Docstring Class" },
    { "<leader>Dt",  function() require("neogen").generate({ type = "type" })   end, desc = "Docstring Type" },
    { "<leader>Df",  function() require("neogen").generate({ type = "file" })   end, desc = "Docstring File" },
    { "<leader>Dg",  function() require("neogen").generate() end,                    desc = "Docstring (auto)" },
  },
  opts = {
    snippet_engine      = "luasnip",  -- Utilise LuaSnip pour l'insertion
    enable_placeholders = true,
    placeholders_text = {
      ["description"]  = "[Description]",
      ["tparam"]       = "[Type]",
      ["parameter"]    = "[Paramètre]",
      ["return"]       = "[Retour]",
      ["rparam"]       = "[Type retour]",
      ["throw"]        = "[Exception]",
      ["varargs"]      = "[Varargs]",
      ["type"]         = "[Type]",
      ["attribute"]    = "[Attribut]",
      ["args"]         = "[Args]",
      ["kwargs"]       = "[Kwargs]",
    },
    placeholders_hl = "DiagnosticHint",

    languages = {
      -- ─── Python — Style Google ────────────────────────────────────────
      python = {
        template = {
          annotation_convention = "google",  -- google | numpydoc | reST
          -- Alternatives : "numpydoc", "reST"
        },
      },

      -- ─── Lua ──────────────────────────────────────────────────────────
      lua = {
        template = {
          annotation_convention = "emmylua",
        },
      },

      -- ─── JavaScript / TypeScript ──────────────────────────────────────
      javascript = {
        template = {
          annotation_convention = "jsdoc",
        },
      },
      typescript = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
    },
  },

  config = function(_, opts)
    require("neogen").setup(opts)

    -- Navigue entre les placeholders avec Tab
    local ls = require("luasnip")
    vim.keymap.set({ "i", "s" }, "<C-Tab>", function()
      if ls.jumpable(1) then ls.jump(1) end
    end, { desc = "Neogen next placeholder" })
    vim.keymap.set({ "i", "s" }, "<C-S-Tab>", function()
      if ls.jumpable(-1) then ls.jump(-1) end
    end, { desc = "Neogen prev placeholder" })
  end,
}