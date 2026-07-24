-- ~/.config/nvim/lua/plugins/persistence.lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    {
      "<leader>Ss",
      function() require("persistence").load() end,
      desc = "Restore Session (cwd)",
    },
    {
      "<leader>Sl",
      function() require("persistence").load({ last = true }) end,
      desc = "Restore Last Session",
    },
    {
      "<leader>Sd",
      function() require("persistence").stop() end,
      desc = "Don't Save Session",
    },
    {
      "<leader>SS",
      function() require("persistence").save() end,
      desc = "Save Session",
    },
    {
      "<leader>Sp",
      function()
        -- Picker Telescope pour les sessions
        local sessions = require("persistence").list()
        if #sessions == 0 then
          vim.notify("Aucune session sauvegardée", vim.log.levels.WARN, { title = "Persistence" })
          return
        end
        vim.ui.select(sessions, {
          prompt    = "Choisir une session:",
          format_item = function(s) return s end,
        }, function(choice)
          if choice then
            require("persistence").load({ session = choice })
          end
        end)
      end,
      desc = "Pick Session",
    },
  },
  opts = {
    dir      = vim.fn.stdpath("state") .. "/sessions/",
    options  = {
      "buffers",
      "curdir",
      "tabpages",
      "winsize",
      "help",
      "globals",
      "skiprtp",
    },
    pre_save = function()
      -- Ferme Neo-tree avant de sauvegarder (évite les conflits)
      pcall(vim.cmd, "Neotree close")
      pcall(vim.cmd, "AerialClose")
      -- Ferme les terminaux
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end,
    save_empty = false,  -- Ne sauvegarde pas les sessions vides
  },

  config = function(_, opts)
    require("persistence").setup(opts)

    -- ─── Sauvegarde automatique à la fermeture ────────────────────────────
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        -- Ne sauvegarde que si on est dans un projet git
        local git_dir = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
        if git_dir ~= "" then
          require("persistence").save()
          vim.notify(
            "Session sauvegardée : " .. vim.fn.getcwd(),
            vim.log.levels.INFO,
            { title = "Persistence", timeout = 1000 }
          )
        end
      end,
    })

    -- ─── Restaure automatiquement si lancé sans arguments ─────────────────
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Restaure seulement si aucun fichier n'est passé en argument
        if vim.fn.argc(-1) == 0 then
          require("persistence").load()
        end
      end,
      nested = true,
    })
  end,
}