-- http://www.sql.ru/forum/actualutils.aspx?action=gotomsg&tid=877463&msg=11212061
recreate table tmp(id int primary key, f01 int);
commit;
insert into tmp values(1, 10);
insert into tmp values(2, 20);
insert into tmp values(3, 30);
insert into tmp values(4, 40);
commit;

with
c1 as(
  select null id,rdb$set_context('USER_TRANSACTION','total',0) f01 from rdb$database union all -- "инициализация"
  select t.id, t.f01
  from tmp t
)
select 
  id
  ,cast(rdb$get_context('USER_TRANSACTION','total') as int) run_total1
  ,f01 + 0*rdb$set_context( 'USER_TRANSACTION','total',
                            f01+cast(rdb$get_context('USER_TRANSACTION','total') as int) 
                          ) 
   as f01
  ,cast(rdb$get_context('USER_TRANSACTION','total') as int) run_total2
from c1
where id is not null
;

/*
result:

         ID   RUN_TOTAL1                   F01   RUN_TOTAL2
============ ============ ===================== ============
           1           10                    10            0
           2           30                    20           10
           3           60                    30           30
           4          100                    40           60

*/
