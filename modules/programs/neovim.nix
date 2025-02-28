{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  options.neovim.enable = mkEnableOption "a terminal text editor";

  config = mkIf config.neovim.enable {
    programs.nixvim = {
      enable = true;

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "frappe";
        };
      };

      plugins = {
        telescope.enable = true;
        oil = {
          enable = true;
          settings.view_options.is_hidden_file = "function(name, bufnr) return name ~= \"..\" and vim.startswith(name, \".\") end,";
        };
        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;
          };
        };
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings.sources = [
            { name = "nvim_lsp"; }
          ];
        };
        web-devicons.enable = true;
        treesitter = {
          enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            lua
            nix
            vim
            yaml
          ];
          nixvimInjections = true;
          settings.highlight.enable = true;
        };
      };
    };
  };
}
