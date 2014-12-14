{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Models where

import Control.Monad (mzero)
import Data.Aeson.Types
import Data.Aeson
import qualified Data.Text as T
import Control.Applicative ((<$>), (<*>))

data Repo = Repo {rname :: T.Text, rurl :: T.Text} deriving Show

instance FromJSON Repo where
  parseJSON (Object v) = Repo <$>
                         v .: "name" <*>
                         v .: "url"
  parseJSON _ = mzero

instance ToJSON Repo where
  toJSON (Repo name url) =
    object ["rurl" .= name, "rname" .= url]

data User = User {
                   username :: String,
                   id :: Int,
                   url :: String,
                   name :: String,
                   token :: String
                 }

instance ToJSON User where
  toJSON (User username id url name token) =
    object ["username" .= username, "id" .= id, "url" .= url, "name" .= name, "token" .= token]

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
  toJSON (AccessToken accessToken tokenType scope) = object ["accessToken" .= accessToken, "tokenType" .= tokenType, "scope" .= scope]
  
instance FromJSON AccessToken where
  parseJSON (Object v) = AccessToken <$>
                         v .: "access_token" <*>
                         v .: "token_type" <*>
                         v .: "scope"
  parseJSON _ = mzero