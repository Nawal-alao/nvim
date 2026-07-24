-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    -- ─── Palette Catppuccin Mocha ──────────────────────────────────────────
    local c = {
      bg = "#1e1e2e",
      bg2 = "#181825",
      surface0 = "#313244",
      surface1 = "#45475a",
      fg = "#cdd6f4",
      subtext = "#a6adc8",
      overlay = "#6c7086",
      blue = "#89b4fa",
      green = "#a6e3a1",
      teal = "#94e2d5",
      violet = "#cba6f7",
      orange = "#fab387",
      red = "#f38ba8",
      yellow = "#f9e2af",
      pink = "#f5c2e7",
      sky = "#89dceb",
    }

    -- ─── Mode : couleur + label ────────────────────────────────────────────
    local mode_colors = {
      n = c.blue,
      i = c.green,
      v = c.violet,
      V = c.violet,
      c = c.orange,
      R = c.red,
      s = c.orange,
      S = c.orange,
      t = c.red,
      [""] = c.violet,
    }
    local mode_labels = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "V-LINE",
      c = "COMMAND",
      R = "REPLACE",
      s = "SELECT",
      S = "S-LINE",
      t = "TERMINAL",
      [""] = "V-BLOCK",
    }

    -- ─── Composant : Mode ─────────────────────────────────────────────────
    local mode = {
      function()
        return mode_labels[vim.fn.mode()] or vim.fn.mode()
      end,
      color = function()
        return { fg = c.bg, bg = mode_colors[vim.fn.mode()] or c.blue, gui = "bold" }
      end,
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Branch ───────────────────────────────────────────────
    local branch = {
      "branch",
      icon = "󰊢",
      color = { fg = c.violet, bg = c.surface0, gui = "bold" },
      padding = { left = 2, right = 2 },
    }

    -- ─── Composant : Diff git ─────────────────────────────────────────────
    local diff = {
      "diff",
      symbols = { added = "+", modified = "~", removed = "-" },
      diff_color = {
        added = { fg = c.green, bg = c.bg },
        modified = { fg = c.orange, bg = c.bg },
        removed = { fg = c.red, bg = c.bg },
      },
      padding = { left = 1, right = 0 },
      cond = function()
        return vim.fn.winwidth(0) > 70
      end,
    }

    -- ─── Composant : Filename intelligent ────────────────────────────────
    local filename = {
      function()
        local name = vim.fn.expand("%:t")
        if name == "" then
          return "[sans nom]"
        end
        local modified = vim.bo.modified and " [+]" or ""
        local readonly = vim.bo.readonly and " [-]" or ""
        return name .. modified .. readonly
      end,
      color = function()
        if vim.bo.modified then
          return { fg = c.yellow, bg = c.bg, gui = "bold" }
        end
        return { fg = c.fg, bg = c.bg }
      end,
      padding = { left = 2, right = 1 },
    }

    -- ─── Composant : Chemin relatif (discret) ─────────────────────────────
    local filepath = {
      function()
        local path = vim.fn.expand("%:.:h")
        if path == "" or path == "." then
          return ""
        end
        if #path > 30 then
          path = "..." .. path:sub(-27)
        end
        return path .. "/"
      end,
      color = { fg = c.overlay, bg = c.bg },
      padding = { left = 2, right = 0 },
      cond = function()
        return vim.fn.winwidth(0) > 100
      end,
    }

    -- ─── Composant : Diagnostics ──────────────────────────────────────────
    local diagnostics = {
      "diagnostics",
      sources = { "nvim_lsp", "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = {
        Error = "󰅚 ",
        Warn = "󰀪 ",
        Info = "󰋽 ",
        Hint = "󰌶 ",
      },
      diagnostics_color = {
        error = { fg = c.red, bg = c.bg },
        warn = { fg = c.yellow, bg = c.bg },
        info = { fg = c.sky, bg = c.bg },
        hint = { fg = c.teal, bg = c.bg },
      },
      colored = true,
      update_in_insert = false,
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Sélection visuelle ───────────────────────────────────
    local selection = {
      function()
        local mode = vim.fn.mode()
        if mode == "v" or mode == "V" or mode == "" then
          local start = vim.fn.line("v")
          local stop = vim.fn.line(".")
          local lines = math.abs(stop - start) + 1
          if lines > 1 then
            return lines .. " lignes"
          end
          -- Nombre de caractères sélectionnés
          local chars = vim.fn.wordcount().visual_chars
          if chars then
            return chars .. " chars"
          end
        end
        return ""
      end,
      color = { fg = c.violet, bg = c.bg, gui = "italic" },
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Python Venv ──────────────────────────────────────────
    local python_venv = {
      function()
        if vim.bo.filetype ~= "python" then
          return ""
        end
        local name
        local ok, vs = pcall(require, "venv-selector")
        if ok and vs.venv then
          local venv_path = vs.venv()
          if venv_path and venv_path ~= "" then
            name = vim.fn.fnamemodify(venv_path, ":t")
          end
        end
        if not name then
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            name = vim.fn.fnamemodify(venv, ":t")
          end
        end
        if not name then
          local conda = os.getenv("CONDA_DEFAULT_ENV")
          if conda and conda ~= "base" then
            name = "C " .. conda
          end
        end
        if name then
          return " " .. name
        end
        return " no venv"
      end,
      color = function()
        if vim.bo.filetype ~= "python" then
          return { fg = c.surface0, bg = c.surface0 }
        end
        local has_venv = false
        local ok, vs = pcall(require, "venv-selector")
        if ok and vs.venv and vs.venv() ~= "" then
          has_venv = true
        elseif os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV") then
          has_venv = true
        end
        return {
          fg = has_venv and c.teal or c.red,
          bg = c.surface0,
          gui = "bold",
        }
      end,
      padding = { left = 2, right = 1 },
    }

    -- ─── Composant : LSP actifs ───────────────────────────────────────────
    local lsp_clients = {
      function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return "no lsp"
        end
        local names = {}
        for _, client in ipairs(clients) do
          -- Exclut null-ls du display
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            table.insert(names, client.name)
          end
        end
        if #names == 0 then
          return ""
        end
        return table.concat(names, " ")
      end,
      color = { fg = c.green, bg = c.surface0 },
      padding = { left = 1, right = 2 },
      cond = function()
        return vim.fn.winwidth(0) > 80
      end,
    }

    -- ─── Composant : Encoding + Format ───────────────────────────────────
    local fileinfo = {
      function()
        local enc = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding):upper()
        local fmt = vim.bo.fileformat == "unix" and "LF"
          or vim.bo.fileformat == "dos" and "CRLF"
          or "CR"
        return enc .. "  " .. fmt
      end,
      color = { fg = c.blue, bg = c.surface0 },
      padding = { left = 1, right = 1 },
      cond = function()
        return vim.fn.winwidth(0) > 80
      end,
    }

    -- ─── Composant : Filetype avec icône ─────────────────────────────────
    local filetype = {
      "filetype",
      icons_enabled = true,
      colored = false,
      color = { fg = c.blue, bg = c.surface0 },
      padding = { left = 0, right = 2 },
    }

    -- ─── Composant : Position (ligne:col + %) ────────────────────────────
    local location = {
      function()
        local line = vim.fn.line(".")
        local col = vim.fn.virtcol(".")
        local total = vim.fn.line("$")
        local pct = math.floor(line / total * 100)
        return string.format("%d:%d  %d%%%%", line, col, pct)
      end,
      color = { fg = c.subtext, bg = c.bg },
      padding = { left = 2, right = 1 },
    }

    -- ─── Composant : Horloge ─────────────────────────────────────────────
    local clock = {
      function()
        return " " .. os.date("%H:%M")
      end,
      color = function()
        return { fg = c.bg, bg = mode_colors[vim.fn.mode()] or c.blue, gui = "bold" }
      end,
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Lazy updates disponibles ────────────────────────────
    local lazy_updates = {
      function()
        local ok, lazy = pcall(require, "lazy.status")
        if ok and lazy.has_updates() then
          return " " .. lazy.updates()
        end
        return ""
      end,
      color = { fg = c.orange, bg = c.surface0 },
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Macro en cours ───────────────────────────────────────
    local macro_recording = {
      function()
        local reg = vim.fn.reg_recording()
        if reg ~= "" then
          return " @" .. reg
        end
        return ""
      end,
      color = { fg = c.red, bg = c.bg, gui = "bold" },
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Search count ─────────────────────────────────────────
    local search_count = {
      function()
        if vim.v.hlsearch == 0 then
          return ""
        end
        local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
        if not ok or next(result) == nil then
          return ""
        end
        if result.incomplete == 1 then
          return "?/?"
        end
        local too_many = result.total > result.maxcount
        return string.format(
          "%s%d/%d",
          too_many and ">" or "",
          result.current,
          too_many and result.maxcount or result.total
        )
      end,
      color = { fg = c.yellow, bg = c.bg, gui = "bold" },
      padding = { left = 1, right = 1 },
    }

    -- ─── Composants Assistants IA ──────────────────────────────────────────

    -- Composant : CodeCompanion Statut
    local codecompanion_status = {
      function()
        local ok, cc = pcall(require, "codecompanion")
        if not ok then
          return ""
        end
        if cc.status then
          local status = cc.status()
          if status and status ~= "" then
            return "󰚩 " .. status
          end
        end
        return "󰚩 AI"
      end,
      color = function()
        local ok, cc = pcall(require, "codecompanion")
        if ok and cc.status then
          local status = cc.status()
          if status and status ~= "" and status ~= "idle" then
            return { fg = c.yellow, bg = c.surface0, gui = "bold" }
          end
        end
        return { fg = c.violet, bg = c.surface0 }
      end,
      padding = { left = 1, right = 1 },
    }

    -- Composant : Codeium Statut
    local codeium_status = {
      function()
        if vim.fn.exists("*codeium#GetStatusString") == 1 then
          local status = vim.fn["codeium#GetStatusString"]()
          status = status:gsub("^%s*", "")
          if status == "" then
            return "󰘦 Codeium"
          end
          return "󰘦 " .. status
        end
        return "󰘦 Codeium"
      end,
      color = function()
        if vim.fn.exists("*codeium#GetStatusString") == 1 then
          local status = vim.fn["codeium#GetStatusString"]():gsub("^%s*", "")
          if status == "OFF" or status == "0" then
            return { fg = c.overlay, bg = c.surface0 }
          end
          return { fg = c.green, bg = c.surface0 }
        end
        return { fg = c.overlay, bg = c.surface0 }
      end,
      padding = { left = 1, right = 1 },
    }

    -- ─── Composant : Indent info ──────────────────────────────────────────
    local indent_info = {
      function()
        if vim.bo.expandtab then
          return "spaces:" .. vim.bo.shiftwidth
        else
          return "tabs:" .. vim.bo.tabstop
        end
      end,
      color = { fg = c.overlay, bg = c.surface0 },
      padding = { left = 1, right = 1 },
      cond = function()
        return vim.fn.winwidth(0) > 100
      end,
    }

    -- ─── Setup principal ──────────────────────────────────────────────────
    lualine.setup({
      options = {
        theme = {
          normal = {
            a = { fg = c.bg, bg = c.blue, gui = "bold" },
            b = { fg = c.violet, bg = c.surface0 },
            c = { fg = c.fg, bg = c.bg },
          },
          insert = {
            a = { fg = c.bg, bg = c.green, gui = "bold" },
            b = { fg = c.green, bg = c.surface0 },
            c = { fg = c.fg, bg = c.bg },
          },
          visual = {
            a = { fg = c.bg, bg = c.violet, gui = "bold" },
            b = { fg = c.violet, bg = c.surface0 },
            c = { fg = c.fg, bg = c.bg },
          },
          replace = {
            a = { fg = c.bg, bg = c.red, gui = "bold" },
            b = { fg = c.red, bg = c.surface0 },
            c = { fg = c.fg, bg = c.bg },
          },
          command = {
            a = { fg = c.bg, bg = c.orange, gui = "bold" },
            b = { fg = c.orange, bg = c.surface0 },
            c = { fg = c.fg, bg = c.bg },
          },
          terminal = {
            a = { fg = c.bg, bg = c.red, gui = "bold" },
            b = { fg = c.red, bg = c.surface0 },
            c = { fg = c.fg, bg = c.bg },
          },
          inactive = {
            a = { fg = c.overlay, bg = c.bg2 },
            b = { fg = c.overlay, bg = c.bg2 },
            c = { fg = c.overlay, bg = c.bg2 },
          },
        },
        -- Séparateurs inchangés
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "alpha", "dashboard", "lazy", "mason", "neo-tree" },
          winbar = {},
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 100,
          tabline = 100,
        },
      },

      sections = {
        lualine_a = { mode },

        lualine_b = { branch, diff },

        lualine_c = {
          filepath,
          filename,
          diagnostics,
          macro_recording,
          search_count,
          selection,
        },

        lualine_x = {
          codecompanion_status,
          codeium_status,
          lazy_updates,
          python_venv,
          lsp_clients,
          indent_info,
          fileinfo,
          filetype,
        },

        lualine_y = { location },

        lualine_z = { clock },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1,
            color = { fg = c.overlay, bg = c.bg2 },
            symbols = { modified = " [+]", readonly = " [-]" },
          },
        },
        lualine_x = {
          { "location", color = { fg = c.overlay, bg = c.bg2 } },
        },
        lualine_y = {},
        lualine_z = {},
      },

      winbar = {},
      inactive_winbar = {},

      extensions = {
        "aerial",
        "lazy",
        "mason",
        "neo-tree",
        "quickfix",
        "toggleterm",
        "trouble",
      },
    })

    -- ─── Force refresh sur les events importants ──────────────────────────
    vim.api.nvim_create_autocmd({
      "RecordingEnter",
      "RecordingLeave",
      "LspAttach",
      "LspDetach",
      "VimEnter",
    }, {
      callback = function()
        -- Rafraîchit la statusline
        pcall(lualine.refresh)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
      callback = function()
        pcall(lualine.refresh)
      end,
    })
  end,
}
