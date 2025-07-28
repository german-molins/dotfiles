import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
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
          {
            text: 'Tools',
            collapsed: true,
            items: [
              { text: "Mise", link: '/tools/mise' },
              { text: "Git", link: '/tools/git' },
              { text: "Neovim", link: '/tools/nvim' }
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
