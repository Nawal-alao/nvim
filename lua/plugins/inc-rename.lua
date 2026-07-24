return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  opts = {},
  config = function(_, opts)
    require("inc-rename").setup(opts)
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Renommer la variable" })
  end,
}