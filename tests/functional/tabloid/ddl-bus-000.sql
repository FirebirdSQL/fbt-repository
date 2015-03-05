recreate table pmove (
  tid int not null,
  pdt date not null,
  pid int not null,
  box char(10) not null,
  constraint pk_pmove primary key (tid, pdt, pid) using index pk_pmove
);
recreate table tmove (
  id int not null,
  cid int not null,
  bus char(10) not null,
  src char(25) not null,
  tgt char(25) not null,
  dts0 timestamp not null,
  dts1 timestamp not null,
  constraint pk_tmove primary key (id) using index pk_tmove
);

recreate table clist (
  id int  not null,
  name    char(10) not null,
  constraint pk_clist primary key (id) using index pk_clist
);

recreate table plist(
  id int  not null,
  name char(20) not null,
  constraint pk_plist primary key (id) using index pk_plist
);
commit;


alter table pmove add constraint fk_pmove_plist foreign key (pid) references plist (id);
alter table pmove add constraint fk_pmove_tmove foreign key (tid) references tmove (id);
alter table tmove add constraint fk_tmove_clist foreign key (cid) references clist (id);
commit;

insert into clist values(1, 'dn');
insert into clist values(2, 'ae');
insert into clist values(3, 'dv');
insert into clist values(4, 'af');
insert into clist values(5, 'ba');

insert into plist values( 1, 'bw');
insert into plist values( 2, 'gc');
insert into plist values( 3, 'kc');
insert into plist values( 4, 'ds');
insert into plist values( 5, 'jl');
insert into plist values( 6, 'rl');
insert into plist values( 7, 'sj');
insert into plist values( 8, 'nk');
insert into plist values( 9, 'ar');
insert into plist values(10, 'kr');
insert into plist values(11, 'hf');
insert into plist values(12, 'rc');
insert into plist values(13, 'sm');
insert into plist values(14, 'mc');
insert into plist values(15, 'aj');
insert into plist values(16, 'mg');
insert into plist values(17, 'md');
insert into plist values(18, 'jt');
insert into plist values(19, 'ss');
insert into plist values(20, 'tj');
insert into plist values(21, 'cz');
insert into plist values(22, 'ab');
insert into plist values(23, 'kb');
insert into plist values(24, 'sn');
insert into plist values(25, 'go');
insert into plist values(26, 'ce');
insert into plist values(27, 'bp');
insert into plist values(28, 'jd');
insert into plist values(29, 'pb');
insert into plist values(30, 'sc');
insert into plist values(31, 'bw');
insert into plist values(37, 'mo');

insert into tmove values(1100, 4, 'bg', 'R', 'P', timestamp'1900-01-01 14:30:00', timestamp'1900-01-01 17:50:00');
insert into tmove values(1101, 4, 'bg', 'P', 'R', timestamp'1900-01-01 08:12:00', timestamp'1900-01-01 11:45:00');
insert into tmove values(1123, 3, 't5', 'R', 'v', timestamp'1900-01-01 16:20:00', timestamp'1900-01-01 03:40:00');
insert into tmove values(1124, 3, 't5', 'v', 'R', timestamp'1900-01-01 09:00:00', timestamp'1900-01-01 19:50:00');
insert into tmove values(1145, 2, 'i8', 'M', 'R', timestamp'1900-01-01 09:35:00', timestamp'1900-01-01 11:23:00');
insert into tmove values(1146, 2, 'i8', 'R', 'M', timestamp'1900-01-01 17:55:00', timestamp'1900-01-01 20:01:00');
insert into tmove values(1181, 1, 't3', 'R', 'M', timestamp'1900-01-01 06:12:00', timestamp'1900-01-01 08:01:00');
insert into tmove values(1182, 1, 't3', 'M', 'R', timestamp'1900-01-01 12:35:00', timestamp'1900-01-01 14:30:00');
insert into tmove values(1187, 1, 't3', 'R', 'M', timestamp'1900-01-01 15:42:00', timestamp'1900-01-01 17:39:00');
insert into tmove values(1188, 1, 't3', 'M', 'R', timestamp'1900-01-01 22:50:00', timestamp'1900-01-01 00:48:00');
insert into tmove values(1195, 1, 't5', 'R', 'M', timestamp'1900-01-01 23:30:00', timestamp'1900-01-01 01:11:00');
insert into tmove values(1196, 1, 't5', 'M', 'R', timestamp'1900-01-01 04:00:00', timestamp'1900-01-01 05:45:00');
insert into tmove values(7771, 5, 'bg', 'L', 'S', timestamp'1900-01-01 01:00:00', timestamp'1900-01-01 11:00:00');
insert into tmove values(7772, 5, 'bg', 'S', 'L', timestamp'1900-01-01 12:00:00', timestamp'1900-01-01 02:00:00');
insert into tmove values(7773, 5, 'bg', 'L', 'S', timestamp'1900-01-01 03:00:00', timestamp'1900-01-01 13:00:00');
insert into tmove values(7774, 5, 'bg', 'S', 'L', timestamp'1900-01-01 14:00:00', timestamp'1900-01-01 06:00:00');
insert into tmove values(7775, 5, 'bg', 'L', 'S', timestamp'1900-01-01 09:00:00', timestamp'1900-01-01 20:00:00');
insert into tmove values(7776, 5, 'bg', 'S', 'L', timestamp'1900-01-01 18:00:00', timestamp'1900-01-01 08:00:00');
insert into tmove values(7777, 5, 'bg', 'L', 'S', timestamp'1900-01-01 18:00:00', timestamp'1900-01-01 06:00:00');
insert into tmove values(7778, 5, 'bg', 'S', 'L', timestamp'1900-01-01 22:00:00', timestamp'1900-01-01 12:00:00');
insert into tmove values(8881, 5, 'bg', 'L', 'P', timestamp'1900-01-01 03:00:00', timestamp'1900-01-01 04:00:00');
insert into tmove values(8882, 5, 'bg', 'P', 'L', timestamp'1900-01-01 22:00:00', timestamp'1900-01-01 23:00:00');

