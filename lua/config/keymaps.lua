-- ~/.config/nvim/lua/config/keymaps.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  Keymaps globales — Neovim Python IDE                                   ║
-- ║  Les keymaps spécifiques aux plugins sont dans leurs fichiers respectifs ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local map = vim.keymap.set

-- ─── Helper ─────────────────────────────────────────────────────────────────
local function desc(description)
  return { desc = description, noremap = true, silent = true }
end

-- ============================================================================
-- ─── MODES DE BASE ──────────────────────────────────────────────────────────
-- ============================================================================

-- Désactive la touche Q (mode Ex inutilisable)
map("n", "Q",     "<nop>",    desc("Disable Ex mode"))

-- Meilleur Esc
map("i", "jk",    "<Esc>",    desc("Exit Insert Mode"))
map("i", "kj",    "<Esc>",    desc("Exit Insert Mode"))
map("i", "<C-c>", "<Esc>",    desc("Exit Insert Mode"))

-- Sauvegarde rapide
map({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("silent! write")
  vim.notify(" Fichier sauvegardé", vim.log.levels.INFO, { title = "Save", timeout = 800 })
end, desc("Save File"))

-- Quit
map("n", "<leader>q",  "<cmd>confirm q<CR>",   desc("Quit"))
map("n", "<leader>Q",  "<cmd>confirm qall<CR>", desc("Quit All"))
map("n", "<leader>wq", "<cmd>confirm wq<CR>",   desc("Save & Quit"))

-- ============================================================================
-- ─── NAVIGATION ─────────────────────────────────────────────────────────────
-- ============================================================================

-- Déplacement entre fenêtres (compatible Tmux via C-h/j/k/l)
map("n", "<C-h>", "<C-w>h", desc("Window Left"))
map("n", "<C-j>", "<C-w>j", desc("Window Down"))
map("n", "<C-k>", "<C-w>k", desc("Window Up"))
map("n", "<C-l>", "<C-w>l", desc("Window Right"))

-- Redimensionnement des fenêtres
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          desc("Increase Height"))
map("n", "<C-Down>",  "<cmd>resize -2<CR>",           desc("Decrease Height"))
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>",  desc("Decrease Width"))
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>",  desc("Increase Width"))

