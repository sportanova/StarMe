module Http.Github where

import Web.Scotty
import Data.Aeson.Types
import qualified Data.Text as T

auth :: String -> Coord
auth x = Coord {x = 1, y = 2}

data Coord = Coord { x :: Double, y :: Double }

instance ToJSON Coord where
   toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]