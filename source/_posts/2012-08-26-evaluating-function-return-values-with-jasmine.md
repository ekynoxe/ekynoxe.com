---
title: Evaluating function return values with Jasmine
author: Matt
layout: post
categories:
  - code
  - javascript
  - testing
  - tools
tags:
  - jasmine
  - javascript
  - spy
  - testing
---
I&#8217;ve been using <a title="Jasmine" href="http://pivotal.github.com/jasmine/" target="_blank">jasmine</a> at work as a javascript test framework to cover front-end code with all sorts of tests. Recently, on one particular spec, I needed to capture the values returned by a spied upon fonction, without completely interrupting the code execution. As capturing returned values from a spy before continuing code execution is something I couldn&#8217;t find in the jasmine framework, I wrote a small integration test that required to use spyOn().andCallFake(), instead of spyOn().andCallThrough(). Here&#8217;s my attempt at an implementation.

<!--more-->

**Disclaimer**: This may well all be very silly, so take it with a pinch of salt. If you find it useful, leave some comments! If you find it useless, leave some comments! If you find it downright rubbish, leave comments just as well! There&#8217;s a million way to do things, and this may well be very far from the best one. Feel free to educate me! I really thought I had a need to write this type of code as the classes I was testing were very convoluted and way more complex than the dumb code below.

I&#8217;m not going to describe what Jasmine is (look at the <a title="Jasmine" href="http://pivotal.github.com/jasmine/" target="_blank">online doc</a> or this <a title="Unit test JavaScript applications with Jasmine" href="http://www.adobe.com/devnet/html5/articles/unit-test-javascript-applications-with-jasmine.html" target="_blank">nice introduction</a>) how to set it up or even how to get going with it. I&#8217;ll assume you know what it does, and what matchers and asynchronous operations are. As this post deals mainly with setting up a spy in a special way, I invite you to consult the <a title="Jasmine spies" href="http://pivotal.github.com/jasmine/#section-Spies" target="_blank">jasmine documentation on spies</a> if you need to.

Code for the examples in this post is on github: <a title="Jasmine spies with result values tests" href="https://github.com/ekynoxe/jasmine-spies-with-result-values-tests" target="_blank">https://github.com/ekynoxe/jasmine-spies-with-result-values-tests</a>

## A refresher: spies

Jasmine spies are essentially decorators with a twist. As we&#8217;re in a testing world, they provide special matchers to test if a method &#8220;spied upon&#8221; has been called, how many times and with which arguments.

ty clear and self explanatory, and also very simple.

Let&#8217;s assume we&#8217;got a simple object that&#8217;s supposed to do stuff in which the function foo.setBar is the one we want to monitor, or &#8220;spy on&#8221;.

<pre class="brush: jscript; title: ; notranslate" title="">foo = {
    setBar: function(value) {
        bar = value;
    }
};</pre>

Setting up a spy is easy and straightforward. Jasmine decorates foo.setBar by using the &#8216;spyOn&#8217; method in a test spec.

<pre class="brush: jscript; title: ; notranslate" title="">spyOn(foo, 'setBar');</pre>

It&#8217;s important to remember that, by default, a spy will track all function calls and their arguments, but the execution will stop at this point, and will not call the function spied upon. If you want to do this, you need to use a chained jasmine method called &#8220;andCallThrough()&#8221;.
Using this will still track the same things about the function you&#8217;re spying, but will also delegate the call back to the original implementation, therefore continuing the execution of a code block. This is particularly useful when you need to check values are passed around the right way between functions, and also need to check something else happens with your code. This is potentially not unit testing anymore, as you are potentially executing multiple methods and code blocks from different classes, but useful nonetheless for some integration tests.

<pre class="brush: jscript; title: ; notranslate" title="">spyOn(foo, 'getBar').andCallThrough();</pre>

## Limitations

This, however, has a limitation: unless you can check the value of a variable &#8211; in production code, not in the tests &#8211; which gets assigned the returned result of the spied upon function, you won&#8217;t know what that function has returned in the scenario you&#8217;re trying to test. Again, this is an integration test, not a unit test, as you could well test directly that your function returns the correct values based on controlled, specific arguments, and one could argue that I should trust the interface etc etc… This is covered by unit tests somewhere else.

Let&#8217;s assume we&#8217;ve got two classes, Bar and Foo, and we want to test that when Bar is executed, a specific method on foo gets called a certain number of times and returns an expected result.

In our scenario, we&#8217;ll be trying to test that a function on foo returns the joined members of an array, only if the object argument indicates to process this array. This is a stupid thing, I know, but it&#8217;s a dead simple example to illustrate the problem.

