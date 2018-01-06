#!/usr/bin/wish
# blq - animacion del mundo de los bloques

# ------------------------------------------------------------------------
# Comprobacion de los argumentos
# Set window title
set msgsintax "Sintaxis: $argv0 <número de bloques entre 1 y 8>"

if {$argc == 1} then {
    set numbloques [lindex $argv 0]
    if {$numbloques >= 1 && $numbloques <= 8} then {
        wm title . "El Mundo de los Bloques"
        wm resizable . false false
    } else {
        puts stderr $msgsintax
        exit
    }
} else {
    puts stderr $msgsintax
    exit
}


# ------------------------------------------------------------------------
proc PanelConfiguracionMundo { w pos } {
    global blq numbloques

    label $w.label -text "Mundo $pos" -relief ridge 
    pack  $w.label -side top -fill x 

    set blq(botonConfigurar$pos) [button $w.boton -text "Configurar" \
				      -width 10 -command [list Configurar $w $pos]]
    pack   $w.boton -side left -padx 10 -pady 10

    canvas $w.canvas -relief sunken -borderwidth 2 -bg PeachPuff -width 140 -height 130
    pack   $w.canvas -side right -pady 10

    #####
    foreach casilla {1 2 3 4 5 6 7 8 9} {
        set blq($pos,casilla,$casilla,blq) 0
    }

    if {$numbloques >= 1} then {
        $w.canvas create rect  20  80  50 110 -outline black -fill red -tag bloque
        set blq($pos,casilla,3,blq) 1
        set blq($pos,bloque,1) 3; 
    }
    if {$numbloques >= 2} then {
        $w.canvas create rect  60  80  90 110 -outline black -fill #2666b9990000 -tag bloque
        set blq($pos,casilla,6,blq) 2
        set blq($pos,bloque,2) 6; 
    }
    if {$numbloques >= 3} then {
        $w.canvas create rect 100  80 130 110 -outline black -fill Dodgerblue -tag bloque
        set blq($pos,casilla,9,blq) 3
        set blq($pos,bloque,3) 9;
    }
    if {$numbloques >= 4} then {
        $w.canvas create rect  20  50  50  80 -outline black -fill #eeee00 -tag bloque
        set blq($pos,casilla,2,blq) 4
        set blq($pos,bloque,4) 2;
    }
    if {$numbloques >= 5} then {
        $w.canvas create rect  60  50  90  80 -outline black -fill gray -tag bloque
        set blq($pos,casilla,5,blq) 5
        set blq($pos,bloque,5) 5;
    }
    if {$numbloques >= 6} then {
        $w.canvas create rect 100  50 130  80 -outline black -fill {medium purple} -tag bloque
        set blq($pos,casilla,8,blq) 6
        set blq($pos,bloque,6) 8;
    }
    if {$numbloques >= 7} then {
        $w.canvas create rect  20  20  50  50 -outline black -fill orange -tag bloque
        set blq($pos,casilla,1,blq) 7
        set blq($pos,bloque,7) 1;
    }
    if {$numbloques >= 8} then {
        $w.canvas create rect  60  20  90  50 -outline black -fill #ee00ee -tag bloque
        set blq($pos,casilla,4,blq) 8
        set blq($pos,bloque,8) 4;
    }

    $w.canvas create line   0 110 145 110 -fill black 
    $w.canvas create text  35 120 -text "P" -anchor center
    $w.canvas create text  75 120 -text "Q" -anchor center
    $w.canvas create text 115 120 -text "R" -anchor center

    set blq($pos,casilla,1,x)  20; set blq($pos,casilla,1,y)  20;
    set blq($pos,casilla,2,x)  20; set blq($pos,casilla,2,y)  50;
    set blq($pos,casilla,3,x)  20; set blq($pos,casilla,3,y)  80;
    set blq($pos,casilla,4,x)  60; set blq($pos,casilla,4,y)  20;
    set blq($pos,casilla,5,x)  60; set blq($pos,casilla,5,y)  50;
    set blq($pos,casilla,6,x)  60; set blq($pos,casilla,6,y)  80;
    set blq($pos,casilla,7,x) 100; set blq($pos,casilla,7,y)  20;
    set blq($pos,casilla,8,x) 100; set blq($pos,casilla,8,y)  50;
    set blq($pos,casilla,9,x) 100; set blq($pos,casilla,9,y)  80;

    set blq($pos,blqmov) 0

    pack $w -side top -expand true -fill both -padx 10 -pady 10
}

