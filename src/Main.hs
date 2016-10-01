module Main (main) where

import Data.Text.ICU.Replace (replaceAll)
import Data.Text.IO (interact)
import Protolude

main :: IO ()
main = interact (replaceAll "jml" "jml of the shaven yak")
