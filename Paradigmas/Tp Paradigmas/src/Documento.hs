module Documento
  ( Doc,
    vacio,
    linea,
    texto,
    foldDoc,
    (<+>),
    indentar,
    mostrar,
    imprimir,
  )
where

data Doc
  = Vacio
  | Texto String Doc
  | Linea Int Doc
  deriving (Eq, Show)

vacio :: Doc
vacio = Vacio

linea :: Doc
linea = Linea 0 Vacio

texto :: String -> Doc
texto t | '\n' `elem` t = error "El texto no debe contener saltos de línea"
texto [] = Vacio
texto t = Texto t Vacio

foldDoc :: b -> (String -> b -> b) -> (Int -> b -> b) -> Doc -> b
foldDoc fVacio fTexto fLinea doc = 
    case doc of
      Vacio -> fVacio
      Texto s d -> fTexto s (rec d)
      Linea i d -> fLinea i (rec d)
      where
        rec = foldDoc fVacio fTexto fLinea

dCustom :: Doc
dCustom = Texto "a" (Linea 2 (Texto "b" (Linea 2 (Texto "c" Vacio))))

dCustom2 :: Doc
dCustom2 = Texto "a" (Linea 2 (Texto "b" (Linea 0 (Texto "c" Vacio))))

-- NOTA: Se declara `infixr 6 <+>` para que `d1 <+> d2 <+> d3` sea equivalente a `d1 <+> (d2 <+> d3)`
-- También permite que expresiones como `texto "a" <+> linea <+> texto "c"` sean válidas sin la necesidad de usar paréntesis.
infixr 6 <+>

-- Esta funcion Cumple el invariante debido a: 
-- d1 y d2 cumplen por definicion su invariante, al pasar como "Caso base" a d2, el final es vacio, siendo el ultimo parametro "Vacio"
-- En el medio segun cada funcion, si es texto los "juntamos" sino le ponemos la linea que pide segun el caso
(<+>) :: Doc -> Doc -> Doc
d1 <+> Vacio = d1
Vacio <+> d2 = d2
d1 <+> d2 = foldDoc d2 (\s rec -> 
  case rec of
    Texto s1 d -> Texto (s ++ s1) d
    otherwise -> Texto s rec 
    ) 
    (\i rec -> Linea i rec) d1



indentar :: Int -> Doc -> Doc
indentar i = foldDoc (Vacio) (\s rec -> Texto s rec) (\j rec -> Linea (i+j) rec) 

mostrar :: Doc -> String
mostrar = foldDoc "" (\s rec -> s ++ rec) (\i rec -> "\n" ++ (replicate i ' ') ++ rec)

-- | Función dada que imprime un documento en pantalla

-- ghci> imprimir (Texto "abc" (Linea 2 (Texto "def" Vacio)))
-- abc
--   def

imprimir :: Doc -> IO ()
imprimir d = putStrLn (mostrar d)

