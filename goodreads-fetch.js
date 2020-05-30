const https = require('https')


// WHY? Because including this thing comes with free cookies...
const url = "https://www.goodreads.com/review/grid_widget/5451893.Wouter's%20bookshelf:%20read?cover_size=medium&hide_link=&hide_title=&num_books=12&order=d&shelf=read&sort=date_added&widget_id=1496758344"

https.get(url, (resp) => {
	let data = '';

	resp.on('data', (chunk) => {
		data += chunk;
	});

	resp.on('end', () => {
		console.log(data)
	});
})
