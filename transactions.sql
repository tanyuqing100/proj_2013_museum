

--**************************** loan ****************************
----------------------------------------------------------------------------
--**************************************************************************    

create or replace  function loan (
ns_tra_wkalphaid  wkalphaid,
ns_tra_wknumid  wknumid,
ns_tra_wkcolid  colid,
ns_tra_colid_from colid,
ns_tra_colid_to colid,
ns_tra_wkinsvalue wkinsvalue,
ns_tra_tradate_start tradate,
ns_tra_tradate_end tradate
) returns void as 
$$
begin

	insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Loan',ns_tra_tradate_start,ns_tra_tradate_end,
				ns_tra_colid_from,ns_tra_colid_to,ns_tra_wkinsvalue);
 	if (ns_tra_colid_to = 'DAM' or ns_tra_colid_to = 'JMBC' or ns_tra_colid_to = 'APM' or ns_tra_colid_to = 'TANK') then
		
		insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Borrowed',ns_tra_tradate_start,ns_tra_tradate_end,
				ns_tra_colid_to,ns_tra_colid_from,ns_tra_wkinsvalue);
  		
 	end if;
	
return;	
end;


$$
language plpgsql;



--select Loan ('AUD','75','JMBC','DAM','JMBC','1000','2013-02-20','2013-02-20');


--*****************************************assign to travel exh****************************************
----------------------------------------------------------------------------
--**************************************************************************    

create or replace function assignWktoTravelExh (
	wkalphaid  wkalphaid,
	wknumid  wknumid,
	wkcolid  colid,
	lcname  lcname,
	lccolid  colid,
	date_s date,
	time_s time,
	date_e date,
	time_e time,
	intemp integer

)returns void as 
$$

declare 
wltype wltype;
begin

-- update prev



if (date_ <= current_date) then
	wltype = 'Current';
else
	wltype = 'Scheduled';
	insert into ns_worklocation select ns_wl_wkalphaid,ns_wl_wknumid,ns_wl_wkcolid,ns_wl_lcname,ns_wl_lccolid,date_s,time_s,date_e,time_e,'Current' 
	from ns_worklocation where ns_wl_wkalphaid = wkalphaid and
							ns_wl_wknumid = wknumid and
							ns_wl_wkcolid = wkcolid and
							ns_wl_lccolid = lccolid and
							ns_wl_lcname = 'storage' and    
							ns_wl_wldate_out is null; 
			
end if;
	


update ns_worklocation set ns_wl_wldate_out = date_s , ns_wl_wltime_out = time_s, ns_wl_type = wltype where 
							ns_wl_wkalphaid = wkalphaid and 
							ns_wl_wknumid = wknumid and
							ns_wl_wkcolid = wkcolid and
							ns_wl_lccolid = lccolid and
							ns_wl_lcname = 'storage' and    
							ns_wl_wldate_out is null; 


-- insert tloc to wl
	
insert into ns_worklocation values(wkalphaid,wknumid,wkcolid,lcname,'OUT',date_s,time_s,date_e,time_e,wltype);


-- insert temp to wl

insert into ns_worklocation values(wkalphaid,wknumid,wkcolid,'temp location','OUT',date_e,time_e,date_e+intemp,time_e,wltype);


end;
$$
language plpgsql;

--select assignWktoTravelExh('AMD','2','DAM','Regina','DAM','2013-12-05','9:00:00','2013-12-26','10:00:00','7');

--*****************************************moveworks****************************************
----------------------------------------------------------------------------
--**************************************************************************    

create or replace  function currentMoveWorks (
	wkalphaid  wkalphaid,
	wknumid  wknumid,
	wkcolid  colid,
	lcname   lcname,
	lccolid colid,
	mv_date date,
	mv_time time,
	actiontype varchar(5)
	) returns void as 
	$$		
        declare 
        date_m date;
	begin

			if(actiontype = 'IN')then
				if((mv_date is null) or (mv_date > current_date or (mv_date = current_date and mv_time > current_time)))then
					insert into ns_worklocation values(wkalphaid,wknumid,wkcolid,lcname,lccolid,current_date,current_time,null,null,'Current');
				else	
					insert into ns_worklocation values(wkalphaid,wknumid,wkcolid,lcname,lccolid,mv_date,mv_time,null,null,'Current');
				end if;
			elseif(actiontype = 'OUT')then
				if((mv_date is null) or (mv_date > current_date or (mv_date = current_date and mv_time > current_time)))then
					update ns_worklocation set ns_wl_wldate_out = current_date, ns_wl_wltime_out = current_time where 
							ns_wl_wkalphaid = wkalphaid and  
							ns_wl_wknumid = wknumid and
							ns_wl_wkcolid = wkcolid and
							ns_wl_lcname = lcname and 
							ns_wl_lccolid = lccolid and
							ns_wl_type = 'Current' and 	ns_wl_wldate_out is null;
							
				else
					update ns_worklocation set ns_wl_wldate_out = mv_date, ns_wl_wltime_out = mv_time where 
							ns_wl_wkalphaid = wkalphaid and  
							ns_wl_wknumid = wknumid and
							ns_wl_wkcolid = wkcolid and
							ns_wl_lcname = lcname and 
							ns_wl_lccolid = lccolid and
							ns_wl_type = 'Current' and 	ns_wl_wldate_out is null;
				end if;					
			end if;
	return;

	END;	  
	$$
	language plpgsql;

	--select  currentMoveWorks('AMD','26','DAM','storage','DAM','2013-11-26','10:00:00','OUT');
