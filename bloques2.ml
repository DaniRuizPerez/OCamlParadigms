   
   (*TIPOS DE DATOS USADOS*)

exception Accion_invalida;;
exception Entrada_invalida;;

type accion = Arriba | Abajo | Izquierda | Derecha | Soltar | Coger | Imposible;;

type plan = accion list;;

type bloques = Uno | Dos | Tres | Cuatro | Cinco | Seis | Siete | Ocho ;;

type bloque = None | Some of bloques;;

type tbrazo = {mutable x:int; mutable y: int; mutable bloque: bloque};;

type mundo = { brazo: tbrazo ; c1: bloque array ;  c2: bloque array ; c3: bloque array};;

type acciones = accion list;; (* Para llevar la cuenta de las acciones que me llevan a este mundo*)

type actual = (mundo * acciones);; (* Mundo sobre el que estoy trabajando*)

type mundoaccioneslist = actual list;; (* Lista de mundos con las acciones que me llevan a ellos*)


   (*FUNCIONES AUXILIARES*)

let rec longitud columna =
   let cont = ref 0 in
   for i = 0 to 2 do
      if columna.(i) != None then cont := !cont +1
   done; !cont;;


let lengthcolumna mundo y = 
   if y = 1 then longitud mundo.c1
   else if y = 2 then longitud mundo.c2
   else if y = 3 then longitud mundo.c3
   else 0;; 

let columna mundo y = 
   if y = 1 then mundo.c1
   else if y = 2 then mundo.c2
   else if y = 3 then mundo.c3
   else [||];; 


let copiar_brazo brazo = let x = {brazo with bloque = brazo.bloque} in x;;

let copiar_mundo mundo = let x = {brazo = copiar_brazo mundo.brazo; c1 = Array.copy mundo.c1; c2 = Array.copy mundo.c2; c3 = Array.copy mundo.c3}in x;;	


                     (* EJECUTAR ACCION*)


let ejecutar_accion mundo accion =
      
      let brazo = mundo.brazo in
      if accion = Arriba 
         then if (brazo.y < 4)    (* se accede como en esta linea*)
            then brazo.y <- brazo.y + 1
         else raise Accion_invalida 
      else 
(* Simplemente si brazo está en la posicion tres lanza una excepcion, y si no, lo mueve*)
     
      if accion = Abajo 
         then if (brazo.bloque = None) 
            then if (brazo.y - (lengthcolumna mundo (brazo.x)) >= 2)
               then brazo.y <- (brazo.y -1)
            else raise Accion_invalida 
         else 
           if (brazo.y -(lengthcolumna mundo (brazo.x)) >= 3)
             then brazo.y <- (brazo.y- 1)
           else raise Accion_invalida 
      else 

(* Para poder ejecutarse, si el brazo no tiene cogido un bloque, la longitud de la columna en la que está el fallo tiene que ser por lo una unidad mayor, si tiene cogido un bloque tiene que ser dos. Si no se cumple todo esto, lanza una excepcion.*)

      if accion = Coger
         then if (brazo.bloque != None)
            then raise Accion_invalida
         else
            if (brazo.y - (lengthcolumna mundo (brazo.x)) != 1)
               then raise Accion_invalida
            else begin brazo.bloque <- (columna mundo (brazo.x)).(brazo.y -2);
                  (columna mundo (brazo.x)).(brazo.y -2) <- None end
      else 
       
(* si tiene cogido un bloque, o en la posicion inmediatamente inferior al brazo no hay nada, lanza una excepcion, si no, coge el bloque de la posicion donde esta el brazo -1, y pone un none en la columna en esa posicion*)

      if accion = Soltar
         then if (mundo.brazo.bloque = None)
            then raise Accion_invalida
         else
            if (mundo.brazo.y - (lengthcolumna mundo (brazo.x)) != 2)
               then raise Accion_invalida
            else begin (columna mundo (brazo.x)).(brazo.y -2) <- brazo.bloque;
                brazo.bloque <- None end
      else 

(*Si no tiene cogido nada, o intentas soltar el bloque en el aire da error, y si no, mete en el mundo el bloque en la posicion en la que está y pone brazo.bloque a None*)


      if accion = Izquierda 
         then if (mundo.brazo.x <= 1)
            then raise Accion_invalida
            else if (brazo.bloque = None) 
               then if (brazo.y - (lengthcolumna mundo (brazo.x -1)) >= 1)
                  then brazo.x <- (brazo.x -1)
               else raise Accion_invalida (*ERROR*)
            else 
              if (brazo.y -(lengthcolumna mundo (brazo.x -1)) >= 2)
                then brazo.x <- (brazo.x -1)
              else raise Accion_invalida (*ERROR*)
      else 

(* Si está en la posición uno o menos, da error, si no, dependiendo de si tiene o no tiene un bloque agarrado, mira si tiene espacio para moverse a esa columna y si puede lo hace y si no, lanza una excepcion*)

      if accion = Derecha 
         then if (brazo.x >= 3)
            then raise Accion_invalida
            else if (brazo.bloque = None) 
               then if (brazo.y - (lengthcolumna mundo (brazo.x +1)) >= 1)
                  then brazo.x <- (brazo.x +1)
               else raise Accion_invalida (*ERROR*)
            else 
              if (brazo.y -(lengthcolumna mundo (brazo.x +1)) >= 2)
                then brazo.x <- (brazo.x +1)
              else raise Accion_invalida (*ERROR*)
      else () ;;


