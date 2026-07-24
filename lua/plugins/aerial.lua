-- ~/.config/nvim/lua/plugins/aerial.lua
return {
  "stevearc/aerial.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>cs", "<cmd>AerialToggle!<CR>",  desc = "Aerial Symbol Outline" },
    { "<leader>cn", "<cmd>AerialNavToggle<CR>", desc = "Aerial Nav Float" },
    { "{",          "<cmd>AerialPrev<CR>",       desc = "Aerial Prev Symbol" },
    { "}",          "<cmd>AerialNext<CR>",       desc = "Aerial Next Symbol" },
  },
  opts = {
    backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },

    layout = {
      max_width       = { 40, 0.2 },
      width           = nil,
      min_width       = 20,
      win_opts        = {},
      default_direction = "prefer_right",
      placement       = "window",
      resize_to_content = true,
      preserve_equality = false,
    },

    attach_mode   = "window",
    close_automatic_events = { "unsupported" },

    -- Keymaps inside the aerial window
    keymaps = {
      ["?"]         = "actions.show_help",
      ["g?"]        = "actions.show_help",
      ["<CR>"]      = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"]     = "actions.jump_vsplit",
      ["<C-s>"]     = "actions.jump_split",
      ["p"]         = "actions.scroll",
      ["<C-j>"]     = "actions.down_and_scroll",
      ["<C-k>"]     = "actions.up_and_scroll",
      ["{"]         = "actions.prev",
      ["}"]         = "actions.next",
      ["[["]        = "actions.prev_up",
      ["]]"]        = "actions.next_up",
      ["q"]         = "actions.close",
      ["o"]         = "actions.tree_toggle",
      ["za"]        = "actions.tree_toggle",
      ["O"]         = "actions.tree_toggle_recursive",
      ["zA"]        = "actions.tree_toggle_recursive",
      ["l"]         = "actions.tree_open",
      ["zo"]        = "actions.tree_open",
      ["L"]         = "actions.tree_open_recursive",
      ["zO"]        = "actions.tree_open_recursive",
      ["h"]         = "actions.tree_close",
      ["zc"]        = "actions.tree_close",
      ["H"]         = "actions.tree_close_recursive",
      ["zC"]        = "actions.tree_close_recursive",
      ["zr"]        = "actions.tree_increase_fold_level",
      ["zR"]        = "actions.tree_open_all",
      ["zm"]        = "actions.tree_decrease_fold_level",
      ["zM"]        = "actions.tree_close_all",
      ["zx"]        = "actions.tree_sync_folds",
      ["zX"]        = "actions.tree_sync_folds",
    },

    -- Show Python-specific symbols
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
      "Variable",
    },

    icons = {
      Array         = "󰅪 ",
      Boolean       = "⊨ ",
      Class         = "󰌗 ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Enum          = "󰕘 ",
      EnumMember    = " ",
      Event         = " ",
      Field         = "󰜢 ",
      File          = "󰈙 ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = "󰌋 ",
      Method        = "󰆧 ",
      Module        = " ",
      Namespace     = " ",
      Null          = "NULL",
      Number        = "󰎠 ",
      Object        = "󰅩 ",
      Operator      = "󰆕 ",
      Package       = " ",
      Property      = "󰖷 ",
      String        = "󰉿 ",
      Struct        = "󰌗 ",
      TypeParameter = "󰊄 ",
      Variable      = "󰀫 ",
    },

    show_guides = true,
    guides = {
      mid_item   = "├─ ",
      last_item  = "└─ ",
      nested_top = "│  ",
      whitespace = "   ",
    },

    float = {
      border   = "rounded",
      relative = "cursor",
      max_height = 0.5,
      height   = nil,
      min_height = { 8, 0.1 },
      override = function(conf, source_winid)
        conf.anchor = "NW"
        return conf
      end,
    },

    nav = {
      border         = "rounded",
      max_height     = 0.9,
      min_height     = { 10, 0.1 },
      max_width      = 0.45,
      min_width      = { 0.2, 20 },
      win_opts       = { cursorline = true, winblend = 10 },
      autojump       = false,
      preview        = false,
      keymaps        = {
        ["<CR>"]  = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["h"]     = "actions.left",
        ["l"]     = "actions.right",
        ["<C-c>"] = "actions.close",
      },
    },

    highlight_mode          = "split_width",
    highlight_closest       = true,
    highlight_on_hover      = true,
    highlight_on_jump       = 300,
    autojump                = false,
    open_automatic          = false,
    on_attach = function(bufnr)
      -- Jump between symbols with Tab/S-Tab inside aerial
      vim.keymap.set("n", "<Tab>",   "<cmd>AerialNext<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<S-Tab>", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    end,
  },
}