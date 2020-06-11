window._domloaded = false;
document.addEventListener("DOMContentLoaded",function() {
	if(window._domloaded) return;
	window._domloaded = true;

	(function sandwich() {
		const navbar = document.querySelector('.navbar-collapse');
		const navtoggle = document.querySelector('.navbar-toggle');
		const navCollapse = () => {
			navbar.setAttribute('class', 'navbar-collapse collapse');
		}
		const navCollapsing = () => {
			navbar.setAttribute('class', 'navbar-collapse collapsing');
		}

		const someHeader = document.querySelector('header')
		if(someHeader) someHeader.addEventListener('click', navCollapse)
		document.querySelector('main').addEventListener('click', navCollapse)

		document.querySelector('nav').addEventListener('click', () => {
			if(window.getComputedStyle(navtoggle)['display'] === 'none') return;
			if(navbar.getAttribute('class').indexOf('collapsing') >= 0) {
				navCollapse();
			} else {
				navCollapsing();
			}
		});
	})();

	new SimpleLightbox('.lbox');
	new Headroom(document.querySelector(".navbar"), {
		offset: 100,
		tolerance: {
			up: 10,
			down: 0
		},
		classes : {
	        initial : "headroom",
	        pinned : "headroom-pinned",
	        unpinned : "headroom-unpinned",
	        top : "headroom-top",
	        notTop : "headroom-not-top",
	        bottom : "headroom-bottom",
	        notBottom : "headroom-not-bottom",
	        frozen: "headroom-frozen"
	    }
    }).init();

	(function() {
		const $target = document.querySelector('#searchapp');
		const $pages = document.querySelector('#resultaten .pages');
		if(!($target && window.searchposts)) return;

		const query = new URLSearchParams(window.location.search);
		const searchString = query.get('q') || "";
		document.querySelector('#zoekentxt').value = searchString;

		// Our index uses title as a reference
		const postsByTitle = window.searchposts.reduce((acc, curr) => {
		  acc[curr.title] = curr;
		  return acc;
		}, {});

		fetch('/js/brainbaking-post.json').then(function (res) {
		  return res.json();
		}).then(function (data) {
		  const index = lunr.Index.load(data);
		  const matches = index.search(searchString);
		  const matchPosts = [];
		  matches.forEach((m) => {
		    matchPosts.push(postsByTitle[m.ref]);
		  });

		  $pages.innerHTML = `(${matches.length})`;
		  if (matchPosts.length > 0) {
		    $target.innerHTML = matchPosts.filter(p => p).map(p => {
		      return `<article>
		        <h3><a href="${p.link}">${p.title}</a></h3>
		        <p>${p.content}...</p>
		      </article>`;
		    }).join('');
		  } else {
		    $target.innerHTML = `<article>No relevant search results found.</article>`;
		  }
		});
	})()

});
