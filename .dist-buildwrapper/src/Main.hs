{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Http.Github

main = scotty 3000 $ do
  get "/wat" $ do
    html "wat!"
  get "/who" $ do
    json "no"