# ------------------------------------------------------------------------
proc PanelControlPlanes { w } {
    global blq

    label $w.label -text "Plan" -relief ridge
    pack  $w.label -side top -fill x -pady 10

    set f [frame $w.opciones]

#    radiobutton $f.anch_alto -variable blq(algoritmo) \
#	-text "Alto nivel (en anchura)" -value anchura_alto -command {RadioButtonsProc}
#    pack $f.anch_alto -side top -anchor w

#    radiobutton $f.prof_alto -variable blq(algoritmo) \
#	-text "Alto nivel (en profundidad)" -value profundidad_alto -command {RadioButtonsProc}
#    pack $f.prof_alto -side top -anchor w

#    radiobutton $f.anch_bajo -variable blq(algoritmo) \
#	-text "Bajo nivel (en anchura)" -value anchura_bajo -command {RadioButtonsProc}
#    pack $f.anch_bajo -side top -anchor w

#    radiobutton $f.prof_bajo -variable blq(algoritmo) \
#	-text "Profundidad (Bajo nivel)" -value profundidad_bajo -command {RadioButtonsProc}
#    pack $f.prof_bajo -side top -anchor w

    set blq(botonPlan) [button $f.plan -text Plan -width 10 -command Plan]
    pack $f.plan -side top -expand true

    set blq(botonEjecutar) [button $f.ejecutar -text Ejecutar -width 10 \
				-command Ejecutar -state disabled]
    pack $f.ejecutar -side top  -expand true

    label $f.label -text "Total de pasos:"
    pack  $f.label -side left 

    label $f.pasos -textvariable blq(numPasos)
    pack  $f.pasos -side right 

    pack $f -side left -padx 10 -expand true -fill y

    set g [frame $w.pasos]
    set blq(listbox) [listbox $g.list -height 10 -width 10 -yscrollcommand [list $g.sy set]]
    scrollbar $g.sy -orient vertical -command [list $g.list yview]
    pack $g.sy -side right -fill y
    pack $g.list -side left -fill both -expand true
    pack $g -side right

    pack $w -side top -expand true -fill both -padx 10 -pady 30
}

# ------------------------------------------------------------------------
proc PanelAnimacion { w } {
    global blq
    label $w.label -text "Escenario" -relief ridge
    pack  $w.label -side top -fill x -pady 10

    set blq(esc) [canvas $w.canvas -relief sunken -bg PeachPuff -borderwidth 2 -width 420 -height 480]
    pack   $w.canvas -side top -expand true

    $w.canvas create line   0 420 435 420 -fill black 
    $w.canvas create text 105 450 -text "P" -anchor center
    $w.canvas create text 225 450 -text "Q" -anchor center
    $w.canvas create text 345 450 -text "R" -anchor center

    frame $w.f
    scale $w.f.sc -from 1 -to 3 -length 300 -variable blq(speedx) \
	-orient horizontal -label Velocidad -showvalue false -command {SetSpeed}
    pack $w.f.sc -side top
    label $w.f.lb -textvariable blq(speedName)
    pack $w.f.lb -side top
    pack $w.f -side top -expand true

    button $w.boton -text "Salir" -command exit
    pack   $w.boton -side top -expand true
}

# ------------------------------------------------------------------------
set blq(Inicial,otro) Final
set blq(Final,otro) Inicial
# set blq(algoritmo) anchura_alto
set blq(algoritmo) anchura_bajo
set blq(numPasos) 0
set blq(speedx) 2
set blq(speed) 5
set blq(speedName) Media

frame .operacion
frame .operacion.inicial
frame .operacion.plan
frame .operacion.final
PanelConfiguracionMundo .operacion.inicial Inicial
PanelControlPlanes .operacion.plan
PanelConfiguracionMundo .operacion.final Final
pack .operacion -side left -padx 10 -pady 10 -expand true -fill both

frame .escenario
PanelAnimacion .escenario
pack   .escenario -side right -padx 10 -pady 10 -expand true -fill y

# ------------------------------------------------------------------------
proc Configurar { w pos } {
    global blq

    set otro $blq($pos,otro)
    $blq(botonConfigurar$otro) config -state disabled
    $blq(botonPlan) config -state disabled
    $blq(botonEjecutar) config -state disabled
    set blq(numPasos) 0
    $blq(listbox) delete 0 end
    # vaciar el escenario
    $blq(esc) delete esc
    $blq(botonConfigurar$pos) config -text Ok -command [list Ok $w $pos]

    $w.canvas bind bloque <Button-1> [list CanvasMark %x %y %W $pos]
    $w.canvas bind bloque <B1-Motion> [list CanvasDrag %x %y %W $pos]
    $w.canvas bind bloque <ButtonRelease-1> [list CanvasMove %x %y %W $pos]
}

