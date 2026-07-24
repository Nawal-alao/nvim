-- ~/.config/nvim/lua/plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    cmd  = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- ─── Python ──────────────────────────────────────────────────
        "basedpyright",           -- LSP Python (type checker avancé)
        -- pyright est désactivé : basedpyright est son successeur amélioré
        "ruff",                   -- Linter + formatter Python ultra-rapide
        "ruff-lsp",               -- LSP wrapper pour ruff
        "black",                  -- Formatter Python
        "isort",                  -- Import sorter
        "debugpy",                -- Adaptateur DAP Python
        "mypy",                   -- Type checker statique
        "pylint",                 -- Linter complet
        "flake8",                 -- Linter léger
        "bandit",                 -- Sécurité Python
        "autopep8",               -- Formatter alternatif
        "python-lsp-server",      -- LSP alternatif (pylsp)
        -- ─── Lua ─────────────────────────────────────────────────────
        "lua-language-server",
        "stylua",
        -- ─── Shell ───────────────────────────────────────────────────
        "bash-language-server",
        "shellcheck",
        "shfmt",
        -- ─── Web / Templates ─────────────────────────────────────────
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "marksman",               -- Markdown LSP
        "prettier",               -- Formatter multi-langages
        -- ─── Docker ──────────────────────────────────────────────────
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint",               -- Linter Dockerfile
        -- ─── TOML ────────────────────────────────────────────────────
        "taplo",
        -- ─── Divers ──────────────────────────────────────────────────
        "editorconfig-checker",
        "misspell",
        "codespell",
      },
      ui = {
        border           = "rounded",
        width            = 0.85,
        height           = 0.85,
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
        keymaps = {
          toggle_package_expand   = "<CR>",
          install_package         = "i",
          update_package          = "u",
          check_package_version   = "c",
          update_all_packages     = "U",
          check_outdated_packages = "C",
          uninstall_package       = "X",
          cancel_installation     = "<C-c>",
          apply_language_filter   = "<C-f>",
          toggle_help             = "?",
          toggle_package_install_log = "<CR>",
          toggle_help_2           = "g?",
        },
        check_outdated_packages_on_open = true,
      },
      max_concurrent_installers = 10,
      registries = {
        "github:mason-org/mason-registry",
      },
      providers = {
        "mason.providers.registry-api",
        "mason.providers.client",
      },
      github = {
        download_url_template = "https://github.com/%s/releases/download/%s/%s",
      },
      pip = {
        upgrade_pip = true,
        args        = {},
      },
      log_level  = vim.log.levels.INFO,
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Commande pour installer tous les outils d'un coup
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        local mr = require("mason-registry")
        mr.refresh(function()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              p:install()
            end
          end
        end)
      end, {})
    end,
  },

  -- ─── Mason-LSPconfig bridge ───────────────────────────────────────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "lua_ls",
        "jsonls",
        "yamlls",
        "bashls",
        "marksman",
        "taplo",
        "dockerls",
        "docker_compose_language_service",
        "cssls",
        "html",
      },
      automatic_installation = true,
    },
  },

  -- ─── Mason-null-ls bridge (diagnostics uniquement) ─────────────────────────
  {
    "jay-babu/mason-null-ls.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      ensure_installed = {
        -- Diagnostics uniquement (le formatage est géré par conform.nvim)
        "mypy",
        "pylint",
        "shellcheck",
        "hadolint",
        "editorconfig-checker",
      },
      automatic_installation = true,
      handlers              = {},
    },
  },
}
