{-# LANGUAGE OverloadedStrings, DataKinds #-}
module RabbitMQ.Queue where

import Network.AMQP
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as BL

initRabbit :: IO (Connection, Channel)
initRabbit = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn

    -- declare a queue, exchange and binding
  declareQueue chan newQueue {queueName = "myQueue"}
  declareExchange chan newExchange {exchangeName = "myExchange", exchangeType = "direct"}
  bindQueue chan "myQueue" "myExchange" "myKey"

    -- publish a message to our new exchange
  publishMsg chan "myExchange" "myKey"
    newMsg {msgBody = (BL.pack "hello world"),
            msgDeliveryMode = Just Persistent}

  publishMsg chan "myExchange" "myKey"
    newMsg {msgBody = (BL.pack "poppet"),
            msgDeliveryMode = Just Persistent}

  -- closeConnection conn
  return (conn, chan)

pushMessage :: Channel -> T.Text -> T.Text -> String -> IO (String)
pushMessage chan exchange key msg = publishMsg chan exchange key newMsg {msgBody = (BL.pack msg), msgDeliveryMode = Just Persistent} >>= (\x -> putStr "hey" >> return "hey")

myCallback :: (Message, Envelope) -> IO ()
myCallback (msg, env) = do
  putStrLn $ "received message: " ++ (BL.unpack $ msgBody msg)
  -- acknowledge receiving the message
  ackEnv env