-- Déplacement dans les lignes wrappées
map("n", "j",  "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (wrapped)" })
map("n", "k",  "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (wrapped)" })
map("v", "j",  "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("v", "k",  "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Centrer après navigation
map("n", "<C-d>",  "<C-d>zz",  desc("Scroll Down (centered)"))
map("n", "<C-u>",  "<C-u>zz",  desc("Scroll Up (centered)"))
map("n", "n",      "nzzzv",    desc("Next Search (centered)"))
map("n", "N",      "Nzzzv",    desc("Prev Search (centered)"))
map("n", "*",      "*zzzv",    desc("Search Word (centered)"))
map("n", "#",      "#zzzv",    desc("Search Word Back (centered)"))
map("n", "G",      "Gzz",      desc("End of File (centered)"))
map("n", "gg",     "ggzz",     desc("Start of File (centered)"))

-- Début / fin de ligne (style PyCharm)
map({ "n", "v" }, "H",  "^",   desc("Start of Line"))
map({ "n", "v" }, "L",  "$",   desc("End of Line"))

-- Marks plus visibles
map("n", "'",  "`",  desc("Go to Mark"))
map("n", "`",  "'",  desc("Go to Mark (line)"))

-- ============================================================================
-- ─── BUFFERS ────────────────────────────────────────────────────────────────
-- ============================================================================

map("n", "<S-h>",     "<cmd>bprevious<CR>",  desc("Prev Buffer"))
map("n", "<S-l>",     "<cmd>bnext<CR>",      desc("Next Buffer"))
map("n", "[b",        "<cmd>bprevious<CR>",  desc("Prev Buffer"))
map("n", "]b",        "<cmd>bnext<CR>",      desc("Next Buffer"))
map("n", "<leader>bd", function()
  local buf = vim.api.nvim_get_current_buf()
  -- Aller au buffer précédent avant de fermer
  local ok = pcall(vim.cmd, "bprev")
  if not ok then pcall(vim.cmd, "bnext") end
  vim.api.nvim_buf_delete(buf, { force = false })
end, desc("Delete Buffer"))
map("n", "<leader>bD", "<cmd>bdelete!<CR>",  desc("Force Delete Buffer"))
map("n", "<leader>bo", function()
  -- Ferme tous les buffers sauf le courant
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  end
end, desc("Close Other Buffers"))
map("n", "<leader>ba", "<cmd>%bdelete<CR>",  desc("Close All Buffers"))
map("n", "<leader>bn", "<cmd>enew<CR>",      desc("New Buffer"))

-- ─── Navigation rapide entre buffers récents ────────────────────────────────
map("n", "<leader><leader>", "<C-^>", desc("Toggle Last Buffer"))

-- ============================================================================
-- ─── TABS ────────────────────────────────────────────────────────────────────
-- ============================================================================

map("n", "<leader><tab>n",  "<cmd>tabnew<CR>",        desc("New Tab"))
map("n", "<leader><tab>d",  "<cmd>tabclose<CR>",       desc("Close Tab"))
map("n", "<leader><tab>]",  "<cmd>tabnext<CR>",        desc("Next Tab"))
map("n", "<leader><tab>[",  "<cmd>tabprevious<CR>",    desc("Prev Tab"))
map("n", "<leader><tab>f",  "<cmd>tabfirst<CR>",       desc("First Tab"))
map("n", "<leader><tab>l",  "<cmd>tablast<CR>",        desc("Last Tab"))

-- ============================================================================
-- ─── ÉDITION ────────────────────────────────────────────────────────────────
-- ============================================================================

-- Déplace les lignes sélectionnées (style PyCharm Alt+↑/↓)
map("n", "<A-j>",  "<cmd>m .+1<CR>==",            desc("Move Line Down"))
map("n", "<A-k>",  "<cmd>m .-2<CR>==",            desc("Move Line Up"))
map("i", "<A-j>",  "<Esc><cmd>m .+1<CR>==gi",     desc("Move Line Down"))
map("i", "<A-k>",  "<Esc><cmd>m .-2<CR>==gi",     desc("Move Line Up"))
map("v", "<A-j>",  ":m '>+1<CR>gv=gv",            desc("Move Selection Down"))
map("v", "<A-k>",  ":m '<-2<CR>gv=gv",            desc("Move Selection Up"))

-- Indentation en mode visuel (conserve la sélection)
map("v", "<",  "<gv",  desc("Indent Left"))
map("v", ">",  ">gv",  desc("Indent Right"))
map("v", "<Tab>",    ">gv",  desc("Indent Right"))
map("v", "<S-Tab>",  "<gv",  desc("Indent Left"))

-- Colle sans écraser le registre (mode visuel)
map("v", "p",  '"_dP', desc("Paste Without Yanking"))
map("v", "P",  '"_dP', desc("Paste Without Yanking"))

-- Supprime sans écraser le registre
map({ "n", "v" }, "<leader>D", '"_d',  desc("Delete Without Yank"))
map({ "n", "v" }, "<leader>C", '"_c',  desc("Change Without Yank"))

-- Duplique ligne / sélection
map("n", "<leader>yl", "<cmd>t.<CR>",          desc("Duplicate Line"))
map("v", "<leader>yl", "y'>p",                 desc("Duplicate Selection"))

-- Join lignes sans espace
map("n", "J",  "mzJ`z",   desc("Join Lines (cursor fixed)"))

-- Nouveau ligne sans entrer en insert
map("n", "<leader>o",  "o<Esc>",    desc("New Line Below"))
map("n", "<leader>O",  "O<Esc>",    desc("New Line Above"))

-- Sélectionne tout
map("n", "<C-a>",  "ggVG",  desc("Select All"))

-- Copie dans le clipboard système
map({ "n", "v" }, "<leader>y",  '"+y',   desc("Yank to Clipboard"))
map("n",          "<leader>Y",  '"+Y',   desc("Yank Line to Clipboard"))

-- ─── Recherche & remplacement ────────────────────────────────────────────────
-- Efface le highlight de recherche
map("n", "<Esc>",        "<cmd>nohlsearch<CR>",        desc("Clear Search Highlight"))
map("n", "<leader>nh",   "<cmd>nohlsearch<CR>",        desc("Clear Highlight"))

-- Remplace le mot sous le curseur dans tout le fichier
map("n", "<leader>sr",  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  desc("Replace Word"))
-- Remplace la sélection
map("v", "<leader>sr",  '"hy:%s/<C-r>h//gI<Left><Left><Left>',
  desc("Replace Selection"))
-- Recherche + remplace avec confirmation
map("n", "<leader>sc",  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>",
  desc("Replace Word (confirm)"))

-- ============================================================================
-- ─── PYTHON SPÉCIFIQUE ──────────────────────────────────────────────────────
-- ============================================================================

-- Exécute le fichier Python courant dans un split terminal
map("n", "<F5>", function()
  local file = vim.fn.expand("%:p")
  if vim.bo.filetype ~= "python" then
    vim.notify("Pas un fichier Python!", vim.log.levels.WARN)
    return
  end
  -- Sauvegarde d'abord
  vim.cmd("silent! write")
  -- Trouve le python du venv
  local python = vim.fn.exepath("python3") or "python3"
  local venv   = os.getenv("VIRTUAL_ENV")
  if venv then python = venv .. "/bin/python3" end
  -- Lance dans un terminal horizontal
  vim.cmd("botright 12split")
  vim.cmd("terminal " .. python .. " " .. vim.fn.shellescape(file))
  vim.cmd("startinsert")
end, desc("Run Python File"))

-- Run pytest
map("n", "<F6>", function()
  local dir = vim.fn.expand("%:p:h")
  vim.cmd("silent! write")
  vim.cmd("botright 15split")
  vim.cmd("terminal cd " .. vim.fn.shellescape(dir) .. " && pytest -v --tb=short")
  vim.cmd("startinsert")
end, desc("Run Pytest"))

-- Insère un breakpoint Python (ipdb si dispo, sinon pdb)
map("n", "<leader>pb", function()
  local row    = vim.api.nvim_win_get_cursor(0)[1]
  local indent = vim.fn.indent(row)
  local spaces = string.rep(" ", indent)
  local bp_line
  -- Préfère ipdb > pdb
  if vim.fn.executable("ipdb3") == 1 or pcall(require, "ipdb") then
    bp_line = spaces .. "import ipdb; ipdb.set_trace()  # BREAKPOINT"
  else
    bp_line = spaces .. "import pdb; pdb.set_trace()  # BREAKPOINT"
  end
  vim.api.nvim_buf_set_lines(0, row, row, false, { bp_line })
  vim.notify("Breakpoint Python inséré", vim.log.levels.INFO, { title = "Python" })
end, desc("Insert Python Breakpoint"))

-- Supprime tous les breakpoints Python
map("n", "<leader>pB", function()
  local lines   = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines = {}
  local removed  = 0
  for _, line in ipairs(lines) do
    if not (line:match("import pdb") or line:match("import ipdb") or
            line:match("set_trace") or line:match("BREAKPOINT")) then
      table.insert(new_lines, line)
    else
      removed = removed + 1
    end
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  vim.notify(
    string.format("%d breakpoint(s) supprimé(s)", removed),
    vim.log.levels.INFO,
    { title = "Python" }
  )
end, desc("Remove All Python Breakpoints"))

-- Affiche le type sous le curseur (basedpyright)
map("n", "<leader>pt", function()
  vim.lsp.buf.hover()
end, desc("Show Python Type"))

-- Organise les imports
map("n", "<leader>pi", function()
  vim.lsp.buf.code_action({
    filter = function(a)
      return a.title:lower():match("organiz") ~= nil or
             a.title:lower():match("import")  ~= nil or
             a.title:lower():match("sort")    ~= nil
    end,
    apply = true,
  })
end, desc("Organize Python Imports"))

-- ─── REPL Python : envoie la sélection ou la ligne courante ─────────────────
map("n", "<leader>ps", function()
  local line = vim.api.nvim_get_current_line()
  -- Cherche le terminal Python (term ID 1)
  require("toggleterm").exec(line, 1)
end, desc("Send Line to Python REPL"))

map("v", "<leader>ps", function()
  -- Récupère le texte sélectionné
  local start_row = vim.fn.line("'<") - 1
  local end_row   = vim.fn.line("'>")
  local lines     = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  local code      = table.concat(lines, "\n")
  require("toggleterm").exec(code, 1)
end, desc("Send Selection to Python REPL"))

-- ============================================================================
-- ─── DIAGNOSTICS & LSP ──────────────────────────────────────────────────────
-- ============================================================================

-- Navigation diagnostics
map("n", "]d",  function() vim.diagnostic.goto_next({ float = true }) end,
  desc("Next Diagnostic"))
map("n", "[d",  function() vim.diagnostic.goto_prev({ float = true }) end,
  desc("Prev Diagnostic"))
map("n", "]e",  function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = true })
end, desc("Next Error"))
map("n", "[e",  function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = true })
end, desc("Prev Error"))
map("n", "]w",  function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, float = true })
end, desc("Next Warning"))
map("n", "[w",  function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, float = true })
end, desc("Prev Warning"))

