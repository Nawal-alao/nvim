-- ~/.config/nvim/lua/plugins/notify.lua
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss Notifications",
    },
    {
      "<leader>hn",
      function()
        require("telescope").extensions.notify.notify()
      end,
      desc = "Notification History",
    },
  },
  config = function()
    local notify = require("notify")

    notify.setup({
      -- ─── Style ──────────────────────────────────────────────────────────
      background_colour = "#1e1e2e",
      fps               = 60,
      icons = {
        DEBUG = " ",
        ERROR = " ",
        INFO  = " ",
        TRACE = "✎ ",
        WARN  = " ",
      },
      level             = vim.log.levels.TRACE,
      minimum_width     = 50,
      max_width         = 80,
      max_height        = 20,
      render            = "wrapped-compact",  -- compact | default | minimal | simple | wrapped-compact
      stages            = "slide",            -- fade | fade_in_slide_out | slide | static
      timeout           = 3000,
      top_down          = false,              -- Notifications en bas à droite
      on_open           = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      on_close          = nil,
    })

    -- NOTE: Ne PAS faire `vim.notify = notify` ici.
    -- noice.nvim gère automatiquement la redirection de vim.notify vers nvim-notify.

    -- ─── Highlights personnalisés ─────────────────────────────────────────
    vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "NotifyWARNBorder",  { fg = "#f9e2af" })
    vim.api.nvim_set_hl(0, "NotifyINFOBorder",  { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#6c7086" })
    vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#cba6f7" })

    vim.api.nvim_set_hl(0, "NotifyERRORIcon",   { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "NotifyWARNIcon",    { fg = "#f9e2af" })
    vim.api.nvim_set_hl(0, "NotifyINFOIcon",    { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGIcon",   { fg = "#6c7086" })
    vim.api.nvim_set_hl(0, "NotifyTRACEIcon",   { fg = "#cba6f7" })

    vim.api.nvim_set_hl(0, "NotifyERRORTitle",  { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "NotifyWARNTitle",   { fg = "#f9e2af", bold = true })
    vim.api.nvim_set_hl(0, "NotifyINFOTitle",   { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "NotifyDEBUGTitle",  { fg = "#6c7086", bold = true })
    vim.api.nvim_set_hl(0, "NotifyTRACETitle",  { fg = "#cba6f7", bold = true })

    -- ─── Intégration Telescope ────────────────────────────────────────────
    require("telescope").load_extension("notify")

    -- ─── Exemples de notifications de test (désactivé en prod) ───────────
    -- vim.notify("Neovim Python IDE chargé!", vim.log.levels.INFO, { title = "IDE Ready" })
  end,
}