
<div align="center">

# zencode-vc <!-- omit in toc -->

### [Zencode](https://dev.zenroom.org) journey implementing W3C Verifiable Credentials signature and verification. <!-- omit in toc -->

</div>

<p align="center">
  <a href="https://www.forkbomb.solutions/">
    <img src="https://forkbomb.solutions/wp-content/uploads/2023/05/forkbomb_logo_espressione.svg" width="170">
  </a>
</p>

***
<br><br>

Vist the [documentation page](https://forkbombeu.github.io/zencode-vc/) for more information.

***

<div id="toc">

### 🚩 Table of Contents <!-- omit in toc -->
- [🎮 Quick start](#-quick-start)
- [🧪 Tests](#-tests)
- [📝 Documentation](#-documentation)
- [🐛 Troubleshooting \& debugging](#-troubleshooting--debugging)
- [😍 Acknowledgements](#-acknowledgements)
- [👤 Contributing](#-contributing)
</div>



## 🎮 Quick start

To be able to run these tests you need the following dependencies to be available in your PATH:
* node@22
* slangroom-exec@^1.6.13
* zenroom@^5.19.1

We handle these deps with [mise](https://mise.jdx.dev/getting-started.html#installing-mise-cli) and simply install them with

```sh
make deps
```

without it you can still run zencode-vc, but you have to install the dependencies by hand:
* node: follow the steps on [nodejs.org](https://nodejs.org/en/download)
* slangroom-exec
	```sh
	wget "https://github.com/dyne/slangroom-exec/releases/latest/download/slexfe" \
		-O "/usr/local/bin/slexfe";
	chmod +x /usr/local/bin/slexfe;
	wget "https://github.com/dyne/slangroom-exec/releases/latest/download/slangroom-exec-$(uname)-$(uname -m)" \
		-O "/usr/local/bin/slangroom-exec";
	chmod +x /usr/local/bin/slangroom-exec;
	```
* zenroom:
	```sh
	wget "https://github.com/dyne/zenroom/releases/latest/download/zenroom" \
		-O "/usr/local/bin/zenroom";
	chmod +x /usr/local/bin/zenroom;
	```

**[🔝 back to top](#toc)**
***

## 🧪 Tests

To run zencode-vc tests, after have done the above steps, simply run
```sh
make
```

**[🔝 back to top](#toc)**
***

## 📝 Documentation

The above step other then running the tests produce also the documentation that can be simply serve with the help
of vitepress simply running
```
make preview
```

## 🐛 Troubleshooting & debugging

Availabe bugs are reported via [GitHub issues](https://github.com/forkbombEu/zencode-vc/issues).

**[🔝 back to top](#toc)**

---
## 😍 Acknowledgements

Copyright © 2025 by [Forkbomb BV](https://www.forkbomb.solutions/), Amsterdam

**[🔝 back to top](#toc)**

---
## 👤 Contributing

1.  🔀 [FORK IT](../../fork)
2.  Create your feature branch `git checkout -b feature/branch`
3.  Commit your changes `git commit -am 'feat: New feature\ncloses #398'`
4.  Push to the branch `git push origin feature/branch`
5.  Create a new Pull Request `gh pr create -f`
6.  🙏 Thank you


**[🔝 back to top](#toc)**