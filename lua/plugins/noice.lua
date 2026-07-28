-- ~/.config/nvim/lua/plugins/noice.lua
return {
  "folke/noice.nvim",
  event        = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<leader>nl",  function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
    { "<leader>nh",  function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>na",  function() require("noice").cmd("all") end,     desc = "Noice All" },
    { "<leader>nd",  function() require("noice").cmd("dismiss") end, desc = "Noice Dismiss" },
    { "<leader>nt",  function() require("noice").cmd("pick") end,    desc = "Noice Telescope Pick" },
    -- Scroll la doc dans les popups
    { "<C-f>",       function()
        if not require("noice.lsp").scroll(4) then return "<C-f>" end
      end, silent = true, expr = true, desc = "Scroll Forward", mode = { "i", "n", "s" } },
    { "<C-b>",       function()
        if not require("noice.lsp").scroll(-4) then return "<C-b>" end
      end, silent = true, expr = true, desc = "Scroll Backward", mode = { "i", "n", "s" } },
  },
  opts = {
    cmdline = {
      enabled     = true,
      view        = "cmdline_popup",
      opts        = {},
      format = {
        cmdline      = { pattern = "^:", icon = "", lang = "vim" },
        search_down  = { kind = "search", pattern = "^/",  icon = " ", lang = "regex" },
        search_up    = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter       = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua          = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help         = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
        input        = { view = "cmdline_input", icon = "󰥻 " },
      },
    },

    messages = {
      enabled          = true,
      view             = "notify",
      view_error       = "notify",
      view_warn        = "notify",
      view_history     = "messages",
      view_search      = "virtualtext",
    },

    popupmenu = {
      enabled  = true,
      backend  = "nui",
      kind_icons = {},
    },

    redirect = {
      view  = "popup",
      filter = { event = "msg_show" },
    },

    commands = {
      history = {
        view    = "split",
        opts    = { enter = true, format = "details" },
        filter  = {
          any = {
            { event = "notify" },
            { error = true },
            { warning = true },
            { event = "msg_show", kind = { "" } },
            { event = "lsp",      kind = "message" },
          },
        },
      },
      last = {
        view   = "popup",
        opts   = { enter = true, format = "details" },
        filter = {
          any = {
            { event = "notify" },
            { error = true },
            { warning = true },
            { event = "msg_show", kind = { "" } },
            { event = "lsp",      kind = "message" },
          },
        },
        filter_opts = { count = 1 },
      },
      errors = {
        view   = "popup",
        opts   = { enter = true, format = "details" },
        filter = { error = true },
        filter_opts = { reverse = true },
      },
      all = {
        view   = "split",
        opts   = { enter = true, format = "details" },
        filter = {},
      },
    },

    notify = {
      enabled  = true,
      view     = "notify",
    },

    lsp = {
      progress = {
        enabled       = true,
        format        = "lsp_progress",
        format_done   = "lsp_progress_done",
        throttle      = 1000 / 30,
        view          = "mini",
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"]                = true,
        ["cmp.entry.get_documentation"]                  = true,
      },
      hover = {
        enabled = true,
        silent  = false,
        view    = nil,
        opts    = {},
      },
      signature = {
        enabled  = true,
        auto_open = {
          enabled   = true,
          trigger   = true,
          luasnip   = true,
          throttle  = 50,
        },
        view     = nil,
        opts     = {},
      },
      message = {
        enabled = true,
        view    = "notify",
        opts    = {},
      },
      documentation = {
        view = "hover",
        opts = {
          lang        = "markdown",
          replace     = true,
          render      = "plain",
          format      = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },

    markdown = {
      hover = {
        ["|(%S-)|"] = vim.cmd.help,
        ["%[.-%]%((%S-)%)"] = require("noice.util").open,
        -- ["%[.-%]%((%S-)%)"] = function(...) return require("noice.util").open(...) end,
      },
      highlights = {
        ["|%S-|"]             = "@text.reference",
        ["@%S+"]              = "@parameter",
        ["^%s*(Parameters:)"] = "@text.title",
        ["^%s*(Return:)"]     = "@text.title",
        ["^%s*(See also:)"]   = "@text.title",
        ["{%S-}"]             = "@parameter",
      },
    },

    health = {
      checker = true,
    },

    presets = {
      bottom_search         = false,  -- ← FALSE pour garder la search en popup
      command_palette       = true,
      long_message_to_split = true,
      inc_rename            = true,
      lsp_doc_border        = true,
    },


    throttle    = 1000 / 30,

      views = {
      cmdline_popup = {
        position = {
          row = "50%",   -- ← centre vertical
          col = "50%",   -- ← centre horizontal
        },
        size = {
          width  = 60,
          height = "auto",
        },
        border = {
          style   = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal      = "NormalFloat",
            FloatBorder = "FloatBorder",
          },
        },
      },
      mini = {
        win_options = { winblend = 0 },
      },
    },

    routes = {
      -- Cache les messages "written"
      { filter = { event = "msg_show", kind = "", find = "written" },           opts = { skip = true } },
      -- Cache les messages "lines"
      { filter = { event = "msg_show", find = "%d+L, %d+B" },                  opts = { skip = true } },
      -- Cache "search hit BOTTOM"
      { filter = { event = "msg_show", kind = "search_count" },                 opts = { skip = true } },
      -- Redirige les messages longs dans split
      { filter = { event = "msg_show", min_height = 20 },                       view = "split" },
      -- Les erreurs LSP importantes en notify
      { filter = { event = "lsp", kind = "message", find = "ERROR" },           view = "notify" },
    },

    status = {},
    format = {},
  },
}
