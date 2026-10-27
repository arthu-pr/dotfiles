## NOTE: Vue 3 + TypeScript support (Volar v3+ hybrid mode)

Volar v3 no longer handles TypeScript internally. It only provides
template/CSS/HTML intelligence for .vue files.

TypeScript inside <script> and <script setup> is handled by an external
TypeScript LSP (vtsls, ts_ls, or typescript-tools) with the
@vue/typescript-plugin enabled.

Official docs:

- Hybrid mode (Vue LS v3):
  https://github.com/vuejs/language-tools/wiki/Neovim#hybrid-mode
- Vue Language Tools (language-server) repo:
  https://github.com/vuejs/language-tools/tree/master/packages/language-server

- @vue/typescript-plugin (required for TS in .vue):
  https://github.com/vuejs/language-tools/tree/master/packages/typescript-plugin

- Volar v3 Migration Notice (no more takeover mode):
  https://github.com/vuejs/language-tools/pull/5248

Summary:
• vue_ls.lua → handles template/CSS/HTML
• vtsls.lua → handles TypeScript & forwards TS intelligence to vue_ls
• BOTH must be running for correct Vue + TS experience.
