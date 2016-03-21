Fz2D
====
Fz2D is a 2D game engine and framework, designed with simplicity and
performance in mind from the ground up.

You should consider it *alpha quality*, as-in take everything with grain of salt
and pepper.

If you used [Flixel](http://flixel.org) and/or [Flash Punk](http://useflashpunk.net/) before, 
you'll feel right at home :recycle:.

Getting Started
---------------
It's terribly easy to get started, but before that, we need to install a couple 
of dependencies.

#### Dependencies
* [node.js](http://nodejs.org)
* [npm](http://npmjs.org)

After that, we can install all the necessary `packages` by executing:

```bash
npm install
```

To create a new `project` based on the provided `Fuzed` template, which you
can try out online over [here](http://szabster.net/fz2d), all you need to do is following:

```
mkdir ~/fuzed
cake -p ~/fuzed create
cd ~/fuzed
npm install
cake build
```

The nice thing is, that `cake build`, will start up an `HTTP` server on your
`localhost` (port _3000_ by default) and then refresh the page (tab) in your
browser automatically anytime you modify any of the `Coffee` files in the `src`
directory. Pretty neat, isn't it?

To find out more `commands` just type `cake`.

What's missing?
---------------
There are certainly a lot of *things* missing and the _feature_ set shouldn't
be considered _full_ nor _final_ by any stretch of the imagination.

Contributions are always welcome and much appreciated.

Contribute
----------
* Fork the project.
* Make your feature addition or bug fix.
* Do **not** bump the version number.
* Send me a pull request. Bonus points for topic branches.

License
-------
Copyright (c) 2014-2016, Mihail Szabolcs

Fz2D is provided **as-is** under the **MIT** license. 
For more information see LICENSE.

##### Template Asset License
* Music by [Tom Peter](http://opengameart.org/content/winter-feeling)
* Sound Effects via [bfxr.net](http://www.bfxr.net/)
* Graphics by [Marc Russel](http://spicypixel.net)
