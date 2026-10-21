{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./keymaps.nix ];

  globals.mapleader = " ";
  globals.maplocalleader = "\\";

  opts = {
    clipboard = "unnamedplus";
    number = true;
    autowriteall = true;
    expandtab = true;
    shiftwidth = 4;
    softtabstop = 4;
    tabstop = 8;
    list = false;
    wrap = false;
    winborder = "rounded";
    swapfile = false;
    relativenumber = true;
    ignorecase = true;
    smartcase = true;
    cursorline = true;
    scrolloff = 20;
    confirm = true;
    undofile = true;
    autoread = true;
    foldmethod = "indent";
    foldlevel = 6;
    termguicolors = true;
  };

  plugins.mini = {
    enable = true;
    modules = {
      pick = { };
      files = { };
    };
  };

  extraPackages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.git
  ];

  extraConfigLua = lib.mkAfter ''
    vim.opt.fillchars:append({ eob = " " })

    local base16 = require("mini.base16")
    local palettes = {
      dark = base16.mini_palette("#282c34", "#abb2bf", 70),
      light = base16.mini_palette("#fafafa", "#383a42", 70),
    }

    local apply_palette = function()
      base16.setup({
        palette = palettes[vim.o.background] or palettes.dark,
        plugins = { default = false, ["nvim-mini/mini.nvim"] = true },
      })
    end

    apply_palette()
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = apply_palette,
    })
  '';
}
