{ config, lib, ... }:
{
  plugins = {
    navic = {
      enable = true;
      settings.lsp.auto_attach = true;
    };
    lualine =
      let
        filetype = {
          __unkeyed-1 = "filetype";
          icon_only = true;
        };
        filename = {
          __unkeyed-1 = "filename";
          symbols = {
            modified = "●";
            readonly = "🔒";
            unnamed = "[No Name]";
            newfile = "[New]";
          };
        };
        diff = {
          __unkeyed-1 = "diff";
          symbols = {
            added = " ";
            modified = " ";
            removed = " ";
          };
        };
        diagnostics = {
          __unkeyed-1 = "diagnostics";
          sources = [ "nvim_lsp" ];
          symbols = {
            error = " ";
            warn = " ";
            info = " ";
            hint = " ";
          };
        };
      in
      {
        enable = true;
        settings = {
          inactive_sections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [
              filetype
              filename
            ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [
              filetype
              filename
              "navic"
            ];
            lualine_c = [
              diagnostics
            ];
            lualine_x = [
              "searchcount"
              diff
              "branch"
            ];
            lualine_y = [
              "encoding"
              "fileformat"
            ];
            lualine_z = [
              "location"
              "progress"
            ];
          };
          options = {
            theme = "auto";
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "";
              right = "";
            };
          };
        };

      };
  };
}
