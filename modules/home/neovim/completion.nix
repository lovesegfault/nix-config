{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        appearance.use_nvim_cmp_as_default = true;
        completion = {
          list.selection.preselect = false;
          documentation = {
            auto_show = true;
            window.border = "rounded";
          };
          ghost_text.enabled = true;
        };
        signature = {
          enabled = true;
          window.border = "rounded";
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "tmux"
          ];
          providers = {
            lsp.score_offset = 3;
            path.score_offset = 2;
            snippets.score_offset = 2;
            buffer.score_offset = 1;
            tmux = {
              name = "tmux";
              module = "blink.compat.source";
              score_offset = 0;
            };
          };
        };
        keymap = {
          preset = "enter";
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
          "<C-n>" = [
            "snippet_forward"
            "fallback"
          ];
          "<C-p>" = [
            "snippet_backward"
            "fallback"
          ];
        };
      };
    };
    cmp-tmux.enable = true;
    blink-compat.enable = true;
    friendly-snippets.enable = true;
  };
}
