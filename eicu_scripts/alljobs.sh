
#!/bin/bash
#echo "Kendall2013" | sqlldr  eicu_adm control=./rsReportBucket.ctl parallel=true direct=true skip_index_maintenance=true 
#echo "Kendall2013" | sqlldr  eicu_adm control=./vitalAperiodic.ctl parallel=true direct=true skip_index_maintenance=true 
#echo "Kendall2013" | sqlldr  eicu_adm control=./lab.ctl parallel=true direct=true skip_index_maintenance=true 
echo "Kendall2013" | sqlldr  eicu_adm control=./nurseCharting.ctl parallel=true direct=true skip_index_maintenance=true 
#echo "Kendall2013" | sqlldr  eicu_adm control=./vitalPeriodic.ctl parallel=true direct=true skip_index_maintenance=true 
