{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Models where

import Control.Monad (mzero)
import Data.Aeson.Types
import Data.Aeson
import qualified Data.Text as T
import Control.Applicative ((<$>), (<*>))

data Coord = Coord { x :: Double, y :: Double }

data User = User {
                   username :: String,
                   id :: Int,
                   url :: String,
                   name :: String,
                   token :: String
                 }

instance ToJSON User where
  toJSON (User username id url name token) =
    object [T.pack "username" .= username, T.pack "id" .= id, T.pack "url" .= url, T.pack "name" .= name, T.pack "token" .= token]

instance FromJSON User where
  parseJSON (Object v) = User <$>
                         v .: "login" <*>
                         v .: "id" <*>
                         v .: "url" <*>
                         v .: "name" <*>
                         v .:? "token" .!= ""
  parseJSON _ = mzero

data AccessToken = AccessToken { accessToken :: String,
                                 tokenType :: String,
                                 scope :: String
                               } deriving Show

instance ToJSON AccessToken where
  toJSON (AccessToken accessToken tokenType scope) = object [T.pack "accessToken" .= accessToken, T.pack "tokenType" .= tokenType, T.pack "scope" .= scope]
  
instance FromJSON AccessToken where
  parseJSON (Object v) = AccessToken <$>
                         v .: "access_token" <*>
                         v .: "token_type" <*>
                         v .: "scope"
  parseJSON _ = mzero

instance ToJSON Coord where
  toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]