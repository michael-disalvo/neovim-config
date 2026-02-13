require("custom.lazy")

vim.o.hlsearch = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.wrap = false
vim.o.mouse = ""
vim.o.linebreak = true
vim.o.scrolloff = 1
vim.o.sidescrolloff = 5
vim.o.nu = true
vim.o.relativenumber = true
vim.o.title = true
vim.o.cursorline = true
vim.o.guicursor = "i:block"
vim.opt.signcolumn = "yes:1"

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
vim.keymap.set("v", "Y", '"+y')
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")

vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = "clip.exe",
    ["*"] = "clip.exe",
  },
  paste = {
    ["+"] = {
      "powershell.exe",
      "-NoLogo",
      "-NoProfile",
      "-c",
      '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    ["*"] = {
      "powershell.exe",
      "-NoLogo",
      "-NoProfile",
      "-c",
      '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
  },
  cache_enabled = 0,
}

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local cursorline_group = vim.api.nvim_create_augroup(
  "CursorLineOnlyInActiveWindow",
  { clear = true }
)

vim.api.nvim_create_autocmd(
  { "VimEnter", "WinEnter", "BufWinEnter" },
  {
    group = cursorline_group,
    callback = function()
      vim.opt_local.cursorline = true
    end,
  }
)

vim.api.nvim_create_autocmd(
  "WinLeave",
  {
    group = cursorline_group,
    callback = function()
      vim.opt_local.cursorline = false
    end,
  }
)

