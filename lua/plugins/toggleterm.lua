-- ~/.config/nvim/lua/plugins/toggleterm.lua
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd     = { "ToggleTerm", "TermExec" },
  keys = {
    { "<C-\\>",      "<cmd>ToggleTerm<CR>",                                          mode = { "n", "t" }, desc = "Terminal Toggle" },
    { "<leader>tt",  "<cmd>ToggleTerm direction=horizontal<CR>",                     desc = "Terminal Horizontal" },
    { "<leader>tv",  "<cmd>ToggleTerm direction=vertical<CR>",                       desc = "Terminal Vertical" },
    { "<leader>tf",  "<cmd>ToggleTerm direction=float<CR>",                          desc = "Terminal Float" },
    { "<leader>ta",  "<cmd>ToggleTerm direction=tab<CR>",                            desc = "Terminal Tab" },
    -- Python REPL
    { "<leader>tpy", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local python   = Terminal:new({
          cmd       = vim.fn.exepath("ipython") ~= "" and "ipython --no-autoindent" or "python3",
          direction = "float",
          display_name = "Python REPL",
          float_opts = {
            border     = "double",
            width      = math.floor(vim.o.columns * 0.85),
            height     = math.floor(vim.o.lines   * 0.85),
          },
          on_open = function(term)
            vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = term.bufnr })
          end,
        })
        python:toggle()
      end, desc = "Python REPL" },
    -- IPython
    { "<leader>ti", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local ipython  = Terminal:new({
          cmd          = "ipython",
          direction    = "vertical",
          display_name = "IPython",
          on_open = function(term)
            vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = term.bufnr })
          end,
        })
        ipython:toggle()
      end, desc = "IPython" },
    -- Lazygit
    { "<leader>tg", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit  = Terminal:new({
          cmd          = "lazygit",
          direction    = "float",
          display_name = "Lazygit",
          float_opts   = {
            border     = "curved",
            width      = math.floor(vim.o.columns * 0.95),
            height     = math.floor(vim.o.lines   * 0.95),
          },
          on_open = function(term)
            vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr })
          end,
          on_close  = function() end,
          hidden    = true,
        })
        lazygit:toggle()
      end, desc = "Lazygit" },
    -- Htop
    { "<leader>th", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local htop     = Terminal:new({
          cmd          = "htop",
          direction    = "float",
          display_name = "Htop",
          hidden       = true,
        })
        htop:toggle()
      end, desc = "Htop" },
    -- Run Python file
    { "<leader>tp", function()
        local file = vim.fn.expand("%:p")
        if vim.bo.filetype == "python" then
          local cmd = "python3 " .. file
          require("toggleterm").exec(cmd, 1, 12, nil, "horizontal")
        end
      end, desc = "Run Python File" },
    -- Run Python tests
    { "<leader>tT", function()
        local dir = vim.fn.expand("%:p:h")
        require("toggleterm").exec("cd " .. dir .. " && pytest -v --tb=short", 2, 12, nil, "horizontal")
      end, desc = "Run Pytest" },
  },

  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.25)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
      return 20
    end,
    open_mapping         = [[<C-\>]],
    on_create = function(t)
      vim.opt_local.foldcolumn   = "0"
      vim.opt_local.signcolumn   = "no"
    end,
    on_open = function(term)
      -- Remapping en mode terminal
      local opts = { buffer = term.bufnr, noremap = true }
      vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>",       opts)
      vim.keymap.set("t", "<C-h>",      "<C-\\><C-n><C-w>h", opts)
      vim.keymap.set("t", "<C-j>",      "<C-\\><C-n><C-w>j", opts)
      vim.keymap.set("t", "<C-k>",      "<C-\\><C-n><C-w>k", opts)
      vim.keymap.set("t", "<C-l>",      "<C-\\><C-n><C-w>l", opts)
    end,
    on_exit  = nil,
    on_close = nil,
    hide_numbers          = true,
    shade_filetypes       = {},
    autochdir             = true,
    highlights = {
      Normal         = { link = "Normal" },
      NormalFloat    = { link = "Normal" },
      FloatBorder = {
        guifg = "#7aa2f7",
        guibg = "#1a1b2e",
      },
    },
    shade_terminals       = true,
    shading_factor        = 2,
    start_in_insert       = true,
    insert_mappings       = true,
    terminal_mappings     = true,
    persist_size          = true,
    persist_mode          = true,
    direction             = "float",
    close_on_exit         = true,
    clear_env             = false,
    shell                 = vim.o.shell,
    auto_scroll           = true,
    float_opts = {
      border            = "curved",
      winblend          = 3,
      width             = function() return math.floor(vim.o.columns * 0.85) end,
      height            = function() return math.floor(vim.o.lines   * 0.85) end,
      title_pos         = "center",
    },
    winbar = {
      enabled           = true,
      name_formatter    = function(term)
        return term.name
      end,
    },
  },

  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Envoi de code Python vers le REPL
    vim.keymap.set("v", "<leader>ts", function()
      local lines = vim.api.nvim_buf_get_lines(0, vim.fn.line("'<") - 1, vim.fn.line("'>"), false)
      local code  = table.concat(lines, "\n")
      require("toggleterm").exec(code, 1)
    end, { desc = "Send Selection to Terminal" })
  end,
}