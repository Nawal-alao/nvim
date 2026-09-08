-- ~/.config/nvim/lua/config/autocmds.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  Autocommandes globales — Neovim Python IDE                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function augroup(name)
  return vim.api.nvim_create_augroup("PyIDE_" .. name, { clear = true })
end

-- ============================================================================
-- ─── FICHIERS ────────────────────────────────────────────────────────────────
-- ============================================================================

-- Relit les fichiers modifiés à l'extérieur de Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  group    = augroup("AutoRead"),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Sauvegarde auto au focus lost (utile en Python lors de tests fréquents)
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group    = augroup("AutoSave"),
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! update")
    end
  end,
})

-- Enlève les espaces en fin de ligne à la sauvegarde
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("TrimWhitespace"),
  pattern  = { "*.py", "*.lua", "*.js", "*.ts", "*.sh", "*.yaml", "*.toml" },
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Restaure la position du curseur
vim.api.nvim_create_autocmd("BufReadPost", {
  group    = augroup("RestoreCursor"),
  callback = function(ev)
    local exclude = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    local buf     = ev.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz")
    end
  end,
})

-- ============================================================================
-- ─── PYTHON ──────────────────────────────────────────────────────────────────
-- ============================================================================

-- Options spécifiques aux fichiers Python
vim.api.nvim_create_autocmd("FileType", {
  group    = augroup("PythonOptions"),
  pattern  = "python",
  callback = function()
    local opt = vim.opt_local

    -- PEP 8
    opt.expandtab   = true
    opt.shiftwidth  = 4
    opt.tabstop     = 4
    opt.softtabstop = 4
    opt.textwidth   = 88     -- Black line length
    opt.colorcolumn = "88,120"

    -- Commentaire automatique
    opt.commentstring = "# %s"

    -- Python keyword completion
    opt.iskeyword:append("-")

    -- Fold
    opt.foldmethod  = "expr"
    opt.foldexpr    = "nvim_treesitter#foldexpr()"

    -- Omnifunc (fallback si LSP absent)
    opt.omnifunc    = "python3complete#Complete"

    -- Active la vérification orthographique dans les docstrings
    opt.spell       = false  -- Géré par spellcheck sélectif

    -- Keymaps Python locaux
    local buf = vim.api.nvim_get_current_buf()
    vim.keymap.set("n", "<localleader>r", function()
      vim.cmd("silent! write")
      local python = os.getenv("VIRTUAL_ENV") and
        (os.getenv("VIRTUAL_ENV") .. "/bin/python3") or
        vim.fn.exepath("python3") or "python3"
      vim.cmd("TermExec cmd='" .. python .. " " .. vim.fn.expand("%:p") .. "'")
    end, { buffer = buf, desc = "Run Python (local)" })

    vim.keymap.set("n", "<localleader>t", function()
      vim.cmd("silent! write")
      vim.cmd("TermExec cmd='pytest " .. vim.fn.expand("%:p") .. " -v'")
    end, { buffer = buf, desc = "Test Python File" })
  end,
})

-- Détection automatique du venv
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  group    = augroup("PythonVenv"),
  pattern  = { "*.py", "*.pyi" },
  callback = function()
    -- Cherche le venv dans le répertoire courant et ses parents
    local function find_venv(dir)
      local venv_names = { "venv", ".venv", "env", ".env", "virtualenv" }
      for _, name in ipairs(venv_names) do
        local path = dir .. "/" .. name
        if vim.fn.isdirectory(path) == 1 then
          return path
        end
      end
      local parent = vim.fn.fnamemodify(dir, ":h")
      if parent ~= dir then return find_venv(parent) end
      return nil
    end

    local cwd  = vim.fn.getcwd()
    local venv = os.getenv("VIRTUAL_ENV")
    if not venv then
      venv = find_venv(cwd)
      if venv then
        vim.env.VIRTUAL_ENV = venv
        vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
      end
    end
  end,
})

-- Surligne les f-strings Python (amélioration visuelle)
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("PythonFstring"),
  pattern = "python",
  callback = function()
    vim.cmd([[
      syn match pythonFstring /\(f\|F\)\("\|'\|'''\|"""\)/ nextgroup=pythonFstringBody
      hi link pythonFstring Special
    ]])
  end,
})

-- ============================================================================
-- ─── UI ──────────────────────────────────────────────────────────────────────
-- ============================================================================

-- Ferme certains buffers spéciaux avec 'q'
vim.api.nvim_create_autocmd("FileType", {
  group    = augroup("CloseWithQ"),
  pattern  = {
    "help", "man", "lspinfo", "startuptime",
    "checkhealth", "qf", "notify", "nofile",
    "git", "gitsigns.blame", "PlenaryTestPopup",
    "aerial", "Trouble", "trouble", "lazy", "mason",
    "TelescopePrompt", "noice",
  },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})

