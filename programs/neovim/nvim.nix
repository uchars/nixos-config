{ lib, pkgs, ... }:
let
  pluginGit = rev: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        rev = rev;
      };
    };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # lsp
      cmp-nvim-lsp
      nvim-lspconfig
      cmp-path
      cmp-buffer
      neodev-nvim
      nvim-cmp

      # helpful
      copilot-vim
      luasnip

      # ui
      nvim-treesitter.withAllGrammars
      onedark-nvim
      zen-mode-nvim
      (pluginGit "29be0919b91fb59eca9e90690d76014233392bef"
        "lukas-reineke/indent-blankline.nvim")

      fugitive
      git-blame-nvim
      plenary-nvim
      nvim-autopairs
      crates-nvim
      comment-nvim
      undotree
      surround
      oil-nvim
      harpoon
      telescope-nvim
      telescope-fzf-native-nvim
      null-ls-nvim
      fidget-nvim
      (pluginGit "3af6232c8d39d51062702e875ff6407c1eeb0391"
        "xiyaowong/transparent.nvim")
      (pluginGit "9751fc0cb7041ba436c27a86f8faefc5ffe7f8bd"
        "octarect/telescope-menu.nvim")
    ];
    extraConfig = ''
      lua << EOF
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
            ${builtins.readFile config/indent-blankline.lua}
            require('neodev').setup()
    '';
  };
}
