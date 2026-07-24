-- ~/.config/nvim/lua/config/options.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  Options globales Neovim — Optimisées pour Python                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local opt = vim.opt
local g = vim.g

-- ─── Leader keys ────────────────────────────────────────────────────────────
g.mapleader = " "
g.maplocalleader = "\\"

-- ─── Interface ──────────────────────────────────────────────────────────────
opt.number = true -- Numéros de ligne absolus
opt.relativenumber = true -- Numéros relatifs (navigation rapide)
opt.cursorline = true -- Surligne la ligne courante
opt.cursorcolumn = false -- Pas de colonne surlignée (perf)
opt.signcolumn = "yes" -- Toujours afficher la colonne de signes
opt.colorcolumn = "88,120" -- Guides visuels PEP8 (88 = black, 120 = max)
opt.showmode = false -- Noice s'en charge
opt.showcmd = false -- Noice s'en charge
opt.laststatus = 3 -- Statusline globale (lualine)
opt.cmdheight = 0 -- Cache la cmdline quand inutilisée
opt.pumheight = 12 -- Hauteur max du menu popup
opt.pumblend = 5 -- Transparence légère du popup
opt.winblend = 0 -- Pas de transparence sur les fenêtres normales
opt.conceallevel = 2 -- Cache les caractères conceal (markdown, etc.)
opt.concealcursor = "nc"
opt.termguicolors = true -- Couleurs 24-bit
opt.background = "dark"

-- ─── Éditeur ────────────────────────────────────────────────────────────────
opt.expandtab = true -- Utilise des espaces (PEP8)
opt.shiftwidth = 4 -- 4 espaces pour Python
opt.tabstop = 4 -- Tab = 4 espaces
opt.softtabstop = 4
opt.smartindent = true -- Indentation intelligente
opt.autoindent = true
opt.shiftround = true -- Arrondit l'indentation au multiple de shiftwidth
opt.breakindent = true -- Indente les lignes wrappées
opt.linebreak = true -- Coupe aux mots, pas aux caractères
opt.wrap = false -- Pas de wrap par défaut (toggle avec <leader>uw)
opt.showbreak = "↪ "
opt.textwidth = 0 -- Pas de coupure automatique

-- ─── Recherche ──────────────────────────────────────────────────────────────
opt.hlsearch = true -- Surligne les résultats de recherche
opt.incsearch = true -- Recherche incrémentale
opt.ignorecase = true -- Insensible à la casse...
opt.smartcase = true -- ...sauf si majuscule dans la recherche
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m"

-- ─── Fichiers ────────────────────────────────────────────────────────────────
opt.fileencoding = "utf-8"
opt.fileformats = { "unix", "dos", "mac" }
opt.autoread = true -- Relit les fichiers modifiés à l'extérieur
opt.autowrite = true -- Sauvegarde auto avant :make, etc.
opt.backup = false -- Pas de fichiers de backup
opt.writebackup = false
opt.swapfile = false -- Pas de swap
opt.undofile = true -- Undo persistant entre sessions
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undolevels = 10000

-- ─── Fenêtres & splits ──────────────────────────────────────────────────────
opt.splitright = true -- Split vertical à droite
opt.splitbelow = true -- Split horizontal en bas
opt.splitkeep = "screen" -- Garde le texte stable lors du split
opt.equalalways = false -- Pas de redimensionnement automatique

-- ─── Performance ────────────────────────────────────────────────────────────
opt.updatetime = 200 -- Déclenchement CursorHold (LSP, gitsigns...)
opt.timeoutlen = 300 -- Délai pour les séquences de touches
opt.ttimeoutlen = 10
opt.redrawtime = 1500
opt.synmaxcol = 240 -- Pas de coloration au-delà de 240 chars
opt.lazyredraw = false -- Ne pas activer (problèmes avec noice)
opt.ttyfast = true

