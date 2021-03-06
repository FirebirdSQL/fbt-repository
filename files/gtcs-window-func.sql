recreate table persons (
  id integer generated by default as identity primary key,
  name varchar(15)
);

recreate table entries (
  id integer generated by default as identity primary key,
  person integer references persons,
  dat date,
  val numeric(10,2)
);

insert into persons (name) values ('Person 1');
insert into persons (name) values ('Person 2');
insert into persons (name) values ('Person 3');
insert into persons (name) values ('Person 4');
insert into persons (name) values ('Person 5');

insert into entries (person, dat, val) select id, date '2010-01-02' + id, id * 2 + 0.3 from persons;
insert into entries (person, dat, val) select id, date '2010-02-01' + id, id * 3 + 0.4 from persons;
insert into entries (person, dat, val) select id, date '2010-03-01' + id, id * 3 + 0.4 from persons;
insert into entries (person, dat, val) values (1, null, null);
commit;

-- select * from entries;

recreate view v1 (x1, x2, x3, x4, x5, x6, x7, x8) as
  select
      count(*) over (partition by p.id), count(e.val) over (partition by p.id),
      min(e.val) over (partition by p.id), max(e.val) over (partition by p.id),
      count(distinct e.val) over (partition by p.id), min(distinct e.val) over (partition by p.id),
      max(distinct e.val) over (partition by p.id),
      p.name
    from entries e
    join persons p
      on p.id = e.person;

recreate view v2 as
  select *
    from entries;

recreate view v3 as
  select v2.person, v2.val, p.name
    from v2
    join persons p
      on p.id = v2.person;
commit;
