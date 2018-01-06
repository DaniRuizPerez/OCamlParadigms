type 'a fb_tree =
	Single of 'a
| Comp of ('a *'a fb_tree* 'a fb_tree);;

let single x = Single x;;

let comp x (y,z) = Comp (x,y,z);;

exception Branches;;

let root = function
	Single x -> x
	|Comp (x,y,z) -> x;;

let branches = function
	Single x -> raise (Branches)
	|Comp (x,y,z) -> (y,z);;

let rec string_of_tree f = function
	Single t -> "("^ (f t) ^ ")"
	|Comp (x,y,z) -> "("^ (f x) ^ " " ^ (string_of_tree f y) ^" "^ (string_of_tree f z)  ^ ")";;
