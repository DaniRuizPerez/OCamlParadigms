
let hd = function
	[] -> raise (Failure "hd")
	| h::_ -> h;;


let tl = function 
	[] -> raise (Failure "tl")
	| _::t -> t;;


let length l =
	let rec aux a l = match l with
		| [] -> a
		| _ :: t -> aux (a + 1) t
	in aux 0 l;;

(*
let rec rev = function
	[] -> []
	| h::t -> let l = rev t in l::h;;
		
*)
let rec nth l n = match (l,n) with 
     ([],_) -> raise (Failure "nth")
   | (h::_,0) -> h
   | (_::t,n) -> nth t (n-1);;


let rec append l1 l2 = match (l1,l2) with
	([],l2) -> l2
	| (h::t,l2) -> h::(append t l2);; 	
	





let rec concat = function
	[] -> []
	| h::t -> List.append h (concat t);; 


let flatten = concat;;
	

let rec map f = function
	[] -> []
	| h::t -> f h :: map f t


let rec map2 f l1 l2 = match (l1, l2) with
	([],[]) -> []
	| h::t, g::w -> (f h g)::(map2 f t w)
   | _ -> raise (Failure "invalid_argument");;


let rec fold_left f a = function
	[] -> a
	| h::t -> fold_left f (f a h) t;;


let fold_right f l a = fold_left f a l;;








let rec for_all f = function
	[] -> false
	| [x] -> f x 
	| h::t -> if f h then for_all f t else false;;


let rec exists f = function
	[] -> false
	| [x] -> f x
	| h::t -> if f h then true else exists f t;;


let rec mem a = function
	[] -> false
	| [x] -> x = a
	| h::t -> if h = a then true else mem a t;;


let rec find f = function
	[] -> raise (Failure "not found")
	| h::t -> if f h then h else find f t;;


let rec filter f = function
	[] -> []
	| h::t -> let l = filter f t in
				if f h then h::l
				else l;;


let find_all = filter;;


let rec partition p = function
	[] -> [], []
	| h::t -> let t1,t2 = partition p t in 
			if p h
			then (h::t1, t2)
			else (t1, h::t2);;


let rec assoc a = function
	[] -> raise (Failure "Not_found")
	| h::t -> if fst h = a then snd h else assoc a t;;


let rec mem_assoc a = function
	[] -> false
	| h::t -> if fst h = a then true else mem_assoc a t;;


let rec remove_assoc a = function
	[] -> []
	| h::t -> if fst h = a then t else h:: remove_assoc a t;;


let rec split = function
	[] -> ([],[])
	| h::t -> let t1,t2 = split t in ((fst h)::t1, (snd h ::t2));;
																

let rec combine l1 l2 = match (l1,l2) with
	([],[]) -> []
	| (h::t, g::f) -> (h,g)::(combine t f)
	| (_) -> raise (Failure "Invalid_argument");;






let rec remove a = function
	[] -> []
	| h::t -> if h = a then t else h::(remove a t );;



let rec remove_all a = function
     [] -> []
   | h::t -> if h = a then remove_all a t else h::(remove_all a t);;



let rec join q l1 l2 = match l1,l2 with
	[],_ | _, [] -> []
	| (a,c)::t1, (b,d)::t2 -> let resto = join q [(a,c)] t2 @ join q t1 l2 in
										if q a b then (a,b,c,d) :: resto else resto;;



let rec natural_join l1 l2 = match l1,l2 with
	[],_ | _,[] -> []
	| (a,c)::t1, (b,d)::t2 -> let resto = natural_join [(a,c)] t2 @ natural_join t1 l2 in
										if a = b then (a,c,d)::resto else resto;;	