# ------------------------------------------------------------------------
proc Ok { w pos } {
    global blq

    if {[MundoLegal $pos]} then {
	set otro $blq($pos,otro)
	$blq(botonConfigurar$otro) config -state normal
	$blq(botonPlan) config -state normal
	$blq(botonConfigurar$pos) config -text Configurar -command [list Configurar $w $pos]
	
	$w.canvas bind bloque <Button-1> {}
	$w.canvas bind bloque <B1-Motion> {}
	$w.canvas bind bloque <ButtonRelease-1> {}
    } else {
	tk_dialog .dialogo {Error} {El mundo no es legal} {} 0 OK
    }
}

# ------------------------------------------------------------------------
proc MundoLegal { pos } {
    global blq
    foreach casilla {1 2 4 5 7 8} {
	set inferior [expr $casilla + 1]
	if {$blq($pos,casilla,$casilla,blq)  != 0 &&
            $blq($pos,casilla,$inferior,blq) == 0} then {
	    return 0
	}
    }
    return 1
}

# ------------------------------------------------------------------------
proc CanvasMark { x y w pos } {
    global blq
    set bloqueselec [$w find closest $x $y]
    set blq($pos,blqmov) $bloqueselec
    set blq($pos,blqmov,x) $x
    set blq($pos,blqmov,y) $y
}

# ------------------------------------------------------------------------
proc CanvasDrag { x y w pos } {
    global blq
    set bloqueselec $blq($pos,blqmov)
    set oldx $blq($pos,blqmov,x)
    set oldy $blq($pos,blqmov,y)
    set dx [expr $x - $oldx]
    set dy [expr $y - $oldy]
    $w move $bloqueselec $dx $dy
    set blq($pos,blqmov,x) $x
    set blq($pos,blqmov,y) $y
}

# ------------------------------------------------------------------------
proc CanvasMove { x y w pos } {
    global blq
    set bloqueselec $blq($pos,blqmov)
    CanvasCasilla $x $y $pos
    set casilla $blq($pos,bloque,$bloqueselec)
    set newx $blq($pos,casilla,$casilla,x)
    set newy $blq($pos,casilla,$casilla,y)
    $w coords $bloqueselec $newx $newy [expr $newx + 30] [expr $newy + 30]
    set blq($pos,blqmov) 0
}

# ------------------------------------------------------------------------
proc CanvasCasilla { x y pos } {
    global blq
    set i 1
    while {$i <= 9} {
	set cx $blq($pos,casilla,$i,x)
	set cxl [expr $cx + 30]
	set cy $blq($pos,casilla,$i,y)
	set cyl [expr $cy + 30]
	if {$x >= $cx && $x <= $cxl && $y >= $cy && $y <= $cyl} then {
	    if {$blq($pos,casilla,$i,blq) == 0} then {
		set bloqueselec $blq($pos,blqmov)
		set blq($pos,casilla,$i,blq) $bloqueselec
		set oldcasilla $blq($pos,bloque,$bloqueselec)
		set blq($pos,casilla,$oldcasilla,blq) 0
		set blq($pos,bloque,$bloqueselec) $i
		return $i
	    } else {
		return 0
	    }
	}
	incr i
    }
    return 0
}

# ------------------------------------------------------------------------
proc RadioButtonsProc {} {
    global blq
    $blq(botonEjecutar) config -state disabled
    set blq(numPasos) 0
    $blq(listbox) delete 0 end
    # vaciar el escenario
    $blq(esc) delete esc
}

# ------------------------------------------------------------------------
proc Plan {} {
    global blq

    $blq(botonEjecutar) config -state disabled
    set blq(numPasos) 0
    $blq(listbox) delete 0 end
    # vaciar el escenario
    $blq(esc) delete esc

    set stringInicial {}
    set stringFinal {}
    set i 1
    while {$i <= 9} {
	set stringInicial $stringInicial$blq(Inicial,casilla,$i,blq)
	set stringFinal $stringFinal$blq(Final,casilla,$i,blq)
	incr i
    }
#    set command "./bloques_$blq(algoritmo) $stringInicial $stringFinal"
    set command "./bloques $stringInicial $stringFinal"

    if [catch {open "|$command |& cat"} blq(input)] then {
	tk_dialog .dialogo {Error} "$blq(input)" {} 0 OK
	return
    } else {
	fileevent $blq(input) readable Log
    }

    if {[string compare $blq(algoritmo) "anchura_bajo"] == 0 ||
        [string compare $blq(algoritmo) "profundidad_bajo"] == 0} then {
	$blq(botonEjecutar) config -state normal
    }
}

