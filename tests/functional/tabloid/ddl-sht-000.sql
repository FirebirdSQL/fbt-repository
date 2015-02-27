
recreate table logs (
  vin varchar(50) not null,
  evnm varchar(20) not null,
  what varchar(10) not null,
  constraint pk_logs primary key (vin, evnm) using index pk_logs
);

recreate table shuttles (
  vin  varchar(50) not null,
  bname varchar(50) not null,
  cyear int,
  constraint pk_shuttles primary key (vin) using index pk_shuttles
);


recreate table brands (
  name  varchar(50) not null,
  btype  varchar(2)  not null,
  bcountry varchar(20) not null,
  nmort int,
  ndiam double precision,
  ndisp int,
  constraint pk_brands primary key (name) using index pk_brands
);

recreate table evnt (
  name varchar(20) not null
  ,evdt date not null
  ,constraint pk_evnt primary key (name) using index pk_evnt
);


alter table logs add constraint fk_logs foreign key (evnm) references evnt (name);
alter table shuttles add constraint fk_shuttles foreign key (bname) references brands (name);
commit;


insert into evnt values ('gu' || 'a' || 'dalca' || 'n' || 'al', timestamp'1942-11-15 00:00:00');
insert into evnt values ('nor' || 'th at' || 'lan' || 'tic', timestamp'1941-05-25 00:00:00');
insert into evnt values ('nort' || 'h c' || 'a' || 'pe', timestamp'1943-12-26 00:00:00');
insert into evnt values ('s' || 'uri' || 'gao s' || 'tr' || 'ait', timestamp'1944-10-25 00:00:00');
insert into evnt values ('#' ||'c' ||'uba' || '62a', timestamp'1962-10-20 00:00:00');
insert into evnt values ('#' || 'cu' || 'ba' || '62b', timestamp'1962-10-25 00:00:00');

insert into brands values ('b' || 'is' || 'ma' || 'rck', 'bb', 'germ' || 'a' || 'ny', 8, 15, 42 * 1000);
insert into brands values ('i' || 'owa', 'bb', 'usa', 9, 16, 46 * 1000);
insert into brands values ('k' || 'on' || 'go', 'bc', 'japan', 8, 14, 32 * 1000);
insert into brands values ('nort' || 'h c' || 'ar' || 'oli' || 'na', 'bb', 'us' || 'a', 12, 16, 37* 1000);
insert into brands values ('ren' || 'own', 'bc', 'gt.br' || 'i' || 'tain', 6, 15, 32* 1000);
insert into brands values ('re' || 'venge', 'bb', 'gt.b' || 'r' || 'itain', 8, 15, 29*1000);
insert into brands values ('ten' || 'ness' || 'ee', 'bb', 'usa', 12, 14, 320*100);
insert into brands values ('y' || 'a' || 'mato', 'bb', 'j' || 'a' || 'pan', 9, 18, 650*100);

