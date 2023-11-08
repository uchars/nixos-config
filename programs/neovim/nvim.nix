{ lib, config, pkgs, vimUtils, ... }:
let
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
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
      luasnip
      oil-nvim
      harpoon
      cmp-path
      cmp-buffer
      telescope-nvim
      (pluginGit "lua" "xiyaowong/transparent.nvim")
    ];
    extraConfig = ''lua << EOF
      vim.cmd[[colorscheme onedark]]
      require("transparent").setup({ -- Optional, you don't have to run setup.
          extra_groups = {}
      })
    '';
  };
}