-- Diagnostics inline / float
map("n", "<leader>ld", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, desc("Line Diagnostics Float"))

-- ============================================================================
-- ─── QUICKFIX & LOCLIST ──────────────────────────────────────────────────────
-- ============================================================================

map("n", "]q",  "<cmd>cnext<CR>zz",    desc("Next Quickfix"))
map("n", "[q",  "<cmd>cprev<CR>zz",    desc("Prev Quickfix"))
map("n", "]Q",  "<cmd>clast<CR>zz",    desc("Last Quickfix"))
map("n", "[Q",  "<cmd>cfirst<CR>zz",   desc("First Quickfix"))
map("n", "]l",  "<cmd>lnext<CR>zz",    desc("Next Loclist"))
map("n", "[l",  "<cmd>lprev<CR>zz",    desc("Prev Loclist"))
map("n", "<leader>xo",  "<cmd>copen<CR>",   desc("Open Quickfix"))
map("n", "<leader>xc",  "<cmd>cclose<CR>",  desc("Close Quickfix"))
map("n", "<leader>lo",  "<cmd>lopen<CR>",   desc("Open Loclist"))
map("n", "<leader>lc",  "<cmd>lclose<CR>",  desc("Close Loclist"))

-- ============================================================================
-- ─── FORMATAGE ───────────────────────────────────────────────────────────────
-- ============================================================================

