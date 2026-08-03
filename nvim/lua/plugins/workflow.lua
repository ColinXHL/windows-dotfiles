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
    "iamcco/markdown-preview.nvim",
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
    "akinsho/bufferline.nvim",
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
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
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
