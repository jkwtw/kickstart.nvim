-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.adapters.renesas = {
      type = 'executable',
      command = 'C:/Users/jkoenig.WTW/AppData/Roaming/Code/User/globalStorage/renesaselectronicscorporation.renesas-debug/DebugComp/RX/e2-server-gdb.exe', -- Adjust this to your debugger's path
      -- command = 'rx-elf-gdb',
      name = 'Renesas GDB Hardware',
      args = {
        -- Add the arguments for your debugger, including the server parameters
        '-g',
        'E2LITE',
        '-t',
        'R5F5651E_DUAL',
        '-uConnectionTimeout=',
        '30',
        '-uClockSrcHoco=',
        '0',
        '-uInputClock=',
        '27.0',
        '-uPTimerClock=',
        '12000000',
        '-uAllowClockSourceInternal=',
        '1',
        '-uUseFine=',
        '1',
        '-uFineBaudRate=',
        '1.50',
        '-sn=',
        'e2l:_9js014066a',
        '-w',
        '0',
        '-z',
        '0',
        '-uRegisterSetting=',
        '0',
        '-uModePin=',
        '0',
        '-uChangeStartupBank=',
        '1',
        '-uStartupBank=',
        '0',
        '-uDebugMode=',
        '0',
        '-uExecuteProgram=',
        '0',
        '-uIdCode=',
        'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF',
        '-uresetOnReload=',
        '1',
        '-n',
        '0',
        '-uWorkRamAddress=',
        '1000',
        '-uverifyOnWritingMemory=',
        '0',
        '-uProgReWriteIRom=',
        '0',
        '-uProgReWriteDFlash=',
        '0',
        '-uhookWorkRamAddr=',
        '0x3fdd0',
        '-uhookWorkRamSize=',
        '0x230',
        '-uOSRestriction=',
        '0',
        '-l',
        '-uCore=',
        'SINGLE_CORE|enabled|1|main',
        '-uSyncMode=',
        'async',
        '-uFirstGDB=',
        'main',
        '--english',
        '--gdbVersion=',
        '12.1',
      },
    }
    dap.configurations.c = {
      {
        name = 'Renesas GDB Hardware Debugging E2LITE',
        type = 'renesas', -- Type must match the adapter we defined
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = false, -- You can adjust this depending on your needs
        args = {},
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'Enable pretty printing',
            ignoreFailures = false,
          },
        },
        runInTerminal = true,
      },
    }

    dap.configurations.cpp = dap.configurations.c

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