(* Si está en la posición tres o más, da error, si no, dependiendo de si tiene o no tiene un bloque agarrado, mira si tiene espacio para moverse a esa columna y si puede lo hace y si no, lanza una excepcion*)


   (*Funciones auxiliares de construir_plan*)


(* A ejecutar_posibles le pasas un mundo y la lista de acciones que llevan a el, y lo que hace es devolver una lista con todos los pares (mundo,aacciones) posibles que parten de ese mundo
Hago un try with con cada una de las acciones, capturando las excepciones de ejecutar_accion.
y por encima de todos hago otro try with con inv_arg para evitar estas excepciones.
*)
let ejecutar_posibles actual =

try (
   let mundo, acciones = fst actual, snd actual in
   (
	let lista = ref [] in(
	(let copia = copiar_mundo mundo in

	(try ejecutar_accion copia Arriba; lista := (copia, acciones @ [Arriba]) :: !lista 
	with Accion_invalida -> ()); 

	let copia = copiar_mundo mundo in
	(try ejecutar_accion copia Abajo; lista := (copia, acciones @ [Abajo]) :: !lista 
	with Accion_invalida -> ()) ;

	let copia = copiar_mundo mundo in
	(try ejecutar_accion copia Izquierda; lista := (copia, acciones @ [Izquierda]) :: !lista 
	with Accion_invalida -> ()) ;

	let copia = copiar_mundo mundo in
	(try ejecutar_accion copia Derecha; lista := (copia, acciones @ [Derecha]) :: !lista 
	with Accion_invalida -> ())  ;

	let copia = copiar_mundo mundo in
	(try ejecutar_accion copia Coger; lista :=(copia, acciones @ [Coger]) :: !lista 
	with Accion_invalida -> ())  ;

	let copia = copiar_mundo mundo in
	(try ejecutar_accion copia Soltar; lista := (copia, acciones @ [Soltar]) :: !lista 
	with Accion_invalida -> ())  ;
	  !lista)))) with inv_arg -> [];;


(* Comparar es para ver que mundos de la lista que devuelve la funcion anterior estan en visitados*)
let comparar l1 visitados =
      let rec aux a b contador =
         if a = [] then contador else (
            if (List.mem( fst (List.hd a)) b) then (aux (List.tl a) b contador)
            else (aux (List.tl a) b ((List.hd a :: contador))))
      in aux l1 visitados [];;


   (*CONSTRUIR_PLAN*)

let construir_plan (inicial, final) =
   if inicial = final then [] 
   else begin
      let visitados, siguiente, solucion = ref [], ref [(inicial,[])] ,  ref [Imposible] in (

         while (!siguiente != []) do begin
            let mundo, acciones = fst (List.hd !siguiente), snd (List.hd !siguiente) in
               (if mundo = final then begin
                  solucion := acciones;
                  siguiente := [] end
                  else begin
                     (let posibles = ejecutar_posibles (mundo,acciones) in 
                        (let novisitados = comparar posibles !visitados in 
                           (siguiente := List.tl !siguiente @ novisitados;
                           visitados := List.rev_append (List.map fst novisitados) !visitados )))
                   end) 
          end done; 

      !solucion)
   end;;
   
   
   (*FUNCIONES E/S*)

let escribir_accion accion = 
    if accion = Arriba then print_endline "Arriba"
    else 
    if accion = Abajo then print_endline "Abajo"
      else 
    if accion = Izquierda then print_endline "Izquierda"
      else 
    if accion = Derecha then print_endline "Derecha"
      else 
    if accion = Coger then print_endline "Coger"
      else 
    if accion = Soltar then print_endline "Soltar" ;;


let escribir_plan = function
   [] | [Imposible] -> print_endline "Imposible"
   | plan -> let rec aux = function
      [] -> ()
      | h::t -> escribir_accion h ; aux t
   in aux plan;;
      

let convierte_a_bloque a = 
   let v = [|None; Some Uno; Some Dos; Some Tres; Some Cuatro; Some Cinco; Some Seis; Some Siete; Some Ocho|] in
   v.(int_of_char a - int_of_char '0');;
   

let construir_mundo entrada = 
   if String.length entrada = 9 then (
      let c1,c2,c3 = Array.make 3 None,Array.make 3 None,Array.make 3 None in 
         for i = 0 to 2 do
            c1.(2-i) <- convierte_a_bloque entrada.[i];
            c2.(2-i) <- convierte_a_bloque entrada.[i+3];
            c3.(2-i) <- convierte_a_bloque entrada.[i+6] 
         done;
      {brazo = {x = 2 ; y = 4; bloque = None}; c1 = c1; c2 = c2; c3 = c3})
   else raise Entrada_invalida;;


   (*main*)

escribir_plan(construir_plan (construir_mundo (Sys.argv.(1)), construir_mundo (Sys.argv.(2))));;













