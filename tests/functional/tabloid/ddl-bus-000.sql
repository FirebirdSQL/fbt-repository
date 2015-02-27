recreate table pdata (
  tid int      not null,
  pdt   date not null,
  pid  int      not null,
  plc   char(10)     not null,
  constraint pk_pdata primary key (tid, pdt, pid) using index pk_pdata
);
recreate table tdata (
  id   int not null,
  cid   int not null,
  bus     char(10) not null,
  src char(25) not null,
  tgt  char(25) not null,
  dts0  timestamp not null,
  dts1   timestamp not null,
  constraint pk_tdata primary key (id) using index pk_tdata
);

recreate table clist (
  id int  not null,
  name    char(10) not null,
  constraint pk_clist primary key (id) using index pk_clist
);

recreate table plist (
  id int  not null,
  name   char(20) not null,
  constraint pk_plist primary key (id) using index pk_plist
);
commit;

alter table pdata add constraint fk_pdata_plist foreign key (pid) references plist (id);
alter table pdata add constraint fk_pdata_tdata foreign key (tid) references tdata (id);
alter table tdata add constraint fk_tdata_clist foreign key (cid) references clist (id);
commit;

insert into clist values (1, 'd'||'on_a'||'via');
insert into clist values (2, 'ae'||'ro'||'fl'||'ot');
insert into clist values (3, 'd'||'a'||'le_a'||'via');
insert into clist values (4, 'ai'||'r_fr'||'an'||'ce');
insert into clist values (5, 'b'||'ri'||'ti'||'sh_aw');

insert into plist values (1, 'b'||'ru'||'ce wi'||'ll'||'is');
insert into plist values (2, 'geo'||'rge cl'||'oo'||'ney');
insert into plist values (3, 'ke'||'v'||'in c'||'os'||'tner');
insert into plist values (4, 'don'||'a'||'ld su'||'th'||'erland');
insert into plist values (5, 'jen'||'ni'||'fe'||'r lo'||'pez');
insert into plist values (6, 'ra'||'y'||' li'||'o'||'tta');
insert into plist values (7, 'sam'||'u'||'el l. ja'||'c'||'kson');
insert into plist values (8, 'n'||'i'||'kol'||'e ki'||'d'||'man');
insert into plist values (9, 'a'||'l'||'an ri'||'ckman');
insert into plist values (10, 'ku'||'rt rus'||'sell');
insert into plist values (11, 'h'||'arri'||'son f'||'ord');
insert into plist values (12, 'russ'||'el'||'l cr'||'owe');
insert into plist values (13, 'st'||'e'||'ve m'||'a'||'rtin');
insert into plist values (14, 'mi'||'ch'||'ael c'||'aine');
insert into plist values (15, 'an'||'ge'||'lin'||'a jo'||'lie');
insert into plist values (16, 'me'||'l g'||'ibson');
insert into plist values (17, 'mic'||'hael doug'||'las');
insert into plist values (18, 'john tr'||'av'||'olta');
insert into plist values (19, 'sylv'||'e'||'ster st'||'all'||'one');
insert into plist values (20, 'to'||'mmy lee jon'||'es');
insert into plist values (21, 'cather'||'ine zet'||'a-j'||'ones');
insert into plist values (22, 'ant'||'onio ba'||'nderas');
insert into plist values (23, 'k'||'im b'||'as'||'inger');
insert into plist values (24, 'sam n'||'eill');
insert into plist values (25, 'gary old'||'man');
insert into plist values (26, 'c'||'l'||'int e'||'astw'||'ood');
insert into plist values (27, 'bra'||'d'||' pitt');
insert into plist values (28, 'joh'||'nny de'||'pp');
insert into plist values (29, 'pi'||'erce '||'br'||'osnan');
insert into plist values (30, 'sean c'||'onnery');
insert into plist values (31, 'bruce '||'will'||'is');
insert into plist values (37, 'm'||'ull'||'ah oma'||'r');

