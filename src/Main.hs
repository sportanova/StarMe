{-# LANGUAGE OverloadedStrings, DataKinds #-}
import Web.Scotty
import Http.Github
import Control.Monad.IO.Class(liftIO)
import Database.Cassandra.CQL
import Cassandra
import Data.UUID
import System.Random
import Network.Wai.Middleware.Static
import qualified Data.Text as T

main = scotty 3000 $ do
  pool <- liftIO initCass
  middleware $ staticPolicy (noDots >-> addBase "static")

  get "/" $ file "index.html"
  get "/wat" $ do
    html "NOW!"
  get "/auth_cb" $ do
    code <- param "code"
    r <- liftIO (createNewUser pool code)
    json r
  get "/hello" $ do
    name <- param "name"
    text name
  get "/star" $ do
    r <- liftIO (starRepo "dinomiike" "pics" "1de5631b352399fdb00f705e9f222729814a0d7f")
    json r
  post "/username/:username/repo/:repo" $ do
    username <- param "username"
    repo <- param "repo"
    r <- liftIO $ insertRepo pool username repo False
    json r
  get "/repos/username/:username" $ do
    username <- param "username"
    starred' <- param "starred"
    let starred = getBool starred'
    r <- liftIO $ findRepos pool (username, starred)
    json r
  get "/repos" $ do
    r <- liftIO (getGHRepos "sportanova")
    json r
  get "/user" $ do
    r <- liftIO (findUser pool $ T.pack "sportanova")
    json r

getBool :: T.Text -> Bool
getBool str = case str of "false" -> False
                          "true" -> True