
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

pponCompuesto :: PPON -> Bool
pponCompuesto x = not (pponObjetoSimple x) &&  not (pponAtomico x)

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

pponADoc :: PPON -> Doc
pponADoc (TextoPP s) = texto (show s)
pponADoc (IntPP i) = texto (show i)
pponADoc (ObjetoPP []) = texto "{ }"
pponADoc (ObjetoPP xs) =  if pponCompuesto (ObjetoPP xs) then entreLlaves (pponAux (ObjetoPP xs)) else  texto "{ " <+> intercalar (texto ", ") (pponAux (ObjetoPP xs))  <+> texto " }"

-- Se utiliza recursión estructural en pponAux ya que el caso base (ObjetoPP []) devuelve un valor fijo ([]) y el caso recursivo se escribe solamente usando s, obj y pponAux (ObjetoPP xs).
-- No se utiliza ObjetoPP xs por sí solo en el caso recursivo, y por eso no es ni primitiva ni global.
pponAux :: PPON -> [Doc]
pponAux (ObjetoPP []) = []
pponAux (ObjetoPP ((s,obj):xs)) = texto (show s) <+> texto ": " <+> pponADoc obj: pponAux (ObjetoPP xs)


