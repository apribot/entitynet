
create schema blue;
create schema master;

create table blue.company (
  companyid bigserial primary key,
  companyname text,
  address text
);

create table blue.companyinstance (
  companyinstanceid bigserial primary key,
  companyname text,
  address text
);

create table blue.companymap (
  companyid bigint references blue.company(companyid),
  companyinstanceid bigint references blue.companyinstance(companyinstanceid)
);



create table master.property (
  propertyid bigserial primary key,
  propertyname text,
  address text
);

create table master.propertyinstance (
  propertyinstanceid bigserial primary key,
  propertyname text,
  address text
);

create table master.propertymap (
  propertyid bigint references master.property(propertyid),
  propertyinstanceid bigint references master.propertyinstance(propertyinstanceid)
);


create table blue.companypropertyinstancemap (
  propertyinstanceid bigint references master.propertyinstance(propertyinstanceid),
  companyinstanceid bigint references blue.companyinstance(companyinstanceid)
);


insert into master.property (propertyname) select 'mp a';
insert into blue.company (companyname) select 'mc a';
insert into master.propertyinstance (propertyname) select 'pi a';
insert into blue.companyinstance (companyname) select 'ci a';

insert into master.propertymap (propertyid, propertyinstanceid) select 1,1;

insert into blue.companymap (companyid, companyinstanceid) select 1,1;

insert into blue.companypropertyinstancemap (companyinstanceid, propertyinstanceid) select 1,1;

create view master.allofit as
select 
	c.companyid,
	ci.companyinstanceid,
	pi.propertyinstanceid,
	p.propertyid

from
  blue.company c 
  inner join blue.companymap cm on cm.companyid = c.companyid
  inner join blue.companyinstance ci on ci.companyinstanceid = cm.companyinstanceid
  inner join blue.companypropertyinstancemap cpim on cpim.companyinstanceid = ci.companyinstanceid
  inner join master.propertyinstance pi on pi.propertyinstanceid = cpim.propertyinstanceid
  inner join master.propertymap pm on pm.propertyinstanceid = pi.propertyinstanceid
  inner join master.property p on p.propertyid = pm.propertyid;


create view master.propertycompany as 
select
  pm.propertyid,
  cm.companyid
from 
  blue.companymap cm 
  inner join blue.companypropertyinstancemap cpim on cpim.companyinstanceid = cm.companyinstanceid
  inner join master.propertymap pm on pm.propertyinstanceid = cpim.propertyinstanceid
;


create view blue.companything as
select 
	companyid
from blue.company;


create view blue.combi1 as 
select 
  pc.propertyid,
  pc.companyid
from 
  master.propertycompany pc
  inner join master.allofit aoi on aoi.propertyid = pc.propertyid;



create view blue.combi2 as 
select
  pc.propertyid,
  pc.companyid
from 
  master.propertycompany pc 
  INNER JOIN blue.combi1 c1 on c1.companyid = pc.companyid;


