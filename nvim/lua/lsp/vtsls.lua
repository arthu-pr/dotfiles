return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = require("mason-registry").get_package("vue-language-server"):get_install_path()
              .. "/node_modules/@vue/typescript-plugin",
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
    typescript = {
      preferences = {
        importModuleSpecifier = "non-relative",
        updateImportsOnFileMove = {
          enabled = "always",
        },
        suggest = {
          completeFunctionCalls = true,
        },
      },
    },
  },
}
