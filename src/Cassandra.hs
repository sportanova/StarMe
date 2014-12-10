{-# LANGUAGE OverloadedStrings, DataKinds #-}
module Cassandra where

import Database.Cassandra.CQL
import Data.UUID
import System.Random
import qualified Data.Text as T
import Data.ByteString.Char8 (ByteString)

initCass :: IO Pool
initCass = createKeyspace >> newPool [("localhost", "9042")] "starme" Nothing

createPool :: IO Pool
createPool = newPool [("localhost", "9042")] "starme" Nothing -- servers, keyspace, maybe auth

createKeyspace :: IO (Query Schema () ())
createKeyspace = return "CREATE KEYSPACE IF NOT EXISTS starme WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };"
  
createSongs :: Query Schema () ()
createSongs = "create table songs (id uuid PRIMARY KEY, title ascii, artist varchar, femaleSinger boolean, timesPlayed int, comment text)"

insertSong :: Query Write (UUID, ByteString, T.Text, Bool, Int, Maybe T.Text) ()
insertSong = "insert into songs (id, title, artist, femaleSinger, timesPlayed, comment) values (?, ?, ?, ?, ?, ?)"