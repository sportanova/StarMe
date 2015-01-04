{-# LANGUAGE OverloadedStrings #-}
module Auth where

import Web.Scotty
import qualified Data.Text as T
import qualified Models as M
import Crypto.BCrypt
import Data.Text.Encoding
import Data.ByteString
import Cassandra
import Control.Monad.IO.Class (liftIO)

type FindUserPartial = (T.Text -> IO (Maybe M.User))

auth' :: Maybe M.User -> T.Text -> Bool
auth' Nothing _ = False
auth' (Just user) plainPw = checkPw (M.password user) plainPw

auth :: FindUserPartial -> T.Text -> T.Text -> ActionM() -> ActionM()
auth findUser username plainPw action = do
  user <- liftIO $ findUser username
  status <- return $ auth' user plainPw
  if status == True then action else return ()

checkPw :: T.Text -> T.Text -> Bool
checkPw hashedP plainP = validatePassword (encodeUtf8 hashedP) (encodeUtf8 plainP)

hashPw :: T.Text -> IO (Maybe Data.ByteString.ByteString)
hashPw plain = hashPasswordUsingPolicy slowerBcryptHashingPolicy (encodeUtf8 plain)