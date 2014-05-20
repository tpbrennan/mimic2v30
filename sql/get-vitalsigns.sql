CREATE OR REPLACE FUNCTION GET_VITALSIGNS (
    p_category IN VARCHAR2, 
    p_subject_id IN NUMBER, 
    p_starttime IN TIMESTAMP, 
    p_endtime IN TIMESTAMP)

RETURN vitalsigns 
IS

  ( subject_id BIGINT,
    p_category VARCHAR(50) COLLATE database_default,
    val NUMBER,
    charttime TIMESTAMP)
    
    
/*                                                                                              
  get-vitalsigns.sql                                                                           
  
  Created on   : 20 May 2014 by Thomas Brennan
  Last updated :
     $Author: tpb@ECG.MIT.EDU $
     $Date: 2014-05-20 11:58:55 -0400 (Tue, 20 May 2014) $
     
  Using MIMIC2 version 3.0

 Function that returns vital signs for a given subject_id, 
 the weight of a particular saps-I parameter
 This is used in the calculation for saps-I score.
 Formula given by Mohammed Saeed, some units have been converted.
 
*/

AS
BEGIN

    IF p_category = 'HR' THEN


    ELSIF p_category = 'TEMPERATURE' THEN


    ELSIF p_category = 'SYSABP' THEN


    ELSIF p_category = 'VENTILATED_RESP' THEN

        
    ELSIF p_category = 'SPONTANEOUS_RESP' THEN

    ELSIF p_category = 'BUN' THEN

    ELSIF p_category = 'HCT' THEN

    ELSIF p_category = 'WBC' THEN

    ELSIF p_category = 'GLUCOSE' THEN

    ELSIF p_category = 'POTASSIUM' THEN

    ELSIF p_category = 'SODIUM' THEN

    ELSIF p_category = 'HCO3' THEN

    ELSIF p_category = 'GCS' THEN

    ELSIF p_category = 'URINE' THEN

    END IF;
    
    INSERT INTO @vitalsigns
      (k.PersonID, Adresse, PlZ, Ort, Land)
      SELECT k.Personid, k.Adresse, o.PLZ, l.Land
        FROM Kontakt k, Ort o, Land l
        WHERE k.OrtID = o.OrtID
         AND o.LandID = l.LandID
         AND k.KontaktID = @KontaktID
  RETURN

END;

 
 