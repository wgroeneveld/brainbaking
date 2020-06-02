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

	const box = new SimpleLightbox('.lbox', { /* options */ });

});
