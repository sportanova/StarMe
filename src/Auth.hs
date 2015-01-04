{-# LANGUAGE OverloadedStrings #-}
module Auth where

import Web.Scotty
import qualified Data.Text as T
import qualified Data.Text.Lazy as LT
import qualified Models as M
import Crypto.BCrypt
import Data.Text.Encoding
import Data.ByteString
import Cassandra
import Control.Monad.IO.Class (liftIO)

type FindUserPartial = (T.Text -> IO (Maybe M.User))

checkPw :: T.Text -> T.Text -> Bool
checkPw hashedP plainP = validatePassword (encodeUtf8 hashedP) (encodeUtf8 plainP)

hashPw :: T.Text -> IO (Maybe Data.ByteString.ByteString)
hashPw plain = hashPasswordUsingPolicy slowerBcryptHashingPolicy (encodeUtf8 plain)

auth' :: Maybe M.User -> T.Text -> Bool
auth' Nothing _ = False
auth' (Just user) plainPw = checkPw (M.password user) plainPw

auth :: FindUserPartial -> ActionM String -> ActionM String -> ActionM() -> ActionM() -> ActionM()
auth findUser username plainPw successAct failAct = do
  uname <- username
  plain <- plainPw
  user <- liftIO $ findUser (T.pack uname)
  status <- return $ auth' user (T.pack plain)
  if status then successAct else failAct

protected :: FindUserPartial -> ActionM() -> ActionM() -> ActionM()
protected findUser successAct failAct = do
  token <- header "Authentication"
  username <- header "Username"
  authenticated <- checkToken findUser token username
  if authenticated then successAct else failAct

checkToken :: FindUserPartial -> Maybe LT.Text -> Maybe LT.Text -> ActionM Bool
checkToken findUser (Just at) (Just uname) = do
  user <- liftIO $ findUser $ LT.toStrict uname
  case user of Just u -> if M.token u == LT.toStrict at then return True else return False
               Nothing -> return False
checkToken _ _ _ = return False