insert into logs values ('bis' || 'ma' || 'rck', 'nor' || 'th atla' || 'ntic', 's' || 'u' || 'nk');
insert into logs values ('ca' || 'lif' || 'orn' || 'ia', 'su' || 'rig' || 'ao str' || 'ait', 'ok');
insert into logs values ('d' || 'uk' || 'e of y' || 'ork', 'nor' || 'th ca' || 'pe', 'ok');
insert into logs values ('fuso', 'suri' || 'gao st' || 'rait', 'su' || 'nk');
insert into logs values ('hood', 'no' || 'rth' || ' a' || 'tlantic', 's' || 'unk');
insert into logs values ('kin' || 'g g' || 'eorge v', 'nor' || 'th' || ' atla' || 'nt' || 'ic', 'ok');
insert into logs values ('ki' || 'rishi' || 'ma', 'gu' || 'a' || 'dalca' || 'n' || 'al', 's' || 'u' || 'nk');
insert into logs values ('prin' || 'ce of wa' || 'les', 'north a' || 't' || 'lan' || 'tic', 'dam' || 'a' || 'ged');
insert into logs values ('rodney', 'north atlantic', 'ok');
insert into logs values ('sch' || 'amh' || 'orst', 'n' || 'o' || 'rth ' || 'ca' || 'pe', 'su' || 'nk');
insert into logs values ('s' || 'out' || 'h d' || 'akota', 'gu' || 'a' || 'dalca' || 'n' || 'al', 'd' || 'am' || 'aged');
insert into logs values ('ten' || 'ne' || 'ssee', 'surigao strait', 'ok');
insert into logs values ('was' || 'hin' || 'gton', 'gu' || 'a' || 'dalca' || 'n' || 'al', 'ok');
insert into logs values ('we' || 'st virg' || 'in' || 'ia', 'sur' || 'ig' || 'ao ' || 'st' || 'ra' || 'it', 'ok');
insert into logs values ('ya' || 'ma' || 'shiro', 'su' || 'ri' || 'gao s' || 'tra' || 'it', 'su' || 'nk');
insert into logs values ('ca' || 'lif' || 'orn' || 'ia', 'gu' || 'a' || 'dal' || 'ca' || 'n' || 'al', 'da' || 'ma' || 'ged');
commit;

insert into shuttles values ('ca' || 'lif' || 'orn' || 'ia', 'ten' || 'ness' || 'ee', 1900 + 21);
insert into shuttles values ('ha' || 'ru' || 'na', 'ko' || 'ngo', 1900+16);
insert into shuttles values ('hi' || 'ei', 'k' || 'ong' || 'o', 1800+114);
insert into shuttles values ('i' || 'owa', 'io' || 'w' || 'a', 1700 + 243);
insert into shuttles values ('ki' || 'ris' || 'hi' || 'ma', 'k' || 'on' || 'go', 1900+15);
insert into shuttles values ('k' || 'ong' || 'o', 'k' || 'o' || 'ng' || 'o', 1800+113);
insert into shuttles values ('mi' || 'ss' || 'ou' || 'ri', 'i' || 'ow' || 'a', 1800+144);
insert into shuttles values ('m' || 'us' || 'as' || 'hi', 'y' || 'ama' || 'to', 1900+42);
insert into shuttles values ('n' || 'ew je' || 'rsey', 'io' || 'wa', 1840+103);
insert into shuttles values ('nor' || 'th c' || 'ar' || 'olina', 'nor' || 'th c' || 'ar' || 'ol' || 'ina', 1940+1);
insert into shuttles values ('r' || 'am' || 'il' || 'lies', 're' || 've' || 'nge', 1900+17);
insert into shuttles values ('re' || 'no' || 'wn', 'ren' || 'ow' || 'n', 1900+16);
insert into shuttles values ('rep' || 'u' || 'lse', 'r' || 'en' || 'own', 1900+16);
insert into shuttles values ('resolu' || 'ti' || 'on', 'reno' || 'w' || 'n', 1800+116);
insert into shuttles values ('r' || 'ev' || 'enge', 're' || 've' || 'nge', 1800+116);
insert into shuttles values ('ro' || 'ya' || 'l oak', 'r' || 'ev' || 'en' || 'ge', 1900+16);
insert into shuttles values ('roya' || 'l so' || 've' || 're' || 'ign', 're' || 've' || 'nge', 1900+16);
insert into shuttles values ('ten' || 'ness' || 'ee', 'ten' || 'ness' || 'ee', 1900+20);
insert into shuttles values ('w' || 'ash' || 'in' || 'gton', 'no' || 'rth c' || 'aro' || 'l' || 'ina', 1900+41);
insert into shuttles values ('wis' || 'con' || 'sin', 'i' || 'owa', 1900+44);
insert into shuttles values ('y' || 'amato', 'yam' || 'at' || 'o', 1900+41);
insert into shuttles values ('s' || 'ou' || 'th' || ' da' || 'kota', 'n' || 'or' || 'th c' || 'arol' || 'i' || 'na', 1900+41);
commit;