# ------------------------------------------------------------------------
proc Log {} {
    global blq
    if [eof $blq(input)] then {
	catch {close $blq(input)}
	$blq(listbox) delete end
	incr blq(numPasos) -1
    } else {
	gets $blq(input) line
	$blq(listbox) insert end $line
        if {[string compare $line "Imposible"] != 0} then {
	    incr blq(numPasos)
	}
    }
}

# ------------------------------------------------------------------------
proc Ejecutar {} {
    global blq

    $blq(esc) delete esc

    set blq(esc,casilla,1,blq) 0; set blq(esc,casilla,4,blq) 0; set blq(esc,casilla,7,blq) 0
    set blq(esc,casilla,2,blq) 0; set blq(esc,casilla,5,blq) 0; set blq(esc,casilla,8,blq) 0
    set blq(esc,casilla,3,blq) 0; set blq(esc,casilla,6,blq) 0; set blq(esc,casilla,9,blq) 0

    if {$blq(numPasos) == 0} then { return }

    SituarBloquesIniciales
    update idletasks
    after 500

#    $blq(esc) create polygon  95 -350 115 -350 115 90 150 90 150 110 60 110 60 90 95 90 \
# 	-fill #d9d9d9 -tags [list esc brazo]
#    $blq(esc) create line    60 90 95 90 95 -350 115 -350 115 90 150 90 \
# 	-fill black -tags [list esc brazo]
#    $blq(esc) create line    60 110 150 110 \
# 	-fill black -tags [list esc brazo]

    $blq(esc) create polygon  215 -350 235 -350 235 90 270 90 270 110 180 110 180 90 215 90 \
 	-fill #d9d9d9 -tags [list esc brazo]
    $blq(esc) create line    180 90 215 90 215 -350 235 -350 235 90 270 90 \
 	-fill black -tags [list esc brazo]
    $blq(esc) create line    180 110 270 110 \
 	-fill black -tags [list esc brazo]

#    $blq(esc) create polygon 60 90 40 90 40 140 50 140 50 110 60 110 \
# 	-fill #d9d9d9 -tags [list esc brazo pinzaizq]
#    $blq(esc) create line    60 90 40 90 40 140 50 140 50 110 60 110 \
# 	-fill black  -tags [list esc brazo pinzaizq]

    $blq(esc) create polygon 180 90 160 90 160 140 170 140 170 110 180 110 \
 	-fill #d9d9d9 -tags [list esc brazo pinzaizq]
    $blq(esc) create line    180 90 160 90 160 140 170 140 170 110 180 110 \
 	-fill black  -tags [list esc brazo pinzaizq]

#    $blq(esc) create polygon 150 90 170 90 170 140 160 140 160 110 150 110 \
# 	-fill #d9d9d9 -tags [list esc brazo pinzadch]
#    $blq(esc) create line    150 90 170 90 170 140 160 140 160 110 150 110 \
# 	-fill black   -tags [list esc brazo pinzadch]

    $blq(esc) create polygon 270 90 290 90 290 140 280 140 280 110 270 110 \
 	-fill #d9d9d9 -tags [list esc brazo pinzadch]
    $blq(esc) create line    270 90 290 90 290 140 280 140 280 110 270 110 \
 	-fill black   -tags [list esc brazo pinzadch]

    update idletasks
    after 500

    set blq(esc,casilla,brazo) 4
    set pasos [$blq(listbox) get 0 end]
    set i 0

    foreach paso $pasos {
	$blq(listbox) selection set $i
	$blq(listbox) see $i
	set b $blq(esc,casilla,brazo)
	
	switch -exact -- $paso {
	    Izquierda { set blq(esc,casilla,brazo) [expr $b - 3]; BrazoIzquierda }
	    Derecha   { set blq(esc,casilla,brazo) [expr $b + 3]; BrazoDerecha   }
	    Arriba    { set blq(esc,casilla,brazo) [expr $b - 1]; BrazoArriba 90 }
	    Abajo     { set blq(esc,casilla,brazo) [expr $b + 1]; BrazoAbajo 90  }
	    Coger     { BrazoAbajo 40; PinzasDentro; Coger; BrazoArriba 10}
	    Soltar    { BrazoAbajo 10; Soltar; PinzasFuera; BrazoArriba 40}
	    default   {}
	}

	update idletasks
	$blq(listbox) selection clear $i
	incr i
    }
}

