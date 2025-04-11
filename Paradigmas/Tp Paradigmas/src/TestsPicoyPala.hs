module TestsPicoyPala (main) where

import Documento
import PPON
import Test.HUnit

main :: IO ()
main = runTestTTAndExit allTests

allTests :: Test
allTests =
  test
    [ "Ejercicio 1" ~: testsEj1,
      "Ejercicio 2" ~: testsEj2,
      "Ejercicio 3" ~: testsEj3,
      "Ejercicio 4" ~: testsEj4,
      "Ejercicio 5" ~: testsEj5,
      "Ejercicio 6" ~: testsEj6,
      "Ejercicio 7" ~: testsEj7,
      "Ejercicio 8" ~: testsEj8,
      "Ejercicio 9" ~: testsEj9
    ]

testsEj1 :: Test
testsEj1 =
  test
    [ 
      "foldDoc identidad" ~: foldDoc vacio (\s rec -> texto s <+> rec) (\j rec -> (indentar j linea) <+> rec) (indentar 2 (texto "a" <+> linea <+> texto "b")) ~?= indentar 2 (texto "a" <+> linea <+> texto "b"),
      "foldDoc indentar dos espacios" ~: foldDoc vacio (\s rec -> texto s <+> rec) (\j rec -> (indentar (j+2) linea) <+> rec) (indentar 2 (texto "a" <+> linea <+> texto "b")) ~?= indentar 4 (texto "a" <+> linea <+> texto "b"),
      "foldDoc sacar las lineas" ~: foldDoc vacio (\s rec -> texto s <+> rec) (\j rec -> rec) (indentar 2 (texto "a" <+> linea <+> texto "b")) ~?= texto "ab"
    ]
-- testeamos el uso de un foldDoc con la función identidad, es decir que no cambie el doc, otra que indente 2 espacios, y otra que saque las lineas.

testsEj2 :: Test
testsEj2 =
  test
    [ "concatenar asociativo" ~: (texto "a" <+> linea) <+> texto "b" ~?= texto "a" <+> (linea <+> texto "b"),
      "vacio y string 1 char" ~: texto "" <+> texto "x" ~?= texto "x",
      "string 1 char y vacio" ~: texto "x" <+> texto "" ~?= texto "x",
      "vacio y vacio" ~: texto "" <+> texto "" ~?= texto "",
      "string vacio string" ~: texto "a" <+> vacio <+> texto "b" ~?= texto "ab",
      "vacio string vacio" ~: vacio <+> texto "a" <+> vacio ~?= texto "a",
      "concatenar indentar" ~: texto "a" <+> indentar 2 linea <+> texto "b" ~?= indentar 2 (texto "a" <+> linea <+> texto "b"),
      "vacio con linea" ~: vacio <+> linea ~?= linea,
      "tres strings" ~: texto "a" <+> texto "b" <+> texto "c" ~?= texto "abc"
    ]
-- testeamos concatenar de formas simples y por ultimo probar multiples concatenaciones, sumado a concatenar vacios para verificar que se mantenga el doc.

testsEj3 :: Test
testsEj3 =
  test
    [ "indentar 0 con texto" ~: indentar 0 (texto "sin cambio") ~?= texto "sin cambio",
      "indentar texto y linea" ~: indentar 3 (texto "a" <+> linea) ~?= texto "a" <+> indentar 3 linea,
      "indentar 2 lineas" ~: indentar 2 (texto "a" <+> linea <+> texto "b" <+> linea) ~?= texto "a" <+> indentar 2 linea <+> texto "b" <+> indentar 2 linea,
      "indentar vacio" ~: indentar 2 vacio ~?= vacio,
      "indentar nro negativo" ~: indentar (-3) (texto "a" <+> linea) ~?= texto "a" <+> linea
    ]
-- testeamos el funcionamiento basico de indentar

testsEj4 :: Test
testsEj4 =
  test
    [ "mostrar texto" ~: mostrar (texto "hola") ~?= "hola",
      "mostrar linea con texto" ~: mostrar (linea <+> texto "fin") ~?= "\nfin",
      "mostrar linea con indentado y texto" ~: mostrar (indentar 1 (linea <+> texto "x")) ~?= "\n x",
      "mostrar varias lineas" ~: mostrar (texto "a" <+> linea <+> texto "b" <+> linea <+> texto "c") ~?= "a\nb\nc",
      "mostrar vacio" ~: mostrar vacio ~?= "",
      "mostrar indentado con espacios" ~: mostrar (indentar 3 (texto "a" <+> linea <+> texto "x")) ~?= "a\n   x"
    ]
-- testeamos que mostrar use transforme correctamente un Doc a un String.

