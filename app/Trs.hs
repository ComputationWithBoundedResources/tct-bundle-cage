{-# LANGUAGE ImplicitParams            #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
module Main (main) where

import Tct.Core
import Tct.Trs
import Tct.Trs.Interactive

import           Tct.Core
import qualified Tct.Core.Data                as T

import           Tct.Trs.Data
import qualified Tct.Trs.Data.DependencyGraph as DG
import qualified Tct.Trs.Data.Problem         as Prob
import qualified Tct.Trs.Data.Rules as RS
import           Tct.Trs.Processors

instance Declared Trs Trs where decls = SD runD :trsDeclarations

main :: IO ()
main = runTrs trsConfig
  -- `setSolver` ("z3",[])





-- | Declaration for "derivational" strategy.
runD :: T.Declaration ('[T.Argument 'Optional CombineWith] T.:-> TrsStrategy)
runD = strategy "run" (T.OneTuple $ combineWithArg `T.optional` Fastest) runtimeStrategy

-- | Default strategy for "runtime" complexity.
runtime :: TrsStrategy
runtime  = T.deflFun runtimeDeclaration

-- | A strategy for "runtime" complexity.
runtime' :: CombineWith -> TrsStrategy
runtime' = T.declFun runtimeDeclaration


--- * direct ---------------------------------------------------------------------------------------------------------

matchbounds = bounds Minimal Match .<||> bounds PerSymbol Match

mx dim deg   = matrix' dim deg Algebraic ?ua ?ur ?sel ?gr
mxCP dim deg = matrixCP' dim deg Algebraic ?ua ?ur

px 1 = poly' Linear Restrict ?ua ?ur ?sel ?gr
px n = poly' (Mixed n) Restrict ?ua ?ur ?sel ?gr

pxCP 1 = polyCP' Linear Restrict ?ua ?ur
pxCP n = polyCP' (Mixed n) Restrict ?ua ?ur

wgOnUsable dim deg = weightgap' dim deg Algebraic ?ua WgOnTrs
wg dim deg         = weightgap' dim deg Algebraic ?ua WgOnAny

--- * rc -------------------------------------------------------------------------------------------------------------

runtimeStrategy :: CombineWith -> TrsStrategy
runtimeStrategy combineWith = withState $ \st ->
  let mto = T.remainingTime st in mto `seq` runtimeStrategy' combineWith mto

runtimeStrategy' :: CombineWith -> Maybe Int -> TrsStrategy
runtimeStrategy' combineWith mto =
  let
    ?timeoutRel = timeoutRelative mto
    ?combine    = case combineWith of { Best -> best cmpTimeUB; Fastest -> fastest }
    ?ua         = UArgs
    ?ur         = URules
    ?gr         = NoGreedy
    ?sel        = Just selAny
  in

  withProblem $ \ prob ->
    if Prob.isInnermostProblem prob
      then rci
      else iteProgress toInnermost rci rc

withDP =
  try (withProblem toDP')
  .>>> try removeInapplicable
  .>>> try cleanSuffix
  .>>> te removeHeads
  .>>> te (withProblem partIndep)
  .>>> try cleanSuffix
  .>>> try trivial
  .>>> try usableRules
  where
    toDP' prob
      | Prob.isInnermostProblem prob =
          timeoutIn 5 (dependencyPairs .>>> try usableRules .>>> wgOnTrs)
          .<|> dependencyTuples .>>> try usableRules
      | otherwise =
          dependencyPairs .>>> try usableRules .>>> try wgOnTrs

    partIndep prob
      | Prob.isInnermostProblem prob = decomposeIndependentSG
      | otherwise                    = linearPathAnalysis

    wgOnTrs = withProblem $ \ prob ->
      if RS.null (Prob.strictTrs prob)
        then identity
        else wgOnUsable 1 1 .<||> wgOnUsable 2 1

trivialDP =
  dependencyTuples
  .>>> try usableRules
  .>>> try trivial
  .>>> try dpsimps
  .>>> tew (wg 1 0 .<||> mx 1 0)

withCWDG s = withProblem $ \ prob -> s (Prob.congruenceGraph prob)


--- ** rci ----------------------------------------------------------------------------------------------------------

rci = -- try innermostRuleRemoval .>>> trivialDP
  try innermostRuleRemoval
  .>>! ?combine
    [ timeoutIn 7 $ trivialDP   .>>> empty
    , timeoutIn 7 $ matchbounds .>>> empty
    , ?combine
        [ interpretations .>>> empty
        , withDP .>>!! dpi .>>> empty ]
    ]
  where

interpretations =
  tew (?timeoutRel 15 $ mx 1 1 .<||> wg 1 1)
  .>>> fastest
    [ tew (px 2) .>>> tew (px 3) .>>> empty
    , tew (?timeoutRel 15 mxs1) .>>> tew (?timeoutRel 15 mxs2) .>>> tew mxs3 .>>> tew mxs4 .>>> empty ]
  where
    mxs1 = mx 2 1 .<||> mx 3 1
    mxs2 = mx 2 2 .<||> mx 3 2 .<||> wg 2 2
    mxs3 = mx 3 3 .<||> mx 4 3
    mxs4 = mx 4 4

dpi =
  tew (withCWDG trans) .>>> basics
  where
    trans cwdg
      | cwdgDepth cwdg == (0::Int) = shiftLeafs
      | otherwise                  = ?timeoutRel 25 shiftLeafs .<|> removeFirstCongruence

    cwdgDepth cwdg = maximum $ 0 : [ dp r | r <- DG.roots cwdg]
      where dp n = maximum $ 0 : [ 1 + dp m | m <- DG.successors cwdg n]


    shiftLeafs = force $ removeLeafs 0 .<||> (removeLeafs 1 .<|> removeLeafs 2)

    removeLeafs 0 = force $ tew $ removeLeaf (mxCP 1 0)
    removeLeafs i =
      removeLeaf (mxCP i i)
      .<||> removeLeaf (mxCP (i+1) i)
      .<||> when' (i == 1) (removeLeaf (mxCP 3 1))
      .<||> when' (i == 2) (removeLeaf (pxCP 2))

    removeFirstCongruence = decomposeDG decomposeDGselect (Just proc) Nothing .>>! try simps
      where proc = try simps .>>> tew shiftLeafs .>>> basics .>>> empty

    basics = tew shift
      where shift = mx 2 2 .<||> mx 3 3 .<||> px 3 .<||>  mx 4 4

    simps =
      try empty
      .>>> cleanSuffix
      .>>! try trivial
      .>>> try usableRules

when' b st = if b then st else abort

--- ** rc ------------------------------------------------------------------------------------------------------------

rc =
  ?combine
    [ timeoutIn 7 $ trivialDP .>>> empty
    , timeoutIn 7 $ matchbounds .>>> empty
    , ?combine
        [ interpretations .>>> empty
        , withDP .>>!! dp .>>> empty ]
    ]
  where

  dp = withProblem $ loopFrom 1
    where
      loopFrom i prob
        | RS.null (Prob.strictTrs prob) = dpi
        | otherwise                      = tew (is i) .>>! withProblem (loopFrom $ succ i)
      is i =
        let ?sel = Just selAnyRule in
        mx i i
        .<||> wg i i
        .<||> when' (i == 2 || i == 3) (px i)
        .<||> when' (i < 4) (mx (succ i) i .<||> wg (succ i) i)

