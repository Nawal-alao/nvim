-- ~/.config/nvim/lua/plugins/autopairs.lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local autopairs = require("nvim-autopairs")
    local Rule      = require("nvim-autopairs.rule")
    local cond      = require("nvim-autopairs.conds")
    local ts_conds  = require("nvim-autopairs.ts-conds")

    autopairs.setup({
      check_ts               = true,   -- Utilise Treesitter
      ts_config = {
        lua    = { "string", "source" },
        python = { "string", "string_content" },
        javascript = { "template_string", "string", "string_fragment" },
      },
      disable_filetype       = { "TelescopePrompt", "spectre_panel", "neo-tree" },
      disable_in_macro       = true,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char      = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright       = true,
      enable_afterquote      = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      enable_abbr            = false,
      break_undo             = true,
      check_comma            = true,
      map_cr                 = true,
      map_bs                 = true,
      map_c_h                = false,
      map_c_w                = false,
    })

    -- ─── Règles Python spécifiques ────────────────────────────────────────────
    -- Triple guillemets pour les docstrings Python
    autopairs.add_rules({
      -- """ → """ (docstring Python)
      Rule('"""', '"""', "python")
        :with_pair(cond.not_before_text('"""'))
        :with_move(function(opts) return opts.char == '"' end)
        :with_del(cond.none()),

      -- ''' → ''' (docstring alternatif)
      Rule("'''", "'''", "python")
        :with_pair(cond.not_before_text("'''"))
        :with_move(function(opts) return opts.char == "'" end)
        :with_del(cond.none()),

      -- f"" → f"" (f-strings)
      Rule('f"', '"', "python"),
      Rule("f'", "'", "python"),

      -- b"" → b"" (byte strings)
      Rule('b"', '"', "python"),
      Rule("b'", "'", "python"),

      -- r"" → r"" (raw strings)
      Rule('r"', '"', "python"),
      Rule("r'", "'", "python"),

      -- Espace dans les brackets []  { }  ( )
      Rule(" ", " ")
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        end)
        :with_move(cond.none())
        :with_cr(cond.none())
        :with_del(function(opts)
          local col  = vim.api.nvim_win_get_cursor(0)[2]
          local ctx  = opts.line:sub(col - 1, col + 2)
          return vim.tbl_contains({ "(  )", "[  ]", "{  }" }, ctx)
        end),

      -- Arrow function : > → >
      Rule(">", ">", "python")
        :with_pair(cond.before_text("-"))
        :with_move(function(opts) return opts.char == ">" end),
    })

    -- ─── Intégration nvim-cmp ─────────────────────────────────────────────────
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp           = require("cmp")
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )
  end,
}