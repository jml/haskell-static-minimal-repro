Minimal example of static linking with Stack.

This builds a simple script that takes stdin and replaces every occurrence of
"jml" with "jml of the shaven yak".

## Building on OS X (standard)

After installing `icu` libraries via `brew install icu4c`, you can get a
standard dynamic build via:

```
$ stack build
```

I have tried this with:

```
Version 1.1.2, Git revision cebe10e845fed4420b6224d97dcabf20477bbd4b (3646 commits) x86_64 hpack-0.14.0
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

## Building on Linux (standard)

This is on Ubuntu 16.04 LTS in a Docker image running on my Macbook. YMMV.

```
$ sudo apt-get install libicu-dev
$ stack build
```

This is:

```
Version 1.2.0, Git revision 241cd07d576d9c0c0e712e83d947e3dd64541c42 (4054 commits) x86_64 hpack-0.14.0
```

Running `ldd` shows the dynamic dependencies:

```
ldd /mnt/.stack-work/install/x86_64-linux/lts-7.1/8.0.1/bin/haskell-static-minimal-repro
       	linux-vdso.so.1 =>  (0x00007fff403c7000)
       	libicuuc.so.55 => /usr/lib/x86_64-linux-gnu/libicuuc.so.55 (0x00007f96cb5f7000)
       	libicui18n.so.55 => /usr/lib/x86_64-linux-gnu/libicui18n.so.55 (0x00007f96cb195000)
       	libicudata.so.55 => /usr/lib/x86_64-linux-gnu/libicudata.so.55 (0x00007f96c96dd000)
       	libgmp.so.10 => /usr/lib/x86_64-linux-gnu/libgmp.so.10 (0x00007f96c945d000)
       	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f96c9154000)
       	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f96c8f4b000)
       	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f96c8d47000)
       	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f96c8b31000)
       	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f96c8767000)
       	libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f96c83e5000)
       	/lib64/ld-linux-x86-64.so.2 (0x000055b30da70000)
       	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f96c81c7000)
```

## Building on Linux (static)

On the same machine, this is the set of options that get me the least errors:

```
# stack build --ghc-options '-static -optl-static -optl-pthread -fPIC'
haskell-static-minimal-repro-0.1.0.0: configure
Configuring haskell-static-minimal-repro-0.1.0.0...
haskell-static-minimal-repro-0.1.0.0: build
Preprocessing executable 'haskell-static-minimal-repro' for
haskell-static-minimal-repro-0.1.0.0...
[1 of 1] Compiling Main             ( src/Main.hs, .stack-work/dist/x86_64-linux/Cabal-1.24.0.0/build/haskell-static-minimal-repro/haskell-static-minimal-repro-tmp/Main.o ) [flags changed]
Linking .stack-work/dist/x86_64-linux/Cabal-1.24.0.0/build/haskell-static-minimal-repro/haskell-static-minimal-repro ...
/root/.stack/programs/x86_64-linux/ghc-8.0.1/lib/ghc-8.0.1/rts/libHSrts.a(Linker.o): In function `internal_dlopen':

/home/ben/bin-dist-8.0.1-Linux/ghc/rts/Linker.c:926:0: error:
     warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao): In function `normalizeSecondAndAppend(UNormalizer2 const*, unsigned short*, int, int, unsigned short const*, int, signed char, UErrorCode*)':
