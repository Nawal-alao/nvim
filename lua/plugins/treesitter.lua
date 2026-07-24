-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version  = false,
    build    = ":TSUpdate",
    -- Ne pas charger via dépendances d'autres plugins
    -- Chargement explicite uniquement
    event    = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd      = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    -- Pas de dependencies sur des plugins tiers problématiques
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = false,  -- config gérée par treesitter principal
      },
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- Sécurité : vérifie que le module est bien disponible
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify(
          "nvim-treesitter non disponible, relance :TSUpdate",
          vim.log.levels.WARN,
          { title = "Treesitter" }
        )
        return
      end

      configs.setup({
        ensure_installed = {
          "python", "toml", "ini",
          "html", "css", "javascript", "typescript",
          "json", "yaml",
          "dockerfile", "bash",
          "lua", "luadoc",
          "markdown", "markdown_inline",
          "regex", "vim", "vimdoc", "query", "diff",
          "gitcommit", "gitignore", "sql",
        },

        sync_install  = false,
        auto_install  = true,
        ignore_install = {},

        highlight = {
          enable  = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024
            local ok2, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok2 and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = { "markdown" },
        },

        indent = {
          enable  = true,
          disable = { "yaml" },
        },

        incremental_selection = {
          enable  = true,
          keymaps = {
            init_selection    = "<C-space>",
            node_incremental  = "<C-space>",
            scope_incremental = "<C-S>",
            node_decremental  = "<BS>",
          },
        },

        textobjects = {
          select = {
            enable    = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer",    desc = "outer function" },
              ["if"] = { query = "@function.inner",    desc = "inner function" },
              ["ac"] = { query = "@class.outer",       desc = "outer class" },
              ["ic"] = { query = "@class.inner",       desc = "inner class" },
              ["ai"] = { query = "@conditional.outer", desc = "outer condition" },
              ["ii"] = { query = "@conditional.inner", desc = "inner condition" },
              ["al"] = { query = "@loop.outer",        desc = "outer loop" },
              ["il"] = { query = "@loop.inner",        desc = "inner loop" },
              ["aa"] = { query = "@parameter.outer",   desc = "outer param" },
              ["ia"] = { query = "@parameter.inner",   desc = "inner param" },
              ["ab"] = { query = "@block.outer",       desc = "outer block" },
              ["ib"] = { query = "@block.inner",       desc = "inner block" },
              ["aC"] = { query = "@comment.outer",     desc = "outer comment" },
              ["aF"] = { query = "@call.outer",        desc = "outer call" },
              ["iF"] = { query = "@call.inner",        desc = "inner call" },
            },
            include_surrounding_whitespace = true,
          },

          swap = {
            enable    = true,
            swap_next     = { ["<leader>a"] = "@parameter.inner" },
            swap_previous = { ["<leader>A"] = "@parameter.inner" },
          },

          move = {
            enable    = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
              ["]i"] = "@conditional.outer",
              ["]l"] = "@loop.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
              ["[i"] = "@conditional.outer",
              ["[l"] = "@loop.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
        },

        autotag = {
          enable    = true,
          filetypes = { "html", "xml", "htmldjango" },
        },
      })

      -- ─── Context commentstring ────────────────────────────────────────────
      local ok_ctx, ctx = pcall(require, "ts_context_commentstring")
      if ok_ctx then
        ctx.setup({ enable_autocmd = false })
      end

      -- ─── Treesitter Context ───────────────────────────────────────────────
      local ok_tc, tc = pcall(require, "treesitter-context")
      if ok_tc then
        tc.setup({
          enable            = true,
          max_lines         = 4,
          min_window_height = 20,
          line_numbers      = true,
          multiline_threshold = 20,
          trim_scope        = "outer",
          mode              = "cursor",
          separator         = "─",
          zindex            = 20,
        })

        vim.keymap.set("n", "[x", function()
          tc.go_to_context(vim.v.count1)
        end, { silent = true, desc = "Jump to Context" })
      end

      -- ─── Folding ──────────────────────────────────────────────────────────
      vim.opt.foldmethod     = "expr"
      vim.opt.foldexpr       = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel      = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable     = true
    end,
  },
}