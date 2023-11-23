vim.g.mapleader = ' '
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir'
vim.o.undofile = true
vim.o.swapfile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
local format_group = vim.api.nvim_create_augroup('FormatGroup', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = format_group,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})
vim.cmd [[autocmd FileType * setlocal formatoptions-=cro]]

vim.keymap.set('n', '<leader>fh', function()
  require('telescope.builtin').help_tags()
end)
vim.keymap.set('n', '<leader>gb', function()
  require('telescope.builtin').git_branches()
end)
vim.keymap.set('n', '<leader>gc', function()
  require('telescope.builtin').git_commits()
end)
vim.keymap.set('n', '<leader>sd', function()
  require('telescope.diagnostics').git_branches()
end)
-- Writing file CTRL+S
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Write file' })
vim.keymap.set('i', '<C-s>', '<cmd>w<cr>', { desc = 'Write file' })

-- Git keybinds
vim.keymap.set('n', '<leader>gs', '<cmd>Git<CR>')
vim.keymap.set('n', '<C-b>', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

vim.api.nvim_create_user_command('W', function()
  vim.cmd 'w'
end, { nargs = 0 })
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>')

require('Comment').setup()
