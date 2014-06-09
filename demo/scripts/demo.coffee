###
	hash-tabs

	demo.coffee

	@author Sean
	
	@note Created on 2014-06-07 by PhpStorm
	@note uses Codoc
	@see https://github.com/coffeedoc/codo
###

jQuery(document).ready ->
	$tabs = $(".tab-container").hashTabs({
		debug: on
		keyboard: on
		smoothScroll: on
	})
	# console.dir $tabs