-- ~/.config/nvim/lua/plugins/indentline.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local hooks = require("ibl.hooks")

      -- ─── Couleur unique sobre pour les guides ─────────────────────────────
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- Guide d'indentation : gris très discret
        vim.api.nvim_set_hl(0, "IblIndent", {
          fg        = "#313244",
          nocombine = true,
        })
        -- Scope actif : légèrement plus visible, couleur de l'accent du thème
        vim.api.nvim_set_hl(0, "IblScope", {
          fg        = "#45475a",
          nocombine = true,
        })
        -- Whitespace
        vim.api.nvim_set_hl(0, "IblWhitespace", {
          fg        = "#2a2b3c",
          nocombine = true,
        })
      end)

      require("ibl").setup({
        enabled  = true,
        debounce = 100,

        indent = {
          -- Caractère de la ligne verticale
          char             = "│",
          tab_char         = "│",
          -- Une seule couleur sobre, pas de rainbow
          highlight        = { "IblIndent" },
          smart_indent_cap = true,
          priority         = 1,
          repeat_linebreak = false,
        },

        whitespace = {
          highlight              = { "IblWhitespace" },
          remove_blankline_trail = true,
        },

        scope = {
          enabled    = true,
          -- Caractère légèrement différent pour le scope actif
          char       = "│",
          -- Couleur unique pour le scope, plus visible que les guides
          highlight  = { "IblScope" },
          show_start = true,
          show_end   = true,
          show_exact_scope    = true,
          injected_languages  = false,
          priority            = 1024,
          include = {
            node_type = {
              python = {
                "function_definition",
                "class_definition",
                "if_statement",
                "for_statement",
                "while_statement",
                "with_statement",
                "try_statement",
                "except_clause",
                "match_statement",
                "case_clause",
                "decorated_definition",
                "block",
                "dictionary",
                "list",
                "tuple",
                "set",
              },
              lua = {
                "chunk",
                "block",
                "do_statement",
                "while_statement",
                "repeat_statement",
                "if_statement",
                "for_statement",
                "local_function",
                "function_declaration",
                "function_definition",
                "table_constructor",
                "assignment_statement",
              },
            },
          },
          exclude = {
            language  = {},
            node_type = {
              ["*"]  = { "source_file", "program" },
              lua    = { "chunk" },
              python = { "module" },
            },
          },
        },

        exclude = {
          filetypes = {
            "alpha",
            "dashboard",
            "help",
            "lazy",
            "lazyterm",
            "mason",
            "neo-tree",
            "notify",
            "TelescopePrompt",
            "toggleterm",
            "Trouble",
            "trouble",
            "aerial",
          },
          buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt",
          },
        },
      })

      -- ─── Mise à jour des couleurs quand le thème change ───────────────────
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Récupère la couleur de fond du thème courant
          local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg

          -- Calcule des couleurs relatives au fond pour rester sobre
          if normal_bg then
            vim.api.nvim_set_hl(0, "IblIndent", {
              fg        = "#313244",
              nocombine = true,
            })
            vim.api.nvim_set_hl(0, "IblScope", {
              fg        = "#45475a",
              nocombine = true,
            })
          end
        end,
      })
    end,
  },

  -- ─── Indent-o-matic : détecte automatiquement l'indentation ─────────────
  {
    "Darazaki/indent-o-matic",
    event = "BufReadPre",
    opts  = {
      max_lines       = 2048,
      standard_widths = { 2, 4, 8 },
      skip_multiline  = true,
    },
  },
}