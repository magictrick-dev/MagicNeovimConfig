
-- --- Lazy Loader -------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- Base Configuration Settings ---------------------------------------------

vim.opt.tabstop         = 4
vim.opt.expandtab       = true
vim.opt.shiftwidth      = 4
vim.opt.relativenumber  = true
vim.opt.number          = true
vim.opt.colorcolumn     = { 80, 100 }
vim.opt.cursorline      = true
vim.g.leader            = '\\'

-- --- Plugins Installation ----------------------------------------------------

local gruvbox_theme_configuration =
{
    italic =
    {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
    },
}

require("lazy").setup({
    { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-treesitter/nvim-treesitter' },
    { "blazkowolf/gruber-darker.nvim",   opts = { bold = false, italic = { strings = false, comments = false } } },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }
})

-- vim.cmd("COQnow --shut-up")
-- require 'nvim-treesitter.install'.compilers = { "clang", "cl" }

require('nvim-treesitter.configs').setup {
    highlight = { 
        enable = true,
    },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
      lualine_a = {'filename'},
      lualine_c = {'windows'},
  },
  winbar = {
  },
  inactive_winbar = {},
  extensions = {}
}

-- --- Set Colorscheme ---------------------------------------------------------

vim.cmd("colorscheme gruber-darker")

-- --- Maps Configurations -----------------------------------------------------

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').treesitter, {})

vim.keymap.set('n', '<C-i>', ':bnext<cr>', {})          -- Next buffer.
vim.keymap.set('n', '<S-tab>', ':bprevious<cr>', {})    -- Prev buffer.
vim.keymap.set('n', '<leader>bk', ':bp|bd! #<cr>', {})  -- Kill buffer.
vim.keymap.set('n', '<leader>bs', ':vsplit<cr><C-w><C-w>', {})    -- Split buffer.
vim.keymap.set('n', '<leader>bn', ':bn<cr>', {})        -- new buffer.

vim.keymap.set('n', '<leader>ls', '^', {})
vim.keymap.set('n', '<leader>le', '$', {})

vim.keymap.set('n', '<leader>dl', 'dd', {})
vim.keymap.set('n', '<leader>drl', 'ddO', {})
vim.keymap.set('n', '<leader>de', 'd$', {})
vim.keymap.set('n', '<leader>dre', 'd$a', {})

vim.keymap.set('n', '<leader>d(', 'F(lvf)hd<esc>', {})
vim.keymap.set('n', '<leader>dr(', 'F(lvf)hd<esc>i', {})

vim.keymap.set('n', '<leader>d"', 'F"lvf"hd<esc>', {})
vim.keymap.set('n', '<leader>dr"', 'F"lvf"hd<esc>i', {})




