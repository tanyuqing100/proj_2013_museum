/*
all typos are cleaned, can run smoothly
location primiary keys are location name, collection id and location open date
*/

/*
what to do:
new TABLE : transaction, loan_Ins,traval_lc_works

Institution should contain both loan info and borrow info
   
changes:
attributes in works: owed and not owed

traval_lcs


no temp TABLEs

CREATE rule for works_lc TABLE



*/

DROP DOMAIN colID		CASCADE;
DROP DOMAIN colName		CASCADE;
DROP DOMAIN colOwner	CASCADE;
DROP DOMAIN phone		CASCADE;
DROP DOMAIN email		CASCADE;
DROP DOMAIN address		CASCADE;

CREATE DOMAIN colID		VARCHAR(10);
CREATE DOMAIN colName	VARCHAR(100);
CREATE DOMAIN colOwner	VARCHAR(50);
CREATE DOMAIN phone		VARCHAR(30);
CREATE DOMAIN email		VARCHAR(30);
CREATE DOMAIN address	VARCHAR(100);

DROP TABLE ns_collection CASCADE;		--modified
CREATE TABLE ns_collection
(
	ns_col_colID		colID		NOT NULL,
    ns_col_colName		colName		NOT NULL,
	ns_col_colOwner		colOwner,
    ns_col_address		address,
    ns_col_phoneNum		phone,
    ns_col_email		email,
    PRIMARY KEY(ns_col_colID)
);

------------------------------------------------------------
/*

DROP DOMAIN musName		CASCADE;

CREATE DOMAIN musName	VARCHAR(100);

DROP TABLE ns_museum CASCADE;
CREATE TABLE ns_museum
(
--museum id are: APM, DAM, TANK, JMBC
   ns_mus_museumID	MuseumID	NOT NULL,
   ns_mus_musOwner	musOwner,
   ns_mus_musName	musName
		REFERENCES ns_collection(ns_coll_collname)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
   PRIMARY KEY(ns_mus_museumID)
);
*/
------------------------------------------------------------

DROP DOMAIN typename		CASCADE;
DROP DOMAIN typedesc		CASCADE;
CREATE DOMAIN typename		VARCHAR(30);
CREATE DOMAIN typedesc		TEXT;

DROP TABLE ns_wtregion CASCADE;
CREATE TABLE ns_wtregion (
	ns_wtr_typename		typename	NOT NULL,
	ns_wtr_typedesc		typedesc,
	PRIMARY KEY(ns_wtr_typename)
);

DROP TABLE ns_wtperiod CASCADE;
CREATE TABLE ns_wtperiod (
	ns_wtp_typename		typename	NOT NULL,
	ns_wtp_typedesc		typedesc,
	PRIMARY KEY(ns_wtp_typename)
);

DROP TABLE ns_wtartstype CASCADE;
CREATE TABLE ns_wtartstype (
	ns_wtat_typename	typename	NOT NULL,
	ns_wtat_typedesc	typedesc,
	PRIMARY KEY(ns_wtat_typename)
);

DROP TABLE ns_wtweapontype CASCADE;
CREATE TABLE ns_wtweapontype (
	ns_wtwt_typename	typename	NOT NULL,
	ns_wtwt_typedesc	typedesc,
	PRIMARY KEY(ns_wtwt_typename)
);

DROP TABLE ns_wtweaponutil CASCADE;
CREATE TABLE ns_wtweaponutil (
	ns_wtwu_typename	typename	NOT NULL,
	ns_wtwu_typedesc	typedesc,
	PRIMARY KEY(ns_wtwu_typename)
);

