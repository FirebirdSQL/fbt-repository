recreate table mpc (
    id int not null,
    mnm varchar(50) not null,
    cpu int not null,
    ram int not null,
    hdd double precision not null,
    cdx varchar(10) not null,
    cost numeric(12,2),
    constraint pk_mpc primary key (id) using index pk_mpc
);

recreate table mpr (
    id int not null, 
    mnm varchar(50) not null,
    clr char(1) not null,
    mty varchar(10) not null,
    cost numeric(12,2),
    constraint pk_mpr primary key (id) using index pk_mpr
);

recreate table mlp (
    id int not null, 
    mnm varchar(50) not null,
    cpu int not null,
    ram int not null,
    hdd double precision not null,
    cost numeric(12,2),
    scr int not null,
    constraint pk_mlp primary key (id) using index pk_mlp
);


recreate table mnf (
    who varchar(10) not null,
    mnm varchar(50) not null,
    mty varchar(50) not null,
    constraint pk_mnf primary key (mnm) using index pk_mnf
);
commit;

alter table mlp add constraint fk_mlp foreign key(mnm) references mnf(mnm);
alter table mpc add constraint fk_mpc foreign key(mnm) references mnf(mnm);
alter table mpr add constraint fk_mpr foreign key(mnm) references mnf(mnm);
commit;

insert into mnf values ('b', '1121', 'pc');
insert into mnf values ('a', '1232', 'pc');
insert into mnf values ('a', '1233', 'pc');
insert into mnf values ('e', '1260', 'pc');
insert into mnf values ('a', '1276', 'printer');
insert into mnf values ('d', '1288', 'printer');
insert into mnf values ('a', '1298', 'laptop');
insert into mnf values ('c', '1321', 'laptop');
insert into mnf values ('a', '1401', 'printer');
insert into mnf values ('a', '1408', 'printer');
insert into mnf values ('d', '1433', 'printer');
insert into mnf values ('e', '1434', 'printer');
insert into mnf values ('b', '1750', 'laptop');
insert into mnf values ('a', '1752', 'laptop');
insert into mnf values ('e', '2113', 'pc');
insert into mnf values ('e', '2112', 'pc');
commit;

insert into mlp values (1, '1298', 350, 32, 4, 700.00, 11);
insert into mlp values (2, '1321', 500, 64, 8, 970.00, 12);
insert into mlp values (3, '1750', 750, 128, 12, 1200.00, 14);
insert into mlp values (4, '1298', 600, 64, 10, 1050.00, 15);
insert into mlp values (5, '1752', 750, 128, 10, 1150.00, 14);
insert into mlp values (6, '1298', 450, 64, 10, 950.00, 12);

insert into mpc values (1, '1232', 500, 64, 5, '12x', 600.00);
insert into mpc values (2, '1121', 750, 128, 14, '40x', 850.00);
insert into mpc values (3, '1233', 500, 64, 5, '12x', 600.00);
insert into mpc values (4, '1121', 600, 128, 14, '40x', 850.00);
insert into mpc values (5, '1121', 600, 128, 8, '40x', 850.00);
insert into mpc values (6, '1233', 750, 128, 20, '50x', 950.00);
insert into mpc values (7, '1232', 500, 32, 10, '12x', 400.00);
insert into mpc values (8, '1232', 450, 64, 8, '24x', 350.00);
insert into mpc values (9, '1232', 450, 32, 10, '24x', 350.00);
insert into mpc values (10, '1260', 500, 32, 10, '12x', 350.00);
insert into mpc values (11, '1233', 900, 128, 40, '40x', 980.00);
insert into mpc values (12, '1233', 800, 128, 20, '50x', 970.00);

insert into mpr values (1, '1276', 'n', 'laser', 400.00);
insert into mpr values (2, '1433', 'y', 'jet', 270.00);
insert into mpr values (3, '1434', 'y', 'jet', 290.00);
insert into mpr values (4, '1401', 'n', 'matrix', 150.00);
insert into mpr values (5, '1408', 'n', 'matrix', 270.00);
insert into mpr values (6, '1288', 'n', 'laser', 400.00);
commit;


