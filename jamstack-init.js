
const { mastodon, goodreads, lunr, webmention } = require('jam-my-stack');
const fsp = require('fs').promises;


(async function() {
	// 1. parse Mastodon RSS feed
	console.log("1. parsing Mastodon RSS feed...")
	await mastodon.parseFeed({
		notesdir: `${__dirname}/content/notes`,
		url: "https://chat.brainbaking.com/users/wouter/feed",
		utcOffset: "+01:00"
	})

	// 2. update goodreads JS widget
	console.log("2. Updating Goodreads Widget...")
	const widget = await goodreads.createWidget("https://www.goodreads.com/review/grid_widget/5451893.Wouter's%20bookshelf:%20read?cover_size=medium&hide_link=&hide_title=&num_books=12&order=d&shelf=read&sort=date_added&widget_id=1496758344")
	widget.replaceAll("src=", "class=\"lazyload\" data-src=")
	await fsp.writeFile(`${__dirname}/static/js/goodreads.js`, widget, 'utf-8')

	// 3. build Lunr index
	console.log("3. Building lunr search index...")
	const index = await lunr.buildIndex([
		`${__dirname}/content/post`,
		`${__dirname}/content/notes`])
	await fsp.writeFile(`${__dirname}/static/js/brainbaking-post.json`, JSON.stringify(index), 'utf-8')

	// 4. get webmentions
	console.log("4. Fetching webmentions that aren't likes...")
	const mentions = await webmention.getWebmentions("brainbaking.com")
	await fsp.writeFile(`${__dirname}/data/webmentions.json`, mentions.filter(m => m.content && m.type !== "like"), 'utf-8')

	console.log("-- all done!")
})()
