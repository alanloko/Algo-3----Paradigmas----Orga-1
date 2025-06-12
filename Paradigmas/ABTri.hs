{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Avoid lambda" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}



data AT a = NilT | Tri a (AT a) (AT a) (AT a)
    deriving (Show)
at1 :: AT Int
at1 = Tri 1 (Tri 2 NilT NilT NilT) (Tri 3 (Tri 4 NilT NilT NilT) NilT NilT) (Tri 5 NilT NilT NilT)


foldAT :: b -> (a -> b -> b -> b -> b) -> AT a -> b
foldAT fNil fTri NilT = fNil
foldAT fNil fTri (Tri x fy fz fh) = fTri x (rec fy) (rec fz) (rec fh)
    where rec = foldAT fNil fTri

preorder :: AT a -> [a]
preorder = foldAT [] (\x fy fz fh -> x : fy ++ fz ++ fh)

mapAT :: (a -> b) -> AT a -> AT b
mapAT f = foldAT NilT (\ x fy fz fh -> Tri (f x) fy fz fh)




nivel :: AT a -> Int -> [a]
nivel  = foldAT (\_ -> []) (\x y z h i -> case i of
        0 -> [x]
        _ -> y (i-1) ++ z (i-1) ++ h (i-1)
        )



data Dato a b = C1 | C2 a | C3 b (Dato a b) (Dato a b)
    deriving (Show)

foldDato :: c -> (a -> c) -> (b -> c -> c -> c) -> Dato a b -> c
foldDato fC1 fC2 fC3 dato =
    case dato of
        C1 -> fC1
        C2 a -> fC2 a
        C3 b d1 d2 -> fC3 b (rec d1) (rec d2)
            where rec = foldDato fC1 fC2 fC3

splitDato :: Dato a b -> ([a], [b])
splitDato = foldDato ([],[]) (\a -> ([a], [])) (\b d1 d2 -> (fst d1 ++ fst d2, [b] ++ snd d1 ++ snd d2))

d :: Dato Int String
d = C3 "a" (C2 1) (C3 "b" (C2 2) C1)


data Operador = Suma Int | DividirPor Int | Secuencia [Operador]
    deriving (Show)

foldOP :: (Int -> b) -> (Int -> b) -> ([b] -> b) -> Operador -> b
foldOP fSuma fDiv fSec op =
            case op of
                Suma i -> fSuma i
                DividirPor i -> fDiv i
                Secuencia xs -> fSec (map rec xs)
                    where rec = foldOP fSuma fDiv fSec

falla :: Operador -> Bool
falla = foldOP (\ _ -> False) (\i -> i == 0) (elem True)

aplanarSecuencia :: Operador -> [Operador]
aplanarSecuencia (Secuencia ops) = ops
aplanarSecuencia ops = [ops]

aplanar :: Operador -> Operador
aplanar = foldOP (\i -> Suma i) (\i -> DividirPor i) (\sec -> Secuencia $ concatMap aplanarSecuencia sec)

s :: Operador
s = Secuencia [Suma 1, Secuencia [DividirPor 3, Suma 2]]