{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Http.Github
import Control.Monad.IO.Class(liftIO)

main = scotty 3000 $ do
  get "/wat" $ do
    html "wat!"
  get "/who" $ do
    s <- liftIO stuff
    json s
  get "/auth_cb" $ do
    code <- param "code"
    r <- liftIO (execPostReq code)
    json r
  get "/hello" $ do
    name <- param "name"
    text name
  get "/star" $ do
    r <- liftIO (starRepo "dinomiike" "pics" "1de5631b352399fdb00f705e9f222729814a0d7f")
    json r