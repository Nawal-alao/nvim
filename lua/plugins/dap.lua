-- ~/.config/nvim/lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- Adaptateur Python
      "mfussenegger/nvim-dap-python",
      -- Intégration avec Mason
      "jay-babu/mason-nvim-dap.nvim",
      -- Breakpoints virtuels
      "theHamsta/nvim-dap-virtual-text",
      -- Telescope integration
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      -- Breakpoints
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point: "))
        end,
        desc = "Log Point",
      },
      {
        "<leader>dL",
        function()
          require("dap").list_breakpoints()
        end,
        desc = "List Breakpoints",
      },
      {
        "<leader>dX",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Clear Breakpoints",
      },
      -- Navigation
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      -- Session
      {
        "<leader>dr",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>ds",
        function()
          require("dap").terminate()
        end,
        desc = "Stop",
      },
      {
        "<leader>dR",
        function()
          require("dap").restart()
        end,
        desc = "Restart",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      -- UI
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "DAP UI Toggle",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Eval",
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input("Expression: "))
        end,
        desc = "Eval Expression",
      },
      -- Python
      {
        "<leader>dPt",
        function()
          require("dap-python").test_method()
        end,
        desc = "Test Method (Python)",
      },
      {
        "<leader>dPc",
        function()
          require("dap-python").test_class()
        end,
        desc = "Test Class (Python)",
      },
      {
        "<leader>dPs",
        function()
          require("dap-python").debug_selection()
        end,
        mode = "v",
        desc = "Debug Selection (Python)",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ─── Virtual Text ──────────────────────────────────────────────────────
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- ─── DAP UI ────────────────────────────────────────────────────────────
      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "→",
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        force_buffers = true,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.30 },
              { id = "watches", size = 0.20 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 12,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⇢",
            step_over = "⇥",
            step_out = "⬆",
            step_back = "⬅",
            run_last = "↺",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
          indent = 1,
        },
      })

      -- ─── Auto open/close UI ───────────────────────────────────────────────
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- ─── Signes visuels ───────────────────────────────────────────────────
      vim.fn.sign_define("DapBreakpoint", {
        text = "󰝥",
        texthl = "DapBreakpoint",
        linehl = "DapBreakpointLine",
        numhl = "DapBreakpointNum",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "󰟃",
        texthl = "DapBreakpointCondition",
        linehl = "DapBreakpointLine",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DapBreakpointRejected",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "󰸩",
        texthl = "DapLogPoint",
        linehl = "DapLogPointLine",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStoppedNum",
      })

      -- ─── Highlights ────────────────────────────────────────────────────────
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#f38ba8", bold = true })
      vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#3d1a1a" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#a6e3a1", bold = true })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#1a3d1a" })

      -- ─── Python DAP ───────────────────────────────────────────────────────
      require("dap-python").setup(
        -- Utilise le python du venv actif, sinon le système
        vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      )
      require("dap-python").test_runner = "pytest"

      -- Adapter pour debugpy manuel (si dap-python ne suffit pas)
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = { source_filetype = "python" },
          })
        else
          cb({
            type = "executable",
            command = vim.fn.exepath("python3") or "python3",
            args = { "-m", "debugpy.adapter" },
            options = { source_filetype = "python" },
          })
        end
      end

      -- Configurations DAP Python
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "󰌠 Lancer le fichier courant",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return vim.fn.exepath("python3") or "python3"
          end,
          console = "integratedTerminal",
          justMyCode = false,
        },
        {
          type = "python",
          request = "launch",
          name = "󰌠 Lancer avec arguments",
          program = "${file}",
          args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ")
          end,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return vim.fn.exepath("python3") or "python3"
          end,
          console = "integratedTerminal",
          justMyCode = false,
        },
        {
          type = "python",
          request = "launch",
          name = " Django",
          module = "django",
          args = { "runserver", "--noreload" },
          django = true,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return vim.fn.exepath("python3") or "python3"
          end,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "⚡ FastAPI (uvicorn)",
          module = "uvicorn",
          args = function()
            local module = vim.fn.input("App module (ex: main:app): ")
            return { module, "--reload" }
          end,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return vim.fn.exepath("python3") or "python3"
          end,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "🧪 Pytest",
          module = "pytest",
          args = function()
            local path = vim.fn.input("Test file/dir: ", vim.fn.expand("%:p"))
            return { path, "-v", "--tb=short" }
          end,
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            end
            return vim.fn.exepath("python3") or "python3"
          end,
          console = "integratedTerminal",
          justMyCode = false,
        },
        {
          type = "python",
          request = "attach",
          name = "  Attacher au processus",
          connect = {
            host = "127.0.0.1",
            port = 5678,
          },
          pathMappings = {
            { localRoot = "${workspaceFolder}", remoteRoot = "." },
          },
          justMyCode = false,
        },
      }

      -- ─── Mason DAP ────────────────────────────────────────────────────────
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        automatic_setup = true,
        ensure_installed = { "python" },
        handlers = {},
      })

      -- ─── Telescope DAP ────────────────────────────────────────────────────
      -- Chargement différé de l'extension dap
      vim.defer_fn(function()
        pcall(require("telescope").load_extension, "dap")
      end, 100)
    end,
  },
}
