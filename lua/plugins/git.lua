-- ~/.config/nvim/lua/plugins/git.lua
return {
  -- ─── Gitsigns : décorations inline ───────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
      },
      signs_staged_enable         = true,
      signcolumn                  = true,
      numhl                       = true,
      linehl                      = false,
      word_diff                   = false,
      watch_gitdir                = { follow_files = true },
      auto_attach                 = true,
      attach_to_untracked         = false,
      current_line_blame          = true,  -- Blame inline
      current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 1000,
        ignore_whitespace = true,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%d/%m/%Y> - <summary>",
      sign_priority   = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length  = 40000,
      preview_config   = {
        border   = "rounded",
        style    = "minimal",
        relative = "cursor",
        row      = 0,
        col      = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation entre les hunks
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Hunk" })

        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Hunk" })

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>",         { desc = "Stage Hunk" })
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>",          { desc = "Reset Hunk" })
        map("n", "<leader>ghS", gs.stage_buffer,                              { desc = "Stage Buffer" })
        map("n", "<leader>ghu", gs.undo_stage_hunk,                           { desc = "Undo Stage Hunk" })
        map("n", "<leader>ghR", gs.reset_buffer,                              { desc = "Reset Buffer" })
        map("n", "<leader>ghp", gs.preview_hunk,                              { desc = "Preview Hunk" })
        map("n", "<leader>ghP", gs.preview_hunk_inline,                       { desc = "Preview Hunk Inline" })
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        map("n", "<leader>ghB", gs.toggle_current_line_blame,                 { desc = "Toggle Line Blame" })
        map("n", "<leader>ghd", gs.diffthis,                                  { desc = "Diff This" })
        map("n", "<leader>ghD", function() gs.diffthis("~") end,              { desc = "Diff This ~" })
        map("n", "<leader>ghQ", function() gs.setqflist("all") end,           { desc = "Quickfix All Hunks" })
        map("n", "<leader>ghq", gs.setqflist,                                 { desc = "Quickfix Hunks" })

        -- Objets texte pour les hunks (ih / ah)
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",  { desc = "Select Hunk" })
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>",  { desc = "Select Hunk" })
      end,
    },
  },

  -- ─── Neogit : interface Git style Magit ──────────────────────────────────
  {
    "NeogitOrg/neogit",
    cmd  = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>",               desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<CR>",         desc = "Neogit Commit" },
      { "<leader>gp", "<cmd>Neogit push<CR>",           desc = "Neogit Push" },
      { "<leader>gP", "<cmd>Neogit pull<CR>",           desc = "Neogit Pull" },
      { "<leader>gf", "<cmd>Neogit fetch<CR>",          desc = "Neogit Fetch" },
      { "<leader>gl", "<cmd>Neogit log<CR>",            desc = "Neogit Log" },
      { "<leader>gb", "<cmd>Neogit branch<CR>",         desc = "Neogit Branch" },
      { "<leader>gr", "<cmd>Neogit rebase<CR>",         desc = "Neogit Rebase" },
      { "<leader>gm", "<cmd>Neogit merge<CR>",          desc = "Neogit Merge" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      kind                      = "tab",
      status                    = { recent_commit_count = 20 },
      commit_editor             = { kind = "tab", show_staged_diff = true },
      commit_select_view        = { kind = "tab" },
      commit_view               = { kind = "vsplit", verify_commit = vim.fn.executable("gpg") == 1 },
      log_view                  = { kind = "tab" },
      rebase_editor             = { kind = "tab" },
      merge_editor              = { kind = "tab" },
      tag_editor                = { kind = "tab" },
      preview_buffer            = { kind = "split" },
      popup                     = { kind = "split" },
      signs = {
        hunk    = { "", "" },
        item    = { ">", "v" },
        section = { ">", "v" },
      },
      integrations = {
        telescope    = true,
        diffview     = true,
        fzf_lua      = false,
      },
      sections = {
        untracked = { folded = false, hidden = false },
        unstaged  = { folded = false, hidden = false },
        staged    = { folded = false, hidden = false },
        stashes   = { folded = true },
        unpulled_upstream   = { folded = true },
        unmerged_upstream   = { folded = false },
        unpulled_pushremote = { folded = true },
        unmerged_pushremote = { folded = false },
        recent_commits      = { folded = true },
        rebase              = { folded = true, hidden = false },
      },
      ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitPullPopup--rebase",
        "NeogitCommitPopup--allow-empty",
        "NeogitRevertPopup--no-edit",
      },
      highlight = {
        italic  = true,
        bold    = true,
        underline = true,
      },
      use_default_keymaps     = true,
      auto_refresh            = true,
      sort_branches           = "-committerdate",
      telescope_sorter        = function()
        return require("telescope").extensions.fzf.native_fzf_sorter()
      end,
    },
  },

  -- ─── Diffview ─────────────────────────────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd",  "<cmd>DiffviewOpen<CR>",                           desc = "Diffview Open" },
      { "<leader>gD",  "<cmd>DiffviewClose<CR>",                          desc = "Diffview Close" },
      { "<leader>gF",  "<cmd>DiffviewFileHistory %<CR>",                  desc = "File History" },
      { "<leader>gH",  "<cmd>DiffviewFileHistory<CR>",                    desc = "Repo History" },
    },
    opts = {
      diff_binaries          = false,
      enhanced_diff_hl       = true,
      git_cmd                = { "git" },
      hg_cmd                 = { "hg" },
      use_icons              = true,
      show_help_hints        = true,
      watch_index            = true,
      icons = {
        folder_closed = "",
        folder_open   = "",
      },
      signs = {
        fold_closed = "",
        fold_open   = "",
        done        = "✓",
      },
      view = {
        default = {
          layout       = "diff2_horizontal",
          winbar_info  = false,
        },
        merge_tool = {
          layout        = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info   = true,
        },
        file_history = {
          layout       = "diff2_horizontal",
          winbar_info  = false,
        },
      },
      file_panel = {
        listing_style     = "tree",
        tree_options = {
          flatten_dirs    = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width    = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = { diff_merges = "combined" },
            multi_file  = { diff_merges = "first-parent" },
          },
          hg  = {
            single_file = {},
            multi_file  = {},
          },
        },
        win_config = {
          position = "bottom",
          height   = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = { win_opts = {} },
      },
      default_args = {
        DiffviewOpen         = {},
        DiffviewFileHistory  = {},
      },
      keymaps = {
        disable_defaults = false,
      },
      hooks = {},
    },
  },

  -- ─── Git blame ────────────────────────────────────────────────────────────
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    opts = {
      enabled              = false,  -- Géré par Gitsigns
      message_template     = "  <author> • <date> • <summary>",
      date_format          = "%d/%m/%Y %H:%M",
      virtual_text_column  = 1,
      highlight_group      = "GitBlame",
      set_extmark_options  = {},
      display_virtual_text = 1,
      ignored_filetypes    = { "neo-tree", "aerial", "toggleterm" },
      delay                = 1000,
    },
  },
}