INSERT INTO ns_wtregion VALUES('Africa', NULL);
INSERT INTO ns_wtregion VALUES('Asian', NULL);
INSERT INTO ns_wtregion VALUES('South America', NULL);
INSERT INTO ns_wtregion VALUES('American India', NULL);
INSERT INTO ns_wtregion VALUES('United States', NULL);
INSERT INTO ns_wtregion VALUES('Canada', NULL);
INSERT INTO ns_wtregion VALUES('Europe', NULL);
INSERT INTO ns_wtperiod VALUES('Pre-confederation of Canada', NULL);
INSERT INTO ns_wtperiod VALUES('Early Confederation', NULL);
INSERT INTO ns_wtperiod VALUES('World War I', NULL);
INSERT INTO ns_wtperiod VALUES('Inter War', NULL);
INSERT INTO ns_wtperiod VALUES('World War II', NULL);
INSERT INTO ns_wtperiod VALUES('Cold War', NULL);
INSERT INTO ns_wtperiod VALUES('Post Cold War', NULL);
INSERT INTO ns_wtperiod VALUES('21th Century', NULL);
INSERT INTO ns_wtartstype VALUES('Acrylic Painting', NULL);
INSERT INTO ns_wtartstype VALUES('Calligraphy', NULL);
INSERT INTO ns_wtartstype VALUES('Ceramics', NULL);
INSERT INTO ns_wtartstype VALUES('Gouache Painting', NULL);
INSERT INTO ns_wtartstype VALUES('Lithograph', NULL);
INSERT INTO ns_wtartstype VALUES('Lacquer Painting', NULL);
INSERT INTO ns_wtartstype VALUES('Mask', NULL);
INSERT INTO ns_wtartstype VALUES('Metal Sculpture', NULL);
INSERT INTO ns_wtartstype VALUES('Metalworks', NULL);
INSERT INTO ns_wtartstype VALUES('Photograph', NULL);
INSERT INTO ns_wtartstype VALUES('Stone Sculpture', NULL);
INSERT INTO ns_wtartstype VALUES('Oil Painting', NULL);
INSERT INTO ns_wtartstype VALUES('Textile', NULL);
INSERT INTO ns_wtartstype VALUES('Watercolor Painting', NULL);
INSERT INTO ns_wtartstype VALUES('Wood Sculpture', NULL);
INSERT INTO ns_wtartstype VALUES('Document', NULL);
INSERT INTO ns_wtartstype VALUES('Artefact', NULL);
INSERT INTO ns_wtartstype VALUES('Audio', NULL);
INSERT INTO ns_wtartstype VALUES('Painting', NULL);
INSERT INTO ns_wtweaponutil VALUES('Heavy', NULL);
INSERT INTO ns_wtweaponutil VALUES('Light', NULL);
INSERT INTO ns_wtweaponutil VALUES('Reconnaissance', NULL);
INSERT INTO ns_wtweaponutil VALUES('Command', NULL);
INSERT INTO ns_wtweaponutil VALUES('Demolition', NULL);
INSERT INTO ns_wtweaponutil VALUES('Medium', NULL);
INSERT INTO ns_wtweaponutil VALUES('Mine Clearing', NULL);
INSERT INTO ns_wtweaponutil VALUES('Crowd Control', NULL);
INSERT INTO ns_wtweaponutil VALUES('Main Battle', NULL);
INSERT INTO ns_wtweaponutil VALUES('Transport', NULL);
INSERT INTO ns_wtweaponutil VALUES('Tank Killer', NULL);
INSERT INTO ns_wtweaponutil VALUES('Training', NULL);
INSERT INTO ns_wtweaponutil VALUES('Supply', NULL);
INSERT INTO ns_wtweapontype VALUES('Depth Bomb', NULL);
INSERT INTO ns_wtweapontype VALUES('MultipurposeGun', NULL);
INSERT INTO ns_wtweapontype VALUES('Heavy Bomb', NULL);
INSERT INTO ns_wtweapontype VALUES('Guided Bomb', NULL);
INSERT INTO ns_wtweapontype VALUES('Cannon', NULL);
INSERT INTO ns_wtweapontype VALUES('Missile', NULL);
INSERT INTO ns_wtweapontype VALUES('Machine gun', NULL);
INSERT INTO ns_wtweapontype VALUES('Rocket', NULL);
INSERT INTO ns_wtweapontype VALUES('Retarder bomb', NULL);
INSERT INTO ns_wtweapontype VALUES('Air to Air missile', NULL);

------------------------------------------------------------
DROP DOMAIN wkAlphaID		CASCADE;
DROP DOMAIN wkNumID			CASCADE;
DROP DOMAIN wkName			CASCADE;
DROP DOMAIN wkAuthur		CASCADE;
DROP DOMAIN wkDate			CASCADE;
DROP DOMAIN wkInsValue		CASCADE;
DROP DOMAIN wkDesc			CASCADE;
DROP DOMAIN wkType			CASCADE;
DROP DOMAIN wkisowned		CASCADE;	--modified

