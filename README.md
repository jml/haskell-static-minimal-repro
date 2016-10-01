Minimal example of static linking with Stack.

This builds a simple script that takes stdin and replaces every occurrence of
"jml" with "jml of the shaven yak".

## Building on OS X (standard)

After installing `icu` libraries via `brew install icu4c`, you can get a
standard dynamic build via:

```
$ stack build
```

You can see this depends on dynamic libraries by running `otool -L`:

```
$ otool -L /Users/jml/src/haskell-static-minimal-repro/.stack-work/install/x86_64-osx/lts-7.1/8.0.1/bin/haskell-static-minimal-repro
/Users/jml/src/haskell-static-minimal-repro/.stack-work/install/x86_64-osx/lts-7.1/8.0.1/bin/haskell-static-minimal-repro:
       	/usr/local/opt/icu4c/lib/libicuuc.57.dylib (compatibility version 57.0.0, current version 57.1.0)
       	/usr/local/opt/icu4c/lib/libicui18n.57.dylib (compatibility version 57.0.0, current version 57.1.0)
       	/usr/local/opt/icu4c/lib/libicudata.57.1.dylib (compatibility version 57.0.0, current version 57.1.0)
       	/usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
       	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1226.10.1)
```

## Building on OS X (static)

You must run `stack clean` first, since `stack` doesn't seem to interpret
change of compiler options as a change worth rebuilding for.

```
$ stack build  --ghc-options '-static -optl-static'
haskell-static-minimal-repro-0.1.0.0: configure
Configuring haskell-static-minimal-repro-0.1.0.0...
haskell-static-minimal-repro-0.1.0.0: build
Preprocessing executable 'haskell-static-minimal-repro' for
haskell-static-minimal-repro-0.1.0.0...
[1 of 1] Compiling Main             ( src/Main.hs, .stack-work/dist/x86_64-osx/Cabal-1.24.0.0/build/haskell-static-minimal-repro/haskell-static-minimal-repro-tmp/Main.o )
Linking .stack-work/dist/x86_64-osx/Cabal-1.24.0.0/build/haskell-static-minimal-repro/haskell-static-minimal-repro ...
ld: library not found for -lcrt0.o
clang: error: linker command failed with exit code 1 (use -v to see invocation)
`gcc' failed in phase `Linker'. (Exit code: 1)

--  While building package haskell-static-minimal-repro-0.1.0.0 using:
      /Users/jml/.stack/setup-exe-cache/x86_64-osx/setup-Simple-Cabal-1.24.0.0-ghc-8.0.1 --builddir=.stack-work/dist/x86_64-osx/Cabal-1.24.0.0 build exe:haskell-static-minimal-repro --ghc-options " -ddump-hi -ddump-to-file"
    Process exited with code: ExitFailure 1
```

This fails. I don't know why.

I asked about this on [Stack Overflow](http://stackoverflow.com/questions/39805657/how-can-i-create-static-executables-on-os-x-with-stack).
