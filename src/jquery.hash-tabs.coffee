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
			tabPanelSelector: "section"
			tabNavSelector: "nav"
			tabButtonSelector: "a"
			initialTabToShow: 0
			tabContainerClass: "hash-tabs"
			debug: off

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
			# console.dir @$selector if options.debug is on

		###
		Generate tabs based off of a selector

		@param [*jQuery] $tabContainer tab container jQuery object
		###
		generateTabs: ($tabContainer) ->
			# add classes to initialized tab container
			$tabContainer.addClass(@options.tabContainerClass)
			# console.log "Added class #{@options.tabContainerClass} to tab container" if @options.debug is on
			# find the tab nav element, giving it a tablist attribute
			@$tabNav = $tabContainer.find(@options.tabNavSelector).attr({
				"role": "tablist"
			})
			@$contentPanes = $tabContainer.find(@options.tabPanelSelector)
			# Find the actual tab (buttons), and give them aria attributes
			self = this # @concern should consider using fat arrow `=>` instead
			@$tabButtons = @$tabNav.find(@options.tabButtonSelector).each((index) ->
				$(this).attr({
						"id": index
						"role": "tab"
						"aria-selected": false
						"aria-expanded": false
						"aria-controls": $(this)[0].hash
						"tab-index": -1
					}
				)
				# set corresponding content
				$associatedTab = self.$contentPanes.filter($(this)[0].hash)
				$associatedTab[0].correspondingTabButton = $(this)
				$(this)[0].correspondingTabContent = $associatedTab
			)
			@$tabPanes = $tabContainer.find(@options.tabPanelSelector).hide().each(->
				$(this).attr({
					"role": "tabpanel"
					"aria-labeledby": $(this)[0].correspondingTabButton[0].id
				})
			)
			@$activeTab = @$tabPanes.eq(@options.initialTabToShow)
			@$activeTabButton = @$tabButtons.eq(@options.initialTabToShow)
			@listenClick(@$tabButtons)
			@updateHash()

		listenClick: ($tabButtons) ->
			self = this
			$tabButtons.on("click", ->
				# console.log "Active tab is "
				# console.dir(self.$activeTab) if self.options.debug is on
				self.$previousTab = self.$activeTab.hide()
				self.$previousTabButton = self.$activeTabButton.removeClass("active").attr({
					"tab-index": -1
					"aria-selected": false
					"aria-expanded": false
				})
				$(this).addClass("active").attr({
					"tab-index": 0
					"aria-selected": true
					"aria-expanded": true
				})
				self.$activeTabButton = $(this)
				self.$activeTab = $(this)[0].correspondingTabContent?.show()
			)

		updateHash: ->
			currentHashURL = document.location.hash
			if currentHashURL isnt "" #a tab was set in hash earlier
				# show selected
				@triggerTab(currentHashURL)
			else #default to show first tab
				@$tabButtons.first().trigger("click")
		generateUniqueID: ->
			c = 1
			today = new Date()
			m = today.getMilliseconds() ""
			++today + m + (if ++c is 10000 then c = 1 else c)
		triggerTab: (url) ->
			@$tabButtons.filter("[href*=#{url}]").trigger("click")
		# Define the plugin
		$.fn.extend hashTabs: (option, args...) ->
			@each ->
				$this = $(this)
				data = $this.data("hashTabs")

				if !data
					$this.data "hashTabs", (data = new HashTabs(this, option))
				if typeof option == "string"
					data[option].apply(data, args)
	) window.jQuery, window