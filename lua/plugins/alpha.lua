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

    local version = vim.version()
    local nvim_version =
      string.format("  v%d.%d.%d", version.major, version.minor, version.patch)
    -- ─── ASCII Header ──────────────────────────────────────────────────────────
    dashboard.section.header.val = {
      [[                                                                                ]],
      [[ =================     ===============     ===============   ========  ======== ]],
      [[ \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . // ]],
      [[ ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .|| ]],
      [[ || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . || ]],
      [[ ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .|| ]],
      [[ || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . || ]],
      [[ ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .|| ]],
      [[ || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . || ]],
      [[ ||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.|| ]],
      [[ ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `|| ]],
      [[ ||    `'         || ||         `'    || ||    `'         || ||   | \  / |   || ]],
      [[ ||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   || ]],
      [[ ||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   || ]],
      [[ ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   || ]],
      [[ ||   .=='    _-'          `-__\._-'         `-_./__-'         `' |. /|  |   || ]],
      [[ ||.=='    _-'                                                     `' |  /==.|| ]],
      [[ =='    _-'                                                            \/   `== ]],
      [[ \   _-'                                                                `-_   / ]],
      [[  `''                                                                      ``'  ]],
      [[                                                                                ]],
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

    -- ─── Footer dynamique ──────────────────────────────────────────────────────
    local function footer()
      local stats = require("lazy").stats()
      local version = vim.version()

      local datetime = os.date("  %d/%m/%Y   %H:%M")
      local plugins_text = string.format("⚡ %d/%d plugins", stats.loaded, stats.count)
      local nvim_version =
        string.format("  v%d.%d.%d", version.major, version.minor, version.patch)

      return {
        "",
        "      " .. datetime,
        "  " .. nvim_version .. "   " .. plugins_text,
        "",
        "Propulsé par Neovim + Python LSP",
      }
    end

    -- Assigne la fonction elle-même (sans les parenthèses) pour qu'Alpha l'évalue dynamiquement
    dashboard.section.footer.val = footer
    dashboard.section.footer.opts = {
      position = "center",
      hl = "AlphaFooter",
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
      { type = "padding", val = 2 },
      dashboard.section.footer,
    }

    dashboard.config.opts.noautocmd = true

    -- ─── Highlights personnalisés ──────────────────────────────────────────────
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#9ece6a" })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#565f89", italic = true })
      end,
    })

    alpha.setup(dashboard.config)

    -- Recharge le footer à chaque ouverture
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
