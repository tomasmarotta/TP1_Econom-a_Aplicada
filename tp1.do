*TP1 ECONOMÍA APLICADA. De Boeck, Garay Adriel, Kastika y Marotta 

clear all 
set more off

*save path in global or local 
global main "/Users/sofia/Desktop/Maestría/Optativas/Tercer trimestre/Economía Aplicada/TPs/TP 1"
global input "$main/input"
global output "$main/output"

*inserto base de datos 
use "$input/data_russia.dta", clear

*CLEANING DATA

*1) Pasamos todas las variables a formato numérico 

*replace: se utiliza para modificar el contenido de una variable existente
*split: divide una variable de texto en múltiples variables basadas en un delimitador especificado
*destring: convierte variables de texto que contienen números a variables numéricas
*encode: convierte una variable de texto en una variable numérica etiquetada (factor)
*float o double: dos formatos numéricos para las variables 
*string: variable en formato texto

*pasamos variables a numericas (factor)
encode sex, gen(sex1) 
drop sex

encode obese, gen(obese1)
replace obese1=. if obese1==1
drop obese

*cambiamos categoria a 1 
replace smokes="1" if smokes=="Smokes"
destring smokes, replace

*pasamos variables a numericas y pasamos los numeros escritos en texto a números 
foreach var of varlist econrk powrnk resprk satlif satecc highsc belief monage cmedin hprblm hosl3m htself wtchng evalhl operat hattac alclmo waistc hhpres tincm_r geo work0 work1 work2 ortho marsta1 marsta2 marsta3 marsta4 { 
    capture confirm string variable `var'
    if _rc == 0 {
        replace `var' = "1" if `var' == "one"
        replace `var' = "2" if `var' == "two"
        replace `var' = "3" if `var' == "three"
        replace `var' = "4" if `var' == "four"
        replace `var' = "5" if `var' == "five"
        replace `var' = "." if `var' == ".b"
		replace `var' = "." if `var' == ".d"
        destring `var', replace
    }
}

*pasamos a numericas variables con split
split hipsiz, gen(hipsiz1)
drop hipsiz12
drop hipsiz11
rename hipsiz13 hipsiz1
replace hipsiz1="." if hipsiz1==","
replace hipsiz1 = subinstr(hipsiz1, ",", ".", .)
destring hipsiz1, replace 
drop hipsiz

split totexpr, gen(totexpr1)
drop totexpr11
drop totexpr12
rename totexpr13 totexpr1
replace totexpr1="." if totexpr1==","
replace totexpr1 = subinstr(totexpr1, ",", ".", .)
destring totexpr1, replace 
drop totexpr

*paso a numerica 
replace tincm_r="." if tincm_r==","
replace tincm_r = subinstr(tincm_r, ",", ".", .)
destring tincm_r, replace 


*2) Vemos cuántos missing tienen las variables 
ssc install mdesc
mdesc // vemos los missing para todas las variables 

*Missing values
*econrk: 28
*powrnk: 87
*resprk: 129
*satlif: 28
*satecc: 12
*highsc: 8 
*belief: 38
*monage: 203
*cmedin: 6
*hosl3m: 2
*htself: 185
*wtchng: 97
*evalhl: 5 
*alclmo: 2
*height: 28
*waistc: 21
*hhpres: 12
*obese1: 203
*hipsiz1: 21
*totexpr1: 187

*vemos si alguna de esas variables tiene mas del 5% de valores faltantes
summarize econrk powrnk resprk satlif satecc highsc belief monage cmedin hosl3m htself wtchng evalhl alclmo height waistc hhpres obese1 hipsiz1 totexpr1

*comparamos el resultado de la cantidad de observaciones por 0.05 con los números de arriba

*3) Reemplazamos outliers con missing 

foreach var of varlist inwgt monage htself height waistc tincm_r {
    summarize `var', detail
    local p99 = r(p99)
    drop if `var' > `p99'
}

*solo para las variables numericas (no las categoricas), sacamos los outliers, definidos como aquellos valores por encima del percentil 99
*Variables: inwgt (individual sample weight), monage (age in months), htself (altura reportada), height (altura), waistc (circumferencia de cintura), tincm_r (ingreso real) 

*4) Ordenamos dataset 
order id site sex1
sort totexpr1 //ordeno de menor a mayor por fila

*DESCRIPTIVE STATISTICS

*5) Agregarle labels a las variables y después summarize 

*Agregamos labels
label var sex1 "Sexo"
label var satlif "Satisfacción con la vida"
label var waistc "Circunferencia de cintura"
label var totexpr1 "Gasto real"

*Genero variable edad en años
gen edad = monage/12 
recast int edad, force // redondeamos los años
label var edad "Edad"

foreach var of varlist sex1 satlif waistc totexpr1 edad  {
    summarize `var'
}

*FALTA SACAR TABLA A LATEX



