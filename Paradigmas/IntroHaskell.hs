module IntroHaskell where
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
import Data.Foldable (Foldable(fold))
{-# HLINT ignore "Use sum" #-}

sumaAux :: Num a => [a] -> a
sumaAux = foldr (+) 0


suma :: Num a => a -> a -> a
suma x y = sumaAux [x,y]

f :: a -> a
f x = x


--pertenece :: Num a => a -> [a] -> Bool
--pertenece = foldr (\x xs -> x == e) [] == [e] 

concatenar :: [[a]] -> [a]
concatenar = foldr (++) []

concatenar' :: [a] -> [a] -> [a]
concatenar' xs ys = foldr (:) ys xs

elemAux :: Eq a => a -> [a] -> Bool
elemAux x = foldr (\y acc -> x == y || acc) False

filterAux :: (a -> Bool) -> [a] -> [a]
filterAux p = foldr (\x acc -> if p x then x : acc else acc) []

mapAux :: (a -> b) -> [a] -> [b]
mapAux f = foldr (\x acc -> f x : acc) []

listaPares :: [Integer] -> [Integer]
listaPares = filterAux even

todosMas1 :: [Integer] -> [Integer]
todosMas1 = mapAux (+1)

mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun p = foldr1 (\x y -> if p x y then x else y)

maximo :: forall a. Ord a => [a] -> a
maximo = mejorSegun (>)

max2 ::(Ord a) => [a] -> a
max2 = foldr1 max

sumasParciales :: Num a => [a] -> [a]
sumasParciales xs = reverse (sumaParcialAux (reverse xs))

sumaParcialAux :: Num a => [a] -> [a]
sumaParcialAux [] = []
sumaParcialAux (x:xs) = foldr (+) 0 (x:xs) : sumaParcialAux xs

--sumaParcial :: Num a => [a] -> [a]
--sumaParcial [] = []
--sumaParcial (x:xs) = foldl (+) x xs : sumaParcial xs

sumaAlt :: Num a => [a] -> a
sumaAlt = foldr (-) 0
-- ?????

prefijos :: [a] -> [[a]]
prefijos [] = [[]]
prefijos (x:xs) = foldr (:) [] (reverse (x:xs)) : prefijos xs

--zip' :: [a] -> [b] -> [(a, b)]
--zip' [] [] = []
--zip' (x : xs) (y : ys) = (x, y) : zip' xs ys

entrelazar :: [a] -> [a] -> [a]
entrelazar [] = id
entrelazar (x:xs) = \ys -> if null ys
                                then x : entrelazar xs []
                                else x : head ys : entrelazar xs (tail ys)

elementosEnPosicionesPares :: [a] -> [a]
elementosEnPosicionesPares [] = []
elementosEnPosicionesPares (x:xs) = if null xs
                                        then [x]
                                        else x : elementosEnPosicionesPares (tail xs)



recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x : xs) = f x xs (recr f z xs)

sacarUna :: Eq a => a -> [a] -> [a]
sacarUna e (x:xs) = recr (\x xs rec -> if x == e then xs else x : rec) [] (x:xs)

sacarUna2 :: Eq a => a -> [a] -> [a]
sacarUna2 _ [] = []
sacarUna2 e (x:xs)
    | e == x = xs
    | otherwise = x : sacarUna2 e xs

insertarOrdenado :: (Ord a) => a -> [a] -> [a]
insertarOrdenado e [] = [e]
insertarOrdenado e (x:xs)= recr (\x xs res -> if e < x then e : x : res else if null xs then x : e : res else x : res) [] (x:xs)


insertarOrdenado2 :: (Ord a) => a -> [a] -> [a]
insertarOrdenado2 e [] = [e]
insertarOrdenado2 e (x:xs)
        | e <= x = e : x : xs
        | null xs = x : e : xs
        | otherwise = x : insertarOrdenado2 e xs


-- ????????
mapPares :: (a -> b -> c) -> [(a, b)] -> [c]
mapPares f = map (uncurry f)

armarPares :: [a] -> [b] -> [(a,b)]
armarPares = zip

mapDoble :: (a -> b -> c) -> [a] -> [b] -> [c]
mapDoble f xs ys = mapPares f (armarPares xs ys)
-- ???????

data Nat = Zero | Succ Nat

foldNat :: (Nat -> b -> b) -> b -> [Nat] -> b
foldNat f z [] = z
foldNat f z (x:xs) = f x (foldr f z xs)

data Arbol a = Hoja a | Nodo (Arbol a) a (Arbol a)
    deriving Show

foldAb :: (a -> b) -> (b -> a -> b -> b) -> Arbol a -> b
foldAb fHoja fNodo (Hoja a) = fHoja a
foldAb fHoja fNodo (Nodo i r d) =
    fNodo (foldAb fHoja fNodo i) r (foldAb fHoja fNodo d)

foldAb2 :: (a -> b) -> (b -> a -> b -> b) -> Arbol a -> b
foldAb2 fHoja fNodo ab =
    case ab of
        Hoja ab -> fHoja ab
        Nodo i r d -> fNodo (foldAb fHoja fNodo i) r (foldAb fHoja fNodo d)

recrAb :: b -> (a -> Arbol a -> Arbol a -> b -> b -> b) -> Arbol a -> b
recrAb z fNodo (Hoja ab) = z
recrAb z fNodo (Nodo i r d) = fNodo r i d (recrAb z fNodo i) (recrAb z fNodo d)


aej :: Arbol Int
aej = Nodo (Hoja 0) 1 (Nodo (Hoja 5) 2 (Hoja 7))

espejo :: Arbol a -> Arbol a
espejo = foldAb2 Hoja (\resi r resd -> Nodo resd r resi)


ramas :: Arbol a -> [[a]]
ramas = foldAb
    (\a -> [[a]])
    (\i r d -> map (r :) i ++ map (r :) d)

insertarAbb :: (Ord a) => a -> Arbol a -> Arbol a
insertarAbb x (Hoja a) = Nodo (Hoja a) x (Hoja a)
insertarAbb x (Nodo i r d) =
    if x < r
        then Nodo (insertarAbb x i) r d
        else Nodo i r (insertarAbb x d)

data RoseTree a = Rose a [RoseTree a]

deriving instance (Show a) => Show (RoseTree a)

foldRt :: (a -> [b] -> b) -> RoseTree a -> b
foldRt fRose (Rose a hijos) = fRose a (map (foldRt fRose) hijos)

alturaRt :: RoseTree a -> Int
alturaRt = foldRt (\r alturahijos ->
                                case alturahijos of
                                    [] -> 1
                                    _ -> maximum (map (+1) alturahijos)
                                    )


type Conj a = (a -> Bool)

perteneceC :: a -> Conj a -> Bool
perteneceC x f = f x

vacio :: Conj a
vacio = const False

agregar :: Eq a => a -> Conj a -> Conj a
agregar x f = (\y -> if x == y then True else False)

compose :: [a -> a] -> (a -> a)
compose = foldr (.) id

entrelazar2 :: [a] -> [a] -> [a]
entrelazar2 = foldr (\x rec ys -> if null ys then x : rec [] else x : head ys : rec []) (const [])

mapPares2 :: (a -> b -> c) -> [(a,b)] -> [c]
mapPares2 f  = map (uncurry f)

foldr1' :: (a -> a -> a) -> [a] -> a
foldr1' fLista [x] = x
foldr1' fLista (x:xs) = fLista x (foldr1' fLista xs)

