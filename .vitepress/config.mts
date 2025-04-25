import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Zencode W3C VC",
  description: "Dyne.org W3C VC based on W3C standard and implemented using Zencode.",
  base: "/zencode-w3c-vc/",
  srcDir: "./src",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'DIDRoom', link: 'https://didroom.com' },
      { text: 'Credimi', link: 'https://credimi.io' },
      { text: 'Zenroom', link: 'https://zenroom.org' },
      { text: 'Zencode', link: 'https://dev.zenroom.org' },
      { text: 'Slangroom', link: 'https://dyne.org/slangroom' },
    ],

    sidebar: [
      {
        text: 'Use in your app',
        items: [
          { text: 'How to embed', link: 'https://dev.zenroom.org/#/pages/how-to-embed' },
          { text: 'Javascript', link: 'https://dev.zenroom.org/#/pages/javascript' },
          { text: 'Python', link: 'https://dev.zenroom.org/#/pages/python' },
          { text: 'Java', link: 'https://dev.zenroom.org/#/pages/java' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'linkedin', link: 'https://linkedin.com/company/forkbomb' },
      { icon: 'github', link: 'https://github.com/dyne/zencode-w3c-vc' },
      { icon: 'maildotru', link: 'mailto:info@forkbomb.eu' }
    ]
  }
})