-- Redimensionne automatiquement les fenêtres
vim.api.nvim_create_autocmd("VimResized", {
  group    = augroup("ResizeWindows"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Surligne le texte lors du yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = augroup("YankHighlight"),
  callback = function()
    vim.highlight.on_yank({
      higroup  = "IncSearch",
      timeout  = 200,
      on_visual = true,
    })
  end,
})

-- Désactive la numérotation de ligne dans les terminaux
vim.api.nvim_create_autocmd("TermOpen", {
  group    = augroup("TerminalOptions"),
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
    vim.opt_local.foldcolumn     = "0"
    vim.opt_local.scrolloff      = 0
    vim.cmd("startinsert")
  end,
})

-- ============================================================================
-- ─── LSP ─────────────────────────────────────────────────────────────────────
-- ============================================================================

-- Format automatique à la sauvegarde pour Python
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("PythonFormatOnSave"),
  pattern  = "*.py",
  callback = function()
    -- Vérifie si un client LSP supporte le format
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_formatter = false
    for _, client in ipairs(clients) do
      if client.supports_method("textDocument/formatting") then
        has_formatter = true
        break
      end
    end
    if has_formatter then
      vim.lsp.buf.format({
        async      = false,
        timeout_ms = 3000,
        filter     = function(client)
          -- Priorité : ruff > null-ls (black+isort) > autres
          return client.name == "ruff" or client.name == "null-ls"
        end,
      })
    end
  end,
})

-- Affiche les diagnostics automatiquement dans une float
vim.api.nvim_create_autocmd("CursorHold", {
  group    = augroup("DiagnosticFloat"),
  callback = function()
    -- Ne rien faire sur les buffers spéciaux
    if vim.bo.buftype ~= "" then return end
    if vim.bo.filetype == "" then return end
    vim.diagnostic.open_float(nil, {
      focusable   = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border      = "rounded",
      source      = "if_many",
      scope       = "cursor",
      max_width   = 80,
    })
  end,
})

-- ============================================================================
-- ─── FILETYPES SPÉCIFIQUES ───────────────────────────────────────────────────
-- ============================================================================

-- Markdown / RST (Python docstrings externes)
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("MarkdownOptions"),
  pattern = { "markdown", "rst", "text" },
  callback = function()
    vim.opt_local.wrap      = true
    vim.opt_local.spell     = true
    vim.opt_local.textwidth = 80
    vim.opt_local.conceallevel = 2
  end,
})

-- YAML (config Python : pyproject.toml, .github, docker-compose)
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("YamlOptions"),
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.expandtab  = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop    = 2
  end,
})

-- JSON
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("JsonOptions"),
  pattern = "json",
  callback = function()
    vim.opt_local.expandtab  = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop    = 2
    vim.opt_local.conceallevel = 0
  end,
})

-- TOML (pyproject.toml, Cargo.toml)
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("TomlOptions"),
  pattern = "toml",
  callback = function()
    vim.opt_local.expandtab  = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop    = 2
  end,
})

-- Git commit : longueur limitée
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("GitCommitOptions"),
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.spell     = true
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "72"
    vim.opt_local.wrap      = true
    -- Place le curseur au début
    vim.cmd("normal! gg0")
  end,
})

-- Shell
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("ShellOptions"),
  pattern = { "sh", "bash", "zsh", "fish" },
  callback = function()
    vim.opt_local.expandtab  = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop    = 2
  end,
})

-- Lua
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("LuaOptions"),
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab  = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop    = 2
  end,
})

-- ============================================================================
-- ─── PERFORMANCE ─────────────────────────────────────────────────────────────
-- ============================================================================

-- Désactive certaines fonctionnalités pour les grands fichiers
vim.api.nvim_create_autocmd("BufReadPre", {
  group    = augroup("BigFilePerfomance"),
  callback = function(ev)
    local max_size = 500 * 1024  -- 500 Ko
    local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stat and stat.size > max_size then
      vim.notify(
        string.format(
          "Grand fichier détecté (%.1f Mo) — certaines fonctionnalités désactivées",
          stat.size / (1024 * 1024)
        ),
        vim.log.levels.WARN,
        { title = "Performance" }
      )
      -- Désactive les fonctionnalités lourdes
      vim.opt_local.foldmethod     = "manual"
      vim.opt_local.spell          = false
      vim.opt_local.undofile       = false
      vim.opt_local.breakindent    = false
      vim.opt_local.colorcolumn    = ""
      vim.opt_local.statuscolumn   = ""
      vim.opt_local.signcolumn     = "no"
      vim.b[ev.buf].large_file     = true
      -- Désactive Treesitter
      vim.cmd("TSBufDisable highlight")
      vim.cmd("TSBufDisable indent")
      -- Désactive IndentBlankline
      pcall(vim.cmd, "IBLDisable")
    end
  end,
})

-- ============================================================================
-- ─── MESSAGES & NOTIFICATIONS ────────────────────────────────────────────────
-- ============================================================================

-- Notification si pas de session Python active
vim.api.nvim_create_autocmd("FileType", {
  group    = augroup("PythonVenvWarning"),
  pattern  = "python",
  once     = true,
  callback = function()
    vim.defer_fn(function()
      local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
      if not venv then
        vim.notify(
          "🐍 Aucun environnement Python actif\n   Utilisez <leader>pv pour sélectionner un venv",
          vim.log.levels.WARN,
          {
            title   = "Python Environment",
            timeout = 5000,
          }
        )
      end
    end, 1000)
  end,
})