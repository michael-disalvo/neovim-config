local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.runtimepath:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    -- import your plugins 
    -- config runs when this function is loaded ,
    { "drewtempelmeyer/palenight.vim", enabled = true, config = function() vim.cmd.colorscheme "palenight" end },
    { "nvim-tree/nvim-web-devicons" },
    { "tpope/vim-surround" },
    { 'junegunn/fzf' },
    { 'nvim-lua/plenary.nvim' },
    { dir = "~/.vim/plugged/vim-go" },
    
    -- or, we can have a lua file in config/plugins that contain specs for a plugin 
    { import = "custom.plugins" },

    -- local plugins
    { dir = "~/configs/nvim/plugins/present.nvim", config = function() require("present") end  },
  },

  ui = {
    border = "rounded",
  }
})
