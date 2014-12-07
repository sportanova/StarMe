{-# LANGUAGE OverloadedStrings #-}
module Http.Github where

import Web.Scotty
import Data.Aeson.Types
import qualified Data.Text as T
import Network.HTTP
import Network.URI
import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L

auth :: Coord
auth = Coord {x = 1, y = 2}

-- https://github.com/login/oauth/authorize?scope=user:email&client_id=99c89395ab6f347787e8

stuff = do
  rsp <- Network.HTTP.simpleHTTP (getRequest "http://www.haskell.org/")
  r <- (getResponseBody rsp)
  putStrLn r
  return auth

doStuff :: T.Text -> IO Print
doStuff code = do
  putStrLn $ T.unpack code
  return Print {thing = T.unpack code}

createAuthPostURL :: T.Text -> String
createAuthPostURL code = "https://github.com/login/oauth/access_token?client_id=99c89395ab6f347787e8&client_secret=74c2b3119b1a0aa39a8482dc116ada1c870ea80f&code=" ++ T.unpack code ++ "&redirect_uri=http://localhost:3000/auth_cb" 

execPostReq :: T.Text -> IO()
execPostReq param = do
  initReq <- parseUrl $ createAuthPostURL param
  let req' = initReq { secure = True, method = "POST" } -- Turn on https
  let req = urlEncodedBody [("?nonce:", "2"), ("&method", "getInfo")] req'
  response <- withManager $ httpLbs req
  L.putStr $ responseBody response
  -- return Print {thing = responseBody response}

data Coord = Coord { x :: Double, y :: Double }

data Print = Print {thing :: String}
instance ToJSON Print where
  toJSON (Print x) = object [T.pack "thing" .= x]

instance ToJSON Coord where
  toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]
   
--instance ToJSON IO a where
  --toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]