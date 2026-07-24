-- ~/.config/nvim/lua/plugins/ufo.lua
-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  nvim-ufo — Folding avancé (nécessaire pour zR/zM/zm/zr/K keymaps)     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
return {
  "kevinhwang91/nvim-ufo",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- Utilise LSP en priorité, Treesitter en fallback, puis indent
    provider_selector = function(_, filetype, _)
      local ft_map = {
        python     = { "treesitter", "indent" },
        lua        = { "treesitter", "indent" },
        javascript = { "treesitter", "indent" },
        typescript = { "treesitter", "indent" },
        json       = { "treesitter", "indent" },
        yaml       = { "indent" },
        toml       = { "treesitter", "indent" },
        markdown   = { "treesitter" },
      }
      return ft_map[filetype] or { "lsp", "indent" }
    end,

    -- Prévisualisation d'un fold fermé avec K (quand le curseur est sur un fold)
    preview = {
      win_config = {
        border      = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        winblend    = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },

    -- Affiche le nombre de lignes cachées dans un fold fermé
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" 󰁂 %d lignes "):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end,
  },
}
