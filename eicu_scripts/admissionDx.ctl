load data 
infile 'admissionDrug.txt' "str '\n'"
replace
into table admissiondrug_new
fields terminated by '$!#'
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( 

)
