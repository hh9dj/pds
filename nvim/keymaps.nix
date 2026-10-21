{ ... }:
{
  keymaps = [
    {
      mode = "n";
      key = "zz";
      action = "<cmd>qa<cr>";
      options.desc = "[Q]uit all";
    }
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Disable Search Highlight";
    }
    {
      mode = "n";
      key = "<leader><space>";
      action.__raw = ''function() require("mini.pick").builtin.files() end'';
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action.__raw = ''function() require("mini.pick").builtin.grep_live() end'';
      options.desc = "Grep";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = ''function() require("mini.files").open() end'';
      options.desc = "File [E]xplorer";
    }
  ];
}
