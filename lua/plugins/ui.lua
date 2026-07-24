return {
  {
    "NvChad/nvim-colorizer.lua", -- REPERE : Correction de la casse ici (NvChad)
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_opts = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts.filetypes, opts.user_opts)
    end,
  },
}
