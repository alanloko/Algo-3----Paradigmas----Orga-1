import Data.List (union)
data Prop = Var String | No Prop | Y Prop Prop | O Prop Prop | Imp Prop Prop

type Valuacion = String -> Bool

foldProp :: (String -> b) -> (b -> b) -> (b -> b -> b) -> (b -> b -> b) -> (b -> b -> b) -> Prop -> b
foldProp fVar fNo fY fO fImp p = case p of
                            Var s -> fVar s
                            No q -> fNo (rec q)
                            Y r q -> fY (rec r) (rec q)
                            O r q -> fO (rec r) (rec q)
                            Imp r q -> fImp (rec r) (rec q)
                            where rec = foldProp fVar fNo fY fO fImp

recProp :: (String -> b) -> (Prop -> b -> b) -> (Prop -> Prop -> b -> b -> b) -> (Prop -> Prop -> b -> b -> b) -> (Prop -> Prop -> b -> b -> b) -> Prop -> b
recProp fVar fNo fY fO fImp p = case p of
                            Var s -> fVar s
                            No q -> fNo q (rec q)
                            Y r q -> fY r q (rec r) (rec q)
                            O r q -> fO r q (rec r) (rec q)
                            Imp r q -> fImp r q (rec r) (rec q)
                            where rec = recProp fVar fNo fY fO fImp


variables :: Prop -> [String]
variables = foldProp (: []) id union union union

valuacion :: Prop -> Valuacion -> Bool
valuacion = foldProp (\s v -> v s) (\p v -> not (p v)) (\p q v -> p v && q v) (\p q v -> p v || q v)
                    (
                        \p q v -> (if p v then q v else True)
                    )

estaEnFNN :: Prop -> Bool
estaEnFNN = recProp (const True) (\p rec->
                            case p of
                                Var s -> True
                                _ -> False
                            )
                            (\p q rec1 rec2 -> rec1 && rec2) (\p q rec1 rec2 -> rec1 && rec2)
                            (\_ _ _ _ -> False)

p :: Prop
p = Var "P"
q :: Prop
q = Var "Q"

prop :: Prop
prop = O p (No q)
