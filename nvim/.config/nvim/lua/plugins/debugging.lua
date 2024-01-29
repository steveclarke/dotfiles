return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dap-go").setup()

    -- DAP UI
    dapui.setup()
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

    -- Keybindings
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
    vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step over" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })

    -- Adapters
    dap.adapters.ruby = function(callback)
      callback({
        type = "server",
        host = "127.0.0.1",
        port = "7777",
      })
    end

    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "Attach to Rails server",
        request = "attach",
      },
    }
  end,
}
