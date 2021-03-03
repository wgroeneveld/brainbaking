const got = require("got");
const parser = require("fast-xml-parser");
const fs = require('fs').promises;
const { writeFileSync, existsSync, mkdirSync } = require('fs');
const { resolve } = require('path');
const ent = require('ent')

const notesdir = `${__dirname}/content/notes`
const url = "https://chat.brainbaking.com/users/wouter/feed";

// https://stackoverflow.com/questions/5827612/node-js-fs-readdir-recursive-directory-search
async function getFiles(dir) {
  const dirents = await fs.readdir(dir, { withFileTypes: true });
  const files = await Promise.all(dirents.map((dirent) => {
    const res = resolve(dir, dirent.name);
    return dirent.isDirectory() ? getFiles(res) : res;
  }));
  return Array.prototype.concat(...files);
}

function stripBeforeThirdSlash(str) {
  const splitted = str.split('/')
  return splitted.slice(splitted.length - 3).join('/')
}

function stripBeforeLastSlash(str) {
  return str.substring(str.lastIndexOf('/') + 1, str.length)
}

function strpad(n) {
    return String("0" + n).slice(-2);
}

function convertAtomItemToMd(item) {
  const path = `${notesdir}/${item.year}/${item.month}`
  if(!existsSync(`${notesdir}/${item.year}`)) mkdirSync(`${notesdir}/${item.year}`)
  if(!existsSync(path)) mkdirSync(path)

  const mddata = `---
source: "${item.url}"
title: "${item.title}"
date: "${item.year}-${item.month}-${item.day}T${strpad(item.date.getHours())}:${strpad(item.date.getMinutes())}:${strpad(item.date.getSeconds())}"
---

${item.content}
  `

  writeFileSync(`${path}/${item.hash}.md`, mddata, 'utf-8')
}

(async function main() {
  const notesroot = await getFiles(notesdir)
  const notes = notesroot
    .filter(name => name.endsWith('.md'))
    .map(n => stripBeforeThirdSlash(n.replace('.md', '')))

  const buffer = await got(url, {
    responseType: "buffer",
    resolveBodyOnly: true,
    timeout: 5000,
    retry: 5
  });
  const root = parser.parse(buffer.toString())
  const items = root.feed.entry.map(item => {
    const date = new Date(item.published)
    const year = date.getFullYear()
    const month = strpad(date.getMonth() + 1)
    const day = strpad(date.getDate())

    return { 
      title: ent.decode(item.title), // summary (cut-off) of content
      content: ent.decode(item.content), // format: &lt;span class=&quot;h-card.... 
      url: item.id, // format: https://chat.brainbaking.com/objects/0707fd54-185d-4ee7-9204-be370d57663c
      id: stripBeforeLastSlash(item.id),
      hash: `${day}h${date.getHours()}m${date.getMinutes()}s${date.getSeconds()}`,
      date, // format: 2021-03-02T16:18:46.658056Z
      year,
      month,
      day
    }
  })
    .filter(itm => !notes.includes(`${itm.year}/${itm.month}/${itm.hash}`))
    .forEach(convertAtomItemToMd)

  console.log('Done!')
})()