----------------------------------------------------------------------------
--**************************************************************************    
--************************************************potential************************
create or replace  function potential (
ns_tra_wkalphaid  wkalphaid,
ns_tra_wknumid  wknumid,
ns_tra_wkcolid  colid,
ns_tra_colid_from colid,
ns_tra_colid_to colid,
ns_tra_wkinsvalue wkinsvalue,
ns_tra_tradate_start tradate,
ns_tra_tradate_end tradate
) returns void as 
$$
begin

	insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Potential Borrowed',ns_tra_tradate_start,ns_tra_tradate_end,
				ns_tra_colid_from,ns_tra_colid_to,ns_tra_wkinsvalue);
	
return;	
end;


$$
language plpgsql;

--select potential ('SR','7003','TANK','DAM','TANK','290000','2014-11-12','2014-12-12');

--select removeWkBeforeExEnd('test', '1', 'MFA', 'MFAtest', '1', '2011-11-11 00:00:00', '2012-11-15 00:00:00');


----------------------------------------------------------------------------
--**************************************************************************    
--*************************** Purchase a work ****************************/

create or replace  function purchase (
ns_tra_wkalphaid  wkalphaid,
ns_tra_wknumid  wknumid,
ns_tra_wkcolid  colid,
ns_tra_colid_from colid,
ns_tra_colid_to colid,
ns_tra_wkinsvalue wkinsvalue,
ns_tra_tradate_start tradate
) returns void as 
$$

begin

	

	insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Purchased',ns_tra_tradate_start,null,
				ns_tra_colid_from,ns_tra_colid_to,ns_tra_wkinsvalue);
 	if (ns_tra_colid_to = 'DAM' or ns_tra_colid_to = 'JMBC' or ns_tra_colid_to = 'APM' or ns_tra_colid_to = 'TANK') then
		
		insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Sale',ns_tra_tradate_start,null,
				ns_tra_colid_to,ns_tra_colid_from,ns_tra_wkinsvalue);
  		
 	end if;



	UPDATE ns_insvalue set ns_ins_insmoddate = ns_tra_tradate_start where 
			ns_ins_inswkalphaid =ns_tra_wkalphaid and 
			ns_ins_inswknumid = ns_tra_wknumid and 
			ns_ins_inswkcolid = ns_tra_wkcolid and 
			ns_ins_inswkinsvalue  =ns_tra_wkinsvalue*1.2;
	
	
return;	
end;
$$
language plpgsql;


--INNER:
--select purchase ('AUD','73','JMBC','JMBC','DAM','1000','2013-02-20');
--OUTTER:
--select purchase ('TEST','111','TANK','TANK','TEST','1000','2013-02-20');


----------------------------------------------------------------------------
--**************************************************************************    
--*************************** Sell a work ****************************/

create or replace  function sale (
ns_tra_wkalphaid  wkalphaid,
ns_tra_wknumid  wknumid,
ns_tra_wkcolid  colid,
ns_tra_colid_from colid,
ns_tra_colid_to colid,
ns_tra_wkinsvalue wkinsvalue,
ns_tra_tradate_start tradate
) returns void as 
$$
begin

	insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Sale',ns_tra_tradate_start,NULL,
				ns_tra_colid_from,ns_tra_colid_to,ns_tra_wkinsvalue);
 	if (ns_tra_colid_to = 'DAM' or ns_tra_colid_to = 'JMBC' or ns_tra_colid_to = 'APM' or ns_tra_colid_to = 'TANK') then
		
		insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Purchased',ns_tra_tradate_start,NULL,
				ns_tra_colid_to,ns_tra_colid_from,ns_tra_wkinsvalue);
  		
 	end if;
	
return;	
end;


$$
language plpgsql;

--*****************************Assignworktoexh********************
----------------------------------------------------------------------------
--**************************************************************************    

create or replace  function Assignworktoexh (
wkalphaid  wkalphaid,
wknumid  wknumid,
wkcolid  colid,
exhname  exhname,
exhcolid colid,
date_s exhdate,
date_e exhdate


) returns void as 
$$
DECLARE
        islocal         	boolean;
		temp_locid			 colid;	
		temp_tloc			 lcname;
		counter 			integer;
		temp_sdate          date;
		temp_edate			date;
		temp_value          DECIMAL(8,2);
		lc_min              integer; 
		lc_max				integer;
		wk_counter  		integer;
		loc_counter         integer;
	
		

