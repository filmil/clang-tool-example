# An example tool built against the LLVM library

I wanted to make a clang tool out of the `clang` source code tree.  Ostensibly
there are examples to follow.  However, I found out that the examples are based
on the assumption that you are writing a tool in the llvm project tree, which I
didn't want to do: I don't want to argue my use of the tool I want to make with
someone who has zero interest in actually seeing my thing get done.  I, on the
other hand, do need to get my thing working.

Here is the inventory of examples that I found on the Internet:

* https://github.com/peter-can-talk/cppnow-2017 has bitrotted.  The docker
  approach has merit since you get to burn your environment into an image; but
  the API has changed since the thing was made, and I wanted to have something
  that works *now*. So...
    
* https://github.com/firolino/clang-tool/ was promising, but requires a system
  clang installation, which is a nonstarter since I want to build on multiple
  machines, and it is very hard to guarantee you'd be using the same library
  version if you use the library installation as provided by the system. I
  don't want to fight the package system on my machine to compile things.

* https://github.com/google/llvm-bazel is purportedly a `bazel` configuration
  for building with llvm. Of course it does not work on many levels. At this
  point nothing about `bazel` not working out of the box surprises me.

* This [mailing list discussion][1] has links to all the bitrotted examples.

[1]: http://clang-developers.42468.n3.nabble.com/How-to-build-a-clang-tool-out-of-the-build-tree-td4066632.html

## What to do?

I found [this blog post][hee] that got me mostly on the right track.  It is old, however,
so some of the concerns there no longer apply, and the API has also bitrotted.

[hee]: https://heejune.me/2016/08/17/build-your-own-clang-example-outside-of-the-llvm-source-tree/

## Building and installing `clang` and `llvm`

I decided to use `ninja` to build LLVM since I have access to a 48-core machine
and wanted to make use of all that CPU automatically.

### Preparation

* Get and install `ninja`.  I like building from source so I checked it out from
  source and installed, as described [here][ninja].

[ninja]: https://ninja-build.org

* Get the `llvm` source code, as described [here][install].  I like keeping build,
  install and source directories separate so I roughly did this:

  ```bash
  $ mkdir -p ${HOME}/code/llvm/{build,installation}
  $ cd ${HOME}/code/llvm
  $ git clone git@github.com:llvm/llvm-project
  ```

  The commit ID at which I checked the project out is
  `c360553c15a8e5aa94d2236eb73e7dfeab9543e5`, in case you are interested in
  reproducing the build environment exactly.  It matters, because the LLVM APIs
  change over time, so my example may bitrot as well.  Sigh.

[install]: https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm

### Generating the `ninja` build files

The command line to generate the `ninja` build files is as follows:

```
cd ${HOME}/code/llvm/build
cmake -G Ninja \
  -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;libcxx;compiler-rt;libcxxabi' \
  -DCMAKE_INSTALL_PREFIX=$HOME/code/llvm/installation \
  ../llvm-project/llvm
ninja
ninja install
```

The build and installation steps tend to last *a long time*.  Luckily, I always
saw some sort of a progress indicator which helped reasure me that things are
going as planned.

Once done, you will have a viable `clang` and `llvm` installation.  
You do need to do the last `ninja install` step, it seems: the structure of the
installation directory is very specific, and different from the structure of the
source and build dirs.  I thought I'd save some disk space by referring to files
from the source and build directories instead of installing, but that turned out
to invite more trouble than it was worth.

## Building and installing the example.

Finally, we hopefully get to substance.
