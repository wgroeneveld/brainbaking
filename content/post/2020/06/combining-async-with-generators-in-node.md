---
title: "Combining async with generators in Node 11"
date: '2020-06-11'
subtitle: "Feel like blowing up your colleagues heads? Use async function*!"
tags:
  - javascript
  - node
---

Whizbang time! So, I was in need of a simple resursive Javascript function that iterates over all directories to look for `.md` Markdown files, to feed it to a search indexer. This is a node script my deploy script utilizes when updating this website. My Hugo content directory looks like this nowadays:

```
content/
    post/
        2020/
            06/
                article1.md
                article2.md
            05/
                article3.md
        2019/
            12/
                article4.md
```

This means that the URL structure of articles on Brain Baking changed (for the better) to [/post/2020/06/combining-async-with-generators-in-node/](/post/2020/06/combining-async-with-generators-in-node/). Instead of simply using `fs.readdir()` in the `content/` folder, I had to use a bit of recursion because of the slightly more complex directory structure. 

And then I found an interesting [Stackoverflow post](https://stackoverflow.com/questions/5827612/node-js-fs-readdir-recursive-directory-search), explaining how to do it in node 8, 10.10+, and 11+. And my god, things did not stand still, did they. As is usually the case in the JS world. 

### Node 8: Using await/async

Since most filesystem related node calls are asynchronous, you use a good amount of `await` and `async` when writing the code:

```js
const { promisify } = require('util');
const { resolve } = require('path');
const fs = require('fs');
const readdir = promisify(fs.readdir);
const stat = promisify(fs.stat);

async function getFiles(dir) {
  const subdirs = await readdir(dir);
  const files = await Promise.all(subdirs.map(async (subdir) => {
    const res = resolve(dir, subdir);
    return (await stat(res)).isDirectory() ? getFiles(res) : res;
  }));
  return files.reduce((a, f) => a.concat(f), []);
}
```

What's happening? Nothing special, once you get the hang of Javascript's [async functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function). Usage is also simple: `getFiles('post').then(doStuffWithFiles)`. In fact, `async` is just syntactic sugar for `Promise.resolve()`. According to MDN, this:

```js
async function sup() {
    return "yo";
}
```

is equivalent to:

```js
function sup() {
    return Promise.resolve("yo");
}
```

since nothing asynchronous is happening at all, the `Promise` object can immediately resolve, and you can carry on with doing whatever it is you plan on doing. Oh, and `util.promisify()` is a Node 8 trinket that converts callback-based functions into Promise-based ones. The last function of `readdir()` is a callback function, and otherwise, we would end up nesting functions in functions in functions in ... - the only requirement is that you follow Node's callback style. A function template like `const myfn = (delay, callback) => { };` fits.

And yes, there's a [polyfill for that](https://github.com/ljharb/util.promisify).

### Node 10.10: Spreading it out

```js
const { resolve } = require('path');
const { readdir } = require('fs').promises;

async function getFiles(dir) {
  const dirents = await readdir(dir, { withFileTypes: true });
  const files = await Promise.all(dirents.map((dirent) => {
    const res = resolve(dir, dirent.name);
    return dirent.isDirectory() ? getFiles(res) : res;
  }));
  return Array.prototype.concat(...files);
}
```

The spread operator `...` makes our `reduce()` redundant, but the most important change here is `requie('fs').promises` instead of `promisify()` and a slightly changed API usage of that. Things are starting to get a bit woozy here. 

For instance, did you know that the [Bluebird Promise library](http://bluebirdjs.com/docs/why-bluebird.html) claims to be significantly faster than native ES6 Promise implementations? Of course, there are other reasons to resort to Bluebird, such as compatibility and utility functions. It should work even in Netscape! Yay - who still cares about that? 

### Node 11: Combining async with generator functions

```js
const { resolve } = require('path');
const { readdir } = require('fs').promises;

async function* getFiles(dir) {
  const dirents = await readdir(dir, { withFileTypes: true });
  for (const dirent of dirents) {
    const res = resolve(dir, dirent.name);
    if (dirent.isDirectory()) {
      yield* getFiles(res);
    } else {
      yield res;
    }
  }
}
```

Head = blown. Don't forget to change it's usage, since we're returning item per item using `yield`, we should iterate over the results:

```js
(async () => {
  for await (const f of getFiles('.')) {
    console.log(f);
  }
})()
```

Let's take a few steps back. What's a `function*`? A really, _really_ badly chosen syntax for a _generator function_, that, according to MDN, is: 

> Generators are functions that can be exited and later re-entered. Their context will be saved across re-entrances.

You simply "exit" the function using `yield` and get access to the returned object or primitive using `fn.next().value`. As long as `yield` has indeed something to yield, it will not return `undefined`. This is mostly handy to create so-called unlimited functions that seemingly never exit, except that they do. A simple generator, inside an ES6 class (now that we're at it we might as well go all out) could look like this:

```js
class Ids {
  *nextId () {
    let index = 0
    while(true) yield index++
  }
}

const id = new Ids()
const gen = id.nextId()

console.log(gen.next().value) // prints 0
console.log(gen.next().value) // prints 1
console.log(gen.next().value) // ... you know the drill
```

(Did you see what I did there with the `;` semicolons?)

Inside generator functions, you can yield other generator function return values using `yield*`. Inception! Now what If I want to call some `async` code in between different `yield`s? Then it's time for some Asperine and an in-depth blog post qwtel wrote about [async generators and it's usage](https://qwtel.com/posts/software/async-generators-in-the-wild/).

Lastly, what is that strange `for await` syntax? That's the "idiomatic" way to consume async generator functions. Do I even want to know? Here's the [MDN documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for-await...of), it would take me too far to go into detail. Async iterators are part of ECMAScript 2018 (ES9), that is only 100% supported by the `V8` engine. For those of you who cannot wait, there are always polyfills... 

I have to admit that [keeping up with the ECMA-262 standard](https://itnext.io/status-of-javascript-ecmascript-2019-beyond-5efca6a2d233) is getting extremely challenging... 