# ------------------------------------------------------------------------
proc SituarBloquesIniciales {} {
    global blq numbloques
    ####
    for {set b 1} {$b <= $numbloques} {incr b} {
	switch -exact -- $b {
	    1 { set color red }
	    2 { set color #2666b9990000 }
	    3 { set color Dodgerblue }
	    4 { set color #eeee00 }
	    5 { set color grey }
            6 { set color {medium purple} }
	    7 { set color orange }
	    8 { set color #ee00ee }
            default {}
	}

        set casilla $blq(Inicial,bloque,$b)
	
	switch -exact -- $casilla {
	    1 { $blq(esc) create rect  60 150 150 240 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    2 { $blq(esc) create rect  60 240 150 330 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    3 { $blq(esc) create rect  60 330 150 420 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    4 { $blq(esc) create rect 180 150 270 240 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    5 { $blq(esc) create rect 180 240 270 330 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    6 { $blq(esc) create rect 180 330 270 420 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    7 { $blq(esc) create rect 300 150 390 240 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    8 { $blq(esc) create rect 300 240 390 330 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    9 { $blq(esc) create rect 300 330 390 420 -outline black -fill $color \
		    -tags [list esc bloque$b] }
	    default {}
	}

	set blq(esc,casilla,$casilla,blq) bloque$b
    }
}

# ------------------------------------------------------------------------
proc BrazoIzquierda {} {
    global blq
    set x 1
    set dx $blq(speed)
    set bx [expr $blq(speed) * -1]
    while {$x <= 120} {
	$blq(esc) move brazo $bx 0
	incr x $dx
	after 5
	update idletasks
    }
}

# ------------------------------------------------------------------------
proc BrazoDerecha {} {
    global blq
    set x 1
    set dx $blq(speed)
    while {$x <= 120} {
	$blq(esc) move brazo $dx 0
	incr x $dx
	after 5
	update idletasks
    }
}

# ------------------------------------------------------------------------
proc BrazoArriba { c } {
    global blq
    set y 1
    set dy $blq(speed)
    set by [expr $blq(speed) * -1]
    while {$y <= $c} {
	$blq(esc) move brazo 0 $by
	incr y $dy
	after 5
	update idletasks
    }
}

# ------------------------------------------------------------------------
proc BrazoAbajo { c } {
    global blq
    set y 1
    set dy $blq(speed)
    while {$y <= $c} {
	$blq(esc) move brazo 0 $dy
	incr y $dy
	after 5
	update idletasks
    }
}

# ------------------------------------------------------------------------
proc Coger {} {
    global blq
    set casilla $blq(esc,casilla,brazo)
    set b $blq(esc,casilla,$casilla,blq)
    set blq(esc,blqmov) $b

    $blq(esc) addtag brazo withtag $b
}

# ------------------------------------------------------------------------
proc Soltar {} {
    global blq
    set casilla $blq(esc,casilla,brazo)
    set b $blq(esc,blqmov)
    set blq(esc,casilla,$casilla,blq) $b
    set blq(esc,blqmov) 0

    $blq(esc) dtag $b brazo 
}

# ------------------------------------------------------------------------
proc PinzasDentro {} {
    global blq
    set x 1
    set dx $blq(speed)
    set px [expr $blq(speed) * -1]
    while {$x <= 10} {
	$blq(esc) move pinzaizq $dx 0
	$blq(esc) move pinzadch $px 0
	incr x $dx
	after 5
	update idletasks
    }
}

# ------------------------------------------------------------------------
proc PinzasFuera {} {
    global blq
    set x 1
    set dx $blq(speed)
    set px [expr $blq(speed) * -1]
    while {$x <= 10} {
	$blq(esc) move pinzaizq $px 0
	$blq(esc) move pinzadch $dx 0
	incr x $dx
	after 5
	update idletasks
    }
}

# ------------------------------------------------------------------------
proc SetSpeed { x } {
    global blq
    switch -exact -- $x {
	1 {set blq(speed) 1;  set blq(speedName) Baja}
	2 {set blq(speed) 5;  set blq(speedName) Media}
	3 {set blq(speed) 10; set blq(speedName) Alta}
    }
}

# ------------------------------------------------------------------------

