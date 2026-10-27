-- lua/config/filetypes.lua
--
-- Compound filetypes targeted by the LSP configs (ansiblels, yamlls,
-- marksman) that Neovim does not detect out of the box. Without these,
-- the servers never attach and :checkhealth vim.lsp reports them as
-- unknown filetypes.
vim.filetype.add {
  extension = {
    mdx = 'markdown.mdx',
  },

  filename = {
    ['.gitlab-ci.yml'] = 'yaml.gitlab',
    ['.gitlab-ci.yaml'] = 'yaml.gitlab',
    ['docker-compose.yml'] = 'yaml.docker-compose',
    ['docker-compose.yaml'] = 'yaml.docker-compose',
    ['compose.yml'] = 'yaml.docker-compose',
    ['compose.yaml'] = 'yaml.docker-compose',
  },

  pattern = {
    -- Ansible
    ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/group_vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*/host_vars/.*%.ya?ml'] = 'yaml.ansible',
    ['.*playbook%.ya?ml'] = 'yaml.ansible',

    -- Helm values files: subchart values always live under charts/,
    -- otherwise require a Chart.yaml next to (or above) the file
    ['.*/charts/.*/values.*%.ya?ml'] = 'yaml.helm-values',
    ['.*/values.*%.ya?ml'] = function(path)
      if vim.fs.root(path, 'Chart.yaml') then
        return 'yaml.helm-values'
      end
    end,
  },
}
