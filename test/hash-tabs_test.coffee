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
	module "jQuery#hash-tabs",

		# This will run before each test in this module.
		setup: ->
			@elems = $("#qunit-fixture").children()

	test "is chainable", ->
		expect 1

		# Not a bad test to run on collection methods.
		strictEqual @elems.hash-tabs(), @elems, "should be chainable"

	test "is hash-tabs", ->
		expect 1
		strictEqual @elems.hash-tabs().text(), "hash-tabs0hash-tabs1hash-tabs2", "should be hash-tabs"

	module "jQuery.hash-tabs"
	test "is hash-tabs", ->
		expect 2
		strictEqual $.hash-tabs(), "hash-tabs.", "should be hash-tabs"
		strictEqual $.hash-tabs(punctuation: "!"), "hash-tabs!", "should be thoroughly hash-tabs"

	module ":hash-tabs selector",

		# This will run before each test in this module.
		setup: ->
			@elems = $("#qunit-fixture").children()

	test "is hash-tabs", ->
		expect 1

		# Use deepEqual & .get() when comparing jQuery objects.
		deepEqual @elems.filter(":hash-tabs").get(), @elems.last().get(), "knows hash-tabs when it sees it"
) jQuery