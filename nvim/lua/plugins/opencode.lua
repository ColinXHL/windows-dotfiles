return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      "folke/snacks.nvim",
    },

    config = function()
      -----------------------------------------------------------------------
      -- OpenCode 服务配置
      -----------------------------------------------------------------------

      local host = "127.0.0.1"
      local port = 4096

      local server_url = ("http://%s:%d"):format(host, port)
      local opencode_cmd = ("opencode --hostname %s --port %d"):format(host, port)

      -----------------------------------------------------------------------
      -- 让本地 OpenCode 请求绕过你的 HTTP 代理
      -----------------------------------------------------------------------

      local function add_no_proxy(value)
        for _, name in ipairs({ "NO_PROXY", "no_proxy" }) do
          local current = vim.env[name] or ""
          local exists = false

          for item in current:gmatch("[^,]+") do
            if vim.trim(item) == value then
              exists = true
              break
            end
          end

          if not exists then
            vim.env[name] = current == "" and value or (current .. "," .. value)
          end
        end
      end

      add_no_proxy("127.0.0.1")
      add_no_proxy("localhost")

      -----------------------------------------------------------------------
      -- Snacks Terminal 配置
      -----------------------------------------------------------------------

      -- 插件自动启动 OpenCode 时，不抢走代码窗口焦点
      local start_terminal_opts = {
        win = {
          position = "right",
          enter = false,
        },
      }

      -- 手动按 Ctrl+. 打开时，直接进入 OpenCode 窗口
      local toggle_terminal_opts = {
        win = {
          position = "right",
          enter = true,
        },
      }

      -----------------------------------------------------------------------
      -- opencode.nvim 配置
      -----------------------------------------------------------------------

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          -- 固定 URL，绕过 Windows PowerShell 进程发现
          url = server_url,

          -- 连接后监听事件、文件修改和权限请求
          connect = true,

          -- 服务不存在时自动启动 OpenCode TUI
          start = function()
            require("snacks.terminal").open(opencode_cmd, start_terminal_opts)
          end,
        },
      }

      -----------------------------------------------------------------------
      -- 常用函数
      -----------------------------------------------------------------------

      local function ask()
        require("opencode").ask("@this: ")
      end

      local function select_action()
        require("opencode").select()
      end

      local function toggle_terminal()
        require("snacks.terminal").toggle(opencode_cmd, toggle_terminal_opts)
      end

      local function scroll_up()
        require("opencode").command("session.half.page.up")
      end

      local function scroll_down()
        require("opencode").command("session.half.page.down")
      end

      -----------------------------------------------------------------------
      -- 官方推荐快捷键
      -----------------------------------------------------------------------

      -- 当前光标或选中内容向 OpenCode 提问
      vim.keymap.set({ "n", "x" }, "<C-a>", ask, { desc = "Ask OpenCode…" })

      -- 打开 OpenCode 操作选择器
      vim.keymap.set({ "n", "x" }, "<C-x>", select_action, { desc = "Select OpenCode…" })

      -- Vim Operator：go + 范围
      -- 例如 goip、goiw、go$
      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator("@this ")
      end, {
        desc = "Append range to OpenCode",
        expr = true,
      })

      -- 把当前整行追加给 OpenCode
      vim.keymap.set("n", "goo", function()
        return require("opencode").operator("@this ") .. "_"
      end, {
        desc = "Append line to OpenCode",
        expr = true,
      })

      -- 滚动 OpenCode 会话
      vim.keymap.set("n", "<S-C-u>", scroll_up, { desc = "Scroll OpenCode up" })

      vim.keymap.set("n", "<S-C-d>", scroll_down, { desc = "Scroll OpenCode down" })

      -----------------------------------------------------------------------
      -- 打开/隐藏 OpenCode
      -----------------------------------------------------------------------

      -- WezTerm uses the Kitty keyboard protocol to send Ctrl+. correctly.
      vim.keymap.set({ "n", "t" }, "<C-.>", toggle_terminal, { desc = "Toggle OpenCode" })

      -- 备用快捷键：Space o t
      vim.keymap.set("n", "<leader>ot", toggle_terminal, { desc = "Toggle OpenCode" })

      -----------------------------------------------------------------------
      -- LazyVim 风格备用快捷键
      -----------------------------------------------------------------------

      vim.keymap.set({ "n", "x" }, "<leader>oa", ask, { desc = "Ask OpenCode" })

      vim.keymap.set({ "n", "x" }, "<leader>os", select_action, { desc = "Select OpenCode Action" })

      vim.keymap.set("n", "<leader>ou", scroll_up, { desc = "Scroll OpenCode Up" })

      vim.keymap.set("n", "<leader>od", scroll_down, { desc = "Scroll OpenCode Down" })

      -----------------------------------------------------------------------
      -- 提交提示词后自动显示 OpenCode 窗口
      -----------------------------------------------------------------------

      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:tui.command.execute",

        callback = function(args)
          local event = args.data and args.data.event
          local properties = event and event.properties

          if properties and properties.command == "prompt.submit" then
            local terminal = require("snacks.terminal").get(opencode_cmd, { create = false })

            if terminal then
              terminal:show()
            end
          end
        end,
      })
    end,
  },
}
