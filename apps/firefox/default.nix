{ pkgs, firefox-addons, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "Jack";
      isDefault = true;

      settings = {
        "browser.startup.homepage" = "https://searx.aicampground.com";
      };

      search = {
        force = true;
        default = "Searx";
        order = [ "Searx" "google" ];
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type";  value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Wiki" = {
            urls = [{
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nw" ];
          };

          "Searx" = {
            urls = [{
              template = "https://searx.aicampground.com/?q={searchTerms}";
            }];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@searx" ];
          };

          "bing".metaData.hidden = true;
          "google".metaData.alias = "@g";
        };
      };

      extensions = {
        packages = with firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          bitwarden
        ];
      };
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      HttpsOnlyMode = "enabled";

      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Preferences = {
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.enabled" = false;

        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.warnOnQuitShortcut" = false;

        "browser.tabs.hoverPreview.enabled" = false;
        "browser.tabs.hoverPreview.showThumbnails" = false;

        "browser.ml.chat.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;

        "layout.css.prefers-color-scheme.content-override" = 0;

        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;

        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.autofillForms.autologin" = false;

        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.addresses.enabled" = false;

        "permissions.default.geo"        = 2;
        "permissions.default.camera"     = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.xr"         = 2;

        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled"                = false;
        "toolkit.telemetry.unified"                = false;
        "toolkit.telemetry.archive.enabled"        = false;
        "browser.ping-centre.telemetry"           = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        "dom.security.https_only_mode" = true;

        "extensions.autoDisableScopes" = 0;
      };
    };
  };
}