begin
  
		islocal = (select ns_exh_exhislocal from ns_exhibition where 
					ns_exh_exhname = exhname and
					ns_exh_exhcolid = exhcolid);  
		
		if(islocal = 'f')then
			RAISE EXCEPTION 'CANNOT HANDLE TRAVEL EXHIBITION';
			return;
			exit;
		end if;	
		
		

		temp_locid = (select DISTINCT ns_el_lccolid from ns_exhibitionlocation where 
						ns_el_exhname = exhname and
						ns_el_exhcolid = exhcolid);

		loc_counter = (select count(*) from ns_exhibitionlocation where 
						ns_el_exhname = exhname and
						ns_el_exhcolid = exhcolid); 
		
		lc_max = (select sum(ns_lc_capacity_max) from ns_location 
						where ns_lc_lcname in (select ns_el_lcname from ns_exhibitionlocation where 
						ns_el_exhname = exhname and
						ns_el_exhcolid = exhcolid) and
							  ns_lc_lccolid = temp_locid);
		

	
						 
		wk_counter = (select ns_exh_exhnumofworks FROM ns_exhibition where 
								ns_exh_exhname = exhname and
								ns_exh_exhcolid = exhcolid);

	
	

		
		if(islocal = 't' and wk_counter >= lc_max )then
				raise EXCEPTION 'The exhibition has the max number of works, assignment failed';	
				return;			
				exit;
		end if;


		temp_sdate = (select ns_exh_exhdate_start from ns_exhibition where 
					ns_exh_exhname = exhname and
					ns_exh_exhcolid = exhcolid);

		temp_edate = (select ns_exh_exhdate_end from ns_exhibition where 
					ns_exh_exhname = exhname and
					ns_exh_exhcolid = exhcolid);

		if (date_s is null and date_e is null )then
			insert into ns_workexhibition values (wkalphaid,wknumid,wkcolid,exhname,exhcolid,temp_sdate,temp_edate );
		else
			insert into ns_workexhibition values(wkalphaid,wknumid,wkcolid,exhname,exhcolid,date_s,date_e );
		
		end if;


		
return;

END;	  
$$
language plpgsql;

-- test
--select Assignworktoexh('TEST','444','TANK','TEST EXH 2','JMBC',NULL,NULL); 
--select Assignworktoexh('ADM','9','DAM','5 CITIES EXHIBITION','DAM',NULL,NULL);



--*****************************Removeworkfromexh********************  
----------------------------------------------------------------------------
--**************************************************************************    
  
create or replace  function Removeworkfromexh (
wkalphaid  wkalphaid,
wknumid  wknumid,
wkcolid  colid, 
exhname  exhname,
exhcolid colid,
rmdate  exhDate 
) returns void as 
$$

DECLARE
islocal         	boolean;
temp_location		 lcname;
temp_locid			 colid;	
temp_tloc			 lcname;
counter 			integer;
temp_sdate          date;
temp_edate			date;
temp_value          DECIMAL(8,2);
lc_min              integer; 
lc_max				integer;
wk_counter  		integer;


begin

		islocal = (select ns_exh_exhislocal from ns_exhibition where 
					ns_exh_exhname = exhname and
					ns_exh_exhcolid = exhcolid);  
		
		--temp_location = (select ns_el_lcname from ns_exhibitionlocation where 
		--				ns_el_exhname = exhname and
		--				ns_el_exhcolid = exhcolid);
/*
		if(islocal = 'f')then
			exit;
			return;
		end if;	
*/			
		
		


		temp_locid = (select distinct ns_el_lccolid from ns_exhibitionlocation where 
						ns_el_exhname = exhname and
						ns_el_exhcolid = exhcolid);
		temp_edate = (select ns_we_wedate_end from ns_workexhibition where ns_we_wkalphaid = wkalphaid and 
 						ns_we_wknumid = wknumid and ns_we_wkcolid = wkcolid and ns_we_exhname = exhname and ns_we_exhcolid = exhcolid);



		
		lc_min = (select sum(ns_lc_capacity_min) from ns_location 
						where ns_lc_lcname in( select ns_el_lcname from ns_exhibitionlocation where 
						ns_el_exhname = exhname and
						ns_el_exhcolid = exhcolid) and
							  ns_lc_lccolid = temp_locid);
						 
		wk_counter = (select ns_exh_exhnumofworks from ns_exhibition where 
								ns_exh_exhname = exhname and
								ns_exh_exhcolid = exhcolid);
		if (temp_edate <= rmdate )then
				raise EXCEPTION 'The remove date is later than the end date of exhibition, remove failed';	
				exit;
		end if;


		if (islocal = 't' and wk_counter <= lc_min)then
				raise EXCEPTION 'The exhibition has the min number of works,remove failed';				
				exit;
		end if;

  
	-- update we
		update ns_workexhibition set ns_we_wedate_end = rmdate where ns_we_wkalphaid = wkalphaid and 
 						ns_we_wknumid = wknumid and ns_we_wkcolid = wkcolid and ns_we_exhname = exhname and ns_we_exhcolid = exhcolid;
	
  
return;
end;
  
$$
language plpgsql;


  
--select Assignworktoexh ('DOC','16','JMBC','Jewish life before 1900 (I)','JMBC',NULL,NULL); 
--select Removeworkfromexh('DOC','16','JMBC','Jewish life before 1900 (I)','JMBC','2013-05-10');

-- ****************Movetostorage ****************
----------------------------------------------------------------------------
--**************************************************************************    

create or replace function movetostorage( wl_wkalphaid wkalphaid,
                                          wl_wknumid  wknumid,
                                          wl_wkcolid colid,
                                      
                                          wl_lccolid colid,           
                                          wl_wldate_in wldate,
                                          wl_wltime_in wltime
                                          
                                         
                                                                     ) returns void as 
$$  

begin
        
        insert into ns_worklocation values(wl_wkalphaid,wl_wknumid, wl_wkcolid, 'storage', wl_lccolid, wl_wldate_in, wl_wltime_in, null, null, 'Current');
        
end;
$$
language plpgsql;

