import { defineConfig } from 'vitepress'
import d2 from 'vitepress-plugin-d2'
import { Layout, Theme, FileType } from 'vitepress-plugin-d2/dist/config'

export default defineConfig({
  title: "Dotfiles",
  description: "Personal development environment",
  base: '/dotfiles/',
  themeConfig: {
    search: {
      provider: 'local'
    },
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
          { text: 'Chezmoi', link: '/chezmoi' },
          { text: "Home Directory", link: '/home' },
          { text: 'Bash', link: '/bash' },
          { text: 'Agents', link: '/agents' },
          {
            text: 'Tools',
            link: "/tools",
            collapsed: true,
            items: [
              { text: "Bash", link: '/tools/bash' },
              { text: "Mise", link: '/tools/mise' },
              { text: "fnox", link: '/tools/fnox' },
              { text: "System Dependencies", link: '/tools/system_dependencies' },
              { text: "General Utils", link: '/tools/utils' },
              { text: "Zellij", link: '/tools/zellij' },
              { text: "Git", link: '/tools/git' },
              { text: "Lazygit", link: '/tools/lazygit' },
              { text: "Jujutsu", link: '/tools/jj' },
              { text: "Jujutsu UI", link: '/tools/jjui' },
              { text: "Atuin", link: '/tools/atuin' },
              { text: "Neovim", link: '/tools/nvim' },
              { text: "Zk", link: '/tools/zk' },
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
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/german-molins/dotfiles' }
    ]
  },

  markdown: {
    config: (md) => {
      md.use(d2, {
        layout: Layout.ELK,
        theme: Theme.NEUTRAL_DEFAULT,
        darkTheme: Theme.DARK_MUAVE,
        fileType: FileType.SVG,
      })
    }
  }
})
