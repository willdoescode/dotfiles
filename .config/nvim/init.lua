-- init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
local g = vim.g

-- Speed up startup
g.loaded_python3_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1

-- Basic settings
opt.hidden = true
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.updatetime = 100
opt.timeoutlen = 300
opt.scrolloff = 8
opt.shortmess:append("sIc")
opt.lazyredraw = true
opt.showmode = false

-- Additional UI improvements
opt.cursorline = true           -- Highlight current line
opt.signcolumn = "yes"          -- Always show sign column
opt.colorcolumn = "80"          -- Show line length marker
opt.list = true                 -- Show invisible characters
opt.listchars = {               -- Define invisible characters
  tab = "→ ",
  trail = "·",
  extends = "▶",
  precedes = "◀",
}
opt.splitright = true           -- Open vertical splits to the right
opt.splitbelow = true           -- Open horizontal splits below
opt.wrap = false               -- Disable line wrapping

-- Indentation settings (global)
opt.expandtab = true      -- Use spaces instead of tabs
opt.shiftwidth = 2        -- Size of an indent
opt.tabstop = 2          -- Size of a tab
opt.softtabstop = 2      -- Size of a soft tab
opt.autoindent = true    -- Copy indent from current line when starting new line
opt.smartindent = true   -- Smart autoindenting on new lines

-- Transparency settings
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Better completion performance
opt.complete:remove({ 'i' })
opt.completeopt = 'menuone,noselect'

-- File settings
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.swapfile = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true      -- Highlight search results
opt.incsearch = true     -- Show search matches as you type

-- Mouse and clipboard integration
opt.mouse = "a"                               -- Enable mouse support
opt.clipboard = "unnamedplus"                 -- Use system clipboard

-- Create in a function to ensure all dependencies are loaded
local function setup_keymaps()
  -- Clear the space key first
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
  
  -- Essential keymaps with descriptive names for which-key
  vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true, desc = "Save file" })
  vim.keymap.set('n', '<leader>q', ':q<CR>', { silent = true, desc = "Quit" })
  vim.keymap.set('n', '<leader>h', ':nohl<CR>', { silent = true, desc = "Clear highlights" })
  
  -- Additional keymaps
  vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true, desc = "Save file" })
  vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Move to left window" })
  vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Move to bottom window" })
  vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Move to top window" })
  vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Move to right window" })
  vim.keymap.set('n', '<S-l>', ':bnext<CR>', { silent = true, desc = "Next buffer" })
  vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { silent = true, desc = "Previous buffer" })
end

setup_keymaps()

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Fast plugins setup
require("lazy").setup({
  -- Essential plugins
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    priority = 1000,
    config = function()
      require('nvim-treesitter.configs').setup({
        sync_install = true,
        ensure_installed = { "lua", "rust", "python", "bash" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "bash" }
        },
        indent = { enable = true },
        -- Enable additional modules
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          enable = true,
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  },

  -- Better UI
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {}
      },
    },
  },

  -- Fast completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer', keyword_length = 5 },
          { name = 'path' },
        },
        performance = {
          max_view_entries = 30,
        },
      })
    end
  },

-- Modern fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    cmd = 'Telescope',
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "dist/" },
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
      -- Key bindings for Telescope
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help tags" })
    end,
  },

  -- Auto-pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Better commenting
  {
    'numToStr/Comment.nvim',
    event = "VeryLazy",
    config = function()
      require('Comment').setup()
    end,
  },

  -- Git signs (lazy loaded)
  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      numhl = false,
      linehl = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
    }
  },
  
  -- ZSH support
  {
    "chrisbra/vim-zsh",
    ft = "zsh",
    config = function()
      -- Ensure proper ZSH file detection
      vim.filetype.add({
        extension = {
          zsh = "zsh",
        },
        filename = {
          [".zshrc"] = "zsh",
          [".zshenv"] = "zsh",
          [".zprofile"] = "zsh",
          [".zlogin"] = "zsh",
          [".zlogout"] = "zsh",
        },
      })
    end
  },
})

-- LSP Configuration
require("mason").setup({
  ui = {
    border = "none",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "rust_analyzer", "pyright" },
  automatic_installation = true,
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

local servers = { 'rust_analyzer', 'pyright', 'lua_ls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  })
end

-- Optimize Lazy loading
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    vim.schedule(function()
      local stats = require("lazy").stats()
      print(stats.details)
    end)
  end
})

-- Performance optimizations for large files
local group = vim.api.nvim_create_augroup("large_file", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*",
  group = group,
  callback = function()
    local buffer = vim.fn.expand("<afile>")
    local size = vim.fn.getfsize(buffer)
    if size > 1024 * 1024 then  -- 1MB
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
      vim.opt_local.undofile = false
      vim.opt_local.swapfile = false
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
    end
  end,
})

-- Restore cursor position
local cursor_position = vim.api.nvim_create_augroup("cursor_position", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  group = cursor_position,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ZSH specific settings
local zsh_group = vim.api.nvim_create_augroup("zsh_config", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  group = zsh_group,
  callback = function()
    vim.bo.commentstring = '# %s'
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})


-- Performance optimizations for position restoration
vim.opt.shada = "!,'1000,<50,s10,h"  -- Optimize shada file settings for faster loading
