-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function del(modes, lhs)
  modes = type(modes) == "table" and modes or { modes }
  for _, mode in ipairs(modes) do
    pcall(vim.keymap.del, mode, lhs)
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymaps",
  once = true,
  callback = function()
    -- Preserve Vim's native H/L motions and leave Alt combinations to GlazeWM.
    for _, lhs in ipairs({ "<S-h>", "<S-l>" }) do
      del("n", lhs)
    end
    for _, lhs in ipairs({ "<A-j>", "<A-k>" }) do
      del({ "n", "i", "v" }, lhs)
    end

    -- Keep one project-oriented entry point for files, grep, buffers, and explorer.
    local redundant_project_maps = {
      "<leader>E",
      "<leader>:",
      "<leader>fB",
      "<leader>fb",
      "<leader>fc",
      "<leader>fe",
      "<leader>fE",
      "<leader>ff",
      "<leader>fF",
      "<leader>fg",
      "<leader>fn",
      "<leader>fp",
      "<leader>fr",
      "<leader>fR",
      "<leader>ft",
      "<leader>fT",
      "<leader>gD",
      "<leader>gd",
      "<leader>gB",
      "<leader>gb",
      "<leader>gf",
      "<leader>gG",
      "<leader>gi",
      "<leader>gI",
      "<leader>gl",
      "<leader>gL",
      "<leader>gp",
      "<leader>gP",
      "<leader>gs",
      "<leader>gS",
      "<leader>gY",
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
      "<leader>sr",
      "<leader>sR",
      "<leader>st",
      "<leader>sT",
      "<leader>su",
      "<leader>sw",
      "<leader>sW",
    }
    for _, lhs in ipairs(redundant_project_maps) do
      del({ "n", "x" }, lhs)
    end

    -- Keep [b/]b, <leader>,, and a small VS Code-style buffer workflow.
    for _, lhs in ipairs({
      "<leader>`",
      "<leader>bb",
      "<leader>bD",
      "<leader>bi",
      "<leader>bj",
      "<leader>bl",
      "<leader>bo",
      "<leader>bp",
      "<leader>bP",
      "<leader>br",
    }) do
      del("n", lhs)
    end

    -- Keep manual project restore (<leader>qs) and quit-all (<leader>qq).
    for _, lhs in ipairs({ "<leader>qd", "<leader>ql", "<leader>qS" }) do
      del("n", lhs)
    end

    -- Keep only the primary diagnostic list and previous/next diagnostic motions.
    for _, lhs in ipairs({
      "<leader>cF",
      "<leader>cd",
      "<leader>cs",
      "<leader>cS",
      "<leader>xl",
      "<leader>xL",
      "<leader>xq",
      "<leader>xQ",
      "<leader>xT",
      "<leader>xt",
      "<leader>xX",
      "[D",
      "]D",
      "[e",
      "]e",
      "[q",
      "]q",
      "[t",
      "]t",
      "[w",
      "]w",
    }) do
      del({ "n", "x" }, lhs)
    end

    -- Low-frequency UI and scratch actions remain available as commands.
    for _, lhs in ipairs({
      "<leader>.",
      "<leader>K",
      "<leader>L",
      "<leader>S",
      "<leader>n",
      "<leader>sn",
      "<leader>sna",
      "<leader>snd",
      "<leader>snh",
      "<leader>snl",
      "<leader>snt",
      "<leader>uA",
      "<leader>ua",
      "<leader>ub",
      "<leader>uc",
      "<leader>uC",
      "<leader>ud",
      "<leader>uD",
      "<leader>uf",
      "<leader>uF",
      "<leader>ug",
      "<leader>ui",
      "<leader>uI",
      "<leader>ul",
      "<leader>uL",
      "<leader>un",
      "<leader>ur",
      "<leader>us",
      "<leader>uS",
      "<leader>uT",
      "<leader>uw",
      "<leader>uZ",
      "<leader>uz",
      "<leader>wm",
      "<leader>dph",
      "<leader>dpp",
    }) do
      del("n", lhs)
    end

    -- Neovim tabs are layouts, not file tabs. Avoid presenting them as a second
    -- buffer workflow while learning the project-oriented setup.
    for _, lhs in ipairs({
      "<leader><tab><tab>",
      "<leader><tab>[",
      "<leader><tab>]",
      "<leader><tab>d",
      "<leader><tab>f",
      "<leader><tab>l",
      "<leader><tab>o",
    }) do
      del("n", lhs)
    end

    -- Window resizing is available through commands and the mouse. Keep only
    -- Ctrl-h/j/k/l navigation and <leader>|/- split creation.
    for _, lhs in ipairs({ "<C-Up>", "<C-Down>", "<C-Left>", "<C-Right>" }) do
      del("n", lhs)
    end

    -- Define the agreed core workflow explicitly so it does not depend on the
    -- load order of LazyVim's optional plugin mappings.
    local map = vim.keymap.set
    map({ "i", "n", "s", "x" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
    map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
    map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
    map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
    map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
    map("n", "<leader>|", "<C-w>v", { desc = "Split Window Right", remap = true })
    map("n", "<leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
    map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window", remap = true })
    map("n", "<leader>b", function()
      Snacks.picker.buffers()
    end, { desc = "Buffers" })
    map("n", "<leader>ba", function()
      Snacks.bufdelete.all()
    end, { desc = "Close All Buffers" })
    map("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "Close Buffer" })
    map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close Buffers to the Left" })
    map("n", "<leader>bo", function()
      Snacks.bufdelete.other()
    end, { desc = "Close Other Buffers" })
    map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close Buffers to the Right" })
    map("n", "<leader>bs", function()
      Snacks.bufdelete(function(buf)
        return vim.bo[buf].buftype == "" and not vim.bo[buf].modified
      end)
    end, { desc = "Close Saved Buffers" })
    map({ "n", "x" }, "<leader>cf", function()
      LazyVim.format({ force = true })
    end, { desc = "Format" })
    del("t", "<C-/>")
    del("t", "<C-_>")
    for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
      map("n", lhs, "gcc", { desc = "Toggle Comment", remap = true })
      map("x", lhs, "gc", { desc = "Toggle Comment", remap = true })
      map("i", lhs, "<esc>gccgi", { desc = "Toggle Comment", remap = true })
    end
    map({ "n", "t" }, "<leader>t", function()
      local shell = vim.fn.has("win32") == 1 and vim.fn.executable("nu.exe") == 1 and { "nu.exe" } or nil
      Snacks.terminal.focus(shell, {
        cwd = LazyVim.root(),
        win = { position = "bottom" },
      })
    end, { desc = "Terminal (Root Dir)" })
    map("n", "<leader>z", function()
      if vim.fn.executable("zoxide") == 0 then
        vim.notify("zoxide is not installed", vim.log.levels.ERROR)
        return
      end

      vim.system({ "zoxide", "query", "-l" }, { text = true }, function(result)
        vim.schedule(function()
          if result.code ~= 0 then
            vim.notify(vim.trim(result.stderr or "zoxide query failed"), vim.log.levels.ERROR)
            return
          end

          local directories = {}
          for directory in (result.stdout or ""):gmatch("[^\r\n]+") do
            directories[#directories + 1] = directory
          end
          vim.ui.select(directories, {
            prompt = "Zoxide directory",
            kind = "zoxide",
            format_item = function(directory)
              return vim.fn.fnamemodify(directory, ":~")
            end,
          }, function(directory)
            if directory then
              vim.api.nvim_set_current_dir(directory)
              vim.notify("cwd: " .. vim.fn.fnamemodify(directory, ":~"))
            end
          end)
        end)
      end)
    end, { desc = "Jump to Directory (Zoxide)" })
    map("n", "<leader>uh", function()
      local filter = { bufnr = 0 }
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
    end, { desc = "Toggle Inlay Hints" })
  end,
})
