import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Zencode VCs",
  description: "Simple implementation guide for verifiable credentials using Zencode: easy, secure, interoperable and cross-country.",
  base: "/zencode-w3c-vc/",
  srcDir: "./src",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    footer: {
     message: 'Funded by Horizon Europe - NGI <a href="https://ngisargasso.eu/">Sargasso</a> - GA nr. <a href="https://cordis.europa.eu/project/id/101092887">101092887</a>',
     copyright: 'Copyright (C) 2025 <a href="https://forkbomb.solutions">Forkbomb BV</a> - GNU GPL License'
    },
    nav: [
      { text: 'Home', link: '/' },
      { text: 'DIDRoom', link: 'https://didroom.com' },
      { text: 'Credimi', link: 'https://credimi.io' },
      { text: 'Zenroom', link: 'https://zenroom.org' },
      { text: 'Zencode', link: 'https://dev.zenroom.org' },
      { text: 'Slangroom', link: 'https://dyne.org/slangroom' },
      { text: 'The Forkbomb Company', link: 'https://forkbomb.solutions' },

    ],
    sidebar: [
      {
        text: 'Language bindings',
        items: [
          { text: 'How to embed', link: 'https://dev.zenroom.org/#/pages/how-to-embed' },
          { text: 'Javascript', link: 'https://dev.zenroom.org/#/pages/javascript' },
          { text: 'Python', link: 'https://dev.zenroom.org/#/pages/python' },
          { text: 'Java', link: 'https://dev.zenroom.org/#/pages/java' },
          { text: 'Golang', link: 'https://github.com/dyne/Zenroom/tree/master/bindings/golang/zenroom' },
          { text: 'Zig', link: 'https://github.com/dyne/Zenroom/tree/master/bindings/zig' },
          { text: 'Rust', link: 'https://github.com/dyne/Zenroom/tree/master/bindings/rust' }
        ]
      },
      {
        text: 'Integration guides',
        items: [
          { text: 'Node.js', link: 'https://dev.zenroom.org/#/pages/zenroom-javascript1b' },
          { text: 'Browser', link: 'https://dev.zenroom.org/#/pages/zenroom-javascript2b' },
          { text: 'React', link: 'https://dev.zenroom.org/#/pages/zenroom-javascript3' }
        ]
      },
      {
        text: 'Mobile native',
        items: [
          { text: 'Android', link: 'https://dev.zenroom.org/#/pages/zenroom-react-native?id=android-setup' },
          { text: 'iOS', link: 'https://dev.zenroom.org/#/pages/zenroom-react-native?id=ios-setup' }
        ]
      }
    ],
    socialLinks: [
      { icon: 'linkedin', link: 'https://linkedin.com/company/forkbomb' },
      { icon: 'github', link: 'https://github.com/dyne/zencode-w3c-vc' },
      { icon: 'maildotru', link: 'mailto:info@forkbomb.eu' }
    ]
  },
  markdown: {
    theme: {
      light: "catppuccin-latte",
      dark: "catppuccin-mocha",
    }
  }
})
