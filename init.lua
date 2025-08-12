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
vim.opt.signcolumn      = 'yes'

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
    {
        "neovim/nvim-lspconfig",
        config = function() 
            require'lspconfig'.clangd.setup{}  
        end,
    },
    { 'hrsh7th/cmp-nvim-lsp'    },
    { 'hrsh7th/cmp-buffer'      },
    { 'hrsh7th/cmp-path'        },
    { 'hrsh7th/cmp-cmdline'     },
    { 'hrsh7th/nvim-cmp'        },
    { 'hrsh7th/cmp-vsnip'       },
    { 'hrsh7th/vim-vsnip'       },
})

local lspconfig = require("lspconfig")

local on_attach = function(_, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- Jump to definition
  bufmap("n", "gd", vim.lsp.buf.definition)
  -- Jump to declaration
  bufmap("n", "gD", vim.lsp.buf.declaration)
  -- Show hover docs
  bufmap("n", "gk", vim.lsp.buf.hover)
  -- List references
  bufmap("n", "gr", vim.lsp.buf.references)
  -- Show signature help
  bufmap("n", "gh", vim.lsp.buf.signature_help)
end

lspconfig.clangd.setup({
    on_attach = on_attach,
    cmd = { "clangd", "--compile-commands-dir=build" }, -- set if not in project root
})

-- Set up nvim-cmp.
local cmp = require'cmp'
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
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
vim.keymap.set('n', 'gD',   '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gd',   '<cmd>lua vim.lsp.buf.definition()<CR>')
