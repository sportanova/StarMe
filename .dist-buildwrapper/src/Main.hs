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
    r <- liftIO (doStuff code)
    json r
  get "/hello" $ do
    name <- param "name"
    text name