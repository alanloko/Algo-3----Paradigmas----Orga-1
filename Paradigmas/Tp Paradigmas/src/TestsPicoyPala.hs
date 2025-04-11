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
      "foldDoc indentar dos espacios" ~: foldDoc vacio (\s rec -> texto s <+> rec) (\j rec -> (indentar (j+2) linea) <+> rec) (indentar 2 (texto "a" <+> linea <+> texto "b")) ~?= indentar 4 (texto "a" <+> linea <+> texto "b")
    ]
--testeamos el uso de un fold identidad, es decir que no aplique ninguna función, y otra indentando 2 espacios.
testsEj2 :: Test
testsEj2 =
  test
    [ (texto "a" <+> linea) <+> texto "b" ~?= texto "a" <+> (linea <+> texto "b"),
      texto "" <+> texto "x" ~?= texto "x",
      texto "x" <+> texto "" ~?= texto "x",
      texto "" <+> texto "" ~?= texto "",
      texto "a" <+> vacio <+> texto "b" ~?= texto "ab",
      vacio <+> texto "a" <+> vacio ~?= texto "a"
    ]
--testeamos concatenar de formas simples y por ultimo probar multiples concatenaciones, sumado a concatenar vacios para verificar que se mantenga el doc.
testsEj3 :: Test
testsEj3 =
  test
    [ indentar 0 (texto "sin cambio") ~?= texto "sin cambio",
      indentar 3 (texto "a" <+> linea) ~?= texto "a" <+> indentar 3 linea
    ]
--testeamos el funcionamiento basico de indentar, y un test un poco más complejo para verificar el resultado de una asociacion distinta.
testsEj4 :: Test
testsEj4 =
  test
    [ mostrar (texto "hola") ~?= "hola",
      mostrar (linea <+> texto "fin") ~?= "\nfin",
      mostrar (indentar 1 (linea <+> texto "x")) ~?= "\n x",
      mostrar (texto "a" <+> linea <+> texto "b" <+> linea <+> texto "c") ~?= "a\nb\nc"
    ]
--testeamos que mostrar use correctamente el ingreso de una linea.
pericles, merlina, addams, familias, pedro :: PPON
pericles = ObjetoPP [("nombre", TextoPP "Pericles"), ("edad", IntPP 30)]
merlina = ObjetoPP [("nombre", TextoPP "Merlina"), ("edad", IntPP 24)]
addams = ObjetoPP [("0", pericles), ("1", merlina)]
familias = ObjetoPP [("Addams", addams)]
pedro = ObjetoPP [("0", addams),("1", addams),("2", merlina)]

testsEj5 :: Test
testsEj5 =
  test
    [ pponAtomico (TextoPP "hola") ~?= True,
      pponAtomico (IntPP 123) ~?= True,
      pponAtomico (ObjetoPP []) ~?= False,
      pponAtomico (ObjetoPP [("x", IntPP 1)]) ~?= False,
      pponAtomico merlina ~?= False
    ]
--agregamos el test 5 para ver el correcto uso de pponAtomico, con datos guardados en memoria y con otros ingresados en el momento.


testsEj6 :: Test
testsEj6 =
  test
    [ pponObjetoSimple (ObjetoPP []) ~?= True,
      pponObjetoSimple (ObjetoPP [("x", IntPP 42), ("y", TextoPP "z")]) ~?= True,
      pponObjetoSimple (ObjetoPP [("a", TextoPP "b"), ("b", ObjetoPP [])]) ~?= False,
      pponObjetoSimple (ObjetoPP [("a", IntPP 1), ("b", ObjetoPP [("c", TextoPP "d")])]) ~?= False
    ]
--testeamos casos tanto verdaderos como falsos, uno muy simple como el de un objeto vacio y los demás un poco más complejos, usando un objeto vacio dentro de otro

a, b, c :: Doc
a = texto "a"
b = texto "b"
c = texto "c"

testsEj7 :: Test
testsEj7 =
  test
    [ mostrar (intercalar (texto "|") [a]) ~?= "a",
      mostrar (intercalar (linea <+> texto "-") [a, b]) ~?= "a\n-b",
      mostrar (intercalar (texto " ") []) ~?= "",
      mostrar (intercalar (texto " y ") [a, b, c]) ~?= "a y b y c"
    ]

testsEj8 :: Test
testsEj8 =
  test
    [ mostrar (aplanar (linea <+> b)) ~?= " b",
      mostrar (aplanar (indentar 4 (a <+> linea <+> b))) ~?= "a b",
      mostrar (aplanar (a <+> linea <+> texto "" <+> linea <+> c)) ~?= "a  c"
    ]

testsEj9 :: Test
testsEj9 =
  test
    [ mostrar (pponADoc (TextoPP "hola")) ~?= "\"hola\"",
      mostrar (pponADoc (IntPP 42)) ~?= "42",
      mostrar (pponADoc (ObjetoPP [])) ~?= "{ }",
      mostrar (pponADoc (ObjetoPP [("a", TextoPP "b")])) ~?= "{ \"a\": \"b\" }",
      mostrar (pponADoc pedro) ~?= "{\n  \"0\": {\n    \"0\": { \"nombre\": \"Pericles\", \"edad\": 30 },\n    \"1\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n  },\n  \"1\": {\n    \"0\": { \"nombre\": \"Pericles\", \"edad\": 30 },\n    \"1\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n  },\n  \"2\": { \"nombre\": \"Merlina\", \"edad\": 24 }\n}"
    ]
