-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-dap.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/trouble.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>fF", "<cmd>Telescope find_files hidden=true<CR>", desc = "Find Files (hidden)" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<leader>fG", "<cmd>Telescope grep_string<CR>", desc = "Grep String" },
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
    { "<leader>fC", "<cmd>Telescope colorscheme<CR>", desc = "Colorscheme" },
    { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Marks" },
    { "<leader>fj", "<cmd>Telescope jumplist<CR>", desc = "Jumplist" },
    { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },
    { "<leader>fl", "<cmd>Telescope loclist<CR>", desc = "Loclist" },
    { "<leader>fR", "<cmd>Telescope registers<CR>", desc = "Registers" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols" },
    { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace Symbols" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Buffer Diagnostics" },
    { "<leader>fD", "<cmd>Telescope diagnostics<CR>", desc = "All Diagnostics" },
    { "<leader>fp", "<cmd>Telescope project<CR>", desc = "Projects" },
    { "<leader>fn", "<cmd>Telescope notify<CR>", desc = "Notifications" },
    { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
    { "<leader>fgb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },
    { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
    { "<leader>fgt", "<cmd>Telescope git_stash<CR>", desc = "Git Stash" },
    { "<leader>fB", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
    { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Quick File Find" },
    { "<C-g>", "<cmd>Telescope live_grep<CR>", desc = "Quick Grep" },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
      end,
      desc = "Find Word",
    },
    {
      "<leader>fpy",
      function()
        require("telescope.builtin").find_files({
          prompt_title = "Fichiers Python",
          find_command = { "rg", "--files", "--glob", "*.py" },
        })
      end,
      desc = "Python Files",
    },
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- Trouble intégration (optionnel)
    local trouble_ok, trouble = pcall(require, "trouble.sources.telescope")
    local send_to_trouble = trouble_ok and trouble.open_with_trouble or function() end

    telescope.setup({
      defaults = {
        treesitter = false,
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        path_display = { "smart" },
        border = true,
        hl_result_eol = true,
        dynamic_preview_title = true,
        results_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = {
          "%.git/",
          "__pycache__/",
          "%.pyc",
          "%.pyo",
          "node_modules/",
          "%.egg-info/",
          "%.mypy_cache/",
          "%.ruff_cache/",
          "%.pytest_cache/",
          "dist/",
          "build/",
          "%.venv/",
          "venv/",
          ".venv/",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
          "--trim",
        },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-T>"] = send_to_trouble,
          },
          n = {
            ["<esc>"] = actions.close,
            ["q"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-T>"] = send_to_trouble,
          },
        },
      },

      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob=!.git/" },
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          sort_mru = true,
          sort_lastused = true,
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["d"] = actions.delete_buffer },
          },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob=!.git/" }
          end,
        },
        lsp_references = { theme = "dropdown", initial_mode = "normal" },
        lsp_definitions = { theme = "dropdown", initial_mode = "normal" },
        lsp_implementations = { theme = "dropdown", initial_mode = "normal" },
        diagnostics = { theme = "ivy", initial_mode = "normal" },
        colorscheme = { enable_preview = true },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            winblend = 10,
            width = 0.5,
            previewer = false,
          }),
        },
        file_browser = {
          theme = "ivy",
          hijack_netrw = false,
        },
        project = {
          base_dirs = {
            { path = vim.fn.expand("~"), max_depth = 2 },
          },
          hidden_files = true,
          theme = "dropdown",
          order_by = "asc",
          search_by = "full_path",
        },
      },
    })

    -- ─── Chargement des extensions ──────────────────────────────────────────
    local extensions = {
      "fzf",
      "ui-select",
      "file_browser",
      "project",
      "notify",
      "dap",
    }
    for _, ext in ipairs(extensions) do
      pcall(telescope.load_extension, ext)
    end
  end,
}
