class vectordinamico (tam_bloque) =
object (this)

   (*ATRIBUTOS*)

   val mutable buffer =if tam_bloque > 0 then  Array.create tam_bloque 0 else invalid_arg "tamaño invalido"
   val mutable numeltos = 0
   val tambloque = tam_bloque

   (*MÉTODOS DE MODIFICACIÓN*)

   method annade (a) = if numeltos != 0 && numeltos mod tam_bloque = 0  
      then (let temp = Array.create tambloque 0 in 
            buffer <- Array.append buffer temp)
      else ();
      buffer.(numeltos) <- a; 
      numeltos <- numeltos +1 
    
   method inserta (elem, pos) = if pos > numeltos || pos < 0 
   (*Considero que no se puede insertar en una posición que sea mayor que la ultima +1 *)
      then invalid_arg "index out of bounds" 
      else this # annade elem ;
      for i = numeltos downto (pos+2) do
          buffer.(i-1) <- buffer.(i-2)
      done;
          buffer.(pos) <- elem
    
   method sobreescribe (elem, pos) = Array.set buffer pos elem
   
   (*MÉTODOS DE CONSULTA*)

   method longitud = numeltos

   method elemento (pos) =  if pos > numeltos || pos < 0 
      then invalid_arg "index out of bounds" 
      else buffer.(pos)

   method indice (elem) = let aux, i = ref (-1), ref 0 in 
      while !i < numeltos && !aux = -1 do 
         if buffer.(!i) = elem then aux := !i else i := !i +1 done;
      if !aux = -1 then -1 else !aux

   method to_string () = let a = ref "[" in 
      for i = 0 to numeltos-2 do
         a := !a ^ (string_of_int buffer.(i) ^ ",")
      done;
         if numeltos = 0 then a := "[]" else
         a := !a ^ (if numeltos = 0 then "" else string_of_int buffer.(numeltos -1) ) ^"]" ; !a
 
   method to_stringBuffer () = let a, long = ref "[", Array.length buffer in 
      for i = 0 to (long -2) do
         a := !a ^ (if i < numeltos then string_of_int buffer.(i) ^ "," else "_," )
      done; 
      a := !a ^ (if long > numeltos then "_" else string_of_int buffer.(long-1))  ^ "]"; !a

   end;;

