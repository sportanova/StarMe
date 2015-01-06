{-# LANGUAGE OverloadedStrings, DataKinds #-}
module RabbitMQ.Queue where

import Network.AMQP
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as BL

initRabbit :: IO (Connection, Channel)
initRabbit = do
  conn <- openConnection "127.0.0.1" "/" "stephen" "stephen"
  chan <- openChannel conn

    -- declare a queue, exchange and binding
  declareQueue chan newQueue {queueName = "userToStar"}
  declareExchange chan newExchange {exchangeName = "starRepos", exchangeType = "topic"}
  bindQueue chan "userToStar" "starRepos" "star.new.user"
  
  declareQueue chan newQueue {queueName = "oldUsers"}
  bindQueue chan "oldUsers" "starRepos" "star.old.user"

  -- closeConnection conn
  return (conn, chan)

pushMessage :: Channel -> T.Text -> T.Text -> String -> IO ()
pushMessage chan exchange key msg = publishMsg chan exchange key newMsg {msgBody = (BL.pack msg), msgDeliveryMode = Just Persistent}