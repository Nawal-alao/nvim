-- ~/.config/nvim/lua/plugins/zen-mode.lua
return {
  {
    "folke/zen-mode.nvim",
    cmd  = "ZenMode",
    keys = {
      { "<leader>zz", "<cmd>ZenMode<CR>",          desc = "Zen Mode" },
      { "<leader>zf", function()
          require("zen-mode").toggle({
            window = { width = 0.85 },
          })
        end, desc = "Zen Mode (large)" },
      { "<leader>zm", function()
          -- Mode "focus écriture" avec Twilight
          require("zen-mode").toggle({
            window = { width = 80 },
            plugins = {
              twilight = { enabled = true },
              tmux     = { enabled = true },
            },
          })
        end, desc = "Zen Mode (writing)" },
    },
    dependencies = {
      {
        "folke/twilight.nvim",   -- Atténue le code hors focus
        opts = {
          dimming = {
            alpha      = 0.25,
            color      = { "Normal", "#ffffff" },
            term_bg    = "#000000",
            inactive   = true,
          },
          context     = 15,
          treesitter  = true,
          expand = {
            "function",
            "method",
            "table",
            "if_statement",
            "class",
            "class_definition",
            "function_definition",
            "decorated_definition",
          },
          exclude     = { "markdown" },
        },
      },
    },
    opts = {
      -- ─── Fenêtre ──────────────────────────────────────────────────────────
      window = {
        backdrop  = 0.92,  -- Opacité du fond
        width     = 0.75,  -- 75% de la largeur
        height    = 1,
        options   = {
          signcolumn    = "no",
          number        = false,
          relativenumber = false,
          cursorline    = false,
          cursorcolumn  = false,
          foldcolumn    = "0",
          list          = false,
        },
      },

      -- ─── Plugins intégrés ─────────────────────────────────────────────────
      plugins = {
        options = {
          enabled      = true,
          ruler        = false,
          showcmd      = false,
          laststatus    = 0,   -- Masque la statusline
        },
        twilight     = { enabled = true  },
        gitsigns     = { enabled = false },
        tmux         = { enabled = false },
        todo         = { enabled = false },
        alacritty    = {
          enabled    = false,
          font       = "14",
        },
        kitty = {
          enabled    = false,
          font       = "+4",
        },
        wezterm = {
          enabled    = false,
          font       = "+4",
        },
        neovide = {
          enabled    = false,
          scale      = 1.2,
          disable_animations = true,
        },
      },

      -- ─── Callbacks ────────────────────────────────────────────────────────
      on_open = function(win)
        -- Actions au démarrage du Zen Mode
        vim.opt.wrap       = true
        vim.opt.linebreak  = true
        vim.opt.breakindent = true
        vim.opt.showbreak  = "  "

        -- Notification discrète
        vim.notify(
          "Zen Mode activé — Bonne concentration! 🧘",
          vim.log.levels.INFO,
          { title = "Zen Mode", timeout = 1500 }
        )

        -- Désactive certains plugins visuels
        pcall(vim.cmd, "IndentBlanklineDisable")
        pcall(vim.cmd, "TSContext disable")
      end,

      on_close = function()
        -- Restaure les paramètres
        vim.opt.wrap       = false
        vim.opt.showbreak  = ""

        -- Réactive les plugins
        pcall(vim.cmd, "IndentBlanklineEnable")
        pcall(vim.cmd, "TSContext enable")

        vim.notify(
          "Zen Mode désactivé",
          vim.log.levels.INFO,
          { title = "Zen Mode", timeout = 1000 }
        )
      end,
    },
  },

  -- ─── Todo Comments ────────────────────────────────────────────────────────
  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "]T",          function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[T",          function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
      { "<leader>xt",  "<cmd>TodoTrouble<CR>",                              desc = "TODOs (Trouble)" },
      { "<leader>fT",  "<cmd>TodoTelescope<CR>",                            desc = "TODOs (Telescope)" },
    },
    opts = {
      signs     = true,
      sign_priority = 8,
      keywords  = {
        FIX     = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO    = { icon = " ", color = "info" },
        HACK    = { icon = " ", color = "warning", alt = { "XXX" } },
        WARN    = { icon = " ", color = "warning", alt = { "WARNING", "ATTENTION" } },
        PERF    = { icon = "󰅒 ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE    = { icon = "󰍨 ", color = "hint",    alt = { "INFO", "NOTA" } },
        TEST    = { icon = "⛋ ", color = "test",   alt = { "TESTING", "PASSED", "FAILED" } },
        SAFETY  = { icon = "󰒃 ", color = "error",   alt = {} },
        PYTHON  = { icon = " ", color = "info",   alt = { "PY" } },      },
      gui_style = {
        fg   = "NONE",
        bg   = "BOLD",
      },
      merge_keywords  = true,
      highlight = {
        multiline          = true,
        multiline_pattern  = "^.",
        multiline_context  = 10,
        before             = "",
        keyword            = "wide",
        after              = "fg",
        pattern            = [[.*<(KEYWORDS)\s*:]],
        comments_only      = true,
        max_line_len       = 400,
        exclude            = { "neo-tree" },
      },
      colors = {
        error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn",  "WarningMsg", "#FBBF24" },
        info    = { "DiagnosticInfo",  "#2563EB" },
        hint    = { "DiagnosticHint",  "#10B981" },
        default = { "Identifier",      "#7C3AED" },
        test    = { "Identifier",      "#FF006E" },
      },
      search = {
        command = "rg",
        args    = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
          "--glob=!__pycache__/",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },
}