--*************************** borrow a work ****************************
----------------------------------------------------------------------------
--**************************************************************************    

create or replace  function borrow (
ns_tra_wkalphaid  wkalphaid,
ns_tra_wknumid  wknumid,
ns_tra_wkcolid  colid,
ns_tra_colid_from colid,
ns_tra_colid_to colid,
ns_tra_wkinsvalue wkinsvalue,
ns_tra_tradate_start tradate,
ns_tra_tradate_end tradate
) returns void as 
$$
DECLARE
temp_value  DECIMAL(8,2);

begin

	insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Borrowed',ns_tra_tradate_start,ns_tra_tradate_end,
				ns_tra_colid_from,ns_tra_colid_to,ns_tra_wkinsvalue);
 	if (ns_tra_colid_to = 'DAM' or ns_tra_colid_to = 'JMBC' or ns_tra_colid_to = 'APM' or ns_tra_colid_to = 'TANK') then
		
		insert into ns_transaction values (ns_tra_wkalphaid,ns_tra_wknumid,ns_tra_wkcolid,'Loan',ns_tra_tradate_start,ns_tra_tradate_end,
				ns_tra_colid_to,ns_tra_colid_from,ns_tra_wkinsvalue);
  		
 	end if;
	temp_value = (select ns_ins_inswkinsvalue from ns_insvalue where ns_ins_inswkalphaid =ns_tra_wkalphaid and 
			ns_ins_inswknumid = ns_tra_wknumid and 
			ns_ins_inswkcolid = ns_tra_wkcolid); 
			

	--IF(temp_value != )

	UPDATE ns_insvalue set ns_ins_insmoddate = ns_tra_tradate_start where 
			ns_ins_inswkalphaid =ns_tra_wkalphaid and 
			ns_ins_inswknumid = ns_tra_wknumid and 
			ns_ins_inswkcolid = ns_tra_wkcolid and 
			ns_ins_inswkinsvalue !=ns_tra_wkinsvalue*1.1;
	

	
return;	
end;


$$
language plpgsql;



--select sale ('AUD','75','JMBC','DAM','JMBC','1000','2013-02-20','2013-02-20');
----------------------------------------------------------------------------
--**************************************************************************    


 
CREATE OR REPLACE FUNCTION AddWork (
	ns_wk_wkAlphaID		wkAlphaID,
	ns_wk_wkNumID		wkNumID,
	ns_wk_wkColID		colID,
	ns_wk_wkName		wkName,
	ns_wk_wkAuthur		wkAuthur,
	ns_wk_wkDate_com	wkDate,
	ns_wk_wkDate_acq	wkDate,
	ns_wk_wkInsValue	wkInsValue,
	ns_wk_wkDesc		wkDesc,
	ns_wk_wkType_region	wkType,
	ns_wk_wkType_period	wkType,
	ns_wk_wkType_artsType	wkType,
	ns_wk_wkType_utility	wkType,
	ns_wk_wkType_weapon	wkType
) returns void as
$$
begin
	INSERT INTO ns_work VALUES(
		ns_wk_wkAlphaID,
		ns_wk_wkNumID,
		ns_wk_wkColID,
		ns_wk_wkName,
		ns_wk_wkAuthur,
		ns_wk_wkDate_com,
		ns_wk_wkDate_acq,
		ns_wk_wkInsValue,
		ns_wk_wkDesc,
		ns_wk_wkType_region,
		ns_wk_wkType_period,
		ns_wk_wkType_artsType,
		ns_wk_wkType_utility,
		ns_wk_wkType_weapon,
		true
	);
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
--------------------------------------------

CREATE OR REPLACE FUNCTION BuildDoor (
	ns_dor_lcName_entrance		lcName,
	ns_dor_lcColID_entrance		colID,
	ns_dor_lcName_exit		lcName
) returns void as
$$
begin
	INSERT INTO ns_door VALUES(
		ns_dor_lcName_entrance,
		ns_dor_lcColID_entrance,
		ns_dor_lcName_exit,
		ns_dor_lcColID_entrance
	);


INSERT INTO ns_door VALUES(
		ns_dor_lcName_exit,
		ns_dor_lcColID_entrance,
		ns_dor_lcName_entrance,
		ns_dor_lcColID_entrance
	);
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
---------------------------------------------


