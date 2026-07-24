-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event        = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim",
    {
      "j-hui/fidget.nvim",
      opts = {
        progress = {
          display = {
            done_icon      = "✓",
            done_style     = "Constant",
            progress_icon  = { pattern = "dots", period = 1 },
            progress_style = "WarningMsg",
            group_style    = "Title",
            icon_style     = "Question",
            priority       = 30,
            skip_history   = true,
          },
        },
        notification = {
          window = {
            normal_hl = "Comment",
            winblend  = 0,
            border    = "none",
            zindex    = 45,
            align     = "bottom",
            relative  = "editor",
          },
        },
      },
    },
  },

  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- ─── Capabilities ─────────────────────────────────────────────────────
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly     = true,
    }

    -- ─── Diagnostics ──────────────────────────────────────────────────────
    vim.diagnostic.config({
      -- Texte virtuel désactivé : les erreurs s'affichent uniquement
      -- dans le popup flottant au survol (CursorHold dans autocmds.lua)
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.HINT]  = "󰠠 ",
          [vim.diagnostic.severity.INFO]  = " ",
        },
      },
      underline        = true,
      update_in_insert = false,
      severity_sort    = true,
      float = {
        border    = "rounded",
        source    = true,  -- Affiche la source du diagnostic (ruff, basedpyright…)
        max_width = 100,
        header    = "",
        prefix    = "",
        focusable = false,
        scope     = "cursor",
      },
    })

    -- ─── on_attach commun ─────────────────────────────────────────────────
    local on_attach = function(client, bufnr)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      map("gd",         vim.lsp.buf.definition,      "Go to Definition")
      map("gD",         vim.lsp.buf.declaration,     "Go to Declaration")
      map("gi",         vim.lsp.buf.implementation,  "Go to Implementation")
      map("gr",         "<cmd>Telescope lsp_references<CR>", "References")
      map("gt",         vim.lsp.buf.type_definition, "Type Definition")
      map("gs",         vim.lsp.buf.signature_help,  "Signature Help")
      -- NOTE: K est géré globalement dans keymaps.lua (ufo peek + hover fallback)
      map("<leader>la", vim.lsp.buf.code_action,     "Code Action", { "n", "v" })
      map("<leader>lr", vim.lsp.buf.rename,          "Rename")
      map("<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, "Format", { "n", "v" })
      map("<leader>li", "<cmd>LspInfo<CR>",    "LSP Info")
      map("<leader>lR", "<cmd>LspRestart<CR>", "LSP Restart")
      map("<leader>ld", vim.diagnostic.open_float, "Line Diagnostics")
      map("]d", function()
        vim.diagnostic.goto_next({ float = true })
      end, "Next Diagnostic")
      map("[d", function()
        vim.diagnostic.goto_prev({ float = true })
      end, "Prev Diagnostic")
      map("<leader>lq", vim.diagnostic.setloclist, "Quickfix Diagnostics")

      -- Inlay hints
      if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- Highlight references
      if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup(
          "LspDocumentHighlight_" .. bufnr, { clear = true }
        )
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer   = bufnr,
          group    = group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer   = bufnr,
          group    = group,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end

    -- ─── Nouvelle API Neovim 0.11 : vim.lsp.config ────────────────────────
    -- Chaque serveur est configuré via vim.lsp.config puis activé via
    -- vim.lsp.enable — c'est l'API recommandée depuis lspconfig v3

    -- 🐍 BasedPyright (remplace pyright — typage + complétion)
    vim.lsp.config("basedpyright", {
      capabilities = capabilities,
      on_attach    = on_attach,
      settings = {
        basedpyright = {
          analysis = {
            autoSearchPaths        = true,
            diagnosticMode         = "openFilesOnly",
            useLibraryCodeForTypes = true,
            typeCheckingMode       = "standard",
            autoImportCompletions  = true,
            -- Désactive les diagnostics redondants avec ruff
            ignore                 = { "*" },  -- ruff gère E/W/F/I/B
          },
        },
      },
    })
    vim.lsp.enable("basedpyright")

    -- 🚫 Pyright désactivé — basedpyright le remplace complètement
    -- (empêche l'activation automatique par mason-lspconfig)
    vim.lsp.enable("pyright", false)

    -- 🐍 Ruff
    vim.lsp.config("ruff", {
      capabilities = capabilities,
      on_attach    = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.hoverProvider = false
      end,
      init_options = {
        settings = {
          logLevel        = "error",
          fixAll          = true,
          organizeImports = true,
          lint = {
            enable = true,
            select = { "E", "W", "F", "I", "B", "C4", "UP", "SIM", "RUF" },
            ignore = { "E501" },
          },
          format = { enable = true },
        },
      },
    })
    vim.lsp.enable("ruff")

    -- 🌐 JSON
    vim.lsp.config("jsonls", {
      capabilities = capabilities,
      on_attach    = on_attach,
      settings = {
        json = {
          schemas  = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
    vim.lsp.enable("jsonls")

    -- 🌐 YAML
    vim.lsp.config("yamlls", {
      capabilities = capabilities,
      on_attach    = on_attach,
      settings = {
        yaml = {
          keyOrdering = false,
          format      = { enable = true },
          validate    = true,
          schemaStore = { enable = false, url = "" },
          schemas     = require("schemastore").yaml.schemas(),
        },
      },
    })
    vim.lsp.enable("yamlls")

    -- 🌐 Lua
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      on_attach    = on_attach,
      settings = {
        Lua = {
          workspace   = { checkThirdParty = false },
          completion  = { callSnippet = "Replace" },
          hint        = { enable = true },
          diagnostics = { disable = { "missing-fields" } },
          format      = { enable = false },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    -- 🌐 Bash
    vim.lsp.config("bashls", { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable("bashls")

    -- 🌐 Marksman
    vim.lsp.config("marksman", { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable("marksman")

    -- 🌐 Taplo (TOML)
    vim.lsp.config("taplo", { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable("taplo")

    -- 🌐 Docker
    vim.lsp.config("dockerls", { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable("dockerls")

    -- 🌐 CSS
    vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable("cssls")

    -- 🌐 HTML
    vim.lsp.config("html", { capabilities = capabilities, on_attach = on_attach })
    vim.lsp.enable("html")
  end,
}