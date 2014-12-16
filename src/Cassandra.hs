{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Cassandra where

import Database.Cassandra.CQL
import Data.UUID
import System.Random
import qualified Data.Text as T
import Data.ByteString.Char8 (ByteString)
import Control.Monad.IO.Class(liftIO)
import qualified Models as M
import Data.Int(Int64)

initCass :: IO Pool
initCass = createPool >>= (\pool -> runCas pool (executeSchema ONE createUsersTable () >> executeSchema ONE createReposTable ()) >> return pool)

createPool :: IO Pool
createPool = newPool [("localhost", "9042")] "starme" Nothing -- servers, keyspace, maybe auth

createKeyspace :: IO (Query Schema () ())
createKeyspace = return "CREATE KEYSPACE IF NOT EXISTS starme WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };"

createUsersTable :: Query Schema () ()
createUsersTable = "CREATE TABLE IF NOT EXISTS users (username text PRIMARY KEY, id int, url text, name text, a_token text, password text)"

insertUser' :: (T.Text, Int, T.Text, T.Text, T.Text, T.Text) -> Cas ()
insertUser' (username, id, url, name, a_token, password) = executeWrite ONE q (username, id, url, name, a_token, password)
  where q = "INSERT INTO users (username, id, url, name, a_token, password) values (?, ?, ?, ?, ?, ?)"

insertUser :: Pool -> Maybe M.User -> IO (Maybe M.User)
insertUser pool (Just user) = (runCas pool $ insertUser' values) >> return (Just user)
  where values = (M.username user, M.id user, M.url user, M.name user, M.token user, "")
insertUser pool Nothing = return (Nothing)

findUser' :: (MonadCassandra m) => T.Text -> m (Maybe (T.Text, Int, T.Text, T.Text, T.Text, T.Text))
findUser' username = executeRow ONE q username
  where q = "SELECT username, id, url, name, a_token, password FROM users WHERE username=?"

findUser :: Pool -> T.Text -> IO (Maybe (M.User))
findUser pool username = runCas pool $ (findUser' username) >>= (\x -> return $ convertToUser x)

convertToUser :: Maybe (T.Text, Int, T.Text, T.Text, T.Text, T.Text) -> Maybe M.User
convertToUser (Just (username, id, url, name, accessToken, password)) = Just user
  where user = M.User {M.username = username, M.id = id, M.url = url, M.name = name, M.token = accessToken, M.password = password}

createReposTable :: Query Schema () ()
createReposTable = "CREATE TABLE IF NOT EXISTS repos (username text, name text, starred boolean, PRIMARY KEY(username, name, starred))"

insertRepo' :: (T.Text, T.Text, Bool) -> Cas ()
insertRepo' (username, name, starred) = executeWrite ONE q (username, name, starred)
  where q = "INSERT INTO repos (username, name, starred) values (?, ?, ?)"

insertRepo :: Pool -> T.Text -> T.Text -> Bool -> IO ()
insertRepo pool username name starred = (runCas pool $ insertRepo' values) >> return ()
  where values = (username, name, starred)

findRepos' :: Query Rows (T.Text, T.Text, Bool) (T.Text, T.Text, Bool)
findRepos' = "SELECT * FROM repos WHERE username=?, name=?, bool=?"

findRepos :: (MonadCassandra m) => (T.Text, T.Text, Bool) -> m ([(T.Text, T.Text, Bool)])
findRepos (username, repoName, starred) = executeRows ONE findRepos' (username, repoName, starred)










