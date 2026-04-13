local vue_language_server_path =
    vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

return {
  cmd = { 'vtsls', '--stdio' },
  init_options = {
    hostInfo = 'neovim',
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
  },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = {
      preferences = {
        importModuleSpecifier = 'non-relative',
        updateImportsOnFileMove = {
          enabled = 'always',
        },
        suggest = {
          completeFunctionCalls = true,
        },
      },
    },
  },
}
