local function disable(keys)
  return vim.tbl_map(function(key)
    if type(key) == "table" then
      return { key[1], false, mode = key.mode }
    end
    return { key, false }
  end, keys)
end

return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    keys = vim.list_extend(
      disable({
        "<leader>.",
        "<leader>:",
        "<leader>E",
        "<leader>S",
        "<leader>dps",
        "<leader>fB",
        "<leader>fb",
        "<leader>fc",
        "<leader>fe",
        "<leader>fE",
        "<leader>ff",
        "<leader>fF",
        "<leader>fg",
        "<leader>fp",
        "<leader>fr",
        "<leader>fR",
        "<leader>gD",
        "<leader>gd",
        "<leader>gi",
        "<leader>gI",
        "<leader>gp",
        "<leader>gP",
        "<leader>gs",
        "<leader>gS",
        "<leader>n",
        '<leader>s"',
        "<leader>s/",
        "<leader>sa",
        "<leader>sb",
        "<leader>sB",
        "<leader>sc",
        "<leader>sC",
        "<leader>sd",
        "<leader>sD",
        "<leader>sg",
        "<leader>sG",
        "<leader>sh",
        "<leader>sH",
        "<leader>si",
        "<leader>sj",
        "<leader>sk",
        "<leader>sl",
        "<leader>sm",
        "<leader>sM",
        "<leader>sp",
        "<leader>sq",
        "<leader>sR",
        "<leader>su",
        { "<leader>sw", mode = { "n", "x" } },
        { "<leader>sW", mode = { "n", "x" } },
        "<leader>uC",
        "<leader>un",
      }),
      {
        {
          "<leader>e",
          function()
            Snacks.explorer({ cwd = LazyVim.root() })
          end,
          desc = "Explorer (Root Dir)",
        },
      }
    ),
  },
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>y",
        "<cmd>Yazi cwd<cr>",
        desc = "Yazi",
      },
    },
    opts = {
      open_for_directories = true,
      change_neovim_cwd_on_close = true,
      floating_window_scaling_factor = 0.95,
      yazi_floating_window_border = "rounded",
      yazi_floating_window_winblend = 0,
      keymaps = {
        show_help = "<f1>",
        copy_relative_path_to_selected_files = false,
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      if not vim.g.neovide then
        return
      end

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        mode = "buffers",
        indicator = { icon = "▎", style = "icon" },
        separator_style = { "", "" },
        max_name_length = 28,
        get_element_icon = function(element)
          local category = element.directory and "directory" or "file"
          local name = vim.fn.fnamemodify(element.path, ":t")
          local icon = require("mini.icons").get(category, name)
          return icon
        end,
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
      })

      local mocha = {
        crust = "#11111b",
        mantle = "#181825",
        text = "#cdd6f4",
        overlay0 = "#6c7086",
        mauve = "#cba6f7",
        yellow = "#f9e2af",
      }
      local original_highlights = opts.highlights
      opts.highlights = function(defaults)
        local highlights = type(original_highlights) == "function" and original_highlights(defaults)
          or original_highlights
          or {}
        local merged = vim.tbl_deep_extend("force", highlights, {
          fill = { bg = mocha.crust },
          background = { fg = mocha.text, bg = mocha.mantle },
          buffer_visible = { fg = mocha.text, bg = mocha.mantle },
          buffer_selected = { fg = mocha.crust, bg = mocha.mauve, bold = true, italic = false },
          modified = { fg = mocha.yellow, bg = mocha.mantle },
          modified_visible = { fg = mocha.yellow, bg = mocha.mantle },
          modified_selected = { fg = mocha.crust, bg = mocha.mauve },
          duplicate = { fg = mocha.overlay0, bg = mocha.mantle, italic = true },
          duplicate_visible = { fg = mocha.overlay0, bg = mocha.mantle, italic = true },
          duplicate_selected = { fg = mocha.crust, bg = mocha.mauve, italic = false },
          separator = { fg = mocha.crust, bg = mocha.mantle },
          separator_visible = { fg = mocha.crust, bg = mocha.mantle },
          separator_selected = { fg = mocha.crust, bg = mocha.mauve },
          indicator_selected = { fg = mocha.crust, bg = mocha.mauve },
        })

        for _, group in ipairs({
          "buffer_selected",
          "numbers_selected",
          "diagnostic_selected",
          "hint_selected",
          "hint_diagnostic_selected",
          "info_selected",
          "info_diagnostic_selected",
          "warning_selected",
          "warning_diagnostic_selected",
          "error_selected",
          "error_diagnostic_selected",
          "modified_selected",
          "duplicate_selected",
          "separator_selected",
          "indicator_selected",
          "pick_selected",
        }) do
          merged[group] = vim.tbl_deep_extend("force", merged[group] or {}, {
            bg = mocha.mauve,
            fg = mocha.crust,
          })
        end

        return merged
      end
    end,
    keys = disable({
      "<S-h>",
      "<S-l>",
      "[B",
      "]B",
      "<leader>bj",
      "<leader>bl",
      "<leader>bp",
      "<leader>bP",
      "<leader>br",
    }),
  },
  {
    "folke/noice.nvim",
    keys = disable({
      "<leader>sn",
      "<leader>sna",
      "<leader>snd",
      "<leader>snh",
      "<leader>snl",
      "<leader>snt",
    }),
  },
  {
    "folke/persistence.nvim",
    keys = disable({ "<leader>qd", "<leader>ql", "<leader>qS" }),
  },
  {
    "MagicDuck/grug-far.nvim",
    keys = disable({ { "<leader>sr", mode = { "n", "x" } } }),
  },
  {
    "stevearc/conform.nvim",
    keys = disable({ { "<leader>cF", mode = { "n", "x" } } }),
    opts = function(_, opts)
      opts.formatters_by_ft.markdown = nil
      opts.formatters_by_ft["markdown.mdx"] = nil
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "markdownlint-cli2" and tool ~= "markdown-toc"
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.marksman = { enabled = false }
      opts.servers["*"].keys = {
        { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
        { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.on_attach = function(buffer)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = desc, silent = true })
        end

        map("]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("<leader>ghp", gs.preview_hunk_inline, "Preview Hunk")
      end
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xX", false },
      { "<leader>cs", false },
      { "<leader>cS", false },
      { "<leader>xL", false },
      { "<leader>xQ", false },
    },
  },
  {
    "folke/todo-comments.nvim",
    keys = {
      { "]t", false },
      { "[t", false },
      { "<leader>xt", false },
      { "<leader>xT", false },
      { "<leader>st", false },
      { "<leader>sT", false },
    },
  },
}
