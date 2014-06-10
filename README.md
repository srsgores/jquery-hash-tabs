# Hash Tabs [![Build Status](https://secure.travis-ci.org/srsgores/jquery-hash-tabs.png?branch=master)](https://travis-ci.org/srsgores/jquery-hash-tabs)

URL-sensitive and hash-friendly tab plugin for jQuery

## Getting Started

Download the [production version][min] or the [development version][max].

[min]: https://raw.github.com/srsgores/jquery-hash-tabs/master/dist/jquery.hash-tabs.min.js
[max]: https://raw.github.com/srsgores/jquery-hash-tabs/master/dist/jquery.hash-tabs.js

First, install the package using [bower](http://bower.io):

```
bower install hash-tabs --save
```

Then, in your web page:

```html
<script src="/bower_components/jquery/dist/jquery.min.js"></script>
<script src="/bower_components/hash-tabs/dist/jquery.hash-tabs.min.js"></script>
<script>
jQuery(function($) {
	$(".myTabContainer").hashTabs(); // "create hash tabs off of all elements with class myTabContainer"
});
</script>
```

## Features

* Hash-friendly URLs, so your states are saved.  **Try refreshing!**
* Compatible with IE8 and up
* Customizable and configurable.  Use custom selectors for your tabs.  Default uses ``nav`` and ``section`` elements
* ``noscript``-friendly.  Works very will in non-javascript browsers.  When tabs can't be loaded, content feels like normal, as hashes are supported natively by the browser.
* Customizable SASS styles, ready to go with my [sass boilerplate](https://github.com/srsgores/sass-boilerplate)
* **Bootstrap-free**!  But you can still use bootstrap if you really want to

## Documentation
Documentation is generated using [codoc](https://github.com/coffeedoc/codo).  [Please refer to the API docs]().

## Options

| Option            	| Default     	| Description                                                                           	|
|-------------------	|-------------	|---------------------------------------------------------------------------------------	|
| ``tabPanelSelector``  	| ``"section"``   	| jQuery selector for individual tab panes (or tab content)                             	|
| ``tabNavSelector``    	| ``"nav"``       	| jQuery selector for main navigation element, with tab buttons or links                	|
| ``tabButtonSelector`` 	| ``"a"``         	| jQuery selector for anchor tags or links contained within the main navigation element 	|
| ``initialTabIndex``   	| ``0``           	| initial tab's index to show when the tabs are initialized                             	|
| ``initialTabId``      	| ``null``        	| initial tab's `id` or hash to show when tabs are initialized                          	|
| ``tabContainerClass`` 	| ``"hash-tabs"`` 	| class to append to initialized hash tabs                                              	|
| ``keyboard``          	| ``true``        	| Enable keyboard navigation using arrow keys                                           	|
| ``smoothScroll``      	| ``false``        	| Enable smooth scrolling to top of tabs when a tab is selected                         	|
| ``history``           	| ``true``        	| Enable HTML5 history api, to navigate backwards/forwards amongst selected tabs        	|
| ``debug``             	| ``false``       	| Enable logging statements to diagnose any problems  |

Declare options in an object literal like so:

```
jQuery(document).ready(function() {
	var $tabs = $(".tab-container").hashTabs({
		debug: true,
		keyboard: true
		// other options here
	});
});
```

## API
### Trigger A Given Tab
(AKA trigger tab by ``id``)

```
$(".myTabs").hashTabs("triggerTab", "chocolates") // triggers tab with id #chocolates
```

### Trigger A Given Tab by Index
```
$(".myTabs").hashTabs("triggerTabByIndex", 1) // triggers second tab (with index 1) in tab set
```

### Trigger Next Tab (to Right)
```
$(".myTabs").hashTabs("selectNext") // triggers right-most tab to current tab
```

### Trigger Previous Tab (to Left)
```
$(".myTabs").hashTabs("selectPrevious") // triggers left-most tab to current tab
```

**NOTE: tabs will *cycle* in a clockwise direction**.  For example, if you are on the last tab to the right, selecting next will fold back over to the first tab (0) to the left

## Contributing

First, make sure to install all [bower](http://bower.io) dependencies:

```
bower install
```

Next, install node dependencies:

```
npm install
```

### Building
Currently, I am using the built-in [grunt](http://gruntjs.com) settings which ship with the [yeoman](http://yeoman.io) generator I used.

### Unit Tests
Unit tests are written using [qunit](http://qunitjs.com/).  A [js test driver](https://code.google.com/p/js-test-driver/) configuration is also included for in-IDE testing (can use PHPStorm), but tests can also be run from the ``test/hash-tabs.html`` file.