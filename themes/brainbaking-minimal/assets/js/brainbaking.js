window._domloaded = false;
document.addEventListener("DOMContentLoaded",function() {
	if(window._domloaded) return;
	window._domloaded = true;

	(function sandwich() {
		var navbar = document.querySelector('.navbar-collapse');
		var navtoggle = document.querySelector('.navbar-toggle');
		function navCollapse() {
			navbar.setAttribute('class', 'navbar-collapse collapse');
		}
		function navCollapsing() {
			navbar.setAttribute('class', 'navbar-collapse collapsing');
		}

		document.querySelector('main').addEventListener('click', function() {
			navCollapse();
		})

		document.querySelector('nav').addEventListener('click', function() {
			if(window.getComputedStyle(navtoggle)['display'] === 'none') return;
			if(navbar.getAttribute('class').indexOf('collapsing') >= 0) {
				navCollapse();
			} else {
				navCollapsing();
			}
		});
	})();

	(function goodreads() {
		if(document.querySelector('.goodreadswidget') === null) return;
		[...document.querySelectorAll('.goodreadswidget img')].forEach(img => {
		    img.src = img.src.replace(/_SX[0-9]+_(SY[0-9]+_)*.jpg/, "_S400_.jpg")
		})
	})()

	const lightbox = () => {
		[...document.querySelectorAll('main img')].forEach(el => {
			if(el.parentNode.nodeName !== 'A') {
				el.parentNode.innerHTML =  `<a href="${el.src}" class="lbox">${el.outerHTML}</a>`; 
			} else {
				el.parentNode.setAttribute('class', 'lbox');				
			}
		})
		const box = new SimpleLightbox('.lbox', { /* options */ });
	};
	lightbox();


});