<pre class="brush: jscript; title: ; notranslate" title="">var foo = {
        processAll: function (objects) {
            var i,
                res,
                results = [];

            for (i = 0; i &lt; objects.length; i++) {
                res = foo.process(objects[i]);
                if (res) {
                    results.push(res);
                }
            }

            return results;
        },

        process: function (args) {
            // Here is the 'filtering', if args.process is false, the function returns false
            if (!args.process) {
                return false;
            }

            return args.parts.join(' ');
        }
    };

    var bar = {
        foo: foo,
        objects: [],
        results: [],
        node: null,

        init: function (nodeClass, objects) {
            bar.objects = objects;

            var nodes = document.getElementsByClassName(nodeClass);
            if (nodes.length) {
                bar.node = nodes[0];
            }
        },

        start: function () {
            bar.results = bar.foo.processAll(bar.objects);
            bar.printAll();
        },

        printAll: function () {
            var i;

            if (!bar.node || !bar.results) {
                return;
            }

            for (i = 0; i &lt; bar.results.length; i++) {
                bar.printResult(bar.results[i]);
            }
        },

        printResult: function (result) {
            var obj,
                i;

            if (!bar.node) {
                return;
            }

            obj = document.createElement(&quot;div&quot;);
            obj.innerHTML = result;
            obj.setAttribute(&quot;class&quot;, &quot;result&quot;);
            bar.node.appendChild(obj);
        }
    };

    function init () {
        bar.init('out', [
            { 'process': true, parts: ['Hello', 'from', 'bar']},
            { 'process': true, parts: ['Hi', 'from', 'foo']},
            { 'process': false, parts: ['Ignore', 'me']},
            { 'process': true, parts: ['Hey', 'from', 'bar', 'foo']}
        ]);

        bar.start();
    }

    window.onload = init;
</pre>

## Unit tests

If you want to test that foo and bar have the correct behaviour, some simple unit tests, some of which with spies will do:

<pre class="brush: jscript; title: ; notranslate" title="">describe('testing FooBar', function () {
    var outputNodeClass = 'output',
        objectsToProcess = [
            { 'process': true, parts: ['I', 'will', 'be', 'joined']},
            { 'process': true, parts: ['This', 'is', 'a', 'test']},
            { 'process': false, parts: ['Ignore', 'me']},
            { 'process': true, parts: ['I', 'am', 'the', 'last', 'one!']}
        ],
        resultsNodes,
        i;

    function createOuputNode() {
        if (!document.getElementsByClassName(outputNodeClass).length) {
            var output = document.createElement(&quot;div&quot;);
            output.setAttribute(&quot;class&quot;, outputNodeClass);
            document.body.appendChild(output);
        }
    }

    beforeEach(function () {
        bar.init('output', objectsToProcess);
        createOuputNode();
    });

    afterEach(function () {
        resultsNodes = document.getElementsByClassName('result');

        runs(function () {
            while (resultsNodes.length) {
                resultsNodes[0].parentNode.removeChild(resultsNodes[0]);
                resultsNodes = document.getElementsByClassName('result');
            }
        });

        waitsFor(function () {
            return 0 === document.getElementsByClassName('result').length;
        });
    });

    /* foo tests */
    it('should process an object marked as to be processed with foo', function () {
        var res = foo.process(objectsToProcess[0]);
        expect(res).not.toBeFalsy();
        expect(res).toEqual('I will be joined');
    });

    it('should not process an object marked as to not be processed with foo', function () {
        expect(foo.process(objectsToProcess[2])).toBeFalsy();
    });

    it('should only contain objects that have been flagged to be processed with foo in the result', function () {
        expect(foo.processAll(objectsToProcess)).toEqual('I will be joined | This is a test | I am the last one!');
    });

    it('processAll should try and process all objects in the argument array with foo', function () {
        if (!jasmine.isSpy(foo.process)) {
            spyOn(foo, 'process');
        }
        foo.process.reset();

        foo.processAll(objectsToProcess);

        expect(foo.process).toHaveBeenCalled();
        expect(foo.process.callCount).toEqual(4);
    });
});
</pre>

## The problem

If you want to test that, when calling bar.start(), bar.foo.process all has been called for each object to process, but has not contributed to the final result for some of these objects (process: false), then you&#8217;d need to know what foo.bar.process has returned for each of its calls. Specifically, in our example, you&#8217;d want to make sure that foo.process returns something else than &#8216;false&#8217; only for objects marked as to be processed.

If you use:

*   **spyOn()** only, execution stops and nothing gets processed at all
*   **spyOn().andCallThrough()**, execution continues, but you&#8217;ve got no idea what got passed back to processAll()
*   **spyOn().andCallFake()** in its basic form, some execution continues, but not to the actual function we want to test return values for.

The only way is to create a hybrid that will still call the initial implementation, but inthe middle of which we can save the return values.

## A solution

I&#8217;ve mimicked the jasmine implementation of the callThrough() method by saving the original function to be spied on \*before the spy is created\*, but wrapped in a andCallFake() method to stop execution and restart it later on, only when I want, so I can capture what I need:

<pre class="brush: jscript; title: ; notranslate" title="">it('should test that the results from the processing are as expected', function () {
    var originalBarFooProcess,
        returnValues = [];

    runs(function () {

        if (!jasmine.isSpy(bar.foo.process)) {
            originalBarFooProcess = bar.foo.process;
            spyOn(bar.foo, 'process').andCallFake(function () {
                returnValues.push(originalBarFooProcess.apply(bar.foo, arguments));
            });
        }
        bar.foo.process.reset();

        bar.start();
    });

    waitsFor('foo.process to be called enough times', function () {
        return 4             }, 1000);

    runs(function () {
        expect(returnValues.length).toEqual(4);
        expect(returnValues[0]).toEqual('I will be joined');
        expect(returnValues[1]).toEqual('This is a test');
        expect(returnValues[2]).toBeFalsy();
        expect(returnValues[3]).toEqual('I am the last one!');
    });
});
</pre>

This is something that could easily be added on the fly to the jasmine library, should you need it, but as I said, it might be totally useless, as you should be able to test return values from methods in your code with unit tests.

Let me know what you think!