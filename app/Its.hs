module Main (main) where

import Tct.Core
import Tct.Core.Common.Pretty  (pretty, putPretty)
import Tct.Core.Data.Answer    (tttac)
import Tct.Core.Data.ProofTree (certificate)
import Tct.Its

instance Declared Its Its where decls = itsDeclarations

main :: IO ()
main = runIts $ itsConfig
  { putAnswer = putPretty . pretty . tttac . certificate }

