vim.pack.add({
  { src = "https://github.com/mrcjkb/rustaceanvim" }, -- better rust LSP
  { src = "https://github.com/saecki/crates.nvim" },  -- better crate helpers
})

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
    hover_actions = {
      auto_focus = true,
    }
  },
  -- LSP configuration
  server = {
    default_settings = {
      -- rust-analyzer settings
      ['rust-analyzer'] = {
        -- Enable all features
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        -- Add clippy lints
        check = {
          command = "clippy",
          extraArgs = {
            "--",
            "-W", "clippy::all",
            "-W", "clippy::pedantic",
            "-W", "clippy::nursery",
            "-A", "clippy::module_name_repetitions",
            "-A", "clippy::must_use_candidate",
          },
        },
        procMacro = {
          enable = true,
        },
        diagnostics = {
          enable = true,
          experimental = {
            enable = true,
          },
        },
        -- Import settings
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        -- Assist settings to help with code actions
        assist = {
          importEnforceGranularity = true,
          importPrefix = "self",
          expressionFillDefault = "todo",
        },
        -- Inlay hints
        inlayHints = {
          bindingModeHints = {
            enable = false,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = {
            enable = "never"
          },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = {
            enable = true,
          },
          reborrowHints = {
            enable = "never",
          },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          }
        }
      }
    }
  }
}

require "crates".setup {
  popup = {
    autofocus = true,
    border = "rounded"
  }
}
