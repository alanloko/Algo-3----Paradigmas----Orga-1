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

--dCustom :: Doc
--dCustom = Texto "a" (Linea 2 (Texto "b" (Linea 2 (Texto "c" Vacio))))

--dCustom2 :: Doc
--dCustom2 = Texto "a" (Linea 2 (Texto "b" (Linea 0 (Texto "c" Vacio))))

-- NOTA: Se declara `infixr 6 <+>` para que `d1 <+> d2 <+> d3` sea equivalente a `d1 <+> (d2 <+> d3)`
-- También permite que expresiones como `texto "a" <+> linea <+> texto "c"` sean válidas sin la necesidad de usar paréntesis.
infixr 6 <+>

-- Esta funcion cumple el invariante debido a que: 
-- d1 y d2 cumplen por definicion su invariante, y su concatenación con Vacio devuelven los mismos d1 y d2, por lo que siguen cumpliendo el invariante.
-- En el medio segun cada funcion, 
-- si es texto nos fijamos si el elemento de la llamada recursiva es un texto, y en ese caso concatenamos los strings en un mismo texto para que cumpla que el d de Texto s d sea Vacio o Linea i d 
-- como solamente estamos concatenando strings, ningún s de Texto s d va a terminar siendo el string vacio
-- como ni d1 ni d2 por invariante tienen saltos de linea, la concatenación de sus textos tampoco.
-- si es una Linea i d, la dejamos igual y la juntamos con los otros docs, entonces debido a que cumple por definición su invariante, su i sigue siendo >= 0
(<+>) :: Doc -> Doc -> Doc
d1 <+> Vacio = d1
Vacio <+> d2 = d2
d1 <+> d2 = foldDoc d2 (\s rec -> 
  case rec of
    Texto s1 d -> Texto (s ++ s1) d
    otherwise -> Texto s rec 
    ) 
    (\i rec -> Linea i rec) d1


-- Esta función cumple el invariante de Doc ya que:
-- Si i es un número negativo, se dejan los textos y las lineas del Doc como están. Y como cumplian por definición su invariante, lo siguen cumpliendo.
-- Si i es un número positivo o cero,
-- los textos se dejan como están, y debido a que cumplen por definición su invariante, se sigue cumpliendo el invariante.
-- se suma i a j en las lineas Linea j d, y como i es un numero positivo o cero y j >= 0 por invariante, (i+j) >= 0 y se sigue cumpliendo el invariante.
indentar :: Int -> Doc -> Doc
indentar i 
  | i < 0 = foldDoc (Vacio) (\s rec -> Texto s rec) (\j rec -> Linea j rec)
  | otherwise = foldDoc (Vacio) (\s rec -> Texto s rec) (\j rec -> Linea (i+j) rec) 

mostrar :: Doc -> String
mostrar = foldDoc "" (\s rec -> s ++ rec) (\i rec -> "\n" ++ (replicate i ' ') ++ rec)

-- | Función dada que imprime un documento en pantalla

-- ghci> imprimir (Texto "abc" (Linea 2 (Texto "def" Vacio)))
-- abc
--   def

imprimir :: Doc -> IO ()
imprimir d = putStrLn (mostrar d)

