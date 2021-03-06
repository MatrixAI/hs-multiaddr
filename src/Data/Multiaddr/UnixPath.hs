{-# LANGUAGE DeriveGeneric #-}

module Data.Multiaddr.UnixPath
  (
    UnixPath (..),
    toString,
    parse,
    encode,
    parseB
  ) where

import qualified Text.ParserCombinators.ReadP as Parser
import qualified Data.ByteString as BSStrict
import qualified Data.ByteString.Char8 as BSStrictChar
import qualified Data.Multiaddr.VarInt as VarInt

import GHC.Generics (Generic)
import System.FilePath (FilePath)
import Data.Serialize.Get (Get)

newtype UnixPath = UnixPath { path :: FilePath }
                 deriving (Show, Eq, Ord, Generic)

toString :: UnixPath -> String
toString (UnixPath p) = show p

parse :: Parser.ReadP UnixPath
parse = do
  path <- Parser.many1 Parser.get
  return $ UnixPath $ "/" ++ path

encode :: UnixPath -> BSStrict.ByteString
encode (UnixPath p) = VarInt.encodeWith $ BSStrictChar.pack p

parseB :: Get UnixPath
parseB = fmap (UnixPath . BSStrictChar.unpack) $ VarInt.decodeSizeVar

