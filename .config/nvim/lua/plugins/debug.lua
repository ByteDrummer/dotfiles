return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>c",  ":lua require'dap'.continue()<CR>",                                                    silent = true },
      { "<leader>s",  ":lua require'dap'.step_over()<CR>",                                                   silent = true },
      { "<leader>si", ":lua require'dap'.step_into()<CR>",                                                   silent = true },
      { "<leader>so", ":lua require'dap'.step_out()<CR>",                                                    silent = true },
      { "<leader>b",  ":lua require'dap'.toggle_breakpoint()<CR>",                                           silent = true },
      { "<leader>B",  ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",        silent = true },
      { "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", silent = true },
      { "<leader>dr", ":lua require'dap'.repl.open()<CR>",                                                   silent = true },
      { "<leader>dl", ":lua require'dap'.run_last()<CR>",                                                    silent = true },
      { "<leader>t",  ":lua require'dap'.terminate()<CR>",                                                   silent = true },
    },
    config = function()
      local dap = require('dap')

      local promptArgs = function()
        local out = {}
        local str = vim.fn.input('Provide args: ');
        str:gsub("%S+", function(c) table.insert(out, c) end)
        return out
      end;

      dap.adapters.python = {
        type = 'executable',
        command = '/usr/bin/python',
        args = { '-m', 'debugpy.adapter' },
      }

      dap.configurations.python = {
        {
          type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = 'launch',
          name = "Launch file",
          program = "${file}", -- This configuration will launch the current file if used.
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
          args = promptArgs,
          console = "integratedTerminal",
        },
      }

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" }
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
        },
      }

      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#e06c75', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

      vim.fn.sign_define('DapBreakpoint',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointCondition',
        { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapLogPoint', {
        text = '',
        texthl = 'DapLogPoint',
        linehl = 'DapLogPoint',
        numhl =
        'DapLogPoint'
      })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    keys = {
      { '<F5>', function() require("ui_modes"):debug_toggle() end, silent = true }
    },
    opts = {
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
    },
  },
}
