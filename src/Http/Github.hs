module Http.Github where

import Web.Scotty
import Data.Aeson.Types
import qualified Data.Text as T
import Network.HTTP
import Network.URI

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

-- createAuthPostURL :: String -> String -> String -> String -> String
-- createAuthPostURL clientId clientSecret code redirectURI = "https://github.com/login/oauth/access_token" ++ clientId 
  
createPostReq :: String -> T.Text -> Request String
createPostReq url qParam = req where
  uri = URI {uriPath = url}
  rqMethod = POST
  req = Request {rqURI = uri, rqMethod = rqMethod, rqHeaders = []}

execPostReq :: String -> T.Text -> IO Print
execPostReq url qParam = do
  rsp <- simpleHTTP (createPostReq url qParam)
  r <- (getResponseBody rsp)
  putStrLn r
  return Print {thing = r}

  -- r <- fmap (take 100) (getResponseBody rsp)
data Coord = Coord { x :: Double, y :: Double }

data Print = Print {thing :: String}
instance ToJSON Print where
  toJSON (Print x) = object [T.pack "thing" .= x]

instance ToJSON Coord where
  toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]
   
--instance ToJSON IO a where
  --toJSON (Coord x y) = object [T.pack "x" .= x, T.pack "y" .= y]