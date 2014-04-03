create table martin_sepsis_cohort as 

SELECT    h.subject_ID,
          h.hadm_id   
  FROM mimic2v26.admissions h, 
       mimic2v26.ICD9 code
  WHERE code.SUBJECT_ID = h.SUBJECT_ID 
        and ( substr( code.CODE , 1 , 3 ) in (  
         '001' -- Cholera; 
        , '002'  --Typhoid/paratyphoid fever; 
        , '003'  --Other salmonella infection; 
        , '004'  --Shigellosis; 
        , '005'  --Other foodpoisoning; 
        , '008'  --Intestinal infection nototherwise classi�ed;
        , '009'  -- Ill-de�ned intestinal infection; 
        , '010'  --Primary tuberculosis infection; 
        , '011'  --Pulmonary tuberculosis; 
        , '012'  --Other respiratory tuberculosis;
        , '013'  --Central nervous system tuberculosis; 
        , '014'  --Intestinal tuberculosis; 
        , '015'  --Tuberculosis of bone or joint; 
        , '016'  --Genitourinary tuberculosis; 
        , '017'  --Tuberculosisnot otherwise classi�ed; 
        , '018'  --Miliary tuberculosis; 
        , '020'  --Plague; 
        , '021'  --Tularemia;
        , '022'  --Anthrax; 
        , '023'  --Brucellosis; 
        , '024'  --Glorers; 
        , '025'  --Melioidosis; 
        , '026'  --Rat-bite fever;
        , '027'  --Other bacterial zoonoses; 
        , '030'  --Leprosy; 
        , '031'  --Other mycobacterial disease;
        , '032'  --Diphtheria; 
        , '033'  --Whooping cough;
        , '034'  --Streptococcal throat/scarlet fever;
        , '035'  --Erysipelas; 
        , '036'  --Meningococcal infection; 
        , '037'  --Tetanus; 
        , '038'  --Septicemia;
        , '039'  --Actinomycotic infections; 
        , '040'  --Other bacterial diseases; 
        , '041'  --Bacterial infectionin other diseases not otherwise speci�ed;
        , '090'  --Congenital syphilis; 
        , '091'  --Earlysymptomatic syphilis; 
        , '092'  --Early syphilislatent; 
        , '093'  --Cardiovascular syphilis; 
        , '094' --Neurosyphilis; 
        , '095'  --Other late symptomatic syphilis; 
        , '096'  --Late syphilis latent;
        , '097'  --Other and unspeci�ed syphilis; 
        , '098' --Gonococcal infections; 
        , '100'  --Leptospirosis; 
        , '101'  --Vincent�s angina; 
        , '102'  --Yaws; 
        , '103' --Pinta; 
        , '104'  --Other spirochetal infection;
        , '110' -- Dermatophytosis; 
        , '111'  --Dermatomycosis not otherwise classi�ed or speci�ed;
        , '112' -- Coridiasis; 
        , '114'  --Coccidioidomycosis; 
        , '115' -- Histoplasmosis; 
        , '116'  --Blastomycotic infection; 
        , '117'  --Other mycoses; 
        , '118' --Opportunistic mycoses; 
        , '320'  --Bacterialmeningitis; 
        , '322'  --Meningitis  unspeci�ed;
        , '324'  --Central nervous system abscess; 
        , '325' --Phlebitis of intracranial sinus; 
        , '420'  --Acutepericarditis; 
        , '421'  --Acute or subacute endocarditis; 
        , '451'  --Thrombophlebitis;
        , '461' --Acute sinusitis;
        , '462'  --Acute pharyngitis;
        , '463' -- Acute tonsillitis; 
        , '464'  --Acute laryngitis/tracheitis;
        , '465'  --Acute upper respiratory infection of multiple sites/not otherwisespeci�e d ; 
        , '481' --  P n e umo c o c c a lpneumonia; 
        , '482'  --Other bacterial pneumonia; 
        , '485'  --Bronchopneumonia with organism not otherwise speci�ed; 
        , '486' --Pneumonia  organism not otherwisespeci�ed; 
        , '494' --Bronchiectasis; 
        , '510'  --Empyema; 
        , '513' --Lung/mediastinum abscess; 
        , '540'  --Acuteappendicitis; 
        , '541'  --Appendicitis not otherwise speci�ed; 
        , '542'  --Other appendicitis;
        , '566'  --Anal or rectal abscess; 
        , '567'  --Peritonitis; 
        , '590'  --Kidney infection; 
        , '597'  --Urethritis/urethral syndrome; 
        , '601' --Prostatic in�ammation;
        , '614'  --Female pelvic in�ammation disease; 
        , '615'  --Uterine in-�ammatory disease; 
        , '616'  --Other femalegenital in�ammation;
        , '681'  --Cellulitis  �nger/toe; 
        , '682'  --Other cellulitis or abscess;
        , '683'  --Acute lymphadenitis;
        , '686'  --Other local skin infection; 
        , '730'  --Osteomyelitis; 
        )
        or substr( code.CODE , 1, 6) in (       
         '491.21' -- Acute exacerbation ofobstructive chronic bronchitis; 
        , '562.01' -- Diverticulitis of small intestinewithout hemorrhage; 
        , '562.03'  --Diverticulitis of small intestine with hemorrhage;
        , '562.11'  --Diverticulitis of colon withouthemorrhage; 
        , '562.13'  --Diverticulitis of colon with hemorrhage; 
        , '569.83' -- Perforation ofintestine; 
       )
       or substr( code.CODE , 1, 5) in (       
         '569.5' -- Intestinal abscess; 
        , '572.0'  --Abscess of liver; 
        , '572.1' --Portal pyemia;
        , '575.0'  --Acute cholecystitis;
        , '599.0'  --Urinary tractinfection not otherwise speci�ed; 
        , '711.0'  --Pyogenic arthritis; 
        , '790.7'  --Bacteremia; 
        , '996.6'  --Infection or in�ammation ofdevice/graft; 
        , '998.5'  --Postoperative infection; 
        , '999.3'  --Infectious complication ofmedical care not otherwise classi�ed. 
        )
    );  

