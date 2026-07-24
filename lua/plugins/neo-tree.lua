-- ~/.config/nvim/lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim", -- Aperçu d'images (optionnel)
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      opts = {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      },
    },
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer Toggle" },
    { "<leader>E", "<cmd>Neotree focus<CR>", desc = "Explorer Focus" },
    { "<leader>fe", "<cmd>Neotree reveal<CR>", desc = "Explorer Reveal" },
    { "<leader>ge", "<cmd>Neotree float git_status<CR>", desc = "Git Status (Neo-tree)" },
    { "<leader>be", "<cmd>Neotree float buffers<CR>", desc = "Buffer Explorer" },
  },
  deactivate = function()
    vim.cmd("Neotree close")
  end,
  init = function()
    -- Ouvre automatiquement si lancé avec un dossier
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    event_handlers = {
      {
        event = "neo_tree_popup_input_ready",
        handler = function(args)
          vim.cmd("stopinsert")
          vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, {
            noremap = true,
            buffer = args.bufnr,
          })
        end,
      },
    },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    sort_case_insensitive = false,

    sort_function = nil,

    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = " ",
        folder_open = " ",
        folder_empty = "󰜌 ",
        provider = function(icon, node, state)
          if node.type == "file" or node.type == "terminal" then
            local success, web_devicons = pcall(require, "nvim-web-devicons")
            local name = node.type == "terminal" and "terminal" or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
        default = "*",
        highlight = "NeoTreeFileIcon",
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          added = " ",
          modified = " ",
          deleted = " ",
          renamed = "󰁕 ",
          untracked = " ",
          ignored = " ",
          unstaged = "󰄱 ",
          staged = "󰱒 ",
          conflict = " ",
        },
      },
      file_size = {
        enabled = true,
        required_width = 64,
      },
      type = {
        enabled = true,
        required_width = 122,
      },
      last_modified = {
        enabled = true,
        required_width = 88,
      },
      created = {
        enabled = true,
        required_width = 110,
      },
      symlink_target = {
        enabled = false,
      },
    },

    commands = {
      -- Ouvre dans un split en gardant Neo-tree ouvert
      open_with_window_picker = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" then
          require("neo-tree.sources.filesystem.commands").expand_node(state)
          return
        end
        local window_picker = require("window-picker")
        local window = window_picker.pick_window({
          hint = "floating-big-letter",
        })
        local target_buf = vim.api.nvim_win_get_buf(window)
        if target_buf ~= vim.api.nvim_get_current_buf() then
          vim.api.nvim_win_set_buf(window, vim.api.nvim_get_current_buf())
        end
        vim.api.nvim_win_call(window, function()
          vim.cmd("e " .. node.path)
        end)
      end,

      -- Copie le chemin absolu
      copy_path_to_clipboard = function(state)
        local node = state.tree:get_node()
        local path = node.path
        vim.fn.setreg("+", path)
        vim.notify("Chemin copié : " .. path, vim.log.levels.INFO, { title = "Neo-tree" })
      end,
    },

    window = {
      position = "left",
      width = 35,
      mapping_options = { noremap = true, nowait = true },
      mappings = {
        ["<space>"] = { "toggle_node", nowait = false },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["<esc>"] = "cancel",
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        ["l"] = "focus_preview",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["w"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["a"] = { "add", config = { show_path = "none" } },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        ["i"] = "show_file_details",
        ["Y"] = "copy_path_to_clipboard",
      },
    },

    nesting_rules = {
      -- Python : __init__.py groupé
      ["*.py"] = { "*.pyi" },
      -- Configs
      [".env"] = { ".env.*" },
      ["pyproject.toml"] = { "setup.cfg", "setup.py", "requirements*.txt", ".flake8", "mypy.ini", ".pylintrc" },
    },

    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false, -- Montre les dotfiles
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          "node_modules",
          ".git",
          "__pycache__",
          ".pytest_cache",
          ".mypy_cache",
          ".ruff_cache",
          "*.egg-info",
          ".DS_Store",
        },
        hide_by_pattern = {
          "*.lock",
          "*.pyc",
          "*.pyo",
        },
        always_show = {
          ".gitignored",
          ".env",
          ".env.example",
          ".env.local",
          "pyproject.toml",
          ".python-version",
        },
        always_show_by_pattern = {
          ".env*",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
        never_show_by_pattern = {
          ".null-ls_*",
          "*.pyc",
          "*.pyo",
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = false,
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["og"] = { "order_by_git_status", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
        },
      },
      async_directory_scan = "auto",
      scan_mode = "shallow",
      bind_to_cwd = true,
      cwd_target = {
        sidebar = "tab",
        current = "window",
      },
    },

    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      show_unloaded = true,
      terminals_first = false,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },

    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
  },
}
