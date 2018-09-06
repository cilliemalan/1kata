-- Build like so: ghc -O factorial.hs
import System.Environment
import Text.Read

factorial :: (Integral a) => a -> a
factorial n = product [1..n]

printUsage :: IO ()
printUsage = putStrLn "Usage: factorial n"

printFactorial :: (Show a, Integral a) => a -> IO ()
printFactorial i = putStrLn (show (factorial i))

readMaybeInt :: String -> Maybe Integer
readMaybeInt = readMaybe

process :: String -> IO ()
process n = case readMaybeInt n of
    Just i -> printFactorial i
    Nothing -> printUsage

main :: IO ()
main = do
    args <- getArgs
    case args of
        [] -> printUsage
        (n:_) -> process n