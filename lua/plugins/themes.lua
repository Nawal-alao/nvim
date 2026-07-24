-- ~/.config/nvim/lua/plugins/themes.lua
return {
  -- ─── Catppuccin (thème principal) ─────────────────────────────────────────
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,  -- Charge en premier
    lazy     = false,
    config = function()
      require("catppuccin").setup({
        flavour              = "mocha",  -- latte | frappe | macchiato | mocha
        background = {
          light = "latte",
          dark  = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer   = false,
        term_colors          = true,
        dim_inactive = {
          enabled    = false,
          shade      = "dark",
          percentage = 0.15,
        },
        no_italic     = false,
        no_bold       = false,
        no_underline  = false,
        styles = {
          comments   = { "italic" },
          conditionals = { "italic" },
          loops      = {},
          functions  = { "bold" },
          keywords   = { "italic" },
          strings    = {},
          variables  = {},
          numbers    = {},
          booleans   = { "bold", "italic" },
          properties = {},
          types      = { "bold" },
          operators  = {},
        },
        color_overrides = {
          mocha = {
            -- Fond légèrement plus foncé pour plus de contraste
            base    = "#1a1b2e",
            mantle  = "#161622",
            crust   = "#12121c",
          },
        },
        custom_highlights = function(colors)
          return {
            -- Python specific
            ["@keyword.python"]          = { fg = colors.mauve,  style = { "italic" } },
            ["@type.python"]             = { fg = colors.blue,   style = { "bold" } },
            ["@function.python"]         = { fg = colors.yellow, style = { "bold" } },
            ["@variable.builtin.python"] = { fg = colors.red,    style = { "italic" } },
            ["@string.documentation.python"] = { fg = colors.green, style = { "italic" } },
            -- UI
            LineNr          = { fg = colors.overlay0 },
            CursorLineNr    = { fg = colors.yellow, style = { "bold" } },
            -- LSP
            DiagnosticVirtualTextError = { fg = colors.red,     bg = colors.base },
            DiagnosticVirtualTextWarn  = { fg = colors.yellow,  bg = colors.base },
            DiagnosticVirtualTextInfo  = { fg = colors.sky,     bg = colors.base },
            DiagnosticVirtualTextHint  = { fg = colors.teal,    bg = colors.base },
          }
        end,
        integrations = {
          aerial           = true,
          alpha            = true,
          cmp              = true,
          cokeline         = true,
          copilot_vim      = true,
          dap              = true,
          dap_ui           = true,
          diffview         = true,
          fidget           = true,
          gitsigns         = true,
          indent_blankline = { enabled = true, scope_color = "lavender", colored_indent_levels = true },
          lsp_trouble      = true,
          mason            = true,
          markdown         = true,
          mini             = { enabled = true, indentscope_color = "lavender" },
          native_lsp = {
            enabled       = true,
            virtual_text = {
              errors      = { "italic" },
              hints       = { "italic" },
              warnings    = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors      = { "underline" },
              hints       = { "underline" },
              warnings    = { "underline" },
              information = { "underline" },
            },
            inlay_hints = { background = true },
          },
          navic            = { enabled = true, custom_bg = "NONE" },
          neo_tree         = true,
          neogit           = true,
          neogen           = true,
          noice            = true,
          notify           = true,
          nvim_surround    = true,
          nvimtree         = true,
          semantic_tokens  = true,
          telescope        = { enabled = true },
          treesitter       = true,
          treesitter_context = true,
          which_key        = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ─── Thèmes alternatifs (commentés, à décommenter selon préférence) ──────

  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy     = true,
    priority = 999,
    opts = {
      style        = "night",  -- storm | night | moon | day
      transparent  = false,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = true },
        functions = { bold   = true },
        variables = {},
        sidebars  = "dark",
        floats    = "dark",
      },
      day_brightness      = 0.3,
      dim_inactive        = false,
      lualine_bold        = true,
      on_colors = function(c)
        c.hint = c.teal
      end,
      on_highlights = function(hl, c)
        hl["@string.documentation"] = { fg = c.green, italic = true }
        hl.DiagnosticVirtualTextError = { fg = c.error }
      end,
    },
  },

  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy     = true,
    priority = 998,
    opts = {
      compile    = false,
      undercurl  = true,
      commentStyle = { italic = true },
      functionStyle = { bold = true },
      keywordStyle  = { italic = true },
      statementStyle = { bold = true },
      typeStyle     = { bold = true },
      transparent   = false,
      dimInactive   = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = { bg_gutter = "none" },
          },
        },
      },
      theme    = "wave",  -- wave | dragon | lotus
      background = { dark = "wave", light = "lotus" },
    },
  },

  -- Gruvbox Material
  {
    "sainnhe/gruvbox-material",
    lazy     = true,
    priority = 997,
    config = function()
      vim.g.gruvbox_material_background            = "hard"  -- soft | medium | hard
      vim.g.gruvbox_material_foreground            = "mix"   -- material | mix | original
      vim.g.gruvbox_material_enable_bold           = 1
      vim.g.gruvbox_material_enable_italic         = 1
      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_diagnostic_text_highlight = 1
      vim.g.gruvbox_material_diagnostic_line_highlight = 1
      vim.g.gruvbox_material_better_performance    = 1
    end,
  },

  -- ─── Commandes de changement de thème ────────────────────────────────────
  {
    "zaldih/themery.nvim",
    cmd  = "Themery",
    keys = {
      { "<leader>ft", "<cmd>Themery<CR>", desc = "Theme Picker" },
    },
    opts = {
      themes = {
        { name = "Catppuccin Mocha",    colorscheme = "catppuccin-mocha"    },
        { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
        { name = "Catppuccin Frappe",   colorscheme = "catppuccin-frappe"   },
        { name = "Catppuccin Latte",    colorscheme = "catppuccin-latte"    },
        { name = "Tokyo Night",         colorscheme = "tokyonight-night"    },
        { name = "Tokyo Storm",         colorscheme = "tokyonight-storm"    },
        { name = "Kanagawa Wave",       colorscheme = "kanagawa-wave"       },
        { name = "Kanagawa Dragon",     colorscheme = "kanagawa-dragon"     },
        { name = "Gruvbox Material",    colorscheme = "gruvbox-material"    },
      },
      themeConfigFile = vim.fn.stdpath("config") .. "/lua/plugins/themes.lua",
      livePreview = true,
    },
  },
}