CREATE DOMAIN wkAlphaID		VARCHAR(4);
CREATE DOMAIN wkNumID		SMALLINT		CHECK (VALUE > 0);
CREATE DOMAIN wkName		VARCHAR(100);
CREATE DOMAIN wkAuthur		VARCHAR(100);
CREATE DOMAIN wkDate		DATE;
CREATE DOMAIN wkInsValue	DECIMAL(8,2)	CHECK (VALUE >= 0);
CREATE DOMAIN wkDesc		TEXT;
CREATE DOMAIN wkType		VARCHAR(100);
CREATE DOMAIN wkisowned 	 boolean;	--modified
/*
DROP tABLE ns_workType CASCADE;
create table ns_workType
(
	ns_wt_wkType_region		wkType not null,
	ns_wt_wkType_period		wkType not null,
	ns_wt_wkType_artsType	wkType not null,
	ns_wt_wkType_utility	wkType not null,
	ns_wt_wkType_weapon		wkType not null

);
*/



DROP TABLE ns_work CASCADE;
CREATE TABLE ns_work (
	ns_wk_wkAlphaID		wkAlphaID		NOT NULL,
	ns_wk_wkNumID		wkNumID			NOT NULL,
	ns_wk_wkColID		colID			NOT NULL
	REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	ns_wk_wkName			wkName,
	ns_wk_wkAuthur			wkAuthur,
	ns_wk_wkDate_com		wkDate,
	ns_wk_wkDate_acq		wkDate 	DEFAULT '1900-01-01',
	ns_wk_wkInsValue		wkInsValue,
	ns_wk_wkDesc			wkDesc,
	ns_wk_wkType_region		wkType
		REFERENCES ns_wtregion(ns_wtr_typename),
	ns_wk_wkType_period		wkType
		REFERENCES ns_wtperiod(ns_wtp_typename),
	ns_wk_wkType_artsType		wkType
		REFERENCES ns_wtartstype(ns_wtat_typename),
	ns_wk_wkType_utility		wkType
		REFERENCES ns_wtweaponutil(ns_wtwu_typename),
	ns_wk_wkType_weapon		wkType
		REFERENCES ns_wtweapontype(ns_wtwt_typename),
	ns_wk_wkisowned		    wkisowned,
	PRIMARY KEY(ns_wk_wkAlphaID, ns_wk_wkNumID, ns_wk_wkColID),
	CHECK (ns_wk_wkDate_com <= ns_wk_wkDate_acq)
);

-- insert into ns_workType()

------------------------------------------------------------

DROP DOMAIN wosOwner		CASCADE;	--modified
DROP DOMAIN wosDate			CASCADE;

CREATE DOMAIN wosOwner		VARCHAR(100);	--modified
CREATE DOMAIN wosDate		DATE			CHECK (VALUE >= '1900-01-1');

