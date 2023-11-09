{ lib, pkgs, ... }:
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
      git-blame-nvim
      plenary-nvim
      nvim-autopairs
      crates-nvim
      comment-nvim
      cmp-nvim-lsp
      undotree
      surround
      copilot-vim
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
      ${builtins.readFile config/tools.lua}
      ${builtins.readFile config/ai.lua}
      ${builtins.readFile config/oil.lua}
      ${builtins.readFile config/rust.lua}
      require('neodev').setup()
    '';
  };
}