insert into tdata values (1100, 4, 'bo'||'ei'||'n'||'g', 'ro'||'st'||'ov', 'p'||'ar'||'is', timestamp'1900-01-01 14:30:00', timestamp'1900-01-01 17:50:00');
insert into tdata values (1101, 4, 'bo'||'ei'||'n'||'g', 'p'||'ar'||'is', 'ro'||'st'||'ov', timestamp'1900-01-01 08:12:00', timestamp'1900-01-01 11:45:00');
insert into tdata values (1123, 3, 'tu-15'||'4', 'ro'||'st'||'ov', 'vl'||'ad'||'iv'||'ost'||'ok', timestamp'1900-01-01 16:20:00', timestamp'1900-01-01 03:40:00');
insert into tdata values (1124, 3, 't'||'u-154', 'vladivostok ', 'ro'||'st'||'ov', timestamp'1900-01-01 09:00:00', timestamp'1900-01-01 19:50:00');
insert into tdata values (1145, 2, 'il'||'-'||'86', 'm'||'o'||'sco'||'w', 'ro'||'st'||'ov', timestamp'1900-01-01 09:35:00', timestamp'1900-01-01 11:23:00');
insert into tdata values (1146, 2, 'i'||'l-'||'86', 'ro'||'st'||'ov', 'm'||'o'||'sco'||'w', timestamp'1900-01-01 17:55:00', timestamp'1900-01-01 20:01:00');
insert into tdata values (1181, 1, 'tu-1'||'34', 'ro'||'st'||'ov', 'm'||'o'||'sco'||'w', timestamp'1900-01-01 06:12:00', timestamp'1900-01-01 08:01:00');
insert into tdata values (1182, 1, 't'||'u-1'||'34', 'm'||'o'||'sco'||'w', 'ro'||'st'||'ov', timestamp'1900-01-01 12:35:00', timestamp'1900-01-01 14:30:00');
insert into tdata values (1187, 1, 'tu-1'||'34', 'ro'||'st'||'ov', 'm'||'o'||'sco'||'w', timestamp'1900-01-01 15:42:00', timestamp'1900-01-01 17:39:00');
insert into tdata values (1188, 1, 'tu-13'||'4', 'm'||'o'||'sco'||'w', 'ro'||'st'||'ov', timestamp'1900-01-01 22:50:00', timestamp'1900-01-01 00:48:00');
insert into tdata values (1195, 1, 't'||'u-15'||'4', 'ro'||'st'||'ov', 'm'||'o'||'sco'||'w', timestamp'1900-01-01 23:30:00', timestamp'1900-01-01 01:11:00');
insert into tdata values (1196, 1, 'tu-1'||'54', 'm'||'o'||'sco'||'w', 'ro'||'st'||'ov', timestamp'1900-01-01 04:00:00', timestamp'1900-01-01 05:45:00');
insert into tdata values (7771, 5, 'bo'||'ei'||'n'||'g', 'lo'||'nd'||'o'||'n', 's'||'in'||'gap'||'ore', timestamp'1900-01-01 01:00:00', timestamp'1900-01-01 11:00:00');
insert into tdata values (7772, 5, 'bo'||'ei'||'n'||'g', 's'||'in'||'gap'||'ore', 'lo'||'nd'||'o'||'n', timestamp'1900-01-01 12:00:00', timestamp'1900-01-01 02:00:00');
insert into tdata values (7773, 5, 'bo'||'ei'||'n'||'g', 'lo'||'nd'||'o'||'n', 's'||'in'||'gap'||'ore', timestamp'1900-01-01 03:00:00', timestamp'1900-01-01 13:00:00');
insert into tdata values (7774, 5, 'b'||'o'||'e'||'i'||'n'||'g', 's'||'in'||'gap'||'ore', 'lo'||'nd'||'o'||'n', timestamp'1900-01-01 14:00:00', timestamp'1900-01-01 06:00:00');
insert into tdata values (7775, 5, 'bo'||'ei'||'n'||'g', 'lo'||'nd'||'o'||'n', 's'||'in'||'gap'||'ore', timestamp'1900-01-01 09:00:00', timestamp'1900-01-01 20:00:00');
insert into tdata values (7776, 5, 'bo'||'ei'||'n'||'g', 's'||'in'||'gap'||'ore', 'lo'||'nd'||'o'||'n', timestamp'1900-01-01 18:00:00', timestamp'1900-01-01 08:00:00');
insert into tdata values (7777, 5, 'bo'||'e'||'i'||'n'||'g', 'lo'||'nd'||'o'||'n', 's'||'in'||'gap'||'ore', timestamp'1900-01-01 18:00:00', timestamp'1900-01-01 06:00:00');
insert into tdata values (7778, 5, 'b'||'o'||'ei'||'n'||'g', 's'||'in'||'gap'||'ore', 'lo'||'nd'||'o'||'n', timestamp'1900-01-01 22:00:00', timestamp'1900-01-01 12:00:00');
insert into tdata values (8881, 5, 'bo'||'ei'||'n'||'g', 'lo'||'nd'||'o'||'n', 'p'||'ar'||'is', timestamp'1900-01-01 03:00:00', timestamp'1900-01-01 04:00:00');
insert into tdata values (8882, 5, 'bo'||'e'||'i'||'n'||'g', 'p'||'ar'||'is', 'lo'||'nd'||'o'||'n', timestamp'1900-01-01 22:00:00', timestamp'1900-01-01 23:00:00');

