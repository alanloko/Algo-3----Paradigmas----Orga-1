

func :: (a -> b -> c) -> b -> a -> c
func f y x =  f x y

f :: Int -> String -> String
f x y = show x ++ y