###
	hash-tabs

	demo.coffee

	@author Sean Goresht

	@note Created on 2014-06-07 by PhpStorm
	@note uses Codoc
	@see https://github.com/coffeedoc/codo
###

jQuery(document).ready ->
	$example1 = $(".example1").hashTabs()
	$example2 = $(".example2").hashTabs({
		smoothScroll:
			enabled: on
			initialTabId: "smooth-scroller"
	})
	$animationExamples = $(".animated-tab").hashTabs()