insert into pdata values (1100, timestamp'2003-04-29 00:00:00', 1, '1a');
insert into pdata values (1123, timestamp'2003-04-05 00:00:00', 3, '2a');
insert into pdata values (1123, timestamp'2003-04-08 00:00:00', 1, '4c');
insert into pdata values (1123, timestamp'2003-04-08 00:00:00', 6, '4b');
insert into pdata values (1124, timestamp'2003-04-02 00:00:00', 2, '2d');
insert into pdata values (1145, timestamp'2003-04-05 00:00:00', 3, '2c');
insert into pdata values (1181, timestamp'2003-04-01 00:00:00', 1, '1a');
insert into pdata values (1181, timestamp'2003-04-01 00:00:00', 6, '1b');
insert into pdata values (1181, timestamp'2003-04-01 00:00:00', 8, '3c');
insert into pdata values (1181, timestamp'2003-04-13 00:00:00', 5, '1b');
insert into pdata values (1182, timestamp'2003-04-13 00:00:00', 5, '4b');
insert into pdata values (1187, timestamp'2003-04-14 00:00:00', 8, '3a');
insert into pdata values (1188, timestamp'2003-04-01 00:00:00', 8, '3a');
insert into pdata values (1182, timestamp'2003-04-13 00:00:00', 9, '6d');
insert into pdata values (1145, timestamp'2003-04-25 00:00:00', 5, '1d');
insert into pdata values (1187, timestamp'2003-04-14 00:00:00', 10, '3d');
insert into pdata values (8882, timestamp'2005-11-06 00:00:00', 37, '1a');
insert into pdata values (7771, timestamp'2005-11-07 00:00:00', 37, '1c');
insert into pdata values (7772, timestamp'2005-11-07 00:00:00', 37, '1a');
insert into pdata values (8881, timestamp'2005-11-08 00:00:00', 37, '1d');
insert into pdata values (7778, timestamp'2005-11-05 00:00:00', 10, '2a');
insert into pdata values (7772, timestamp'2005-11-29 00:00:00', 10, '3a');
insert into pdata values (7771, timestamp'2005-11-04 00:00:00', 11, '4a');
insert into pdata values (7771, timestamp'2005-11-07 00:00:00', 11, '1b');
insert into pdata values (7771, timestamp'2005-11-09 00:00:00', 11, '5a');
insert into pdata values (7772, timestamp'2005-11-07 00:00:00', 12, '1d');
insert into pdata values (7773, timestamp'2005-11-07 00:00:00', 13, '2d');
insert into pdata values (7772, timestamp'2005-11-29 00:00:00', 13, '1b');
insert into pdata values (8882, timestamp'2005-11-13 00:00:00', 14, '3d');
insert into pdata values (7771, timestamp'2005-11-14 00:00:00', 14, '4d');
insert into pdata values (7771, timestamp'2005-11-16 00:00:00', 14, '5d');
insert into pdata values (7772, timestamp'2005-11-29 00:00:00', 14, '1c');
commit;

