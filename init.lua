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
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = gruvbox_theme_configuration },
    { 'nvim-treesitter/nvim-treesitter' },
})

-- --- Set Colorscheme ---------------------------------------------------------

vim.cmd([[colorscheme gruvbox]])

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




