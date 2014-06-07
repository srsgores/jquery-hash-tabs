###
	hash-tabs

	hash-tabs.coffee

	@author Sean
	
	@note Created on 2014-06-07 by PhpStorm
	@note uses Codoc
	@see https://github.com/coffeedoc/codo
###

(($, window) ->

	###
	Class for creating accessible tabs with jQuery
	@example create tabs from nav and container element
		$(".myTabContainer").hash-tabs();
	###
	class HashTabs
		defaults:
			tabPanelSelector: ".contentsection"
			tabNavSelector: ".tab-nav"
			tabButtonSelector: "a"
			initialTabToShow: 0
			$tabPanel: []
			$tabNav: []
			$tabButtons: []

		###
		Construct a new instance of HashTabs

		@param [*jQuery] el tab container selector
		@param [Array] options array for constructing new tabs
		###
		constructor: (el, options) ->
			@options = $.extend({}, @defaults, options)
			@$selector = $(el)
			throw new ReferenceError("The selector passed in does not contain any items") if @$selector.length < 1
			@generateTabs(@$selector)

		###
		Generate tabs based off of a selector

		@param [*jQuery] $tabSelector tab container selector
		###
		generateTabs: ($tabSelector) ->
			# find the tab nav element, giving it a tablist attribute
			@$tabNav = $tabSelector.find(@tabNavSelector).attr({
				"role": "tablist"
			})
			# Find the actual tab (buttons), and give them aria attributes
			@$tabButtons = @$tabNav.find(@tabButtonSelector).each((index) ->
				selected = "false"
				if index == @initialTabToShow
					selected = "true"
				$(this).attr({
						"selected": selected
						"aria-controls": $(this)[0].id
						"tab-index": index
					}
				)
			)

		# Define the plugin
		$.fn.extend HashTabs: (option, args...) ->
			@each ->
				$this = $(this)
				data = $this.data("HashTabs")

				if !data
					$this.data "HashTabs", (data = new HashTabs(this, option))
				if typeof option == "string"
					data[option].apply(data, args)
	) window.jQuery, window