insert into pmove values (1100, timestamp'2003-04-29 00:00:00', 1, '1a');
insert into pmove values (1123, timestamp'2003-04-05 00:00:00', 3, '2a');
insert into pmove values (1123, timestamp'2003-04-08 00:00:00', 1, '4c');
insert into pmove values (1123, timestamp'2003-04-08 00:00:00', 6, '4b');
insert into pmove values (1124, timestamp'2003-04-02 00:00:00', 2, '2d');
insert into pmove values (1145, timestamp'2003-04-05 00:00:00', 3, '2c');
insert into pmove values (1181, timestamp'2003-04-01 00:00:00', 1, '1a');
insert into pmove values (1181, timestamp'2003-04-01 00:00:00', 6, '1b');
insert into pmove values (1181, timestamp'2003-04-01 00:00:00', 8, '3c');
insert into pmove values (1181, timestamp'2003-04-13 00:00:00', 5, '1b');
insert into pmove values (1182, timestamp'2003-04-13 00:00:00', 5, '4b');
insert into pmove values (1187, timestamp'2003-04-14 00:00:00', 8, '3a');
insert into pmove values (1188, timestamp'2003-04-01 00:00:00', 8, '3a');
insert into pmove values (1182, timestamp'2003-04-13 00:00:00', 9, '6d');
insert into pmove values (1145, timestamp'2003-04-25 00:00:00', 5, '1d');
insert into pmove values (1187, timestamp'2003-04-14 00:00:00', 10, '3d');
insert into pmove values (8882, timestamp'2005-11-06 00:00:00', 37, '1a');
insert into pmove values (7771, timestamp'2005-11-07 00:00:00', 37, '1c');
insert into pmove values (7772, timestamp'2005-11-07 00:00:00', 37, '1a');
insert into pmove values (8881, timestamp'2005-11-08 00:00:00', 37, '1d');
insert into pmove values (7778, timestamp'2005-11-05 00:00:00', 10, '2a');
insert into pmove values (7772, timestamp'2005-11-29 00:00:00', 10, '3a');
insert into pmove values (7771, timestamp'2005-11-04 00:00:00', 11, '4a');
insert into pmove values (7771, timestamp'2005-11-07 00:00:00', 11, '1b');
insert into pmove values (7771, timestamp'2005-11-09 00:00:00', 11, '5a');
insert into pmove values (7772, timestamp'2005-11-07 00:00:00', 12, '1d');
insert into pmove values (7773, timestamp'2005-11-07 00:00:00', 13, '2d');
insert into pmove values (7772, timestamp'2005-11-29 00:00:00', 13, '1b');
insert into pmove values (8882, timestamp'2005-11-13 00:00:00', 14, '3d');
insert into pmove values (7771, timestamp'2005-11-14 00:00:00', 14, '4d');
insert into pmove values (7771, timestamp'2005-11-16 00:00:00', 14, '5d');
insert into pmove values (7772, timestamp'2005-11-29 00:00:00', 14, '1c');
commit;

