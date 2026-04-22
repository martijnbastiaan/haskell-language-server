module B where

-- Mirrors the pattern from clash-compiler's Clash.Sized.Internal.Index:
-- a SOURCE import bringing in a subset of names, followed by a
-- qualified normal import of the same module used to reach functions
-- that only exist in the non-boot file.
import {-# SOURCE #-} A (T(T))
import qualified A as QA

data BB = BB Int

-- Uses QA.extraFn, which is exported by A.hs but NOT by A.hs-boot.
-- With the bug, ghcide reports
--   Variable not in scope: QA.extraFn ...
--   NB: the module 'A' does not export 'extraFn'
-- because it resolves the qualified import against the hs-boot exports
-- instead of the full module.
someBFn :: Int -> Int
someBFn n = case QA.extraFn (T n) of
  T m -> m