map({ "n", "v" }, "<leader>cf", function()
  vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
end, desc("Format"))

-- Format à la sauvegarde (toggle)
local auto_format = true
map("n", "<leader>uf", function()
  auto_format = not auto_format
  vim.notify(
    "Auto-format: " .. (auto_format and "ON" or "OFF"),
    vim.log.levels.INFO,
    { title = "Format" }
  )
end, desc("Toggle Auto-Format"))

-- ============================================================================
-- ─── FOLDING ────────────────────────────────────────────────────────────────
-- ============================================================================

map("n", "zR",  function() require("ufo").openAllFolds()  end,  desc("Open All Folds"))
map("n", "zM",  function() require("ufo").closeAllFolds() end,  desc("Close All Folds"))
map("n", "zr",  function() require("ufo").openFoldsExceptKinds() end, desc("Open Folds Except"))
map("n", "zm",  function() require("ufo").closeFoldsWith() end, desc("Close Folds With"))
map("n", "K",   function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then vim.lsp.buf.hover() end
end, desc("Hover / Peek Fold"))

-- ============================================================================
-- ─── UI TOGGLES ──────────────────────────────────────────────────────────────
-- ============================================================================

map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"), vim.log.levels.INFO)
end, desc("Toggle Wrap"))

map("n", "<leader>ul", function()
  vim.wo.number = not vim.wo.number
  vim.notify("Line Numbers: " .. (vim.wo.number and "ON" or "OFF"), vim.log.levels.INFO)
end, desc("Toggle Line Numbers"))

map("n", "<leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify("Relative Numbers: " .. (vim.wo.relativenumber and "ON" or "OFF"), vim.log.levels.INFO)
end, desc("Toggle Relative Numbers"))

map("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell: " .. (vim.wo.spell and "ON" or "OFF"), vim.log.levels.INFO)
end, desc("Toggle Spell"))

map("n", "<leader>uc", function()
  vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
  vim.notify("Conceal: " .. (vim.wo.conceallevel == 2 and "ON" or "OFF"), vim.log.levels.INFO)
end, desc("Toggle Conceal"))

-- Inlay hints toggle
map("n", "<leader>uh", function()
  if vim.lsp.inlay_hint then
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
    vim.notify("Inlay Hints: " .. (not enabled and "ON" or "OFF"), vim.log.levels.INFO)
  end
end, desc("Toggle Inlay Hints"))

-- Colonne de couleur
map("n", "<leader>uC", function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "88,120"
    vim.notify("ColorColumn: ON (88, 120)", vim.log.levels.INFO)
  else
    vim.wo.colorcolumn = ""
    vim.notify("ColorColumn: OFF", vim.log.levels.INFO)
  end
end, desc("Toggle ColorColumn"))

