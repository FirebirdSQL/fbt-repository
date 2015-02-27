recreate table snd1i(
   igate int not null
  ,idate date not null
  ,icost numeric(12,2)
  ,constraint pk_sndi1 primary key (igate, idate) using index pk_snd1i
);

recreate table snd1o(
   ogate int not null
  ,odate date not null
  ,ocost numeric(12,2)
  ,constraint pk_sndo1 primary key (ogate, odate) using index pk_snd1o
);

recreate table sndxi(
   id int primary key using index pk_sndxi
  ,igate int not null
  ,idate date not null
  ,icost numeric(12,2)
);

recreate table sndxo(
   id int primary key using index pk_sndxo
  ,ogate int not null
  ,odate date not null
  ,ocost numeric(12,2)
);

insert into sndxi values (1, 1, timestamp'2001-03-22 00:00:00', 15000.00);
insert into sndxi values (2, 1, timestamp'2001-03-23 00:00:00', 15000.00);
insert into sndxi values (3, 1, timestamp'2001-03-24 00:00:00', 3600.00);
insert into sndxi values (4, 2, timestamp'2001-03-22 00:00:00', 10000.00);
insert into sndxi values (5, 2, timestamp'2001-03-24 00:00:00', 1500.00);
insert into sndxi values (6, 1, timestamp'2001-04-13 00:00:00', 5000.00);
insert into sndxi values (7, 1, timestamp'2001-05-11 00:00:00', 4500.00);
insert into sndxi values (8, 1, timestamp'2001-03-22 00:00:00', 15000.00);
insert into sndxi values (9, 2, timestamp'2001-03-24 00:00:00', 1500.00);
insert into sndxi values (10, 1, timestamp'2001-04-13 00:00:00', 5000.00);
insert into sndxi values (11, 1, timestamp'2001-03-24 00:00:00', 3400.00);
insert into sndxi values (12, 3, timestamp'2001-09-13 00:00:00', 1350.00);
insert into sndxi values (13, 3, timestamp'2001-09-13 00:00:00', 1750.00);


insert into snd1i values (1, timestamp'2001-03-22 00:00:00', 15000.00);
insert into snd1i values (1, timestamp'2001-03-23 00:00:00', 15000.00);
insert into snd1i values (1, timestamp'2001-03-24 00:00:00', 3400.00);
insert into snd1i values (1, timestamp'2001-04-13 00:00:00', 5000.00);
insert into snd1i values (1, timestamp'2001-05-11 00:00:00', 4500.00);
insert into snd1i values (2, timestamp'2001-03-22 00:00:00', 10000.00);
insert into snd1i values (2, timestamp'2001-03-24 00:00:00', 1500.00);
insert into snd1i values (3, timestamp'2001-09-13 00:00:00', 11500.00);
insert into snd1i values (3, timestamp'2001-10-02 00:00:00', 18000.00);



insert into sndxo values (1, 1, timestamp'2001-03-14 00:00:00', 15348.00);
insert into sndxo values (2, 1, timestamp'2001-03-24 00:00:00', 3663.00);
insert into sndxo values (3, 1, timestamp'2001-03-26 00:00:00', 1221.00);
insert into sndxo values (4, 1, timestamp'2001-03-28 00:00:00', 2075.00);
insert into sndxo values (5, 1, timestamp'2001-03-29 00:00:00', 2004.00);
insert into sndxo values (6, 1, timestamp'2001-04-11 00:00:00', 3195.04);
insert into sndxo values (7, 1, timestamp'2001-04-13 00:00:00', 4490.00);
insert into sndxo values (8, 1, timestamp'2001-04-27 00:00:00', 3110.00);
insert into sndxo values (9, 1, timestamp'2001-05-11 00:00:00', 2530.00);
insert into sndxo values (10, 2, timestamp'2001-03-22 00:00:00', 1440.00);
insert into sndxo values (11, 2, timestamp'2001-03-29 00:00:00', 7848.00);
insert into sndxo values (12, 2, timestamp'2001-04-02 00:00:00', 2040.00);
insert into sndxo values (13, 1, timestamp'2001-03-24 00:00:00', 3500.00);
insert into sndxo values (14, 2, timestamp'2001-03-22 00:00:00', 1440.00);
insert into sndxo values (15, 1, timestamp'2001-03-29 00:00:00', 2006.00);
insert into sndxo values (16, 3, timestamp'2001-09-13 00:00:00', 1200.00);
insert into sndxo values (17, 3, timestamp'2001-09-13 00:00:00', 1500.00);
insert into sndxo values (18, 3, timestamp'2001-09-14 00:00:00', 1150.00);

insert into snd1o values (1, timestamp'2001-03-14 00:00:00', 15348.00);
insert into snd1o values (1, timestamp'2001-03-24 00:00:00', 3663.00);
insert into snd1o values (1, timestamp'2001-03-26 00:00:00', 1221.00);
insert into snd1o values (1, timestamp'2001-03-28 00:00:00', 2075.00);
insert into snd1o values (1, timestamp'2001-03-29 00:00:00', 2004.00);
insert into snd1o values (1, timestamp'2001-04-11 00:00:00', 3195.04);
insert into snd1o values (1, timestamp'2001-04-13 00:00:00', 4490.00);
insert into snd1o values (1, timestamp'2001-04-27 00:00:00', 3110.00);
insert into snd1o values (1, timestamp'2001-05-11 00:00:00', 2530.00);
insert into snd1o values (2, timestamp'2001-03-22 00:00:00', 1440.00);
insert into snd1o values (2, timestamp'2001-03-29 00:00:00', 7848.00);
insert into snd1o values (2, timestamp'2001-04-02 00:00:00', 2040.00);
insert into snd1o values (3, timestamp'2001-09-13 00:00:00', 1500.00);
insert into snd1o values (3, timestamp'2001-09-14 00:00:00', 2300.00);
insert into snd1o values (3, timestamp'2002-09-16 00:00:00', 2150.00);
commit;

