# Hash Tabs

URL-sensitive tab plugin for jQuery

## Getting Started

Download the [production version][min] or the [development version][max].

[min]: https://raw.github.com/srsgores/jquery-hash-tabs/master/dist/jquery.hash-tabs.min.js
[max]: https://raw.github.com/srsgores/jquery-hash-tabs/master/dist/jquery.hash-tabs.js

In your web page:

```html
<script src="/bower_components/jquery/dist/jquery.min.js"></script>
<script src="/bower_components/hash-tabs/dist/jquery.hash-tabs.min.js"></script>
<script>
jQuery(function($) {
	$(".myTabContainer").hashTabs(); // "create hash tabs off of all elements with class myTabContainer"
});
</script>
```

## Documentation
Documentation is generated using [codoc](https://github.com/coffeedoc/codo).  [Please refer to the API docs]().

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