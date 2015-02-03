{-# LANGUAGE OverloadedStrings, DataKinds #-}
import Web.Scotty
import System.Environment 
import Http.Github
import System.IO.Unsafe
import Control.Monad.IO.Class(liftIO)
import Database.Cassandra.CQL
import Cassandra
import Data.UUID
import System.Random
import Network.Wai.Middleware.Static
import qualified Data.Text as T
import qualified Models as M
import Data.Maybe
import RabbitMQ.Queue
import Auth

getEnvVar :: Int -> IO String
getEnvVar index = getArgs >>= (\args -> return $ args !! index)

main = scotty 3000 $ do
  pool <- liftIO initCass
  middleware $ staticPolicy (noDots >-> addBase "static")
  rabbit <- liftIO initRabbit
  
  liftIO $ putStrLn "starting up"

  get "/" $ file "index.html"
  get "/auth" $ auth (findUser pool) (param "username") (param "password") (html "hey") (html "Authenticate")
  get "/ses" $ protected (findUser pool) (html "success") (html "Authenticate")
  post "/event" $ do
    x <- liftIO $ insertEvent pool $ Just M.User {M.username = "username", M.id = 1, M.url = "url", M.name = "name", M.token = "accessToken", M.password = "password"}
    json x
  get "/event" $ do
    r <- liftIO $ findEvents pool ("user", 0)
    json r
  get "/queue" $ do
    key <- param "key"
    username <- param "username"
    liftIO $ pushMessage (snd rabbit) "starRepos" (T.pack key) username
    html "wat"
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
    r <- liftIO (starRepo "sportanova" "a" "d3548d264712d42538eb6ca3d6ec4ce5ee783c6d")
    json r
  post "/username/:username/repo/:repo" $ do
    username <- param "username"
    repo <- param "repo"
    r <- liftIO $ insertRepo pool username repo False
    json r
  post "/repos/username/:username" $ do
    b <- body
    repos <- return $ fromMaybe [] (M.convertBodyToJSON b)
    liftIO $ sequence (insertRepos pool repos)
    html $ "[]"
  get "/repos/username/:username" $ do
    username <- param "username"
    r <- liftIO $ findRepos1 pool username
    json r
  get "/repos" $ do
    r <- liftIO (getGHRepos "sportanova")
    json r
  get "/user" $ do
    u <- liftIO (findUser pool $ T.pack "sportanova")
    liftIO $ insertEvent pool u
    json u