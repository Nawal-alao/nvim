-- ~/.config/nvim/init.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║           Neovim Python IDE — Configuration principale                  ║
-- ║           Inspiré de PyCharm, propulsé par Neovim                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ─── Charge les options en premier (avant les plugins) ──────────────────────
require("config.options")

-- ─── Bootstrap Lazy.nvim ────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ─── Setup Lazy ─────────────────────────────────────────────────────────────
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = true, -- Charge les plugins en lazy par défaut
    version = false, -- Utilise toujours le dernier commit
  },
  install = {
    missing = true,
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true, -- Vérifie les mises à jour automatiquement
    notify = true,
    frequency = 86400, -- Une fois par jour
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    size = { width = 0.85, height = 0.85 },
    border = "rounded",
    backdrop = 60,
    title = " Lazy Plugin Manager",
    title_pos = "center",
    pills = true,
    icons = {
      cmd = " ",
      config = "⚙ ",
      event = " ",
      favorite = " ",
      ft = "󰈔 ",
      init = " ",
      import = "󰋺 ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "➔ ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
})

-- ─── Charge les keymaps et autocmds après les plugins ───────────────────────
if vim.g.neovide then
  -- Définit la police et sa taille initiale (ex: 10)
  vim.o.guifont = "JetBrainsMono Nerd Font:h10"
  -- vim.g.neovide_opacity = 0.85
end
require("config.keymaps")
require("config.autocmds")