DROP TABLE ns_workownership CASCADE;
CREATE TABLE ns_workownership
(
	ns_wos_wkAlphaID	wkAlphaID		NOT NULL,
	ns_wos_wkNumID		wkNumID			NOT NULL,
	ns_wos_wkColID		ColID			NOT NULL
	REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	ns_wos_wosDate_mod	 wosDate			NOT NULL,
	ns_wos_wosOwner      wosOwner
	REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	-- can be null if the work is stolen
	PRIMARY KEY(ns_wos_wkAlphaID, ns_wos_wkNumID, ns_wos_wkColID, ns_wos_wosDate_mod),
	FOREIGN KEY(ns_wos_wkAlphaID, ns_wos_wkNumID, ns_wos_wkColID)
		REFERENCES ns_work(ns_wk_wkAlphaID, ns_wk_wkNumID, ns_wk_wkColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

------------------------------------------------------------

DROP DOMAIN exhName			CASCADE;
DROP DOMAIN exhDate			CASCADE;
DROP DOMAIN exhDesc			CASCADE;
DROP DOMAIN exhNumOfWorks	CASCADE;
DROP DOMAIN exhInsValue		CASCADE;
DROP DOMAIN exhisLocal		    CASCADE;

CREATE DOMAIN exhName		VARCHAR(100);
CREATE DOMAIN exhDate		DATE			CHECK (VALUE >= '1900-01-1');
CREATE DOMAIN exhDesc		Text;
CREATE DOMAIN exhNumOfWorks	SMALLINT		CHECK(VALUE >=0) ;
CREATE DOMAIN exhInsValue	DECIMAL(10,2)	CHECK(VALUE >=0) ;
CREATE DOMAIN exhislocal	boolean;	--new

DROP TABLE ns_exhibition CASCADE;
CREATE TABLE ns_exhibition
(
    ns_exh_exhName		exhName		NOT NULL,
	ns_exh_exhColID		colID		NOT NULL
		REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	ns_exh_exhDate_start	exhDate,
	ns_exh_exhDate_end		exhDate,
	ns_exh_exhDescription	exhDesc,
	ns_exh_exhNumOfWorks	exhNumOfWorks,
	ns_exh_exhInsValue		exhInsValue,
	ns_exh_exhislocal		exhislocal default true,
	PRIMARY KEY(ns_exh_exhName, ns_exh_exhColID),
	CHECK (ns_exh_exhDate_start <= ns_exh_exhDate_end),
	CONSTRAINT chk_COLID CHECK (ns_exh_exhColID IN ('DAM', 'JMBC', 'APM', 'TANK'))
);

------------------------------------------------------------

DROP DOMAIN lcName		CASCADE;
DROP DOMAIN dimension	CASCADE;
DROP DOMAIN capacity	CASCADE;
DROP DOMAIN lcDate		CASCADE;	--new
DROP DOMAIN lcIsLocal	CASCADE;	--new

CREATE DOMAIN lcName	VARCHAR(50);
CREATE DOMAIN dimension	SMALLINT;
CREATE DOMAIN capacity	SMALLINT;
CREATE DOMAIN lcDate	DATE		CHECK (VALUE >= '1900-01-1');	--new
CREATE DOMAIN lcIsLocal	BOOLEAN;
									--new

DROP TABLE ns_location CASCADE;
CREATE TABLE ns_location
(
    ns_lc_lcName			lcName		NOT NULL,
	ns_lc_lcColID			colID		NOT NULL
		REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	ns_lc_address			Address,
	ns_lc_lcIsLocal			lcIsLocal    default 'true',
	--if the location is in local museum, otherwise a temperal location for travel exhibition

	ns_lc_dimension_length	dimension,
	ns_lc_dimension_width	dimension,
	ns_lc_dimension_height	dimension,
	ns_lc_capacity_min		capacity,
	NS_lc_capacity_max		capacity,
	PRIMARY KEY(ns_lc_lcName, ns_lc_lcColID),
	--how about ns_lc_lcDate_open?
	
	CONSTRAINT chk_COLID CHECK (ns_lc_lcColID IN ('OUT','DAM', 'JMBC', 'APM', 'TANK'))
);

------------------------------------------------------------

DROP DOMAIN lcsStatus	CASCADE;
DROP DOMAIN lcsDate		CASCADE;


CREATE DOMAIN lcsStatus	VARCHAR(50) check (value in ('Closed for changing exhibition','Closed for construction','On exhibition', 'Available')); 
CREATE DOMAIN lcsDate	DATE CHECK (VALUE >= '1900-01-1');

drop TABLE ns_locationStatus cascade;
CREATE TABLE ns_locationStatus
(
	ns_lcs_lcColID			colID	 NOT NULL,
	ns_lcs_lcname			lcName   NOT NULL,
	ns_lcs_lcsDate_Start	lcsDate  NOT NULL,
	ns_lcs_lcsDate_End		lcsDate,
    ns_lcs_status			lcsStatus,
    PRIMARY KEY(ns_lcs_lcsDate_Start,ns_lcs_lcname,ns_lcs_lcColID),
	FOREIGN KEY(ns_lcs_lcName, ns_lcs_lcColID)
	REFERENCES ns_location(ns_lc_lcName, ns_lc_lcColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);	




------------------------------------------------------------

DROP TABLE ns_door CASCADE;
CREATE TABLE ns_door
(
    ns_dor_lcName_entrance		lcName		NOT NULL,
	ns_dor_lcColID_entrance		colID		NOT NULL,
	ns_dor_lcName_exit			lcName		NOT NULL,
	ns_dor_lcColID_exit			colID		NOT NULL,
	PRIMARY KEY(ns_dor_lcName_entrance, ns_dor_lcColID_entrance, 
		ns_dor_lcName_exit, ns_dor_lcColID_exit),

	FOREIGN KEY(ns_dor_lcName_entrance, ns_dor_lcColID_entrance)
	REFERENCES ns_location(ns_lc_lcName, ns_lc_lcColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(ns_dor_lcName_exit, ns_dor_lcColID_exit)
	REFERENCES ns_location(ns_lc_lcName, ns_lc_lcColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT chk_DORLCNAME CHECK (ns_dor_lcName_entrance <> ns_dor_lcName_exit),
	CONSTRAINT chk_DORCOLID CHECK (ns_dor_lcColID_entrance = ns_dor_lcColID_exit)
);

------------------------------------------------------------

DROP DOMAIN wlDate			CASCADE;
DROP DOMAIN wlTime			CASCADE;
DROP DOMAIN wlType			CASCADE;

CREATE DOMAIN wlDate		DATE	CHECK (VALUE >= '1900-01-1');
CREATE DOMAIN wlTime		TIME;
CREATE DOMAIN wlType		VARCHAR(20)	check (value in ('Current', 'Scheduled','Canceled'));

DROP TABLE ns_workLocation CASCADE;
CREATE TABLE ns_workLocation
(
    ns_wl_wkAlphaID		wkAlphaID	NOT NULL,
    ns_wl_wkNumID		wkNumID		NOT NULL,
    ns_wl_wkColID		colID		NOT NULL,
    ns_wl_lcName		lcName		NOT NULL,
	ns_wl_lcColID		colID		NOT NULL,
	--ns_wl_wkColID and ns_wl_lcColID can be different if the work is not in the owner museum
	
    ns_wl_wlDate_in		wlDate		NOT NULL,
    ns_wl_wlTime_in		wlTime		NOT NULL,
    ns_wl_wlDate_out	wlDate,
    ns_wl_wlTime_out	wlTime,
	ns_wl_type	wltype,
    PRIMARY KEY(ns_wl_wkAlphaID, ns_wl_wkNumID, ns_wl_wkColID,
		ns_wl_lcName, ns_wl_lcColID,ns_wl_wlDate_in, ns_wl_wlTime_in,ns_wl_type),
    FOREIGN KEY(ns_wl_wkAlphaID, ns_wl_wkNumID, ns_wl_wkColID)
	REFERENCES ns_work(ns_wk_wkAlphaID, ns_wk_wkNumID, ns_wk_wkColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
    FOREIGN KEY(ns_wl_lcName, ns_wl_lcColID)
	REFERENCES ns_location(ns_lc_lcName, ns_lc_lcColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CHECK ((ns_wl_wlDate_in < ns_wl_wlDate_out)
	OR ((ns_wl_wlDate_in = ns_wl_wlDate_out) AND
	(ns_wl_wlTime_in <= ns_wl_wlTime_out)))
);

------------------------------------------------------------

DROP DOMAIN elDate			CASCADE;
DROP DOMAIN elSponsor		CASCADE;	--new
DROP DOMAIN elSecPerson		CASCADE;	--new

CREATE DOMAIN elDate		DATE	CHECK (VALUE >= '1900-01-1');
CREATE DOMAIN elSponsor		VARCHAR(100);	--new
CREATE DOMAIN elSecPerson	VARCHAR(100);	--new

DROP TABLE ns_exhibitionLocation CASCADE;
CREATE TABLE ns_exhibitionLocation
(
    ns_el_exhName		ExhName		NOT NULL,
	ns_el_exhColID		colID		NOT NULL,
    ns_el_lcName		lcName		NOT NULL,
    ns_el_lcColID		colID		NOT NULL,
	--ns_el_exhColID and ns_el_lcColID can be different if the exhibition is held on travelling
    ns_el_elDate_start	elDate		NOT NULL,
    ns_el_elDate_end	elDate,
	ns_el_sponsor		elSponsor,
	ns_el_secPerson		elSecPerson,
    PRIMARY KEY(ns_el_exhName, ns_el_exhColID, ns_el_lcName,  ns_el_lcColID, ns_el_elDate_start), 
    FOREIGN KEY(ns_el_exhName, ns_el_exhColID)
	REFERENCES ns_exhibition(ns_exh_exhName, ns_exh_exhColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
    FOREIGN KEY(ns_el_lcName, ns_el_lcColID)
	REFERENCES ns_location(ns_lc_lcName, ns_lc_lcColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CHECK (ns_el_elDate_start <= ns_el_elDate_end)
); 

------------------------------------------------------------

DROP DOMAIN weDate			CASCADE;
CREATE DOMAIN weDate		DATE	CHECK (VALUE >= '1900-01-1');
DROP TABLE ns_workExhibition CASCADE;
CREATE TABLE ns_workExhibition
(
	ns_we_wkAlphaID 	wkAlphaID	NOT NULL,
	ns_we_wkNumID 		wkNumID		NOT NULL,
	ns_we_wkColID		colID		NOT NULL,
	ns_we_exhName 		exhName		NOT NULL,
	ns_we_exhColID		colID		NOT NULL,
	--not sure if ns_we_wkColID and ns_we_wkColID can be different
	
	ns_we_weDate_start	weDate		NOT NULL,
	ns_we_weDate_end 	weDate,
	PRIMARY KEY(ns_we_wkalphaID, ns_we_wkNumID, ns_we_wkColID,
		ns_we_exhName, ns_we_exhColID, ns_we_weDate_start),
	FOREIGN KEY(ns_we_exhName, ns_we_exhColID)
	REFERENCES ns_exhibition(ns_exh_exhName, ns_exh_exhColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(ns_we_wkAlphaID, ns_we_wkNumID, ns_we_wkColID)
	REFERENCES ns_work(ns_wk_wkAlphaID, ns_wk_wkNumID, ns_wk_wkColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CHECK (ns_we_weDate_start <= ns_we_weDate_end)
);

------------------------------------------------------------

DROP DOMAIN traDate		CASCADE;
DROP DOMAIN traType		CASCADE;
DROP DOMAIN tradetail	cascade;
drop domain traDes cascade;
CREATE DOMAIN traDate	DATE		CHECK (VALUE >= '1900-01-1');
CREATE DOMAIN traType	VARCHAR(50);
CREATE DOMAIN tradetail	text;
create domain traDes text;

DROP TABLE ns_transType CASCADE;
CREATE TABLE ns_transType(
	ns_tt_traType			traType		NOT NULL,
	ns_tt_traDes			traDes,
	PRIMARY KEY(ns_tt_traType)
);

insert into ns_transType values ('Purchased',null),('Sale',null),( 'Loan',null),('Borrowed',null),( 'Donate',null),( 'Stolen',null),('Repair',null),('Special',null),('Potential Borrowed',null);



DROP TABLE ns_transaction CASCADE;
CREATE TABLE ns_transaction
( 
	ns_tra_wkAlphaID		wkAlphaID	NOT NULL,
	ns_tra_wkNumID			wkNumID		NOT NULL,
	ns_tra_wkColID			colID		NOT NULL,
	ns_tra_traType			traType		NOT NULL
	REFERENCES ns_transType(ns_tt_traType)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	ns_tra_traDate_start	traDate		NOT NULL,
	ns_tra_traDate_end		traDate,
	--can be null if the work is sold out
	ns_tra_colID_from		colID
		REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	ns_tra_colID_to			colID
		REFERENCES ns_collection(ns_col_colID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	ns_tra_wkInsValue 	wkInsValue,
	ns_tra_traDetail 	traDetail,
	PRIMARY KEY(ns_tra_wkAlphaID, ns_tra_wkNumID, ns_tra_wkColID, ns_tra_traType, ns_tra_traDate_start),
	FOREIGN KEY(ns_tra_wkAlphaID, ns_tra_wkNumID, ns_tra_wkColID)
	REFERENCES ns_work(ns_wk_wkAlphaID, ns_wk_wkNumID, ns_wk_wkColID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CHECK (ns_tra_traDate_start <= ns_tra_traDate_end)
);

drop table ns_insvalue CASCADE;

create table ns_insvalue
(
   ns_ins_inswkAlphaID wkAlphaID,
   ns_ins_inswkNumID wkNumID,
   ns_ins_inswkColID colID,
   ns_ins_inswkInsValue wkInsValue,
   ns_ins_insModDate wkDate,
   primary key(ns_ins_inswkAlphaID, ns_ins_inswkNumID, ns_ins_inswkColID, ns_ins_insModDate), 
   foreign key(ns_ins_inswkAlphaID, ns_ins_inswkNumID, ns_ins_inswkColID) references 
   ns_work(ns_wk_wkAlphaID, ns_wk_wkNumID, ns_wk_wkColID)
   ON UPDATE CASCADE
   ON DELETE CASCADE

);