CREATE OR REPLACE FUNCTION ModifyWork (
	new_wk_wkAlphaID	wkAlphaID,
	new_wk_wkNumID		wkNumID,
	new_wk_wkColID		colID,
	new_wk_wkName		wkName,
	new_wk_wkAuthur		wkAuthur,
	new_wk_wkDate_com	wkDate,
	new_wk_wkDate_acq	wkDate,
	new_wk_wkInsValue	wkInsValue,
	new_wk_wkDesc		wkDesc,
	new_wk_wkType_region	wkType,
	new_wk_wkType_period	wkType,
	new_wk_wkType_artsType	wkType,
	new_wk_wkType_utility	wkType,
	new_wk_wkType_weapon	wkType
) returns void as
$$
begin
	IF ((new_wk_wkAlphaID IS NOT NULL) AND (new_wk_wkNumID IS NOT NULL) AND (new_wk_wkColID IS NOT NULL)) THEN
		IF (new_wk_wkName IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkName = new_wk_wkName
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkAuthur IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkAuthur = new_wk_wkAuthur
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkDate_com IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkDate_com = new_wk_wkDate_com
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkDate_acq IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkDate_acq = new_wk_wkDate_acq
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkInsValue IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkInsValue = new_wk_wkInsValue
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
			INSERT INTO ns_insvalue VALUES(new_wk_wkAlphaID, new_wk_wkNumID, new_wk_wkColID, new_wk_wkInsValue, CURRENT_DATE);
		END IF;
		IF (new_wk_wkDesc IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkDesc = new_wk_wkDesc
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkType_region IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkType_region = new_wk_wkType_region
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkType_period IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkType_period = new_wk_wkType_period
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkType_artsType IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkType_artsType = new_wk_wkType_artsType
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkType_utility IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkType_utility = new_wk_wkType_utility
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;
		IF (new_wk_wkType_weapon IS NOT NULL) THEN
			UPDATE	ns_work SET ns_wk_wkType_weapon = new_wk_wkType_weapon
			WHERE	ns_wk_wkAlphaID = new_wk_wkAlphaID AND
				ns_wk_wkNumID = new_wk_wkNumID AND
				ns_wk_wkColID = new_wk_wkColID;
		END IF;

	END IF;
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
-------------------------------------------------

CREATE OR REPLACE FUNCTION AddCollection (
	ns_col_colID		colID,
	ns_col_colName		colName,
	ns_col_colOwner		colOwner,
	ns_col_address		address,
	ns_col_phoneNum		phone,
	ns_col_email		email
) returns void as
$$
begin
	INSERT INTO ns_collection VALUES(
		ns_col_colID,
		ns_col_colName,
		ns_col_colOwner,
		ns_col_address,
		ns_col_phoneNum,
		ns_col_email
	);
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
-------------------------------------------------

/* 
CREATE OR REPLACE FUNCTION CreateLocalLocat (
	new_lc_lcName		lcName,
	new_lc_lcColID		colID,
	new_lc_dimension_length	dimension,
	new_lc_dimension_width	dimension,
	new_lc_dimension_height	dimension,
	new_lc_capacity_min	capacity,
	new_lc_capacity_max	capacity,
	new_lc_constr		int2
) returns void as
$$
declare	new_lc_address	address;
begin
	IF (new_lc_constr > -1 AND new_lc_constr < 1000) THEN
	new_lc_address = (SELECT ns_col_address FROM ns_collection WHERE ns_col_colid = new_lc_lcColID);
	INSERT INTO ns_location VALUES(
		new_lc_lcName,
		new_lc_lcColID,
		new_lc_address,
		true,
		new_lc_dimension_length,
		new_lc_dimension_width,
		new_lc_dimension_height,
		new_lc_capacity_min,
		new_lc_capacity_max
	);
	IF (new_lc_constr > 0) THEN
	INSERT INTO ns_locationstatus VALUES(
		new_lc_lcColID,
		new_lc_lcName,
		CURRENT_DATE,
		(CURRENT_DATE + new_lc_constr),
		'Closed for construction'
	);
	END IF;
	INSERT INTO ns_locationstatus VALUES(
		new_lc_lcColID,
		new_lc_lcName,
		(CURRENT_DATE + new_lc_constr),
		NULL,
		'Available'
	);
	END IF;
        return;
end;
$$
language plpgsql;*/

----------------------------------------------------------------------------
--**************************************************************************    
----------------------------------------------------

CREATE OR REPLACE FUNCTION CreateTravelLocat (
	new_lc_lcName		lcName,
	new_lc_address		Address
) returns void as
$$
begin
	INSERT INTO ns_location VALUES(
		new_lc_lcName,
		'OUT',
		new_lc_address,
		false,
		null,
		null,
		null,
		null,
		null
	);
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
-----------------------------------------------


CREATE OR REPLACE FUNCTION AddLocatStatus (
	new_lcs_lcColID		colID,
	new_lcs_lcname		lcName,
	new_lcs_lcsDate_Start	lcsDate,
	new_lcs_lcsDate_End	lcsDate,
	new_lcs_status		lcsStatus
) returns void as
$$
begin
	IF ((new_lcs_lcsDate_Start > (SELECT ns_lcs_lcsDate_Start FROM ns_locationstatus WHERE
		ns_lcs_lcsdate_end IS NULL AND
		ns_lcs_lcColID = new_lcs_lcColID AND
		ns_lcs_lcname = new_lcs_lcname)) AND

	(new_lcs_status <> (SELECT ns_lcs_status FROM ns_locationstatus WHERE
		ns_lcs_lcsdate_end IS NULL AND
		ns_lcs_lcColID = new_lcs_lcColID AND
		ns_lcs_lcname = new_lcs_lcname)))

	THEN
	UPDATE ns_locationstatus SET ns_lcs_lcsdate_end = new_lcs_lcsDate_Start WHERE
		ns_lcs_lcsdate_end IS NULL AND
		ns_lcs_lcColID = new_lcs_lcColID AND
		ns_lcs_lcname = new_lcs_lcname;
	INSERT INTO ns_locationstatus VALUES(
		new_lcs_lcColID,
		new_lcs_lcname,
		new_lcs_lcsDate_Start,
		new_lcs_lcsDate_End,
		new_lcs_status
	);
	END IF;
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
-----------------------------------------------------

CREATE OR REPLACE FUNCTION AssignLocatToExhib (
	new_el_exhName		ExhName,
	new_el_exhColID		colID,
	new_el_lcName		lcName,
	new_el_lcColID		colID,
	new_el_elDate_start	elDate,
	new_el_elDate_end	elDate,
	new_el_sponsor		elSponsor,
	new_el_secPerson	elSecPerson
) returns void as
$$
declare
	tmp_elDate_start	Date;
	tmp_elDate_end		Date;
	tmp_sepLocat		BOOLEAN;
	tmp_lcname		VARCHAR;
begin
	IF ((NOT EXISTS (SELECT * 
		FROM ns_exhibitionlocation WHERE
		ns_el_exhName = new_el_exhName AND
		ns_el_exhColID = new_el_exhColID AND
		ns_el_lcName = new_el_lcName AND
		ns_el_lcColID = new_el_lcColID)) OR

		(new_el_elDate_start > (SELECT ns_el_elDate_end
		FROM ns_exhibitionlocation WHERE
		ns_el_exhName = new_el_exhName AND
		ns_el_exhColID = new_el_exhColID AND
		ns_el_lcName = new_el_lcName AND
		ns_el_lcColID = new_el_lcColID)) OR

		(new_el_elDate_end < (SELECT ns_el_elDate_start
		FROM ns_exhibitionlocation WHERE
		ns_el_exhName = new_el_exhName AND
		ns_el_exhColID = new_el_exhColID AND
		ns_el_lcName = new_el_lcName AND
		ns_el_lcColID = new_el_lcColID))) THEN

	tmp_sepLocat = TRUE;
	IF EXISTS (SELECT ns_el_lcName FROM ns_exhibitionlocation WHERE ns_el_exhname = new_el_exhName AND ns_el_exhcolid = new_el_exhColID) THEN
		FOR tmp_lcname IN SELECT ns_el_lcName FROM ns_exhibitionlocation WHERE ns_el_exhname = new_el_exhName AND ns_el_exhcolid = new_el_exhColID LOOP
		IF EXISTS (SELECT * FROM ns_door WHERE ns_dor_lcName_entrance = new_el_lcName AND ns_dor_lcName_exit = tmp_lcname) THEN
			tmp_sepLocat = FALSE;
		END IF;
		END LOOP;
	ELSE
		tmp_sepLocat = FALSE;
	END IF;

	IF (tmp_sepLocat = TRUE) THEN
		RAISE NOTICE'Exhibition cannot be held in multiple locations without door connection';
	ELSE

	IF (new_el_elDate_start IS NULL) THEN
		tmp_elDate_start = (
		SELECT	ns_exh_exhDate_start
		FROM	ns_exhibition
		WHERE	ns_exh_exhName = new_el_exhName AND
			ns_exh_exhColID = new_el_exhColID);
	ELSIF (new_el_elDate_start > (
		SELECT	ns_exh_exhDate_start
		FROM	ns_exhibition
		WHERE	ns_exh_exhName = new_el_exhName AND
			ns_exh_exhColID = new_el_exhColID)) THEN
		tmp_elDate_start = new_el_elDate_start;
	END IF;
	IF (new_el_elDate_end IS NULL) THEN
		tmp_elDate_end = (
		SELECT	ns_exh_exhDate_end
		FROM	ns_exhibition
		WHERE	ns_exh_exhName = new_el_exhName AND
			ns_exh_exhColID = new_el_exhColID);
	ELSIF (new_el_elDate_end < (
		SELECT	ns_exh_exhDate_end
		FROM	ns_exhibition
		WHERE	ns_exh_exhName = new_el_exhName AND
			ns_exh_exhColID = new_el_exhColID)) THEN
		tmp_elDate_end = new_el_elDate_end;
	END IF;


	IF ((tmp_elDate_start IS NOT NULL) AND (tmp_elDate_end IS NOT NULL) AND
	(EXISTS (SELECT * FROM ns_locationstatus WHERE
		ns_lcs_lccolid = new_el_lcColID AND
		ns_lcs_lcname = new_el_lcName AND
		ns_lcs_status = 'Available' AND
		ns_lcs_lcsdate_start < tmp_elDate_start - 3 AND
		((ns_lcs_lcsdate_end is null) or
		(ns_lcs_lcsdate_end > tmp_elDate_end + 3))))) THEN
	INSERT INTO ns_exhibitionlocation VALUES(
		new_el_exhName,
		new_el_exhColID,
		new_el_lcName,
		new_el_lcColID,
		tmp_elDate_start,
		tmp_elDate_end,
		new_el_sponsor,
		new_el_secPerson
	);
	END IF;
	END IF;
	END IF;
        return;
end;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
------------------------------------------------------------


CREATE FUNCTION AddWorkType (
	whichtype		VARCHAR(30),
	ns_wt_typename		typename,
	ns_wt_typedesc		typedesc
) returns void as
$$
begin
	IF (whichtype = 'region' OR whichtype = 'Region' OR whichtype = 'REGION') THEN
		INSERT INTO ns_wtregion VALUES(
			ns_wt_typename,
			ns_wt_typedesc
		);
	ELSIF (whichtype = 'period' OR whichtype = 'Period' OR whichtype = 'PERIOD') THEN
		INSERT INTO ns_wtperiod VALUES(
			ns_wt_typename,
			ns_wt_typedesc
		);
	ELSIF (whichtype = 'arts type' OR whichtype = 'Arts Type' OR whichtype = 'ARTS TYPE') THEN
		INSERT INTO ns_wtartstype VALUES(
			ns_wt_typename,
			ns_wt_typedesc
		);
	ELSIF (whichtype = 'weapon type' OR whichtype = 'Weapon Type' OR whichtype = 'WEAPON TYPE') THEN
		INSERT INTO ns_wtweapontype VALUES(
			ns_wt_typename,
			ns_wt_typedesc
		);
	ELSIF (whichtype = 'weapon utility' OR whichtype = 'Weapon Utility' OR whichtype = 'WEAPON UTILITY') THEN
		INSERT INTO ns_wtweaponutil VALUES(
			ns_wt_typename,
			ns_wt_typedesc
		);
	END IF;
        return;
end;
$$
language plpgsql;



----------------------------------------------------------------------------
--**************************************************************************    


--CREATE LANGUAGE plpgsql;
create or replace function max_minus_numworks(elname exhname,
                                              elcolid colid,
                                              elstartdate eldate
                                                                     ) returns integer as 
$$  
DECLARE
        locationname lcname;
        locationid colid;
        max_capacity capacity;
        exhibitionname exhname;
        exhibitionid colid;
        numberworksinexhi exhnumofworks;      
        availableworks integer;
begin
        
        locationname=(select ns_el_lcname from ns_exhibitionlocation where ns_el_exhname=elname AND ns_el_exhcolid=elcolid AND ns_el_eldate_start= elstartdate);
        locationid=(select ns_el_lccolid from ns_exhibitionlocation where ns_el_exhname=elname AND ns_el_exhcolid=elcolid AND ns_el_eldate_start= elstartdate);
        max_capacity=(select ns_lc_capacity_max from ns_location where ns_lc_lcname=locationname AND ns_lc_lccolid=locationid);
        
        exhibitionname=(select ns_exh_exhname from ns_exhibition where ns_exh_exhname=elname AND ns_exh_exhcolid=elcolid AND ns_exh_exhdate_start=elstartdate);
        exhibitionid=(select ns_exh_exhcolid from ns_exhibition where ns_exh_exhname=elname AND ns_exh_exhcolid=elcolid AND ns_exh_exhdate_start=elstartdate);
        numberworksinexhi=(select ns_exh_exhnumofworks from ns_exhibition where exhibitionname=elname AND exhibitionid=elcolid);
   
        availableworks=max_capacity-numberworksinexhi;
        return availableworks;
        
end;
$$
language plpgsql;


----------------------------------------------------------------------------
--**************************************************************************    

--CREATE LANGUAGE plpgsql;
create or replace function movework(wl_wkalphaid wkalphaid, 
                                    wl_wknumid  wknumid,
                                    wl_wkcolid  colid,
                                    wl_lcname lcname,
                                    wl_lccolid colid,
                                    wl_wldate_in wldate,
                                    wl_wltime_in wltime,
                                    wl_wldate_out wldate,
                                    wl_wltime_out wltime) returns void as 
$$  
DECLARE
         alphaid wkalphaid;
         numberid wknumid;
         collid colid;
         lcname lcname;
         lccolid colid;
         datein wldate;
         timein wltime;
         testmaxdatein wldate;
             
begin
        alphaid = (select distinct ns_wl_wkalphaid from ns_worklocation where ns_wl_wkalphaid=wl_wkalphaid);
        numberid = (select distinct ns_wl_wknumid from ns_worklocation where ns_wl_wknumid=wl_wknumid);
        collid = (select distinct ns_wl_wkcolid from ns_worklocation where ns_wl_wkcolid=wl_wkcolid);
        lcname = (select distinct ns_wl_lcname from ns_worklocation where ns_wl_lcname=wl_lcname);
        lccolid = (select distinct ns_wl_lccolid from ns_worklocation where ns_wl_lccolid=wl_lccolid);
       -- datein = (select max(ns_wl_wldate_in) from ns_worklocation where ns_wl_wkalphaid=wl_wkalphaid AND ns_wl_wknumid=wl_wknumid AND ns_wl_wkcolid=wl_wkcolid 
       --  AND ns_wl_lcname=wl_lcname AND ns_wl_lccolid=wl_lccolid);
       
        --testmaxdatein=(select max(ns_wl_wldate_in) from ns_worklocation where ns_wl_wkalphaid=wl_wkalphaid AND ns_wl_wknumid=wl_wknumid AND ns_wl_wkcolid=wl_wkcolid 
        --- AND ns_wl_lcname=wl_lcname AND ns_wl_lccolid=wl_lccolid);


--update ns_worklocation set ns_wl_wldate_out=wl_wldate_out, ns_wl_wltype='Current' where alphaid= wl_wkalphaid AND numberid=wl_wknumid AND collid=wl_wkcolid AND lcname=wl_lcname AND lccolid=wl_lccolid  
--AND datein=(select max(ns_wl_wldate_in) from ns_worklocation where ns_wl_wkalphaid=wl_wkalphaid AND ns_wl_wknumid=wl_wknumid AND ns_wl_wkcolid=wl_wkcolid AND ns_wl_lcname=wl_lcname AND ns_wl_lccolid=wl_lccolid);
        
 insert into ns_worklocation values(wl_wkalphaid, wl_wknumid, wl_wkcolid, wl_lcname, wl_lccolid, wl_wldate_in,wl_wltime_in, wl_wldate_out,wl_wltime_out, 'Scheduled');

        
        
end;
$$
language plpgsql;
--select movework('AMD', '43', 'DAM', 'storage', 'DAM', '2022-10-10', '00:00:01', '2022-12-25', '00:00:00');

----------------------------------------------------------------------------
--**************************************************************************    


--CREATE LANGUAGE plpgsql;
create or replace function UpdateInsurance(wk_wkalphaid wkalphaid, 
                                           wk_wknumid  wknumid,
                                           wk_wkcolid  colid,
                                           wk_wkinsvalue wkinsvalue) returns void as 
$$  
DECLARE
         alphaid wkalphaid;
         numberid wknumid;
         collid colid;
         insurance wkinsvalue;       
begin
         alphaid = (select ns_wk_wkalphaid from ns_work where ns_wk_wkalphaid=wk_wkalphaid);
         numberid = (select ns_wk_wknumid from ns_work where ns_wk_wknumid=wk_wknumid);
         collid =(select ns_wk_wkcolid from ns_work where ns_wk_wkcolid=wk_wkcolid);
         insurance= (select ns_wk_wkinsvalue from ns_work where ns_wk_wkinsvalue=wk_wkinsvalue);
 
        
         update ns_work set ns_wk_wkinsvalue = wk_wkinsvalue where alphaid=wk_wkalphaid AND numberid=wk_wknumid AND collid=wk_wkcolid AND insurance!=wk_wkinsvalue ;
         insert into ns_insvalue values(wk_wkalphaid, wk_wknumid, wk_wkcolid, wk_wkinsvalue, now());
     
        
end;
$$
language plpgsql;
--select UpdateInsurance('DAM', '12', 'DAM', '601');




----------------------------------------------------------------------------
--**************************************************************************    

-------create exhibition
CREATE or replace FUNCTION BuildExhib (
         ns_exh_exhName		exhName,
        ns_exh_exhColID		colID,
        ns_exh_exhDate_start	exhDate,
        ns_exh_exhDate_end	exhDate


) returns void as

$$

begin

	INSERT INTO ns_exhibition VALUES(

		ns_exh_exhName,

		ns_exh_exhColID,

		ns_exh_exhDate_start,

		ns_exh_exhDate_end

	);

        return;

end;

$$

language plpgsql;

----select BuildExhib('new exhib 3','TANK','2014-11-15','2014-12-05');


----------------------------------------------------------------------------
--**************************************************************************    



-----add location for an exhibition
Create or replace function addExhibtoLoc (
  el_exhName       ExhName   ,
    el_exhColID      colID   ,
    el_lcColID       colID 
) returns void as
$$
Declare
       temp_start  elDate;
       temp_end    elDate;  
       temp_lcname lcname;
       count      integer;
       temp_max integer;
 
begin
       count= (select ns_exh_exhnumofworks FROM ns_exhibition where 
								ns_exh_exhname = el_exhname and
								ns_exh_exhcolid = el_exhcolid);
       temp_max=(select max(ns_lc_capacity_max) from ns_location 
						where ns_lc_lcname != 'storage' and
							  ns_lc_lccolid = el_lcColID);
       if(count>temp_max) then
             raise notice 'The exhibition exceed the max capacity of locations, assignment failed';
             exit;
       end if;
       
      temp_lcname=(select ns_lc_lcname from ns_exhibition,ns_location,ns_locationstatus where el_exhColID=ns_exh_exhcolid 
                    and ns_lc_lccolid = el_lcColID and ns_lc_lcname != 'storage' and el_lcColID=ns_lcs_lccolid and ns_lc_lccolid=ns_lcs_lccolid 
                   and ns_lcs_status='Available' and ns_exh_exhnumofworks<= ns_lc_capacity_max limit 1);

       
       if(temp_lcname is not null) then
         temp_start=(select ns_exh_exhdate_start from ns_exhibition where el_exhName=ns_exh_exhname and el_exhcolID=ns_exh_exhcolid);
         temp_end=(select ns_exh_exhdate_end from ns_exhibition where el_exhName=ns_exh_exhname and el_exhcolID=ns_exh_exhcolid);
        end if;
 
     insert into ns_exhibitionlocation values (el_exhName,el_exhcolID,temp_lcname,el_lcColID,temp_start,temp_end);

return;

End;
$$
language plpgsql;

----------------------------------------------------------------------------
--**************************************************************************    
Create or replace function exhibAfterexhib(  exh_exhName   exhName,
    exh_exhColID    colID,
    exh_exhDescription   exhDesc,
    exh_exhNumOfWorks    exhNumOfWorks,
    exh_exhInsValue  exhInsValue, 
    during integer ) returns void as 
$$
declare
     temp_start    exhDate;
    temp_end  exhDate;
begin 
     temp_start=(select ns_exh_exhdate_end from ns_exhibition where exh_exhName=ns_exh_exhname and exh_exhColID=ns_exh_exhColID);
     temp_start=temp_start+5;
     temp_end=temp_start+during;
     insert into ns_exhibition values (exh_exhName,exh_exhColID,temp_start,temp_end,exh_exhDescription,exh_exhNumOfWorks,exh_exhInsValue );
 return;
end;
$$
language plpgsql;

----test
---select exhibAfterexhib('Test','TANK','just for test','18','200000','25');

