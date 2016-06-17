npm-package-integrity
=====================

basic prepublish test for an npm package's integrity. runs `npm pack` then attempts to `require` the resulting tarball.

how
---

`npm install --save-dev npm-package-integrity`, and in your package.json:

```json
{
	"scripts": {
		"prepublish": "npm-package-integrity"
	}
}
```

why
---

there's a bug (npm/npm#5082) that's particularly painful in node 6 and causes missing files in your package in certain circumstances. i've been bitten by it a few times. the packages are broken enough that `require` just doesn't work, so that's a good prepublish test.

who
---

matt brennan. MIT licence 
