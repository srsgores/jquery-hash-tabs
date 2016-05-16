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
		$(".myTabContainer").hashTabs();
	###
	class HashTabs
		defaults:
			# @property [String] jQuery selector for individual tab panes (or tab content)
			tabPanelSelector: "section"
			# @property [String] jQuery selector for main navigation element, with tab buttons or links
			tabNavSelector: "nav"
			# @property [String] jQuery selector for anchor tags or links contained within the main navigation element
			tabButtonSelector: "a"
			###
			@property [Integer] initial tab's index to show when the tabs are initialized
			@note Initial tab will default to first tab, or index of 0
			@note You must provide a non-negative Integer within the range of the current active tabs
			###
			initialTabIndex: 0
			###
			@property [String] (optional) initial tab's `id` or hash to show when tabs are initialized
			@example tab2
			@note You must provide a non-negative Integer within the range of the current active tabs
			###
			initialTabId: null
			###
			@property [String] class to append to initialized hash tabs
			@note Styles are applied using the `.hash-tabs` class.  Expect unexpected output if you override this setting
			###
			tabContainerClass: "hash-tabs"
			###
			@property [Boolean] whether keyboard navigation is enabled
			@note anchor tag tab element must be selected (using tab) in order for keyboard navigation to work
			@note keyboard navigation binds to the left and right arrow keys on the keyboard
			###
			keyboard: on
			###
			@property [Boolean] whether to apply smooth scrolling, in which the screen scrolls up to the top of the tab navigation panel when any tab is clicked
			@note Enabling smooth scrolling will override the default browser behaviour, in which the browser "jumps" to the top of an anchor
			###
			smoothScroll:
				enabled: off
			# @property offset amount, in pixels from top of main tab navigation, when smooth scrolling is enabled
				offset: 100
				duration: 1000
			###
			@property [Boolean] whether to enable html5 history API to navigate back/forwards amongst selected tabs
			@note Defaults to `false` on non-html5-supported browsers
			###
			history: on
			# @property [Boolean] whether to enable debugging logging statements from within the console.  Enable this if you are having trouble identifying an error
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
			console.dir @$selector if @options.debug is on

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
			# @property [*jQuery] jQuery Array of all content (tab) panes
			@$contentPanes = $tabContainer.find(@options.tabPanelSelector)
			# Find the actual tab (buttons), and give them aria attributes
			self = this # @concern should consider using fat arrow `=>` instead
			# TODO: Refactor ARIA-logic into new method
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
				$(this)[0].index = index
				$(this)[0].correspondingTabContent = $associatedTab
			)
			# @property [Integer] (zero-based) number of tabs contained within current tabset
			@tabsLength = @$tabButtons.length
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
			@listenKeyboard() if @options.keyboard is on
			@enableHistory() if @options.history is on
		###
		Listen to click events on the tab anchor elements, showing the corresponding tab, and adding WAI-ARIA attributes

		@param [*jQuery] $tabButtons all tab anchor tags on a tabset
		@return [*jQuery] $tabButtons
		###
		listenClick: ($tabButtons) ->
			self = this
			$tabButtons.on("click", (e) ->
				if self.options.debug is on
					console.log "Active tab is "
					console.dir(self.$activeTab) if self.options.debug is on
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
				if self.options.smoothScroll.enabled is on
					$("html, body").stop().animate
						scrollTop: self.$tabNav.offset().top - self.options.smoothScroll.offset
					, self.options.smoothScroll.duration
				if self.options.keyboard is on
					# fix for FF and Chrome not performing hash update on triggered click
					false if $(this)[0].href is "##{self.options.initialTabId?}" or $(this)[0].index is self.options.initialTabIndex
					targetHref = $(this)[0].href
					console.log "Pushed state #{targetHref}" if @options.debug is on
					if window.history? and self.options.history is on
						history.pushState(self.options, "HashTabs", targetHref)
					else window.location.hash = targetHref.split("#")[1]
					false
			)

		###
		Update the document's current URL to match that of the initially-configured and selected tab

		@note Only fired once, when plugin initialized
		###
		updateHash: ->
			currentHashURL = document.location.hash
			if currentHashURL isnt "" #a tab was set in hash earlier
				# show selected
				@triggerTab(currentHashURL)
			else # show default
				if @options.initialTabId? then @triggerTab(@options.initialTabId) else @triggerTabByIndex(@options.initialTabIndex)

		enableHistory: ->
			$(window).on("popstate", (e) =>
				console.dir e if @options.debug is on
				if e.originalEvent.state?
					previousTabUrl = location.hash
					console.log "Pushing url #{previousTabUrl}" if @options.debug is on
					@triggerTab(previousTabUrl)
			)
		###
		Trigger a given tab, provided its `id`

		@param [String] url the hash or `id` of the corresponding tab and anchor
		@note A corresponding anchor (`<a>`) tag with the corresponding hash must be present in the tab navigation element
		@example trigger section element (tab) with id "chocolates" in tab container element ".myTabs"
			$(".myTabs").hashTabs("triggerTab", "chocolates") // triggers tab with id #chocolates
		###
		triggerTab: (url) ->
			@$tabButtons.filter("[href*='#{url}']").trigger("click")
		###
		Trigger a given tab, provided its index

		@param [Integer] non-negative integer, corresponding to the (nth + 1) tab to display
		@note A corresponding anchor (`<a>`) tag with the corresponding hash must be present in the tab navigation element
		@example trigger 3rd tab with in tab container ".myTabs"
			$(".myTabs").hashTabs("triggerTabByIndex", 3) // triggers tab with index 3
		###
		triggerTabByIndex: (index) ->
			condition = null
			if @options.debug is on then console.log "Triggering tab with index #{index}"
			switch condition
				when index < 0
					condition = "is a negative number, and you cannot trigger a tab with a negative index.  Please choose an index within"
				when index > @tabsLength
					condition = "is larger than"
				else condition = "is either not a non-negative integer or is outside of"
			throw new Error("Cannot show tab of index #{index}, as it #{condition} the current amount of tabs (#{@tabsLength}).") if index > @tabsLength or index < 0 or not (/^\d+$/.test(index))
			@$tabButtons.eq(index).trigger("click")
		###
		Listen to keypress events of the left and right arrow keys, to enable keyboard tab navigation

		@note tabs will *cycle* in a clockwise direction**.  For example, if you are on the last tab to the right, selecting next will fold back over to the first tab (0) to the left
		###
		listenKeyboard: ->
			self = this
			@$tabButtons.on("keydown", (event) ->
				if self.options.debug is on then console.log "Pressed key #{event.keyCode}"
				switch event.keyCode
					when 37 or 38
						self.selectPrevious()
					when 39 or 40
						self.selectNext()
					else
						if self.options.debug is on then console.log("keypress of #{event.keyCode} was false")
			)
		###
		Select and trigger clicking of the left-most tab of the currently-active tab

		@example trigger previous tab to current tab (0 is default)
			$(".myTabs").hashTabs("selectPrevious") // triggers left-most tab to current tab
		###
		selectPrevious: ->
			previousTabIndex = @$activeTabButton[0].index - 1
			if previousTabIndex is -1 then @triggerTabByIndex(@tabsLength - 1) else @triggerTabByIndex(previousTabIndex)
		###
		Select and trigger clicking of the right-most tab of the currently-active tab

		@example trigger next tab to current tab (0 is default)
			$(".myTabs").hashTabs("selectNext") // triggers right-most tab to current tab
		###
		selectNext: ->
			if @options.debug is on then console.dir [@$activeTabButton, @$activeTabButton[0].index]
			nextTabIndex = @$activeTabButton[0].index + 1
			if nextTabIndex is @tabsLength then @triggerTabByIndex(0) else @triggerTabByIndex(nextTabIndex)
		###
		Add and configure HashTabs to be within the jQuery namespace

		@param [String] option Method name to trigger
		@overload args
			@param [Object] customized jQuery options to set in the new instance of HashTabs
		@see https://gist.github.com/rjz/3610858
		###
		$.fn.extend hashTabs: (option, args...) ->
			@each ->
				$this = $(this)
				data = $this.data("hashTabs")

				if !data
					$this.data "hashTabs", (data = new HashTabs(this, option))
				if typeof option == "string"
					data[option].apply(data, args)
	) window.jQuery, window
