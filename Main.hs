{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Github

main = scotty 3000 $ do
  get "/" $ do
    html "YO!"