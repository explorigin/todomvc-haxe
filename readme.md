# Haxe TodoMVC Example (with jQuery)

Haxe is a staticly-typed programming language that can be transpiled to Javascript, PHP, Java, C++, C# or Python or compiled into Flash or Neko bytecode. Haxe has the unique advantage of code-sharing between all manner of clients and servers even though they run different servers, languages or architectures.

_[Haxe - haxe.org](http://haxe.org)_

This demo shows the basics of how to develop client-side Javascript apps in Haxe. Many details are included in the comments of the files under src/ as well as build.hxml. While the Haxe standard library exposes standard Javascript and DOM APIs, we advise using a library that abstracts these since direct DOM manipulation can be verbose and unnecessarily complex. In this example, we use jQuery.

## Building

1. Clone the repo
2. Install the jQueryExtern extern with haxelib by running `haxelib install jQueryExtern`.
3. Compile Haxe source with `haxe build.hxml`

## Learning Haxe

The [Haxe manual](http://haxe.org/manual/introduction.html) is a growing resource for getting started with Haxe.

Here are some links you may find helpful:

* [An Introduction to Haxe](http://haxe.org/documentation/introduction/)
* [Haxe targeting Javascript](http://haxe.org/manual/target-javascript-getting-started.html)
* [API Reference](http://api.haxe.org)
* [Haxe News Roundup](http://haxe.io)
* [Try Haxe in your browser](http://try.haxe.org)

Get help from other Haxe users:

* [Haxe Users Google Group](http://groups.google.com/group/haxelang?hl=en)
* [Haxe on StackOverflow](http://stackoverflow.com/questions/tagged/haxe)
* [Haxe on Twitter](http://twitter.com/haxelang)

_If you have other helpful links to share, or find any of the links above no longer work, please [let us know](https://github.com/explorigin/haxe-todomvc/issues)._

## Notes on Modular Javascript with Haxe

While not necessary, this example also includes a pattern for creating multiple, modular output files. In the __Store.hx__ and __Todo.hx__ files, this pattern is repeated preceeding classes:

    #if sharedcode
        @:expose
    #else
        extern
    #end
    
Like other compiled languages, Haxe has a built-in preprocessor in the form of [macros](http://haxe.org/manual/macro.html).  In this case, we're simply checking if the macro variable `sharedcode` exists. (We specify it for certain builds in __build.hxml__.) If so, we [expose](http://haxe.org/manual/target-javascript-metatags.html) the following class as a globally-accessable variable. If `sharedcode` does not exist, the following class is flagged as an [extern](http://haxe.org/manual/lf-externs.html) and other modules that use it assume that it will be a part of the code-base as a separate Javascript file.

There is a trade-off to using this approach to modular code.  Because we can't use [DCE](http://haxe.org/manual/cr-dce.html) on our separate modules, there is the potential for some duplicated code between files. In this example there are a few lines shared between the two output files. Search for `Boot.__instanceof =` to find them in each file.  With some diligence, this can be kept to a minimum and would not be much of an issue for large code-bases. For small code-bases, it's probably best to not output separate modules (leave your code separation in Haxe source files rather than in Javascript).
