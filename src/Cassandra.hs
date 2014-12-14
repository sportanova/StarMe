{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Cassandra where

import Database.Cassandra.CQL
import Data.UUID
import System.Random
import qualified Data.Text as T
import Data.ByteString.Char8 (ByteString)
import Control.Monad.IO.Class(liftIO)
import qualified Models as M

initCass :: IO Pool
initCass = createPool >>= (\pool -> runCas pool (executeSchema ONE createUsers ()) >> return pool)

createPool :: IO Pool
createPool = newPool [("localhost", "9042")] "starme" Nothing -- servers, keyspace, maybe auth

createKeyspace :: IO (Query Schema () ())
createKeyspace = return "CREATE KEYSPACE IF NOT EXISTS starme WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };"

createUsers :: Query Schema () ()
createUsers = "CREATE TABLE IF NOT EXISTS users (username text PRIMARY KEY, id int, url text, name text, a_token text, password text)"
  
insertUser' :: (T.Text, Int, T.Text, T.Text, T.Text, T.Text) -> Cas ()
insertUser' (username, id, url, name, a_token, password) = executeWrite QUORUM q (username, id, url, name, a_token, password)
  where q = "INSERT INTO users (username, id, url, name, a_token, password) values (?, ?, ?, ?, ?, ?)"

insertUser :: Pool -> Maybe M.User -> IO (Maybe M.User)
insertUser pool (Just user) = (runCas pool $ insertUser' values) >>= (\_ -> return (Just user))
  where values = (T.pack (M.username user), M.id user, T.pack (M.url user), T.pack (M.name user), T.pack (M.token user), T.pack "")
insertUser pool Nothing = return (Nothing)