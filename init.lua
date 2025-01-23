

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
vim.opt.formatoptions   = 'croq'
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
    { "blazkowolf/gruber-darker.nvim", opts = { bold = false, italic = { strings = false, comments = false } } },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'github/copilot.vim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'echasnovski/mini.nvim', version = false },
})

-- vim.cmd("COQnow --shut-up")
-- require 'nvim-treesitter.install'.compilers = { "clang", "cl" }

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
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

-- --- Language Server Protocol ------------------------------------------------

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', '<leader>jtd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', '<leader>jtD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', '<leader>ji', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', '<leader>jd', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', '<leader>jr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', '<leader>js', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<leader>jn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
  cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
  init_options = {
    fallbackFlags = { '-std=c++17' },
  },
})

require('mini.completion').setup()