-- ============================================================================
-- ─── TERMINAL ────────────────────────────────────────────────────────────────
-- ============================================================================

-- Sortie facile du mode terminal
map("t", "<Esc><Esc>",  "<C-\\><C-n>",       desc("Exit Terminal Mode"))
map("t", "<C-h>",       "<C-\\><C-n><C-w>h", desc("Terminal → Window Left"))
map("t", "<C-j>",       "<C-\\><C-n><C-w>j", desc("Terminal → Window Down"))
map("t", "<C-k>",       "<C-\\><C-n><C-w>k", desc("Terminal → Window Up"))
map("t", "<C-l>",       "<C-\\><C-n><C-w>l", desc("Terminal → Window Right"))

-- ============================================================================
-- ─── GIT ────────────────────────────────────────────────────────────────────
-- ============================================================================

-- Navigation entre hunks
map("n", "]h",  function()
  if vim.wo.diff then return "]h" end
  vim.schedule(function() require("gitsigns").next_hunk() end)
  return "<Ignore>"
end, { expr = true, desc = "Next Git Hunk" })

map("n", "[h",  function()
  if vim.wo.diff then return "[h" end
  vim.schedule(function() require("gitsigns").prev_hunk() end)
  return "<Ignore>"
end, { expr = true, desc = "Prev Git Hunk" })

-- ============================================================================
-- ─── MISC ───────────────────────────────────────────────────────────────────
-- ============================================================================

-- Ouvre la config Neovim
map("n", "<leader>nc", "<cmd>e $MYVIMRC<CR>",         desc("Edit init.lua"))
map("n", "<leader>nC", function()
  require("telescope.builtin").find_files({
    cwd           = vim.fn.stdpath("config"),
    prompt_title  = "Config Neovim",
  })
end, desc("Browse Config"))

-- Recharge la config
map("n", "<leader>nr", "<cmd>source $MYVIMRC<CR>",     desc("Reload Config"))

-- Infos sur le fichier courant (style :file mais plus lisible)
map("n", "<leader>fi", function()
  local fname  = vim.fn.expand("%:p")
  local ftype  = vim.bo.filetype
  local fsize  = vim.fn.getfsize(fname)
  local lines  = vim.api.nvim_buf_line_count(0)
  local enc    = vim.bo.fileencoding or vim.o.encoding
  local msg    = string.format(
    " %s\n   Type: %s  |  Lignes: %d  |  Taille: %s  |  Enc: %s",
    fname, ftype, lines,
    fsize > 1024 and string.format("%.1fKo", fsize/1024) or fsize .. "o",
    enc
  )
  vim.notify(msg, vim.log.levels.INFO, { title = "Fichier", timeout = 4000 })
end, desc("File Info"))

-- Ouvre l'URL sous le curseur
map("n", "gx", function()
  local url = vim.fn.expand("<cfile>")
  if url:match("^https?://") then
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  else
    vim.cmd("normal! gf")
  end
end, desc("Open URL or File"))

-- Zoom fenêtre courante (toggle)
local _zoomed = false
local _zoom_layout = nil
map("n", "<leader>wz", function()
  if _zoomed then
    if _zoom_layout then
      vim.fn.winrestview(_zoom_layout)
    end
    vim.cmd("wincmd =")
    _zoomed = false
    vim.notify("Zoom désactivé", vim.log.levels.INFO, { title = "Window", timeout = 600 })
  else
    _zoom_layout = vim.fn.winsaveview()
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
    _zoomed = true
    vim.notify("Zoom activé", vim.log.levels.INFO, { title = "Window", timeout = 600 })
  end
end, desc("Toggle Zoom Window"))

-- Copie le chemin du fichier courant
-- NOTE: <leader>fp est réservé à Telescope project (telescope.lua)
map("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Chemin copié : " .. path, vim.log.levels.INFO, { title = "Path" })
end, desc("Copy File Path"))

map("n", "<leader>fY", function()
  local path = vim.fn.expand("%:.")  -- Chemin relatif
  vim.fn.setreg("+", path)
  vim.notify("Chemin relatif copié : " .. path, vim.log.levels.INFO, { title = "Path" })
end, desc("Copy Relative Path"))

-- Chercher le fichier courant dans Neo-tree
map("n", "<leader>fe", function()
  require("neo-tree.command").execute({
    action = "reveal",
    source = "filesystem",
    position = "left",
  })
end, desc("Reveal in Neo-tree"))