(.text+0x216): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao): In function `unorm2_normalize_55':
(.text+0xb4f): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTIN6icu_5511Normalizer2E[_ZTIN6icu_5511Normalizer2E]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTIN6icu_5519Normalizer2WithImplE[_ZTIN6icu_5519Normalizer2WithImplE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTIN6icu_5520DecomposeNormalizer2E[_ZTIN6icu_5520DecomposeNormalizer2E]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTIN6icu_5518ComposeNormalizer2E[_ZTIN6icu_5518ComposeNormalizer2E]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTIN6icu_5514FCDNormalizer2E[_ZTIN6icu_5514FCDNormalizer2E]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTIN6icu_5515NoopNormalizer2E[_ZTIN6icu_5515NoopNormalizer2E]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTVN6icu_5511Normalizer2E[_ZTVN6icu_5511Normalizer2E]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTVN6icu_5511Normalizer2E[_ZTVN6icu_5511Normalizer2E]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTVN6icu_5511Normalizer2E[_ZTVN6icu_5511Normalizer2E]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTVN6icu_5511Normalizer2E[_ZTVN6icu_5511Normalizer2E]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTVN6icu_5511Normalizer2E[_ZTVN6icu_5511Normalizer2E]+0x60): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2.ao):(.data.rel.ro._ZTVN6icu_5511Normalizer2E[_ZTVN6icu_5511Normalizer2E]+0x68): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(loadednormalizer2impl.ao):(.data.rel.ro._ZTIN6icu_5521LoadedNormalizer2ImplE[_ZTIN6icu_5521LoadedNormalizer2ImplE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uniset_props.ao): In function `icu_55::UnicodeSet::applyPattern(icu_55::RuleCharacterIterator&, icu_55::SymbolTable const*, icu_55::UnicodeString&, unsigned int, icu_55::UnicodeSet& (icu_55::UnicodeSet::*)(int), UErrorCode&)':
(.text+0x1bb9): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(rbbiscan.ao):(.data.rel.ro._ZTIN6icu_5515RBBIRuleScannerE[_ZTIN6icu_5515RBBIRuleScannerE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(locid.ao):(.data.rel.ro._ZTIN6icu_556LocaleE[_ZTIN6icu_556LocaleE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(locid.ao):(.data.rel.ro._ZTIN6icu_5518KeywordEnumerationE[_ZTIN6icu_5518KeywordEnumerationE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(normalizer2impl.ao):(.data.rel.ro._ZTIN6icu_5515Normalizer2ImplE[_ZTIN6icu_5515Normalizer2ImplE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTIN6icu_5513BreakIteratorE[_ZTIN6icu_5513BreakIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTIN6icu_5523ICUBreakIteratorFactoryE[_ZTIN6icu_5523ICUBreakIteratorFactoryE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTVN6icu_5513BreakIteratorE[_ZTVN6icu_5513BreakIteratorE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTVN6icu_5513BreakIteratorE[_ZTVN6icu_5513BreakIteratorE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTVN6icu_5513BreakIteratorE[_ZTVN6icu_5513BreakIteratorE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTVN6icu_5513BreakIteratorE[_ZTVN6icu_5513BreakIteratorE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTVN6icu_5513BreakIteratorE[_ZTVN6icu_5513BreakIteratorE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkiter.ao):(.data.rel.ro._ZTVN6icu_5513BreakIteratorE[_ZTVN6icu_5513BreakIteratorE]+0x48): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servls.ao):(.data.rel.ro._ZTIN6icu_5516ICULocaleServiceE[_ZTIN6icu_5516ICULocaleServiceE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servls.ao):(.data.rel.ro._ZTIN6icu_5518ServiceEnumerationE[_ZTIN6icu_5518ServiceEnumerationE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servls.ao):(.data.rel.ro._ZTVN6icu_5516ICULocaleServiceE[_ZTVN6icu_5516ICULocaleServiceE]+0x80): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x56f): undefined reference to `ulist_createEmptyList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x57c): undefined reference to `ulist_createEmptyList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x72e): undefined reference to `ulist_addItemEndList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x73c): undefined reference to `ulist_getListSize_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x792): undefined reference to `ulist_addItemBeginList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x7d4): undefined reference to `ulist_deleteList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x7e2): undefined reference to `ulist_resetList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x830): undefined reference to `ulist_deleteList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x838): undefined reference to `ulist_deleteList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x854): undefined reference to `ulist_resetList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x866): undefined reference to `ulist_getNext_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x887): undefined reference to `ulist_containsString_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `ucol_getKeywordValuesForLocale_55':
(.text+0x89b): undefined reference to `ulist_addItemEndList_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::CollationLoader(icu_55::CollationCacheEntry const*, icu_55::Locale const&, UErrorCode&)':
(.text+0x928): undefined reference to `icu_55::UnifiedCache::getInstance(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::loadFromData(UErrorCode&)':
(.text+0xe04): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::loadFromData(UErrorCode&)':
(.text+0xe0e): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::loadFromData(UErrorCode&)':
(.text+0xef5): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::getCacheEntry(UErrorCode&)':
(.text+0xfae): undefined reference to `icu_55::CacheKeyBase::~CacheKeyBase()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::getCacheEntry(UErrorCode&)':
(.text+0x1006): undefined reference to `icu_55::UnifiedCache::_get(icu_55::CacheKeyBase const&, icu_55::SharedObject const*&, void const*, UErrorCode&) const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::getCacheEntry(UErrorCode&)':
(.text+0x1025): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::getCacheEntry(UErrorCode&)':
(.text+0x105c): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::getCacheEntry(UErrorCode&)':
(.text+0x1087): undefined reference to `icu_55::CacheKeyBase::~CacheKeyBase()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::loadTailoring(icu_55::Locale const&, UErrorCode&)':
(.text+0x110a): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::makeCacheEntry(icu_55::Locale const&, icu_55::CollationCacheEntry const*, UErrorCode&)':
(.text+0x1424): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::makeCacheEntry(icu_55::Locale const&, icu_55::CollationCacheEntry const*, UErrorCode&)':
(.text+0x142c): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::makeCacheEntry(icu_55::Locale const&, icu_55::CollationCacheEntry const*, UErrorCode&)':
(.text+0x1434): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::makeCacheEntry(icu_55::Locale const&, icu_55::CollationCacheEntry const*, UErrorCode&)':
(.text+0x1454): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::makeCacheEntry(icu_55::Locale const&, icu_55::CollationCacheEntry const*, UErrorCode&)':
(.text+0x146a): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::makeCacheEntryFromRoot(icu_55::Locale const&, UErrorCode&) const [clone .part.10] [clone .constprop.12]':
(.text+0x14a1): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::CollationLoader::loadFromLocale(UErrorCode&)':
(.text+0x1b33): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::LocaleCacheKey<icu_55::CollationCacheEntry>::clone() const':
(.text._ZNK6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEE5cloneEv[_ZNK6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEE5cloneEv]+0x53): undefined reference to `icu_55::CacheKeyBase::~CacheKeyBase()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::LocaleCacheKey<icu_55::CollationCacheEntry>::~LocaleCacheKey()':
(.text._ZN6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEED2Ev[_ZN6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEED5Ev]+0x27): undefined reference to `icu_55::CacheKeyBase::~CacheKeyBase()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao): In function `icu_55::LocaleCacheKey<icu_55::CollationCacheEntry>::~LocaleCacheKey()':
(.text._ZN6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEED0Ev[_ZN6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEED5Ev]+0x26): undefined reference to `icu_55::CacheKeyBase::~CacheKeyBase()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro._ZTIN6icu_558CacheKeyINS_19CollationCacheEntryEEE[_ZTIN6icu_558CacheKeyINS_19CollationCacheEntryEEE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro._ZTIN6icu_558CacheKeyINS_19CollationCacheEntryEEE[_ZTIN6icu_558CacheKeyINS_19CollationCacheEntryEEE]+0x10): undefined reference to `typeinfo for icu_55::CacheKeyBase'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro._ZTIN6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEEE[_ZTIN6icu_5514LocaleCacheKeyINS_19CollationCacheEntryEEE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro._ZTVN6icu_558CacheKeyINS_19CollationCacheEntryEEE[_ZTVN6icu_558CacheKeyINS_19CollationCacheEntryEEE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro._ZTVN6icu_558CacheKeyINS_19CollationCacheEntryEEE[_ZTVN6icu_558CacheKeyINS_19CollationCacheEntryEEE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro+0x10): undefined reference to `ulist_close_keyword_values_iterator_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro+0x18): undefined reference to `ulist_count_keyword_values_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro+0x28): undefined reference to `ulist_next_keyword_value_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol_res.ao):(.data.rel.ro+0x30): undefined reference to `ulist_reset_keyword_values_iterator_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setMaxVariable(UColReorderCode, UErrorCode&)':
(.text+0x12e5): undefined reference to `icu_55::SharedObject::getRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setMaxVariable(UColReorderCode, UErrorCode&)':
(.text+0x1317): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setMaxVariable(UColReorderCode, UErrorCode&)':
(.text+0x1323): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setAttribute(UColAttribute, UColAttributeValue, UErrorCode&)':
(.text+0x14b4): undefined reference to `icu_55::SharedObject::getRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setAttribute(UColAttribute, UColAttributeValue, UErrorCode&)':
(.text+0x14e2): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setAttribute(UColAttribute, UColAttributeValue, UErrorCode&)':
(.text+0x14ee): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setReorderCodes(int const*, int, UErrorCode&)':
(.text+0x16fc): undefined reference to `icu_55::SharedObject::getRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setReorderCodes(int const*, int, UErrorCode&)':
(.text+0x172a): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setReorderCodes(int const*, int, UErrorCode&)':
(.text+0x1737): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setReorderCodes(int const*, int, UErrorCode&)':
(.text+0x17b9): undefined reference to `icu_55::SharedObject::getRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setReorderCodes(int const*, int, UErrorCode&)':
(.text+0x17ea): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setReorderCodes(int const*, int, UErrorCode&)':
(.text+0x17f7): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setVariableTop(unsigned int, UErrorCode&)':
(.text+0x1953): undefined reference to `icu_55::SharedObject::getRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setVariableTop(unsigned int, UErrorCode&)':
(.text+0x1985): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::setVariableTop(unsigned int, UErrorCode&)':
(.text+0x1991): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::operator=(icu_55::RuleBasedCollator const&)':
(.text+0x23e6): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::operator=(icu_55::RuleBasedCollator const&)':
(.text+0x23f7): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::operator=(icu_55::RuleBasedCollator const&)':
(.text+0x2416): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::operator=(icu_55::RuleBasedCollator const&)':
(.text+0x2427): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::internalGetCEs(icu_55::UnicodeString const&, icu_55::UVector64&, UErrorCode&) const':
(.text+0x3467): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::internalGetCEs(icu_55::UnicodeString const&, icu_55::UVector64&, UErrorCode&) const':
(.text+0x35a7): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::RuleBasedCollator(icu_55::RuleBasedCollator const&)':
(.text+0x3bc7): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::RuleBasedCollator(icu_55::RuleBasedCollator const&)':
(.text+0x3bd0): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::RuleBasedCollator(icu_55::CollationCacheEntry const*)':
(.text+0x3cae): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::RuleBasedCollator(icu_55::CollationCacheEntry const*)':
(.text+0x3cb7): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::~RuleBasedCollator()':
(.text+0x3cf8): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::~RuleBasedCollator()':
(.text+0x3d0e): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::adoptTailoring(icu_55::CollationTailoring*, UErrorCode&)':
(.text+0x3dc3): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::adoptTailoring(icu_55::CollationTailoring*, UErrorCode&)':
(.text+0x3ddc): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::adoptTailoring(icu_55::CollationTailoring*, UErrorCode&)':
(.text+0x3de9): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::adoptTailoring(icu_55::CollationTailoring*, UErrorCode&)':
(.text+0x3e3f): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::hashCode() const':
(.text+0x43e4): undefined reference to `icu_55::UnicodeSetIterator::UnicodeSetIterator(icu_55::UnicodeSet const&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::hashCode() const':
(.text+0x4445): undefined reference to `icu_55::UnicodeSetIterator::next()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::hashCode() const':
(.text+0x4454): undefined reference to `icu_55::UnicodeSetIterator::~UnicodeSetIterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::hashCode() const':
(.text+0x44b6): undefined reference to `icu_55::UnicodeSetIterator::~UnicodeSetIterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::adoptTailoring(icu_55::CollationTailoring*, UErrorCode&)':
(.text+0x3d5a): undefined reference to `icu_55::SharedObject::deleteIfZeroRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao): In function `icu_55::RuleBasedCollator::adoptTailoring(icu_55::CollationTailoring*, UErrorCode&)':
(.text+0x3e2c): undefined reference to `icu_55::SharedObject::deleteIfZeroRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro._ZTIN6icu_5517RuleBasedCollatorE[_ZTIN6icu_5517RuleBasedCollatorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x18): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x30): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x48): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x60): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x108): undefined reference to `icu_55::ByteSink::Flush()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro+0x148): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro._ZTIN6icu_5520CollationKeyByteSinkE[_ZTIN6icu_5520CollationKeyByteSinkE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rulebasedcollator.ao):(.data.rel.ro._ZTVN6icu_5520CollationKeyByteSinkE[_ZTVN6icu_5520CollationKeyByteSinkE]+0x30): undefined reference to `icu_55::ByteSink::Flush()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao): In function `icu_55::Collator::makeInstance(icu_55::Locale const&, UErrorCode&)':
(.text+0x8e0): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao): In function `icu_55::Collator::makeInstance(icu_55::Locale const&, UErrorCode&)':
(.text+0x914): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao): In function `icu_55::initAvailableLocaleList(UErrorCode&)':
(.text+0x180f): undefined reference to `__cxa_throw_bad_array_new_length'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTIN6icu_558CollatorE[_ZTIN6icu_558CollatorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTIN6icu_5515CollatorFactoryE[_ZTIN6icu_5515CollatorFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTIN6icu_5518ICUCollatorFactoryE[_ZTIN6icu_5518ICUCollatorFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTIN6icu_5518ICUCollatorServiceE[_ZTIN6icu_5518ICUCollatorServiceE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTIN6icu_558CFactoryE[_ZTIN6icu_558CFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTIN6icu_5530CollationLocaleListEnumerationE[_ZTIN6icu_5530CollationLocaleListEnumerationE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTVN6icu_5515CollatorFactoryE[_ZTVN6icu_5515CollatorFactoryE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTVN6icu_5515CollatorFactoryE[_ZTVN6icu_5515CollatorFactoryE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTVN6icu_558CollatorE[_ZTVN6icu_558CollatorE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTVN6icu_558CollatorE[_ZTVN6icu_558CollatorE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTVN6icu_558CollatorE[_ZTVN6icu_558CollatorE]+0x48): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coll.ao):(.data.rel.ro._ZTVN6icu_558CollatorE[_ZTVN6icu_558CollatorE]+0x58): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::appendOp(int)':
(.text+0x244): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::blockTopLoc(signed char)':
(.text+0x7d4): undefined reference to `icu_55::UVector64::insertElementAt(long, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::insertOp(int)':
(.text+0x844): undefined reference to `icu_55::UVector64::insertElementAt(long, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::insertOp(int)':
(.text+0x8ba): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compileInterval(int, int)':
(.text+0xa46): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compileInterval(int, int)':
(.text+0xa66): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compileInterval(int, int)':
(.text+0xa7d): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compileInterval(int, int)':
(.text+0xa94): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compileInlineInterval() [clone .part.17] [clone .constprop.27]':
(.text+0xc37): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compileInlineInterval() [clone .part.17] [clone .constprop.27]':
(.text+0xc98): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::handleCloseParen()':
(.text+0x18fd): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::handleCloseParen()':
(.text+0x19f6): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::handleCloseParen()':
(.text+0x1a0f): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::handleCloseParen()':
(.text+0x1a35): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao):(.text+0x1b2b): more undefined references to `icu_55::UVector64::setElementAt(long, int)' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::stripNOPs()':
(.text+0x1ea5): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::stripNOPs()':
(.text+0x1ef5): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::findCaseInsensitiveStarters(int, icu_55::UnicodeSet*)':
(.text+0x27fa): undefined reference to `icu_55::UnicodeSet::closeOver(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::matchStartType()':
(.text+0x30cd): undefined reference to `icu_55::UnicodeSet::closeOver(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::createSetForProperty(icu_55::UnicodeString const&, signed char)':
(.text+0x365b): undefined reference to `icu_55::UnicodeSet::UnicodeSet(icu_55::UnicodeString const&, unsigned int, icu_55::SymbolTable const*, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::createSetForProperty(icu_55::UnicodeString const&, signed char)':
(.text+0x3b5f): undefined reference to `icu_55::UnicodeSet::UnicodeSet(icu_55::UnicodeString const&, unsigned int, icu_55::SymbolTable const*, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::createSetForProperty(icu_55::UnicodeString const&, signed char)':
(.text+0x46b9): undefined reference to `icu_55::UnicodeSet::closeOver(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::setEval(int)':
(.text+0x5bc9): undefined reference to `icu_55::UnicodeSet::closeOver(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x5e0b): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x5ee5): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x6327): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x6471): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x671d): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao):(.text+0x69d5): more undefined references to `icu_55::UVector64::setElementAt(long, int)' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x7bc1): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x7e77): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x7f29): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x86e7): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::doParseActions(int)':
(.text+0x8ba0): undefined reference to `icu_55::UVector64::setElementAt(long, int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao): In function `icu_55::RegexCompile::compile(UText*, UParseError&, UErrorCode&)':
(.text+0x905e): undefined reference to `__cxa_throw_bad_array_new_length'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(regexcmp.ao):(.data.rel.ro._ZTIN6icu_5512RegexCompileE[_ZTIN6icu_5512RegexCompileE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(ucnv_bld.ao):(.data.DW.ref.__gxx_personality_v0[DW.ref.__gxx_personality_v0]+0x0): undefined reference to `__gxx_personality_v0'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uniset.ao): In function `icu_55::SymbolTable::~SymbolTable()':
(.text+0x571): undefined reference to `operator delete(void*)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uniset.ao):(.data.rel.ro._ZTIN6icu_5511SymbolTableE[_ZTIN6icu_5511SymbolTableE]+0x0): undefined reference to `vtable for __cxxabiv1::__class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uniset.ao):(.data.rel.ro._ZTIN6icu_5510UnicodeSetE[_ZTIN6icu_5510UnicodeSetE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao): In function `icu_55::UnicodeMatcher::~UnicodeMatcher()':
(.text+0x181): undefined reference to `operator delete(void*)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTIN6icu_5514UnicodeMatcherE[_ZTIN6icu_5514UnicodeMatcherE]+0x0): undefined reference to `vtable for __cxxabiv1::__class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTIN6icu_5513UnicodeFilterE[_ZTIN6icu_5513UnicodeFilterE]+0x0): undefined reference to `vtable for __cxxabiv1::__vmi_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTVN6icu_5513UnicodeFilterE[_ZTVN6icu_5513UnicodeFilterE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTVN6icu_5513UnicodeFilterE[_ZTVN6icu_5513UnicodeFilterE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTVN6icu_5513UnicodeFilterE[_ZTVN6icu_5513UnicodeFilterE]+0x48): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTVN6icu_5513UnicodeFilterE[_ZTVN6icu_5513UnicodeFilterE]+0x80): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTVN6icu_5513UnicodeFilterE[_ZTVN6icu_5513UnicodeFilterE]+0x88): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifilt.ao):(.data.rel.ro._ZTVN6icu_5513UnicodeFilterE[_ZTVN6icu_5513UnicodeFilterE]+0x90): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifunct.ao):(.data.rel.ro._ZTIN6icu_5514UnicodeFunctorE[_ZTIN6icu_5514UnicodeFunctorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifunct.ao):(.data.rel.ro._ZTVN6icu_5514UnicodeFunctorE[_ZTVN6icu_5514UnicodeFunctorE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifunct.ao):(.data.rel.ro._ZTVN6icu_5514UnicodeFunctorE[_ZTVN6icu_5514UnicodeFunctorE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unifunct.ao):(.data.rel.ro._ZTVN6icu_5514UnicodeFunctorE[_ZTVN6icu_5514UnicodeFunctorE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(rbbi.ao):(.data.rel.ro._ZTIN6icu_5522RuleBasedBreakIteratorE[_ZTIN6icu_5522RuleBasedBreakIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(rbbirb.ao):(.data.rel.ro._ZTIN6icu_557UMemoryE[_ZTIN6icu_557UMemoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(rbbirb.ao):(.data.rel.ro._ZTIN6icu_5515RBBIRuleBuilderE[_ZTIN6icu_5515RBBIRuleBuilderE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(rbbistbl.ao):(.data.rel.ro._ZTIN6icu_5515RBBISymbolTableE[_ZTIN6icu_5515RBBISymbolTableE]+0x0): undefined reference to `vtable for __cxxabiv1::__vmi_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(parsepos.ao):(.data.rel.ro._ZTIN6icu_5513ParsePositionE[_ZTIN6icu_5513ParsePositionE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uobject.ao): In function `icu_55::UMemory::operator new[](unsigned long)':
(.text+0x3d): undefined reference to `__cxa_call_unexpected'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uobject.ao): In function `icu_55::UMemory::operator delete[](void*)':
(.text+0x83): undefined reference to `__cxa_call_unexpected'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uobject.ao):(.data.rel.ro._ZTIN6icu_557UObjectE[_ZTIN6icu_557UObjectE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uvector.ao):(.data.rel.ro._ZTIN6icu_557UVectorE[_ZTIN6icu_557UVectorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(ustack.ao):(.data.rel.ro._ZTIN6icu_556UStackE[_ZTIN6icu_556UStackE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(locavailable.ao): In function `icu_55::locale_available_init()':
(.text+0x421): undefined reference to `__cxa_throw_bad_array_new_length'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTIN6icu_5523UnicodeStringAppendableE[_ZTIN6icu_5523UnicodeStringAppendableE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTIN6icu_5511ReplaceableE[_ZTIN6icu_5511ReplaceableE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTIN6icu_5513UnicodeStringE[_ZTIN6icu_5513UnicodeStringE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTVN6icu_5511ReplaceableE[_ZTVN6icu_5511ReplaceableE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTVN6icu_5511ReplaceableE[_ZTVN6icu_5511ReplaceableE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTVN6icu_5511ReplaceableE[_ZTVN6icu_5511ReplaceableE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTVN6icu_5511ReplaceableE[_ZTVN6icu_5511ReplaceableE]+0x50): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTVN6icu_5511ReplaceableE[_ZTVN6icu_5511ReplaceableE]+0x58): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(unistr.ao):(.data.rel.ro._ZTVN6icu_5511ReplaceableE[_ZTVN6icu_5511ReplaceableE]+0x60): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(filterednormalizer2.ao):(.data.rel.ro._ZTIN6icu_5519FilteredNormalizer2E[_ZTIN6icu_5519FilteredNormalizer2E]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(schriter.ao):(.data.rel.ro._ZTIN6icu_5523StringCharacterIteratorE[_ZTIN6icu_5523StringCharacterIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uchriter.ao):(.data.rel.ro._ZTIN6icu_5522UCharCharacterIteratorE[_ZTIN6icu_5522UCharCharacterIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(bmpset.ao):(.data.rel.ro._ZTIN6icu_556BMPSetE[_ZTIN6icu_556BMPSetE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkeng.ao):(.data.rel.ro._ZTIN6icu_5519LanguageBreakEngineE[_ZTIN6icu_5519LanguageBreakEngineE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkeng.ao):(.data.rel.ro._ZTIN6icu_5520LanguageBreakFactoryE[_ZTIN6icu_5520LanguageBreakFactoryE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkeng.ao):(.data.rel.ro._ZTVN6icu_5519LanguageBreakEngineE[_ZTVN6icu_5519LanguageBreakEngineE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkeng.ao):(.data.rel.ro._ZTVN6icu_5519LanguageBreakEngineE[_ZTVN6icu_5519LanguageBreakEngineE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(brkeng.ao):(.data.rel.ro._ZTVN6icu_5520LanguageBreakFactoryE[_ZTVN6icu_5520LanguageBreakFactoryE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTIN6icu_5521DictionaryBreakEngineE[_ZTIN6icu_5521DictionaryBreakEngineE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTIN6icu_5515ThaiBreakEngineE[_ZTIN6icu_5515ThaiBreakEngineE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTIN6icu_5514LaoBreakEngineE[_ZTIN6icu_5514LaoBreakEngineE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTIN6icu_5518BurmeseBreakEngineE[_ZTIN6icu_5518BurmeseBreakEngineE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTIN6icu_5516KhmerBreakEngineE[_ZTIN6icu_5516KhmerBreakEngineE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTIN6icu_5514CjkBreakEngineE[_ZTIN6icu_5514CjkBreakEngineE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictbe.ao):(.data.rel.ro._ZTVN6icu_5521DictionaryBreakEngineE[_ZTVN6icu_5521DictionaryBreakEngineE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao): In function `icu_55::ICUService::acceptsListener(icu_55::EventListener const&) const':
(.text+0x5fd): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTIN6icu_5513ICUServiceKeyE[_ZTIN6icu_5513ICUServiceKeyE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTIN6icu_5517ICUServiceFactoryE[_ZTIN6icu_5517ICUServiceFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTIN6icu_5513SimpleFactoryE[_ZTIN6icu_5513SimpleFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTIN6icu_5515ServiceListenerE[_ZTIN6icu_5515ServiceListenerE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTIN6icu_5510ICUServiceE[_ZTIN6icu_5510ICUServiceE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTVN6icu_5517ICUServiceFactoryE[_ZTVN6icu_5517ICUServiceFactoryE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTVN6icu_5517ICUServiceFactoryE[_ZTVN6icu_5517ICUServiceFactoryE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTVN6icu_5517ICUServiceFactoryE[_ZTVN6icu_5517ICUServiceFactoryE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTVN6icu_5515ServiceListenerE[_ZTVN6icu_5515ServiceListenerE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(serv.ao):(.data.rel.ro._ZTVN6icu_5510ICUServiceE[_ZTVN6icu_5510ICUServiceE]+0x80): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servnotf.ao):(.data.rel.ro._ZTIN6icu_5513EventListenerE[_ZTIN6icu_5513EventListenerE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servnotf.ao):(.data.rel.ro._ZTIN6icu_5511ICUNotifierE[_ZTIN6icu_5511ICUNotifierE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servnotf.ao):(.data.rel.ro._ZTVN6icu_5511ICUNotifierE[_ZTVN6icu_5511ICUNotifierE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servnotf.ao):(.data.rel.ro._ZTVN6icu_5511ICUNotifierE[_ZTVN6icu_5511ICUNotifierE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servlk.ao):(.data.rel.ro._ZTIN6icu_559LocaleKeyE[_ZTIN6icu_559LocaleKeyE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servlkf.ao):(.data.rel.ro._ZTIN6icu_5516LocaleKeyFactoryE[_ZTIN6icu_5516LocaleKeyFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servrbf.ao):(.data.rel.ro._ZTIN6icu_5524ICUResourceBundleFactoryE[_ZTIN6icu_5524ICUResourceBundleFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(servslkf.ao):(.data.rel.ro._ZTIN6icu_5522SimpleLocaleKeyFactoryE[_ZTIN6icu_5522SimpleLocaleKeyFactoryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(ustrenum.ao):(.data.rel.ro._ZTIN6icu_5517StringEnumerationE[_ZTIN6icu_5517StringEnumerationE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(ustrenum.ao):(.data.rel.ro._ZTIN6icu_5518UStringEnumerationE[_ZTIN6icu_5518UStringEnumerationE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(ustrenum.ao):(.data.rel.ro._ZTVN6icu_5517StringEnumerationE[_ZTVN6icu_5517StringEnumerationE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(ustrenum.ao):(.data.rel.ro._ZTVN6icu_5517StringEnumerationE[_ZTVN6icu_5517StringEnumerationE]+0x50): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(uvectr32.ao):(.data.rel.ro._ZTIN6icu_559UVector32E[_ZTIN6icu_559UVector32E]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(resbund.ao):(.data.rel.ro._ZTIN6icu_5514ResourceBundleE[_ZTIN6icu_5514ResourceBundleE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictionarydata.ao):(.data.rel.ro._ZTIN6icu_5517DictionaryMatcherE[_ZTIN6icu_5517DictionaryMatcherE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictionarydata.ao):(.data.rel.ro._ZTIN6icu_5523UCharsDictionaryMatcherE[_ZTIN6icu_5523UCharsDictionaryMatcherE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(dictionarydata.ao):(.data.rel.ro._ZTIN6icu_5522BytesDictionaryMatcherE[_ZTIN6icu_5522BytesDictionaryMatcherE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(appendable.ao):(.data.rel.ro._ZTIN6icu_5510AppendableE[_ZTIN6icu_5510AppendableE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(appendable.ao):(.data.rel.ro._ZTVN6icu_5510AppendableE[_ZTVN6icu_5510AppendableE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTIN6icu_5524ForwardCharacterIteratorE[_ZTIN6icu_5524ForwardCharacterIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTIN6icu_5517CharacterIteratorE[_ZTIN6icu_5517CharacterIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTVN6icu_5524ForwardCharacterIteratorE[_ZTVN6icu_5524ForwardCharacterIteratorE]+0x20): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTVN6icu_5524ForwardCharacterIteratorE[_ZTVN6icu_5524ForwardCharacterIteratorE]+0x28): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTVN6icu_5524ForwardCharacterIteratorE[_ZTVN6icu_5524ForwardCharacterIteratorE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTVN6icu_5524ForwardCharacterIteratorE[_ZTVN6icu_5524ForwardCharacterIteratorE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTVN6icu_5524ForwardCharacterIteratorE[_ZTVN6icu_5524ForwardCharacterIteratorE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicuuc.a(chariter.ao):(.data.rel.ro._ZTVN6icu_5524ForwardCharacterIteratorE[_ZTVN6icu_5524ForwardCharacterIteratorE]+0x48): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol.ao): In function `ucol_openBinary_55':
(.text+0x3d): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol.ao): In function `ucol_cloneBinary_55':
(.text+0x103): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol.ao): In function `ucol_getRules_55':
(.text+0x91a): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol.ao): In function `ucol_getRulesEx_55':
(.text+0x9d3): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(ucol.ao): In function `ucol_getLocaleByType_55':
(.text+0xaa7): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao): In function `icu_55::CollationTailoring::CollationTailoring(icu_55::CollationSettings const*)':
(.text+0x292): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao): In function `icu_55::CollationTailoring::CollationTailoring(icu_55::CollationSettings const*)':
(.text+0x376): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao): In function `icu_55::CollationCacheEntry::~CollationCacheEntry()':
(.text+0x3ab): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao): In function `icu_55::CollationTailoring::~CollationTailoring()':
(.text+0x408): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao): In function `icu_55::CollationCacheEntry::~CollationCacheEntry()':
(.text+0x3c8): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao): In function `icu_55::CollationTailoring::~CollationTailoring()':
(.text+0x497): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao):(.data.rel.ro._ZTIN6icu_5518CollationTailoringE[_ZTIN6icu_5518CollationTailoringE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao):(.data.rel.ro._ZTIN6icu_5518CollationTailoringE[_ZTIN6icu_5518CollationTailoringE]+0x10): undefined reference to `typeinfo for icu_55::SharedObject'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao):(.data.rel.ro._ZTIN6icu_5519CollationCacheEntryE[_ZTIN6icu_5519CollationCacheEntryE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationtailoring.ao):(.data.rel.ro._ZTIN6icu_5519CollationCacheEntryE[_ZTIN6icu_5519CollationCacheEntryE]+0x10): undefined reference to `typeinfo for icu_55::SharedObject'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationdatareader.ao): In function `icu_55::CollationDataReader::read(icu_55::CollationTailoring const*, unsigned char const*, int, icu_55::CollationTailoring&, UErrorCode&)':
(.text+0x335): undefined reference to `icu_55::SharedObject::getRefCount() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationdatareader.ao): In function `icu_55::CollationDataReader::read(icu_55::CollationTailoring const*, unsigned char const*, int, icu_55::CollationTailoring&, UErrorCode&)':
(.text+0x367): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationdatareader.ao): In function `icu_55::CollationDataReader::read(icu_55::CollationTailoring const*, unsigned char const*, int, icu_55::CollationTailoring&, UErrorCode&)':
(.text+0x374): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationdatareader.ao): In function `icu_55::CollationDataReader::read(icu_55::CollationTailoring const*, unsigned char const*, int, icu_55::CollationTailoring&, UErrorCode&)':
(.text+0x6f4): undefined reference to `uset_getSerializedSet_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationdatareader.ao): In function `icu_55::CollationDataReader::read(icu_55::CollationTailoring const*, unsigned char const*, int, icu_55::CollationTailoring&, UErrorCode&)':
(.text+0x706): undefined reference to `uset_getSerializedRangeCount_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationdatareader.ao): In function `icu_55::CollationDataReader::read(icu_55::CollationTailoring const*, unsigned char const*, int, icu_55::CollationTailoring&, UErrorCode&)':
(.text+0x73f): undefined reference to `uset_getSerializedRange_55'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationroot.ao): In function `uprv_collation_root_cleanup':
(.text+0x11): undefined reference to `icu_55::SharedObject::removeRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationroot.ao): In function `icu_55::CollationRoot::load(UErrorCode&)':
(.text+0x180): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationroot.ao): In function `icu_55::CollationRoot::load(UErrorCode&)':
(.text+0x188): undefined reference to `icu_55::SharedObject::addRef() const'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationroot.ao): In function `icu_55::CollationRoot::load(UErrorCode&)':
(.text+0x1cf): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coleitr.ao): In function `icu_55::CollationElementIterator::operator=(icu_55::CollationElementIterator const&)':
(.text+0x112c): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coleitr.ao): In function `icu_55::CollationElementIterator::operator=(icu_55::CollationElementIterator const&)':
(.text+0x1232): undefined reference to `__dynamic_cast'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coleitr.ao):(.data.rel.ro._ZTIN6icu_5524CollationElementIteratorE[_ZTIN6icu_5524CollationElementIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(coleitr.ao):(.data.rel.ro+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(sortkey.ao):(.data.rel.ro._ZTIN6icu_5512CollationKeyE[_ZTIN6icu_5512CollationKeyE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsettings.ao): In function `icu_55::CollationSettings::CollationSettings(icu_55::CollationSettings const&)':
(.text+0x42d): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsettings.ao): In function `icu_55::CollationSettings::~CollationSettings()':
(.text+0x23): undefined reference to `icu_55::SharedObject::~SharedObject()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsettings.ao):(.data.rel.ro._ZTIN6icu_5517CollationSettingsE[_ZTIN6icu_5517CollationSettingsE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsettings.ao):(.data.rel.ro._ZTIN6icu_5517CollationSettingsE[_ZTIN6icu_5517CollationSettingsE]+0x10): undefined reference to `typeinfo for icu_55::SharedObject'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTIN6icu_5517CollationIteratorE[_ZTIN6icu_5517CollationIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTVN6icu_5517CollationIteratorE[_ZTVN6icu_5517CollationIteratorE]+0x30): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTVN6icu_5517CollationIteratorE[_ZTVN6icu_5517CollationIteratorE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTVN6icu_5517CollationIteratorE[_ZTVN6icu_5517CollationIteratorE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTVN6icu_5517CollationIteratorE[_ZTVN6icu_5517CollationIteratorE]+0x48): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTVN6icu_5517CollationIteratorE[_ZTVN6icu_5517CollationIteratorE]+0x70): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationiterator.ao):(.data.rel.ro._ZTVN6icu_5517CollationIteratorE[_ZTVN6icu_5517CollationIteratorE]+0x78): more undefined references to `__cxa_pure_virtual' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(utf16collationiterator.ao):(.data.rel.ro._ZTIN6icu_5522UTF16CollationIteratorE[_ZTIN6icu_5522UTF16CollationIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(utf16collationiterator.ao):(.data.rel.ro._ZTIN6icu_5525FCDUTF16CollationIteratorE[_ZTIN6icu_5525FCDUTF16CollationIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(utf8collationiterator.ao):(.data.rel.ro._ZTIN6icu_5521UTF8CollationIteratorE[_ZTIN6icu_5521UTF8CollationIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(utf8collationiterator.ao):(.data.rel.ro._ZTIN6icu_5524FCDUTF8CollationIteratorE[_ZTIN6icu_5524FCDUTF8CollationIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(uitercollationiterator.ao):(.data.rel.ro._ZTIN6icu_5522UIterCollationIteratorE[_ZTIN6icu_5522UIterCollationIteratorE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(uitercollationiterator.ao):(.data.rel.ro._ZTIN6icu_5525FCDUIterCollationIteratorE[_ZTIN6icu_5525FCDUIterCollationIteratorE]+0x0): more undefined references to `vtable for __cxxabiv1::__si_class_type_info' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addContractions(int, unsigned short const*)':
(.text+0x20a): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addContractions(int, unsigned short const*)':
(.text+0x225): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addContractions(int, unsigned short const*)':
(.text+0x231): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addContractions(int, unsigned short const*)':
(.text+0x259): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addPrefixes(icu_55::CollationData const*, int, unsigned short const*)':
(.text+0x3cf): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addPrefixes(icu_55::CollationData const*, int, unsigned short const*)':
(.text+0x3f5): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addPrefixes(icu_55::CollationData const*, int, unsigned short const*)':
(.text+0x401): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::addPrefixes(icu_55::CollationData const*, int, unsigned short const*)':
(.text+0x42b): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x576): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x593): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x6b8): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x6d9): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x7ae): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x7b7): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x7f2): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::compareContractions(int, unsigned short const*, unsigned short const*)':
(.text+0x7fb): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0xfec): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x1009): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x110b): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x1133): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x126e): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x1278): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x12aa): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::TailoredSet::comparePrefixes(int, unsigned short const*, unsigned short const*)':
(.text+0x12cc): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handlePrefixes(int, int, unsigned int)':
(.text+0x1bf0): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handlePrefixes(int, int, unsigned int)':
(.text+0x1c47): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handlePrefixes(int, int, unsigned int)':
(.text+0x1c89): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handlePrefixes(int, int, unsigned int)':
(.text+0x1ca7): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handleContractions(int, int, unsigned int)':
(.text+0x1d1b): undefined reference to `icu_55::UCharsTrie::Iterator::Iterator(unsigned short const*, int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handleContractions(int, int, unsigned int)':
(.text+0x1d77): undefined reference to `icu_55::UCharsTrie::Iterator::next(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handleContractions(int, int, unsigned int)':
(.text+0x1d8e): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao): In function `icu_55::ContractionsAndExpansions::handleContractions(int, int, unsigned int)':
(.text+0x1dd9): undefined reference to `icu_55::UCharsTrie::Iterator::~Iterator()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationsets.ao):(.data.rel.ro._ZTIN6icu_5525ContractionsAndExpansions6CESinkE[_ZTIN6icu_5525ContractionsAndExpansions6CESinkE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao): In function `icu_55::SortKeyByteSink::~SortKeyByteSink()':
(.text+0x35f): undefined reference to `icu_55::ByteSink::~ByteSink()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao): In function `icu_55::SortKeyByteSink::~SortKeyByteSink()':
(.text+0x34b): undefined reference to `icu_55::ByteSink::~ByteSink()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao):(.data.rel.ro._ZTIN6icu_5515SortKeyByteSinkE[_ZTIN6icu_5515SortKeyByteSinkE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao):(.data.rel.ro._ZTIN6icu_5515SortKeyByteSinkE[_ZTIN6icu_5515SortKeyByteSinkE]+0x10): undefined reference to `typeinfo for icu_55::ByteSink'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao):(.data.rel.ro._ZTIN6icu_5513CollationKeys13LevelCallbackE[_ZTIN6icu_5513CollationKeys13LevelCallbackE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao):(.data.rel.ro._ZTVN6icu_5515SortKeyByteSinkE[_ZTVN6icu_5515SortKeyByteSinkE]+0x30): undefined reference to `icu_55::ByteSink::Flush()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao):(.data.rel.ro._ZTVN6icu_5515SortKeyByteSinkE[_ZTVN6icu_5515SortKeyByteSinkE]+0x38): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(collationkeys.ao):(.data.rel.ro._ZTVN6icu_5515SortKeyByteSinkE[_ZTVN6icu_5515SortKeyByteSinkE]+0x40): undefined reference to `__cxa_pure_virtual'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::setStackLimit(int, UErrorCode&)':
(.text+0x1f52): undefined reference to `icu_55::UVector64::setMaxCapacity(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::setStackLimit(int, UErrorCode&)':
(.text+0x1f72): undefined reference to `icu_55::UVector64::setMaxCapacity(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::init2(UText*, UErrorCode&)':
(.text+0x214d): undefined reference to `icu_55::UVector64::UVector64(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::init2(UText*, UErrorCode&)':
(.text+0x2282): undefined reference to `icu_55::UVector64::setMaxCapacity(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::resetStack()':
(.text+0x26ff): undefined reference to `icu_55::UVector64::removeAllElements()'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::resetStack()':
(.text+0x276b): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x304e): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x3432): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x3792): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x3b38): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x436d): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x472d): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x47fd): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x5632): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao):(.text+0x56e4): more undefined references to `icu_55::UVector64::expandCapacity(int, UErrorCode&)' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchAt(long, signed char, UErrorCode&)':
(.text+0x63cd): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x6e0c): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x7651): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x76d9): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x7769): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x7eb8): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x826d): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x8365): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x8e9a): undefined reference to `icu_55::UVector64::expandCapacity(int, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao):(.text+0x8fe8): more undefined references to `icu_55::UVector64::expandCapacity(int, UErrorCode&)' follow
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao): In function `icu_55::RegexMatcher::MatchChunkAt(int, signed char, UErrorCode&)':
(.text+0x9a36): undefined reference to `icu_55::UVector64::setSize(int)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(rematch.ao):(.data.rel.ro._ZTIN6icu_5512RegexMatcherE[_ZTIN6icu_5512RegexMatcherE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(repattrn.ao): In function `icu_55::RegexPattern::init()':
(.text+0x3ee): undefined reference to `icu_55::UVector64::UVector64(UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(repattrn.ao): In function `icu_55::RegexPattern::operator=(icu_55::RegexPattern const&)':
(.text+0x9c0): undefined reference to `icu_55::UVector64::assign(icu_55::UVector64 const&, UErrorCode&)'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(repattrn.ao): In function `icu_55::RegexPattern::operator=(icu_55::RegexPattern const&)':
(.text+0xc18): undefined reference to `__cxa_throw_bad_array_new_length'
/usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libicui18n.a(repattrn.ao):(.data.rel.ro._ZTIN6icu_5512RegexPatternE[_ZTIN6icu_5512RegexPatternE]+0x0): undefined reference to `vtable for __cxxabiv1::__si_class_type_info'
collect2: error: ld returned 1 exit status
`gcc' failed in phase `Linker'. (Exit code: 1)

--  While building package haskell-static-minimal-repro-0.1.0.0 using:
      /root/.stack/setup-exe-cache/x86_64-linux/setup-Simple-Cabal-1.24.0.0-ghc-8.0.1 --builddir=.stack-work/dist/x86_64-linux/Cabal-1.24.0.0 build exe:haskell-static-minimal-repro --ghc-options " -ddump-hi -ddump-to-file"
    Process exited with code: ExitFailure 1
```
