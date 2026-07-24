-- ~/.config/nvim/lua/plugins/venv-selector.lua
return {
  "linux-cultist/venv-selector.nvim",
  -- branch = "regexp",  -- supprime : fusionne dans main
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap-python",
  },
  ft = "python",
  event = { "BufReadPre *.py", "BufNewFile *.py" },
  cmd = { "VenvSelect" },
  keys = {
    { "<leader>pv", "<cmd>VenvSelect<CR>", desc = "Select Python Venv" },
  },
  opts = {
    options = {
      -- ─── Notifications ─────────────────────────────────────────────────
      notify_user_on_venv_activation = true,

      -- ─── Recherches par defaut (venv, .venv, poetry, pyenv, etc.) ───────
      -- Remplace l'ancien `name = {...}` : les recherches integrees
      -- couvrent deja venv/.venv/poetry/pipenv/conda/pyenv/hatch/pipx.
      enable_default_searches = true,

      -- ─── Cache du venv par projet ────────────────────────────────────────
      enable_cached_venvs = true,
      cached_venv_automatic_activation = true,

      -- ─── Debug si besoin (mettre "DEBUG" ou "TRACE" puis :VenvSelectLog) ─
      log_level = "NONE",

      -- ─── Hook d'activation ───────────────────────────────────────────────
      -- Remplace l'ancien `changed_venv_hooks = { fn(venv_path, venv_python) }`
      on_venv_activate_callback = function()
        local vs = require("venv-selector")
        local venv_python = vs.python()
        local venv_path = vs.venv()

        if not venv_python or venv_python == "" then
          return
        end

        -- Met a jour basedpyright
        local clients = vim.lsp.get_clients({ name = "basedpyright" })
        for _, client in ipairs(clients) do
          client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
            python = {
              pythonPath = venv_python,
              venvPath = vim.fn.fnamemodify(venv_path, ":h"),
              venv = vim.fn.fnamemodify(venv_path, ":t"),
            },
          })
          client.notify("workspace/didChangeConfiguration", {
            settings = client.config.settings,
          })
        end

        -- Met a jour ruff
        local ruff_clients = vim.lsp.get_clients({ name = "ruff" })
        for _, client in ipairs(ruff_clients) do
          client.config.init_options = vim.tbl_deep_extend(
            "force",
            client.config.init_options or {},
            { settings = { interpreter = { venv_python } } }
          )
        end

        -- Met a jour DAP Python
        local ok, dap_python = pcall(require, "dap-python")
        if ok then
          dap_python.setup(venv_python)
        end
      end,
    },

    -- Recherches personnalisees supplementaires (optionnel, laisser vide
    -- pour utiliser uniquement les recherches par defaut ci-dessus)
    search = {},
  },

  config = function(_, opts)
    require("venv-selector").setup(opts)

    -- ─── Commande manuelle pour afficher le venv actif ─────────────────────
    vim.api.nvim_create_user_command("VenvInfo", function()
      local vs = require("venv-selector")
      local venv = vs.venv()
      local python = vs.python()

      if venv and venv ~= "" then
        vim.notify(
          string.format("Venv : %s\nPython : %s", venv, python or "N/A"),
          vim.log.levels.INFO,
          { title = "Python Environment" }
        )
      else
        vim.notify("Aucun venv actif", vim.log.levels.WARN, { title = "Python Environment" })
      end
    end, { desc = "Info venv Python actif" })

    -- ─── Reactivation manuelle du venv en cache ─────────────────────────────
    -- Disponible nativement si cached_venv_automatic_activation = false ;
    -- ici on garde un raccourci simple base sur VIRTUAL_ENV.
    vim.api.nvim_create_user_command("VenvResume", function()
      local venv = os.getenv("VIRTUAL_ENV")
      if venv then
        vim.notify("Venv deja actif : " .. venv, vim.log.levels.INFO, { title = "Python Venv" })
      else
        vim.cmd("VenvSelect")
      end
    end, { desc = "Reprendre ou selectionner venv" })

    -- ─── Mise a jour des keymaps ───────────────────────────────────────────
    vim.keymap.set("n", "<leader>pV", "<cmd>VenvResume<CR>", { desc = "Resume/Select Venv" })
    vim.keymap.set("n", "<leader>pc", "<cmd>VenvInfo<CR>", { desc = "Current Venv Info" })
  end,
}