###
	hash-tabs

	hash-tabs_test.coffee

	@author Sean
	
	@note Created on 2014-06-07 by PhpStorm
	@note uses Codoc
	@see https://github.com/coffeedoc/codo
###

(($) ->

	###
	======== A Handy Little QUnit Reference ========
	http://api.qunitjs.com/

	Test methods:
	module(name, {[setup][ ,teardown]})
	test(name, callback)
	expect(numberOfAssertions)
	stop(increment)
	start(decrement)
	Test assertions:
	ok(value, [message])
	equal(actual, expected, [message])
	notEqual(actual, expected, [message])
	deepEqual(actual, expected, [message])
	notDeepEqual(actual, expected, [message])
	strictEqual(actual, expected, [message])
	notStrictEqual(actual, expected, [message])
	throws(block, [expected], [message])
	###
	"use strict"
	module "hashtabs",

		# This will run before each test in this module.
		setup: ->
			@elems = $("#qunit-fixture").children()
			@$tabContainer = $(".tab-container")
	test "is chainable", ->
		expect 1

		# Not a bad test to run on collection methods.
		strictEqual @elems.hashTabs(), @elems, "should be chainable"
	test "hides non-active tab panes", ->
		expect 2

		$tabs = @$tabContainer.first().hashTabs()
		console.dir $tabs
		strictEqual $tabs.find("section:first").is(":visible"), true
		strictEqual $tabs.find("section").not(":first").is("visible"), false
	test "has correct hash tabs class", ->
		expect 1
		equal @$tabContainer.first().hashTabs().hasClass("hash-tabs"), true
	test "throws correct error when no navigation exists", ->
		throws(->
			@$tabContainer.eq(2).hashTabs()
		, ReferenceError)
	test "Updates href on click", ->
		@$tabContainer.find("a[href*='#tab2']").trigger("click")
		strictEqual(window.location.hash, "#tab2")
	test "displays correct tab, corresponding to current browser URL", ->
		expect 2
		window.location.hash = "tab2"
		$tabs = @$tabContainer.first().hashTabs()
		$tabSections = $tabs.find("section")
		$tab2 = $tabSections.eq(2)
		equal($tab2.is(":visible"), true)
		equal($tabSections.filter($tab2).is(":visible"), false)
	test "Shows correct tab when overridden in options", ->
		expect 3
		$tabs = @$tabContainer.first().hashTabs({
			initialTabToShow: 2
		})
		$tabSections = $tabs.find("section")
		$tab2 = $tabSections.eq(2)
		equal($tab2.is(":visible"), true)
		equal($tabSections.filter($tab2).is(":visible"), false)
		equal(window.location.hash, "#tab2")
	test "Adds active class to clicked tab", ->
		$tabs = @$tabContainer.first().hashTabs()
		$firstTab = $tabs.find("nav a:first").trigger("click")
		equal($firstTab.hasClass("active"), true)
	test "Removes active class to previously-clicked tab", ->
		$tabs = @$tabContainer.first().hashTabs()
		$firstTab = $tabs.find("nav a:first").trigger("click")
		$secondTab = $tabs.find("nav a").eq(2).trigger("click")
		equal($firstTab.hasClass("active"), false)
	test "Contains wai-aria accessibility tags", ->
		expect 7
		$tabs = @$tabContainer.first().hashTabs()
		$nav = $tabs.find("nav:first")
		$navButtons = $nav.find("a")
		$tabPanels = $tabs.find("section")
		equal($nav.is("[role*='tablist']"), true)
		equal($navButtons.is("[tabindex]"), true)
		equal($navButtons.is("[aria-controls]"), true)
		equal($navButtons.is("[aria-expanded]"), true)
		equal($navButtons.is("[aria-selected]"), true)
		equal($navButtons.is("[role*='tab']"), true)
		equal($tabPanels.is("[role*='tabpanel']"), true)
		equal($tabPanels.is("[aria-labeledby]"), true)
	test "Navigates to previous and next tabs using arrow keys on keyboard", ->
		expect 3
		$tabs = @$tabContainer.first().hashTabs()
		$secondTab = $tabs.find("nav a").eq(2).trigger("click")
		$firstTab = $tabs.find("nav a").first()
		$tabSections = $tabs.find("section")
		equal($firstTab.hasClass("active"), true)
		leftArrowKeyPress = $.Event("keydown")
		leftArrowKeyPress.keyCode = 9
		$(document).trigger(leftArrowKeyPress)
		equal($tabSections.filter("#{$firstTab[0].href}").is(":visible"), true)
		rightArrowKeyPress = leftArrowKeyPress
		rightArrowKeyPress.keyCode = 10
		equal($tabSections.filter("#{$secondTab[0].href}").is(":visible"), true)
) jQuery