-- ─── Complétion ─────────────────────────────────────────────────────────────
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = { "longest:full", "full" }
opt.wildoptions = "pum"
opt.wildignorecase = true
opt.wildignore = {
  "*.pyc",
  "*.pyo",
  "__pycache__",
  "*.egg-info",
  ".eggs",
  ".git",
  ".hg",
  ".svn",
  "node_modules",
  ".npm",
  "*.o",
  "*.obj",
  "*.so",
  "*.DS_Store",
  "Thumbs.db",
  ".mypy_cache",
  ".ruff_cache",
  ".pytest_cache",
  "dist",
  "build",
  "*.egg",
}

-- ─── Folding (Treesitter) ────────────────────────────────────────────────────
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "1" -- Colonne de fold de 1 caractère
-- ─── Fillchars (1 caractère ASCII/unicode simple par champ) ─────────────────
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- ─── Caractères invisibles ───────────────────────────────────────────────────
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
}

-- ─── Scroll ─────────────────────────────────────────────────────────────────
opt.scrolloff = 8 -- Garde 8 lignes visibles en haut/bas
opt.sidescrolloff = 8
opt.smoothscroll = true -- Scroll fluide (Neovim 0.10+)

-- ─── Clipboard ──────────────────────────────────────────────────────────────
opt.clipboard = "unnamedplus" -- Utilise le clipboard système

-- ─── Mouse ──────────────────────────────────────────────────────────────────
opt.mouse = "a" -- Souris activée dans tous les modes
opt.mousemodel = "extend"

-- ─── Format ─────────────────────────────────────────────────────────────────
opt.formatoptions = opt.formatoptions
  - "a" -- Pas de formatage automatique des paragraphes
  - "t" -- Pas de wrap automatique du texte
  + "c" -- Wrap des commentaires selon textwidth
  + "q" -- Formate les commentaires avec gq
  - "o" -- Pas de commentaire automatique sur 'o'/'O'
  + "r" -- Continue les commentaires sur <Enter>
  + "n" -- Reconnait les listes numérotées
  + "j" -- Enlève le leader des commentaires lors du join

-- ─── Spell ──────────────────────────────────────────────────────────────────
opt.spelllang = { "fr", "en" }
opt.spelloptions = "camel" -- Reconnait les mots camelCase

-- ─── Sessions ───────────────────────────────────────────────────────────────
opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "globals",
  "help",
  "tabpages",
  "terminal",
  "winpos",
  "winsize",
}

-- ─── Divers ─────────────────────────────────────────────────────────────────
opt.confirm = true -- Demande confirmation avant de quitter
opt.virtualedit = "block" -- Curseur libre en mode bloc
opt.inccommand = "nosplit" -- Aperçu des substitutions en temps réel
opt.diffopt = { "internal", "filler", "closeoff", "linematch:60" }
opt.jumpoptions = "view"
-- opt.shortmess      = opt.shortmess
--   + "I"   -- Pas de message d'intro
--   + "W"   -- Pas de message "written"
--   + "c"   -- Pas de messages de complétion
--   - "F"   -- Affiche le nom du fichier au chargement
--   + "s"   -- Pas de "search hit BOTTOM"

-- ─── Python provider ────────────────────────────────────────────────────────
-- Désactive les providers inutiles pour accélérer le démarrage
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

-- Spécifie le Python pour pynvim
local python3 = vim.fn.exepath("python3") or vim.fn.exepath("python")
if python3 and python3 ~= "" then
  g.python3_host_prog = python3
end

-- ─── Désactive les plugins built-in non utilisés ────────────────────────────
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "bugreport",
  -- NOTE: ftplugin et compiler sont intentionnellement conservés
  -- car ils sont nécessaires au bon fonctionnement de lua_ls et autres LSP
}
for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

-- ─── Dossiers nécessaires ────────────────────────────────────────────────────
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_dir(vim.fn.stdpath("state") .. "/undo")
ensure_dir(vim.fn.stdpath("state") .. "/sessions")
ensure_dir(vim.fn.stdpath("state") .. "/swap")
ensure_dir(vim.fn.stdpath("cache") .. "/backup")
