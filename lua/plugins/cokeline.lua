-- ~/.config/nvim/lua/plugins/cokeline.lua
return {
  "willothy/nvim-cokeline",
  event     = { "BufRead", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/aerial.nvim",
  },
  keys = {
    { "<Tab>",       "<Plug>(cokeline-focus-next)",  desc = "Buffer suivant" },
    { "<S-Tab>",     "<Plug>(cokeline-focus-prev)",  desc = "Buffer précédent" },
    { "<leader>bp",  "<Plug>(cokeline-pick-focus)",  desc = "Pick buffer" },
    { "<leader>bP",  "<Plug>(cokeline-pick-close)",  desc = "Pick & close buffer" },
    { "<leader>b1",  "<Plug>(cokeline-focus-1)",     desc = "Buffer 1" },
    { "<leader>b2",  "<Plug>(cokeline-focus-2)",     desc = "Buffer 2" },
    { "<leader>b3",  "<Plug>(cokeline-focus-3)",     desc = "Buffer 3" },
    { "<leader>b4",  "<Plug>(cokeline-focus-4)",     desc = "Buffer 4" },
    { "<leader>b5",  "<Plug>(cokeline-focus-5)",     desc = "Buffer 5" },
    { "<leader>bx",  function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd("bprev")
        vim.api.nvim_buf_delete(buf, { force = false })
      end, desc = "Fermer buffer" },
  },
  config = function()
    local get_hex = require("cokeline.hlgroups").get_hl_attr

    -- Couleurs dynamiques depuis le thème courant
    local bg_focused   = get_hex("Normal",    "bg") or "#1e1e2e"
    local bg_unfocused = get_hex("StatusLine", "bg") or "#181825"
    local fg_focused   = get_hex("Normal",    "fg") or "#cdd6f4"
    local fg_unfocused = get_hex("Comment",   "fg") or "#6c7086"
    local red          = get_hex("DiagnosticError", "fg") or "#f38ba8"
    local yellow       = get_hex("DiagnosticWarn",  "fg") or "#f9e2af"
    local blue         = get_hex("Function",        "fg") or "#89b4fa"

    require("cokeline").setup({
      show_if_buffers_are_at_least = 1,

      buffers = {
        filter_valid = function(buf)
          -- Exclut les buffers spéciaux
          return buf.type ~= "terminal"
              and buf.type ~= "nofile"
              and buf.filetype ~= "neo-tree"
              and buf.filetype ~= "aerial"
        end,
        filter_visible = function(buf)
          return buf.type ~= "terminal"
        end,
        focus_on_delete  = "next",
        new_buffers_position = "next",
        delete_on_right_click = false,
      },

      mappings = {
        cycle_prev_next = true,
        --disable_map     = false,
      },

      history = {
        enabled  = true,
        size     = 2,
      },

      rendering = {
        max_buffer_width = 30,
      },

      default_hl = {
        fg = function(buf)
          return buf.is_focused and fg_focused or fg_unfocused
        end,
        bg = function(buf)
          return buf.is_focused and bg_focused or bg_unfocused
        end,
        bold   = function(buf) return buf.is_focused end,
        italic = false,
      },

      -- ─── Composants ─────────────────────────────────────────────────────────
      components = {
        -- Espace gauche
        { text = " ", bg = bg_unfocused },

        -- Indicateur de focus (trait coloré à gauche)
        {
          text = "▌",
          fg = function(buf)
            if buf.is_focused then return blue
            elseif buf.diagnostics.errors > 0 then return red
            elseif buf.diagnostics.warnings > 0 then return yellow
            else return bg_unfocused
            end
          end,
          bg = function(buf)
            return buf.is_focused and bg_focused or bg_unfocused
          end,
        },

        -- Icône du type de fichier
        {
          text = function(buf)
            return buf.devicon.icon
          end,
          fg = function(buf)
            return buf.devicon.color
          end,
          bg = function(buf)
            return buf.is_focused and bg_focused or bg_unfocused
          end,
        },
        { text = " " },

        -- Numéro du buffer
        {
          text = function(buf) return buf.index .. ": " end,
          fg = function(buf)
            return buf.is_focused and blue or fg_unfocused
          end,
          bold = true,
        },

        -- Nom du fichier
        {
          text = function(buf)
            return buf.unique_prefix .. buf.filename
          end,
          fg = function(buf)
            if buf.diagnostics.errors > 0 then return red end
            return buf.is_focused and fg_focused or fg_unfocused
          end,
          bold   = function(buf) return buf.is_focused end,
          italic = function(buf) return not buf.is_loaded end,
          underline = function(buf)
            return buf.is_hovered and not buf.is_focused
          end,
        },

        -- Indicateur de modification
        {
          text = function(buf)
            return buf.is_modified and " ●" or "  "
          end,
          fg = function(buf)
            return buf.is_modified and yellow or fg_unfocused
          end,
        },

        -- Diagnostics
        {
          text = function(buf)
            if buf.diagnostics.errors > 0 then
              return " 󰅚 " .. buf.diagnostics.errors
            elseif buf.diagnostics.warnings > 0 then
              return " 󰀪 " .. buf.diagnostics.warnings
            end
            return ""
          end,
          fg = function(buf)
            if buf.diagnostics.errors > 0 then return red end
            return yellow
          end,
        },

        -- Bouton de fermeture
        {
          text = " 󰅖",
          fg = function(buf)
            return buf.is_hovered and red or fg_unfocused
          end,
          bg = function(buf)
            return buf.is_focused and bg_focused or bg_unfocused
          end,
          on_click = function(_, _, _, _, buf)
            buf:delete()
          end,
        },

        -- Espace droit + trait
        { text = " ▐",
          fg = function(buf)
            return buf.is_focused and blue or bg_unfocused
          end,
          bg = bg_unfocused,
        },
        { text = " ", bg = bg_unfocused },
      },

      -- ─── Sidebar (intégration Neo-tree) ─────────────────────────────────────
      sidebar = {
        filetype = { "neo-tree", "NvimTree", "aerial" },
        components = {
          {
            text = function(buf)
              return buf.filetype == "aerial" and "  Outline" or "  Explorer"
            end,
            fg   = blue,
            bg   = get_hex("NeoTreeNormal", "bg") or bg_unfocused,
            bold = true,
          },
        },
      },
    })
  end,
}