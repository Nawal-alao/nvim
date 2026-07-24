-- ~/.config/nvim/lua/plugins/trouble.lua
return {
  "folke/trouble.nvim",
  cmd          = { "Trouble", "TroubleToggle" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>xx",  "<cmd>Trouble diagnostics toggle<CR>",                            desc = "Diagnostics (Trouble)" },
    { "<leader>xX",  "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",               desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>cs",  "<cmd>Trouble symbols toggle focus=false<CR>",                    desc = "Symbols (Trouble)" },
    { "<leader>cl",  "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",     desc = "LSP Definitions (Trouble)" },
    { "<leader>xL",  "<cmd>Trouble loclist toggle<CR>",                                desc = "Location List (Trouble)" },
    { "<leader>xQ",  "<cmd>Trouble qflist toggle<CR>",                                 desc = "Quickfix (Trouble)" },
    { "<leader>xt",  "<cmd>Trouble todo toggle focus=false filter = {tag = {TODO,FIX,FIXME}}<CR>", desc = "TODOs (Trouble)" },
    -- Navigation dans les items Trouble
    {
      "[t", function()
        local trouble = require("trouble")
        if trouble.is_open() then
          trouble.prev({ skip_groups = true, jump = true })
        else
          vim.cmd("cprev")
        end
      end, desc = "Previous Trouble/Quickfix" },
    {
      "]t", function()
        local trouble = require("trouble")
        if trouble.is_open() then
          trouble.next({ skip_groups = true, jump = true })
        else
          vim.cmd("cnext")
        end
      end, desc = "Next Trouble/Quickfix" },
  },
  opts = {
    auto_close      = false,
    auto_fold       = false,
    auto_jump       = false,
    auto_open       = false,
    auto_preview    = true,
    auto_refresh    = true,
    auto_scroll     = { enabled = true, new_item = false },

    focus           = false,

    -- Filtres
    filter          = { buf = 0 },
    follow          = true,
    indent_guides   = true,

    -- Mode par défaut
    modes = {
      diagnostics = {
        mode  = "diagnostics",
        auto_open  = false,
        auto_close = false,
        preview    = {
          type     = "split",
          relative = "win",
          position = "right",
          size     = 0.3,
        },
        groups   = {
          { "filename", format = "{file_icon} {basename:Title} {count}" },
        },
        filter   = { severity = vim.diagnostic.severity.WARN },
      },
      symbols = {
        desc   = "document symbols",
        mode   = "lsp_document_symbols",
        focus  = false,
        win    = { position = "right" },
        filter = {
          ["not"] = { ft = "lua", kind = "Package" },
          any = {
            ft = { "go", "lua", "python", "typescript" },
            kind = {
              "Class",
              "Constructor",
              "Enum",
              "Field",
              "Function",
              "Interface",
              "Method",
              "Module",
              "Namespace",
              "Package",
              "Property",
              "Struct",
              "Trait",
            },
          },
        },
      },
      lsp = {
        mode  = "lsp",
        win   = { size = 0.3 },
      },
    },

    -- Icônes
    icons = {
      indent = {
        fold_open  = " ",
        fold_closed = " ",
        middle     = "│ ",
        last       = "└╴",
        top        = "│ ",
        ws         = "  ",
      },
      folder_closed = " ",
      folder_open   = " ",
      kinds = {
        Array     = " ",
        Boolean   = "󰨙 ",
        Class     = " ",
        Constant  = "󰏿 ",
        Constructor = " ",
        Enum      = " ",
        EnumMember = " ",
        Event     = " ",
        Field     = " ",
        File      = " ",
        Function  = "󰊕 ",
        Interface = " ",
        Key       = " ",
        Method    = "󰆧 ",
        Module    = " ",
        Namespace = "󰦮 ",
        Null      = " ",
        Number    = "󰎠 ",
        Object    = " ",
        Operator  = " ",
        Package   = " ",
        Property  = " ",
        String    = " ",
        Struct    = "󰆼 ",
        TypeParameter = " ",
        Variable  = "󰀫 ",
      },
    },

    -- Apparence
    win = {
      border   = "rounded",
      padding  = true,
    },
    multiline     = true,
    max_items     = 200,
    throttle      = { refresh = 20, render = 10, follow = 100, preview = { ms = 100, debounce = true } },
    keys = {
      ["?"]          = "help",
      r              = "refresh",
      R              = "toggle_refresh",
      q              = "close",
      o              = "jump_close",
      ["<esc>"]      = "cancel",
      ["<cr>"]       = "jump",
      ["<2-leftmouse>"] = "jump",
      ["<c-s>"]      = "jump_split",
      ["<c-v>"]      = "jump_vsplit",
      ["}"          ] = "next",
      ["{"          ] = "prev",
      dd             = "delete",
      d              = { action = "delete", mode = "v" },
      i              = "inspect",
      p              = "preview",
      P              = "toggle_auto_preview",
      zo             = "fold_open",
      zO             = "fold_open_recursive",
      zc             = "fold_close",
      zC             = "fold_close_recursive",
      za             = "fold_toggle",
      zA             = "fold_toggle_recursive",
      zm             = "fold_close_all",
      zM             = "fold_close_all",
      zr             = "fold_open_all",
      zR             = "fold_open_all",
      zx             = "fold_update_all",
      ["tab"]        = "fold_toggle",
      ["<s-tab>"]    = "fold_toggle_recursive",
      ["g?"]         = "help",
      s              = "toggle_auto_scroll",
      gb             = "toggle_background",
      K              = "hover",
      gK             = "hover",
    },
  },

  config = function(_, opts)
    require("trouble").setup(opts)

    -- ─── Todo Comments intégration ────────────────────────────────────────
    -- (nécessite folke/todo-comments.nvim)
    local ok, todo = pcall(require, "todo-comments")
    if not ok then
      require("lazy").load({ plugins = { "todo-comments.nvim" } })
    end
  end,
}