-- ejemplos de ppones
pericles, merlina, addams, familias, pedro :: PPON
pericles = ObjetoPP [("nombre", TextoPP "Pericles"), ("edad", IntPP 30)]
merlina = ObjetoPP [("nombre", TextoPP "Merlina"), ("edad", IntPP 24)]
addams = ObjetoPP [("0", pericles), ("1", merlina)]
familias = ObjetoPP [("Addams", addams)]
pedro = ObjetoPP [("0", addams),("1", addams),("2", merlina)]

testsEj5 :: Test
testsEj5 =
  test
    [ "pponAtomico Texto" ~: pponAtomico (TextoPP "hola") ~?= True,
      "pponAtomico Int" ~: pponAtomico (IntPP 123) ~?= True,
      "pponAtomico ObjetoPP Vacio" ~: pponAtomico (ObjetoPP []) ~?= False,
      "pponAtomico ObjetoPP Simple" ~: pponAtomico (ObjetoPP [("x", IntPP 1)]) ~?= False,
      "pponAtomico ObjetoPP Compuesto" ~: pponAtomico addams ~?= False,
      "pponAtomico ObjetoPP Simple 2" ~: pponAtomico merlina ~?= False
    ]
-- testeamos el funcionamiento de pponAtomico, con datos guardados en memoria y con otros ingresados en el momento.

testsEj6 :: Test
testsEj6 =
  test
    [ "pponObjetoSimple Objeto Vacio" ~: pponObjetoSimple (ObjetoPP []) ~?= True,
      "pponObjetoSimple Texto" ~: pponObjetoSimple (TextoPP "hola") ~?= False,
      "pponObjetoSimple Int" ~: pponObjetoSimple (IntPP 123) ~?= False,
      "pponObjetoSimple dos tuplas" ~: pponObjetoSimple (ObjetoPP [("x", IntPP 42), ("y", TextoPP "z")]) ~?= True,
      "pponObjetoSimple Objeto complejo con vacio" ~: pponObjetoSimple (ObjetoPP [("a", TextoPP "b"), ("b", ObjetoPP [])]) ~?= False,
      "pponObjetoSimple Objeto Complejo" ~: pponObjetoSimple (ObjetoPP [("a", IntPP 1), ("b", ObjetoPP [("c", TextoPP "d")])]) ~?= False
    ]
-- testeamos el funcionamiento de pponObjetoSimple con los diferentes constructores de PPON y posibles valores que puede tener.

a, b, c :: Doc
a = texto "a"
b = texto "b"
c = texto "c"

testsEj7 :: Test
testsEj7 =
  test
    [ "intercalar un elemento" ~: mostrar (intercalar (texto "|") [a]) ~?= "a",
      "intercalar dos elementos" ~: mostrar (intercalar (linea <+> texto "-") [a, b]) ~?= "a\n-b",
      "intercalar vacio" ~: mostrar (intercalar (texto " ") []) ~?= "",
      "intercalar tres elementos" ~: mostrar (intercalar (texto " y ") [a, b, c]) ~?= "a y b y c",
      "intercalar sep vacio" ~: mostrar (intercalar vacio [a, b, c]) ~?= "abc"
    ]
-- testeamos el funcionamiento de intercalar con varias listas de docs y separadores

testsEj8 :: Test
testsEj8 =
  test
    [ "aplanar linea y texto" ~: mostrar (aplanar (linea <+> b)) ~?= " b",
      "aplanar linea con indentacion" ~: mostrar (aplanar (indentar 4 (a <+> linea <+> b))) ~?= "a b",
      "aplanar dos lineas" ~: mostrar (aplanar (a <+> linea <+> vacio <+> linea <+> c)) ~?= "a  c",
      "aplanar solo texto" ~: mostrar (aplanar c) ~?= "c",
      "aplanar vacio" ~: mostrar (aplanar vacio) ~?= ""
    ]
-- testeamos el funcionamiento de aplanar con varios tipos de documentos

testsEj9 :: Test
testsEj9 =
  test
    [ "pponADoc texto" ~: mostrar (pponADoc (TextoPP "hola")) ~?= "\"hola\"",
      "pponADoc int" ~: mostrar (pponADoc (IntPP 42)) ~?= "42",
      "pponADoc Objeto Vacio" ~: mostrar (pponADoc (ObjetoPP [])) ~?= "{ }",
      "pponADoc Objeto Simple" ~: mostrar (pponADoc (ObjetoPP [("a", TextoPP "b")])) ~?= "{ \"a\": \"b\" }",
      "pponADoc Objeto Compuesto" ~: mostrar (pponADoc pedro) ~?= "{\n  \"0\": {\n    \"0\": { \"nombre\": \"Pericles\", \"edad\": 30 },\n    \"1\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n  },\n  \"1\": {\n    \"0\": { \"nombre\": \"Pericles\", \"edad\": 30 },\n    \"1\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n  },\n  \"2\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n}"
    ]
-- testeamos el funcionamiento de pponADoc con los distintos constructores de PPPONes