-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    -- Sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "saadparwaiz1/cmp_luasnip",
    "Exafunction/codeium.nvim",      -- Source IA
    "onsails/lspkind.nvim",           -- Icônes LSP
    -- Snippets
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build   = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets",  -- Collection de snippets Python
      },
      config = function()
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        -- Snippets Python personnalisés
        require("luasnip.loaders.from_lua").lazy_load({
          paths = vim.fn.stdpath("config") .. "/snippets",
        })
        luasnip.config.set_config({
          history                 = true,
          updateevents            = "TextChanged,TextChangedI",
          enable_autosnippets     = true,
          ext_opts = {
            [require("luasnip.util.types").choiceNode] = {
              active    = { virt_text = { { "●", "GruvboxOrange" } } },
              passive   = { virt_text = { { "○", "GruvboxBlue" } } },
              visited   = { virt_text = { { "✓", "GruvboxGreen" } } },
              unvisited = { virt_text = { { "●", "GruvboxOrange" } } },
            },
          },
        })
      end,
    },
  },

  config = function()
    local cmp     = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- ─── Helpers ──────────────────────────────────────────────────────────────
    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
        and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    -- ─── Setup principal ──────────────────────────────────────────────────────
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      window = {
        completion = {
          border         = "rounded",
          winhighlight   = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
          scrollbar      = true,
          col_offset     = -3,
          side_padding   = 1,
        },
        documentation = {
          border         = "rounded",
          winhighlight   = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
          max_width      = 80,
          max_height     = 20,
        },
      },

      -- ─── Keymaps ────────────────────────────────────────────────────────────
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-j>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-f>"]     = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<CR>"]      = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select   = false,  -- Ne confirme que si sélectionné
        }),
        -- Super-Tab
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        -- Navigation dans les choix LuaSnip
        ["<C-n>"] = cmp.mapping(function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end),
        ["<C-p>"] = cmp.mapping(function()
          if luasnip.choice_active() then
            luasnip.change_choice(-1)
          end
        end),
      }),

      -- ─── Sources (ordonnées par priorité) ──────────────────────────────────
      sources = cmp.config.sources({
        {
          name     = "nvim_lsp",
          priority = 1000,
          entry_filter = function(entry, _)
            -- Exclut les snippets du LSP (on préfère LuaSnip)
            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
          end,
        },
        { name = "codeium",                priority = 900 },
        { name = "luasnip",                priority = 750 },
        { name = "nvim_lsp_signature_help", priority = 700 },
        { name = "nvim_lua",               priority = 600 },
        { name = "buffer",                 priority = 500, keyword_length = 3,
          option = {
            get_bufnrs = function()  -- Tous les buffers visibles
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "path",                   priority = 400 },
      }),

      -- ─── Formatage avec lspkind ─────────────────────────────────────────────
      formatting = {
        fields          = { "kind", "abbr", "menu" },
        expandable_indicator = true,
        format = lspkind.cmp_format({
          mode        = "symbol_text",
          maxwidth    = 50,
          ellipsis_char = "…",
          show_labelDetails = true,
          symbol_map  = {
            Codeium       = "󰘦",
            CodeCompanion = "󰚩",
            Text          = "󰉿",
            Method        = "󰆧",
            Function      = "󰊕",
            Constructor   = "󰗡",
            Field         = "󰜢",
            Variable      = "󰀫",
            Class         = "󰌗",
            Interface     = "󰌗",
            Module        = "󰏗",
            Property      = "󰖷",
            Unit          = "󰑭",
            Value         = "󰎠",
            Enum          = "󰕘",
            Keyword       = "󰌋",
            Snippet       = "󰅍",
            Color         = "󰏘",
            File          = "󰈙",
            Reference     = "󰈇",
            Folder        = "󰉋",
            EnumMember    = "󰕘",
            Constant      = "󰏿",
            Struct        = "󰌗",
            Event         = "󰉁",
            Operator      = "󰆕",
            TypeParameter = "󰊄",
          },
          before = function(entry, vim_item)
            -- Source tag
            local source_names = {
              nvim_lsp      = "[LSP]",
              luasnip       = "[Snip]",
              buffer        = "[Buf]",
              path          = "[Path]",
              nvim_lua      = "[Lua]",
              codeium       = "[AI]",
              codecompanion = "[CC]",
            }
            vim_item.menu = source_names[entry.source.name] or ""
            return vim_item
          end,
        }),
      },

      -- ─── Comportement ────────────────────────────────────────────────────────
      completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_length = 1,
      },
      matching = {
        disallow_fuzzy_matching  = false,
        disallow_fullfuzzy_matching = false,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          -- Favorise les éléments récemment utilisés
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find("^_+")
            local _, entry2_under = entry2.completion_item.label:find("^_+")
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",  -- Suggestion inline en grisé
        },
      },
    })

    -- ─── Cmdline / pour la recherche ─────────────────────────────────────────
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
      },
    })

    -- ─── Cmdline : pour les commandes ─────────────────────────────────────────
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
      }),
    })

    -- ─── Highlights ───────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, "CmpGhostText",  { link = "Comment", default = true })
    vim.api.nvim_set_hl(0, "CmpNormal",     { link = "NormalFloat", default = true })
    vim.api.nvim_set_hl(0, "CmpBorder",     { link = "FloatBorder", default = true })
    vim.api.nvim_set_hl(0, "CmpSel",        { link = "PmenuSel", default = true })
    vim.api.nvim_set_hl(0, "CmpDocNormal",  { link = "NormalFloat", default = true })
    vim.api.nvim_set_hl(0, "CmpDocBorder",  { link = "FloatBorder", default = true })
  end,
}