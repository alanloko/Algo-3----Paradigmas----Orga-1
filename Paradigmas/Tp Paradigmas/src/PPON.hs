
module PPON where

import Documento



data PPON
  = TextoPP String
  | IntPP Int
  | ObjetoPP [(String, PPON)]
  deriving (Eq, Show)

pponAtomico :: PPON -> Bool
pponAtomico (TextoPP s) = True
pponAtomico (IntPP i) = True
pponAtomico _ = False


pponObjetoSimple :: PPON -> Bool
pponObjetoSimple (TextoPP s) = False
pponObjetoSimple (IntPP i) = False
pponObjetoSimple (ObjetoPP ppon) = foldr ((\x acc -> x && acc) . (\(_,v) -> pponAtomico v)) True ppon


intercalar :: Doc -> [Doc] -> Doc
intercalar d [] = vacio
intercalar sep ds  = foldr (\doc rec-> doc <+> sep <+> rec) (last ds) (init ds)


entreLlaves :: [Doc] -> Doc
entreLlaves [] = texto "{ }"
entreLlaves ds =
  texto "{"
    <+> indentar
      2
      ( linea
          <+> intercalar (texto "," <+> linea) ds
      )
    <+> linea
    <+> texto "}"

aplanar :: Doc -> Doc
aplanar = foldDoc vacio (\s rec-> texto s <+> rec) (\i rec-> texto " " <+> rec)

-- pponADoc usa recursion primitiva, esto se puede ver en la funcion pponCompuesto, donde recorremos el Objeto para 
-- corroborar que no sea Atomico ni Simple, accediendo a todos los valores del objeto antes de hacer el calculo que necesitamos
pponADoc :: PPON -> Doc
pponADoc (TextoPP s) = texto (show s)
pponADoc (IntPP i) = texto (show i)
pponADoc (ObjetoPP []) = texto "{ }"
pponADoc (ObjetoPP xs) =  if pponCompuesto (ObjetoPP xs) then entreLlaves (pponAux (ObjetoPP xs)) else  texto "{ " <+> intercalar (texto ", ") (pponAux (ObjetoPP xs))  <+> texto " }"

pponCompuesto :: PPON -> Bool
pponCompuesto x = not (pponObjetoSimple x) &&  not (pponAtomico x)


pponAux :: PPON -> [Doc]
pponAux (ObjetoPP []) = []
pponAux (ObjetoPP ((s,obj):xs)) = texto (show s) <+> texto ": " <+> pponADoc obj: pponAux (ObjetoPP xs)


