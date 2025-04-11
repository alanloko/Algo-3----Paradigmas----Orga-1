
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

-- Se utiliza recursión primitiva sobre el tipo recurtsivo PPON 
-- por el hecho de que en pponCompuesto estamos accediendo a los parametros
-- recursivos en la instancia actual del ObjetoPP sobre el que estamos evaluando.
pponADoc :: PPON -> Doc
pponADoc (TextoPP s) = texto (show s)
pponADoc (IntPP i) = texto (show i)
pponADoc (ObjetoPP []) = texto "{ }"
pponADoc (ObjetoPP xs) =  if pponCompuesto (ObjetoPP xs) then entreLlaves (objPPaListaDoc xs) else  texto "{ " <+> intercalar (texto ", ") (objPPaListaDoc xs)  <+> texto " }"

pponCompuesto :: PPON -> Bool
pponCompuesto x = not (pponObjetoSimple x) &&  not (pponAtomico x)

objPPaListaDoc :: [(String,PPON)] -> [Doc]
objPPaListaDoc = foldr (\(s,obj) rec -> texto (show s) <+> texto ": " <+> pponADoc obj : rec) []

