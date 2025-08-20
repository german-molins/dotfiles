import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Dotfiles",
  description: "Personal development environment",
  base: '/dotfiles/',
  themeConfig: {
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Documentation', link: '/welcome' }
    ],

    sidebar: [
      {
        text: 'Developer Guide',
        link: "dev_guide",
        items: [
          { text: 'Setup', link: '/setup' },
          { text: "Home Directory", link: '/home' },
          { text: 'Agents', link: '/agents' },
          {
            text: 'Tools',
            link: "/tools",
            collapsed: true,
            items: [
              { text: "Mise", link: '/tools/mise' },
              { text: "System Dependencies", link: '/tools/system_dependencies' },
              { text: "General Utils", link: '/tools/utils' },
              { text: "Zellij", link: '/tools/zellij' },
              { text: "Git", link: '/tools/git' },
              { text: "Lazygit", link: '/tools/lazygit' },
              { text: "Atuin", link: '/tools/atuin' },
              { text: "Neovim", link: '/tools/nvim' },
              { text: "http", link: '/tools/http' },
              { text: "uutils", link: '/tools/uutils' },
              { text: "tldr", link: '/tools/tldr' },
            ]
          }
        ]
      },
      {
        text: "Package Managers",
        link: "/package_managers",
        items: [
          { text: "Mise", link: "/mise_global_tasks" },
          { text: "Devbox", link: "devbox_global" }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/german-molins/dotfiles' }
    ]
  }
})
