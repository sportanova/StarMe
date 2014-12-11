{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Cassandra where

import Database.Cassandra.CQL
import Data.UUID
import System.Random
import qualified Data.Text as T
import Data.ByteString.Char8 (ByteString)
import Control.Monad.IO.Class(liftIO)

initCass :: IO Pool
initCass = do
  pool <- createPool
  result <- runCas pool $ do
    executeSchema ONE createSongs ()
    u1 <- liftIO randomIO
    executeWrite ONE insertSong (u1, "La Grange", "ZZ Top", False, 2, Nothing)
  return pool

createPool :: IO Pool
createPool = newPool [("localhost", "9042")] "starme" Nothing -- servers, keyspace, maybe auth

createKeyspace :: IO (Query Schema () ())
createKeyspace = return "CREATE KEYSPACE IF NOT EXISTS starme WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };"

createSongs :: Query Schema () ()
createSongs = "create table IF NOT EXISTS songs (id uuid PRIMARY KEY, title ascii, artist varchar, femaleSinger boolean, timesPlayed int, comment text)"

createUsers :: Query Schema () ()
createUsers = "CREATE TABLE IF NOT EXISTS users (username text PRIMARY KEY, access_token text, password)"

insertSong :: Query Write (UUID, ByteString, T.Text, Bool, Int, Maybe T.Text) ()
insertSong = "insert into songs (id, title, artist, femaleSinger, timesPlayed, comment) values (?, ?, ?, ?, ?, ?)"