-- ~/.config/nvim/lua/plugins/alpha.lua
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- ─── ASCII Header ──────────────────────────────────────────────────────────
    dashboard.section.header.val = {
      [[███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
      [[███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
      [[███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
      [[███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
      [[███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
      [[███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
      [[███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
      [[ ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
    }
    -- ─── Boutons ───────────────────────────────────────────────────────────────

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Trouver un fichier", "<cmd>Telescope find_files<CR>"),
      dashboard.button("n", "󰈔  Nouveau fichier", "<cmd>ene <BAR> startinsert<CR>"),
      dashboard.button("r", "󰄉  Fichiers récents", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "󰊄  Recherche globale", "<cmd>Telescope live_grep<CR>"),
      dashboard.button(
        "s",
        "󱺓  Restaurer session",
        "<cmd>lua require('persistence').load()<CR>"
      ),
      dashboard.button("p", "󱂬  Projets", "<cmd>Telescope projects<CR>"),
      dashboard.button("c", "⚙  Configuration", "<cmd>e $MYVIMRC<CR>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("m", "󱁆  Mason", "<cmd>Mason<CR>"),
      dashboard.button("q", "󰗼  Quitter", "<cmd>qa<CR>"),
    }

    -- ─── Highlights ────────────────────────────────────────────────────────────
    dashboard.section.header.opts = { position = "center", hl = "AlphaHeader" }
    dashboard.section.buttons.opts = { position = "center", hl = "AlphaButtons", spacing = 1 }

    -- ─── Layout ────────────────────────────────────────────────────────────────
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
    }

    dashboard.config.opts.noautocmd = true

    -- ─── Highlights personnalisés ──────────────────────────────────────────────
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#9ece6a" })
      end,
    })

    alpha.setup(dashboard.config)
  end,
}
