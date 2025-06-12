{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use infix" #-}
data Buffer a = Empty | Write Int a (Buffer a) | Read Int (Buffer a)
    deriving (Show)

deshacer :: Buffer a -> Int-> Buffer a
deshacer = foldBuffer (\_ -> Empty)
        (
          \i a fb n -> case n of
            0 -> Write i a (fb n)
            _ -> fb (n-1)
              )
              (
          \i fb n -> case n of
            0 -> Read i (fb n)
            _ -> fb (n-1)
              )



foldBuffer :: b -> (Int -> a -> b -> b) -> (Int -> b -> b) -> Buffer a -> b
foldBuffer fEmpty fWrite fRead Empty = fEmpty
foldBuffer fEmpty fWrite fRead (Write i a b) = fWrite i a (foldBuffer fEmpty fWrite fRead b)
foldBuffer fEmpty fWrite fRead (Read i b) = fRead i (foldBuffer fEmpty fWrite fRead b)

recBuffer :: b -> (Int -> a -> Buffer a -> b -> b) -> (Int -> Buffer a -> b -> b) -> Buffer a -> b
recBuffer fEmpty fWrite fRead Empty = fEmpty
recBuffer fEmpty fWrite fRead (Write i a b) = fWrite i a b (recBuffer fEmpty fWrite fRead b)
recBuffer fEmpty fWrite fRead (Read i b) = fRead i b (recBuffer fEmpty fWrite fRead b)


posicionesOcupadas :: Buffer a -> [Int]
posicionesOcupadas = recBuffer []
                    (
                      \i a b fb -> if pertenecei i b then i : fb else fb
                        )
                        (
                          \i b fb -> fb
                        )
                        where pertenecei i = foldBuffer False (\i' _ fb' -> i == i' || fb') (\i' fb' -> i == i' || fb')

buf :: Buffer String
buf = Write 1 "a" $ Write 2 "b" $ Write 1 "c" $ Empty


contenido :: Int -> Buffer a -> Maybe a
contenido n = foldBuffer Nothing
              (
                \i a fb -> if i == n then Just a else fb
              )
              (
                \i fb -> if i == n then Nothing else fb
              )

puedeCompletarLectura :: Eq a => Buffer a -> Bool
puedeCompletarLectura = recBuffer True (\_ _ _ rec -> rec) (\i b' rec -> contenido i b' /= Nothing && rec)

buf' :: Buffer String
buf' = Read 1 buf

bufer :: Buffer a
bufer = Empty
ejemplo :: Buffer Char
ejemplo = Write 1 'a' (Write 2 'b' (Read 1 (Write 3 'c' Empty)))

b3 = Read 1 (Write 2 True (Write 1 False Empty))



data RoseTree a = Rose a [RoseTree a]
        deriving (Show)

foldRose :: (a -> [b] -> b) -> RoseTree a -> b
foldRose fRose (Rose a xs) = fRose a (map (foldRose fRose) xs)

t :: RoseTree Int
t = Rose 1 [Rose 2 [Rose 8 [Rose 9 []]],Rose 3 [],h]
h :: RoseTree Int
h = Rose 4 [Rose 5 [],Rose 6 [],Rose 7 []]


hojas :: RoseTree a -> [a]
hojas = foldRose (\a hijos -> case hijos of
                    [] -> [a]
                    xs -> a : concat hijos
                  )

altura :: RoseTree a -> Int
altura = foldRose (\a hijos -> case hijos of
                    [] -> 1
                    _ -> maximum (map (+1) hijos))