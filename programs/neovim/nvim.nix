{ lib, config, pkgs, vimUtils, ... }:
let
  pluginGit = rev: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      rev = rev;
    };
  };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      onedark-nvim
      fugitive
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      oil-nvim
      harpoon
      neodev-nvim
      cmp-path
      cmp-buffer
      telescope-nvim
      telescope-fzf-native-nvim
      null-ls-nvim
      fidget-nvim
      (pluginGit "3af6232c8d39d51062702e875ff6407c1eeb0391" "xiyaowong/transparent.nvim")
      (pluginGit "9751fc0cb7041ba436c27a86f8faefc5ffe7f8bd" "octarect/telescope-menu.nvim")
    ] ++ [
      # Language Servers
      pkgs.gopls
      pkgs.rust-analyzer
      pkgs.nodePackages.typescript-language-server
      pkgs.clang-tools
      pkgs.pyright
      pkgs.cmake-language-server
      pkgs.nodePackages.bash-language-server
      pkgs.lua-language-server
      pkgs.nodePackages.vscode-html-languageserver-bin
      pkgs.nil
    ] ++ [
      # Formatters
      pkgs.stylua
      pkgs.nodePackages.prettier
      pkgs.nodePackages.fixjson
      pkgs.nodePackages.markdownlint-cli
      pkgs.python310Packages.autopep8
    ];
    extraConfig = ''lua << EOF
      vim.cmd[[colorscheme onedark]]
      ${builtins.readFile config/essentials.lua}
      ${builtins.readFile config/lsp.lua}
      ${builtins.readFile config/cmp.lua}
      ${builtins.readFile config/telescope.lua}
      ${builtins.readFile config/transparent.lua}
      ${builtins.readFile config/treesitter.lua}
      ${builtins.readFile config/format.lua}
      require('neodev').setup()
      vim.keymap.set('n', '<leader>fh', function()
        require('telescope.builtin').help_tags()
      end)
      vim.keymap.set('n', '<leader>gb', function()
        require('telescope.builtin').git_branches()
      end)
      vim.keymap.set('n', '<leader>gc', function()
        require('telescope.builtin').git_commits()
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
    '';
  };
}
