(*Daniel Ruiz Pérez, Grupo 2.1.2 *)

(*La funcion rlist no es recursiva terminal, ya que deja cuentas pendientes.
  Podría ocasionar un desbordamiento de la pila para valorse muy grandes*)

let rec rlist r l =
	if l <= 0 then []
	else Random.int r :: rlist r (l-1);;

(* version terminal de rlist _ *)

let t_rlist r l =
	let rec aux n li = 
		if n <= 0 then li
		else aux (n-1) ((Random.int r):: li)
		in aux l [];;



(* Ordenacion por selección e insercion: 
	No son recursivas terminales. Su limitación es que no pueden ordenar
	un vector cuyo número de elementos supere un máximo que hace que
	la pila desborde.
*)

let s_sort = function
	[] -> []
	|h::t ->
	let rec aux res m = function
		([],[]) -> m::res
		| (h::t,[]) -> aux (m::res) h ([],t)
		| (l,h::t) -> if h <= m
							then aux res m (h::l,t)
							else aux res h (m::l,t)
	in aux [] h ([], t);;


let rec insert x = function
	[] -> [x]
	| h::t -> if x <= h then x::h::t
				else h::insert x t;;

let rec i_sort = function
	[] -> []
	| h::t -> insert h (i_sort t);;


(* Pseudo función crono: *)
	
let crono f x =
	let t = Sys.time () in
		let _ = f x in
			Sys.time () -. t;;
	

(* Comparación de la rapidez de los algoritmos: *)

(*

Ejecutados en mi portátil

						      ALGORITMOS 

   nºelementos       	 selecciòn		          inserción

	100			          0.003999999999          	 0

	1000	           		 0.060004		             0.02800199999

	5000		             1.056065999999		       0.35202199999

	10000		     	       4.416276		             1.54809700000

	20000			          19.72523199999	        	 7.24045200000

   64000                 253.527844                 106.602660999999983     

ord. de 10000            4.424276999999	      	 0.004000000000

invers. ord. de 10000 	 4.420275999999	          3.1881989999999

*)


(*
Éstá claro que la función más eficiente es inserción, ya que presenta tiempos claramente inferiores que selección.
Las dos presentan un crecimiento cuadrático bastante definido, siendo así para todos los casos en selección, mientras que inserción tiene casos en los que es especialmente rápido o lento.
el mejor caso para inserción es cuando la lista ya está ordenada por que lo único que tiene que hacer es recorrerla, mientras que si está inversamente ordenada tiene que insertar siempre en la primera posición, lo cual es mucho más costoso.
*)

(* formas terminales: *)


let t_insert x lista = 
	let rec aux visto = function
		[] -> List.rev_append visto [x] 
	  | h::t -> if h < x then aux (h::visto) t else 
		List.rev_append visto (x :: h::t)
		in aux [] lista;;
				      	    

let t_i_sort lista = 
	let rec aux listaordenada = function
		[] -> listaordenada 
		| h::t -> aux (t_insert h listaordenada) t
	in aux [] lista;; 
		

   (* Comparación i_sort y t_i_sort*)

(*

Ejecutados en las máquinas de la facultad

lista de 1000 elementos:

 crono i_sort lista;;
- : float = 0.012000
# crono t_i_sort lista;;
- : float = 0.024002


lista de 10000 elementos:

# crono i_sort lista;;
- : float = 2.484156
# crono t_i_sort lista;;
- : float = 3.764235


lista de 20000 elementos:

# crono i_sort lista;;
- : float = 13.6368520
# crono t_i_sort lista;;
- : float = 17.45309


lista de 64000  elementos
 
# crono i_sort lista;;
- : float = 277.61334899
# crono t_i_sort lista;;
- : float = 211.57322299

Como vemos, la función recursiva terminal es más rápida para listas muy grandes.

*)







