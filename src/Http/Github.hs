{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Http.Github where

import Web.Scotty
import Data.Aeson.Types
import Data.Aeson
import qualified Data.Text as T
import Network.HTTP
import Network.URI
import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L
import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)
import Cassandra

auth :: Coord
auth = Coord {x = 1, y = 2}

-- https://github.com/login/oauth/authorize?scope=user,public_repo&client_id=99c89395ab6f347787e8

stuff = do
  rsp <- Network.HTTP.simpleHTTP (getRequest "http://www.haskell.org/")
  r <- (getResponseBody rsp)
  putStrLn r
  return auth
  
-- PUT /user/starred/:owner/:repo
starRepo :: String -> String -> String -> IO (String)
starRepo owner repo accessToken = do
  initReq <- parseUrl $ "https://api.github.com/user/starred/dinomiike/pics?access_token=1de5631b352399fdb00f705e9f222729814a0d7f"
  let req = initReq { secure = True, method = "PUT", requestHeaders = [("Accept", "application/vnd.github.v3+json"), ("User-Agent", "StarMe")] } -- Turn on https
  response <- withManager $ httpLbs req
  x <- return (responseHeaders response) -- TODO: evaluate header for 204 success code
  return ""
  --return (decode (responseBody response))

createAuthPostURL :: T.Text -> String
createAuthPostURL code = "https://github.com/login/oauth/access_token?client_id=99c89395ab6f347787e8&client_secret=74c2b3119b1a0aa39a8482dc116ada1c870ea80f&code=" ++ T.unpack code ++ "&redirect_uri=http://localhost:3000/auth_cb" 

execPostReq :: T.Text -> IO (Maybe AccessTokenJSON)
execPostReq param = do
  initReq <- parseUrl $ createAuthPostURL param
  let req' = initReq { secure = True, method = "POST", requestHeaders = [("Accept", "application/json")] } -- Turn on https
  let req = urlEncodedBody [("?nonce:", "2"), ("&method", "getInfo")] req'
  response <- withManager $ httpLbs req
  L.putStr $ responseBody response
  return (decode (responseBody response))

data Coord = Coord { x :: Double, y :: Double }

data AccessTokenJSON = AccessTokenJSON { accessToken :: String,
                                         tokenType :: String,
                                         scope :: String
                                       } deriving Show

instance ToJSON AccessTokenJSON where
  toJSON (AccessTokenJSON accessToken tokenType scope) = object [T.pack "accessToken" .= accessToken, T.pack "tokenType" .= tokenType, T.pack "scope" .= scope]
  
instance FromJSON AccessTokenJSON where
  parseJSON (Object v) = AccessTokenJSON <$>
                         v .: "access_token" <*>
                         v .: "token_type" <*>
                         v .: "scope"
  parseJSON _ = mzero

data Print = Print {thing :: String}
instance ToJSON Print where
  toJSON (Print x) = object [T.pack "thing" .= x]

instance ToJSON Coord where
  toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]
   
--instance ToJSON IO a where
  --toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]