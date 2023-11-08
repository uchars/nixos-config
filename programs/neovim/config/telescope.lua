require('telescope').setup {
  extensions = {
    menu = {
      test = {
        items = {
          {
            'Run Current',
            function()
              require('neotest').run.run()
            end,
          },
          {
            'Run File',
            function()
              require('neotest').run.run(vim.fn.expand '%')
            end,
          },
          {
            'Stop All',
            function()
              require('neotest').run.stop()
            end,
          },
          {
            'Toggle Summary',
            function()
              require('neotest').summary.toggle()
            end,
          },
        },
      },
      default = {
        items = {
          { 'Checkhealth',                  'checkhealth' },
          { 'Files',                        'Telescope find_files' },
          { 'Run Tests',                    "lua require('neotest').run.run(vim.fn.expand('%'))" },
          { 'Zen Mode Enable/Disable',      'ZenMode' },
          { 'Change Colorscheme',           'Telescope colorscheme' },
          { 'Markdown Preview',             'MarkdownPreviewToggle' },
          { 'Toggle Terminal',              'ToggleTerm' },
          { 'npm start',                    'tabnew npm start | term npm start' },
          { 'Prettier',                     'Prettier' },
          { 'Toggle Indent Lines',          'IndentBlanklineToggle' },
          { 'Diffview Open',                'DiffviewOpen' },
          { 'Diffview Close',               'DiffviewClose' },
          { 'Toggle Filetree',              'NvimTreeToggle' },
          { 'Toggle Treesitter Context',    'TSContextToggle' },
          { 'LSP Restart',                  'LspRestart' },
          { 'Remove all // comments',       '%s/\\/\\/.*//g' },
          { 'Remove all # comments',        '%s/#.*//g' },
          { 'Package Manager',              'Lazy' },
          { 'Show Undo Tree',               'UndotreeToggle' },
          { 'Copilot disable',              'Copilot disable' },
          { 'Copilot enable',               'Copilot enable' },
          { 'Copilot restart',              'Copilot restart' },
          { 'Toggle Spell check',           'set spell!' },
          { 'Open Blame Commit in Browser', 'GitBlameOpenCommitURL' },
          { 'Toggle Git Blame',             'GitBlameToggle' },
          { 'Refresh Colorizer',            'ColorizerReloadAllBuffers' },
          { 'Toggle Colorizer',             'ColorizerToggle' },
          { 'Show TODO',                    'TodoTelescope' },
          { 'Test',                         'Telescope menu test' },
        },
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'menu')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<C-f>', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })
vim.keymap.set('n', '<leader>fh', function()
  require('telescope.builtin').help_tags()
end)
vim.keymap.set('n', '<M-p>', '<cmd>Telescope menu<cr>')
vim.keymap.set('t', '<M-p>', '<cmd>Telescope menu<cr>')
