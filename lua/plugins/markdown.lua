return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons", -- Ou 'echasnovski/mini.icons'
    },
    ft = { "markdown" }, -- Chargement fainéant (Lazy load) uniquement sur les fichiers Markdown
    opts = {
      -- Configuration de base épurée
      enabled = true,
      render_modes = { "n", "v", "ic" }, -- Actif en mode Normal, Visuel et Insertion (partiel)
      anti_conceal = {
        enabled = true, -- Révèle la syntaxe brute (*, #, etc.) sur la ligne où se trouve le curseur
      },
      headings = {
        sign = false, -- Désactive les signes superflus dans la colonne latérale
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " }, -- Icônes épurées pour les titres H1 à H6
      },
      code = {
        sign = false,
        width = "block", -- Étend l'arrière-plan du bloc de code sur toute sa largeur textuelle
        right_pad = 4,
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = " " },
      },
    },
    config = function(_, opts)
      -- Initialisation du plugin avec les options ci-dessus
      require("render-markdown").setup(opts)
      vim.diagnostic.config({ virtual_text = false, underline = False, signs = False })

      local diagnostic_groups = { "Error", "Warn", "Info", "Hint" }
      for _, type in ipairs(diagnostic_groups) do
        vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. type, { underline = false, undercurl = false })
        vim.api.nvim_set_hl(0, "LspDiagnosticsUnderline" .. type, { underline = false, undercurl = false })
      end

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = false,
      })

      -- Configuration des options de buffer natives indispensables pour accompagner le plugin
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          local opt = vim.opt_local

          -- Masquage natif requis pour le fonctionnement des plugins de rendu
          opt.conceallevel = 2

          -- Gestion de la prose (Soft Wrap)
          opt.wrap = true -- Retour à la ligne visuel automatique
          opt.linebreak = true -- Ne coupe pas les mots au milieu
          opt.breakindent = true -- Aligne le retour à la ligne avec l'indentation d'origine
          opt.textwidth = 0 -- Empêche les retours à la ligne matériels (hard wrap) forcés

          -- Nettoyage visuel périphérique
          opt.colorcolumn = "" -- Supprime la ligne verticale de limite
          opt.signcolumn = "yes" -- Évite le scintillement de l'écran lors des diagnostics

          -- Correction orthographique
          opt.spell = true
          opt.spelllang = { "fr" }

          -- Raccourcis de navigation sur lignes visuelles (très important pour les longs paragraphes)
          local keymap = vim.keymap.set
          local kopts = { buffer = true, silent = true }
          keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, buffer = true, silent = true })
          keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, buffer = true, silent = true })

          -- Raccourci local rapide pour cocher/décocher les tâches (- [ ] <-> - [x])
          keymap("n", "<leader><leader>", function()
            local line = vim.api.nvim_get_current_line()
            if line:match("%-%s%[%s%]") then
              line = line:gsub("%-%s%[%s%]", "- [x]", 1)
            elseif line:match("%-%s%[%x%]") then
              line = line:gsub("%-%s%[%x%]", "- [ ]", 1)
            end
            vim.api.nvim_set_current_line(line)
          end, kopts)
        end,
      })
    end,
  },
}
