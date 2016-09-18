-- ADD WORKS

delete from ns_works where ns_wk_wkAlphaID = 'TEST';  

select AddWork('TEST','666','JMBC','This is not a work', 'YUQING TAN', '2013-11-11', '2013-11-30', '1111', 'This is not a work', null, null, null, null, null);
select AddWork('TEST','555','DAM','This is not a work', 'jIAJING', '2013-11-11', '2013-11-30', '1111', 'This is not a work', null, null, null, null, null);
select AddWork('TEST','444','TANK','This is not a work', 'WUYOU', '2013-11-11', '2013-11-30', '1111', 'This is not a work', null, null, null, null, null);
select AddWork('TEST','777','APM','This is not a work', 'ZHICHAO', '2013-11-11', '2013-11-30', '1111', 'This is not a work', null, null, null, null, null);


--


select CreateLocalLocat('TEST LOC1', 'JMBC', '20', '50', '5', '1', '2', '0');
select CreateLocalLocat('TEST LOC2', 'JMBC', '20', '50', '5', '1', '2', '0');

delete from ns_door where ns_dor_lcname_entrance = 'TEST LOC1';

select BuildExhib('TEST EXH 1','JMBC','2013-12-01','2014-01-01');
select addExhibtoLoc('TEST EXH 1','JMBC','JMBC');




CREATE LANGUAGE plpgsql;
create or replace function movetostorage( wl_wkalphaid wkalphaid,
                                          wl_wknumid  wknumid,
                                          wl_wkcolid colid,
                                      
                                          wl_lccolid colid,           
                                          wl_wldate_in wldate,
                                          wl_wltime_in wltime,
                                          
                                          wl_type wltype
                                                                     ) returns void as 
$$  

begin
        
        insert into ns_worklocation values(wl_wkalphaid,wl_wknumid, wl_wkcolid, 'storage', wl_lccolid, wl_wldate_in, wl_wltime_in, null, null, wl_type);
        
end;
$$
language plpgsql;



create or replace function movetostorage( wl_wkalphaid wkalphaid,
                                          wl_wknumid  wknumid,
                                          wl_wkcolid colid,
                                      
                                          wl_lccolid colid,           
                                          wl_wldate_in wldate,
                                          wl_wltime_in wltime,
                                          
                                         
                                                                     ) returns void as 
$$  

begin
        
        insert into ns_worklocation values(wl_wkalphaid,wl_wknumid, wl_wkcolid, 'storage', wl_lccolid, wl_wldate_in, wl_wltime_in, null, null, 'Current');
        
end;
$$
language plpgsql;


