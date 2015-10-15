set bail on;
set list on;

with a as (
    select rf.rdb$field_id fid, rr.rdb$relation_id rid, rr.rdb$relation_name rnm
    from rdb$relation_fields rf join rdb$relations rr on rf.rdb$relation_name=rr.rdb$relation_name
)
,b as (
    select fid, rnm, rid, iif(rid is null, 1, r) r
    from (--f
        select fid, rnm, rid,
                iif(lag(fid) over(partition by rid order by fid) is not null
                    and lag(r) over(partition by rid order by fid) >= r
                    , r + 1, r) r
        from (--e
            select fid, rnm, rid,
                    iif(lag(fid) over(partition by rid order by fid) is not null
                        and lag(r) over(partition by rid order by fid) >= r
                        , r + 1, r) r
            from (--d
                select fid, rnm, rid,
                        iif(lag(fid) over(partition by rid order by fid) is not null
                            and lag(r) over(partition by rid order by fid) >= r
                            , r + 1, r) r
                from (--c
                    select fid, rnm, rid,
                            iif(lag(fid) over(partition by rid order by fid) is not null
                                and lag(r) over(partition by rid order by fid) >= r
                           ,r + 1, r) r
                    from (--b
                        select fid, rnm, rid,
                                iif( lag(fid) over(partition by rid order by fid) is not null
                                      and lag(r) over(partition by rid order by fid) >= r
                                     ,r + 1, r) r
                        from (
                                select a.*, 1 r
                                from a
                              ) a
                        ) b
                  ) c
              ) d
          ) e
      ) f
)
-- select max(r) r from b group by fid having max(r) < 6; -- ok

,c
as (
    select fid, rnm, rid, iif(rid is null, 1, r) r
    from (--f
        select fid, rnm, rid,
                iif(lag(fid) over(partition by rid order by fid) is not null
                     and lag(r) over(partition by rid order by fid) >= r
                    , r + 1, r) r
        from (--e
            select fid, rnm, rid,
                    iif(lag(fid) over(partition by rid order by fid) is not null
                         and lag(r) over(partition by rid order by fid) >= r
                        , r + 1, r) r
            from (--d
                select fid, rnm, rid,
                        iif(lag(fid) over(partition by rid order by fid) is not null
                             and lag(r) over(partition by rid order by fid) >= r
                            , r + 1, r) r
                from (--c
                    select fid, rnm, rid,
                            iif(lag(fid) over(partition by rid order by fid) is not null
                                 and lag(r) over(partition by rid order by fid) >= r
                           ,r + 1, r) r
                    from (--b
                        select fid, rnm, rid,
                                iif( lag(fid) over(partition by rid order by fid) is not null
                                      and lag(r) over(partition by rid order by fid) >= r
                                     ,r + 1, r) r
                        from (
                                select fid, rnm, rid, max(r) over(partition by fid) r from b
                              ) a
                        ) b
                  ) c
              ) d
          ) e
      ) f
)
-- select * from c -- ok

,d
as (
    select fid, rnm, rid, iif(rid is null, 1, r) r
    from (--f
        select fid, rnm, rid,
                iif( lag(fid) over(partition by rid order by fid) is not null
                     and lag(r) over(partition by rid order by fid) >= r
                    , r + 1, r) r
        from (--e
            select fid, rnm, rid,
                    iif( lag(fid) over(partition by rid order by fid) is not null
                         and lag(r) over(partition by rid order by fid) >= r
                        , r + 1, r) r
            from (--d
                select fid, rnm, rid,
                        iif( lag(fid) over(partition by rid order by fid) is not null
                             and lag(r) over(partition by rid order by fid) >= r
                            , r + 1, r) r
                from (--c
                    select fid, rnm, rid,
                            iif( lag(fid) over(partition by rid order by fid) is not null
                                 and lag(r) over(partition by rid order by fid) >= r
                           ,r + 1, r) r
                    from (--b
                        select fid, rnm, rid,
                                iif( lag(fid) over(partition by rid order by fid) is not null
                                      and lag(r) over(partition by rid order by fid) >= r
                                     ,r + 1, r) r
                        from (
                                select fid, rnm, rid, max(r) over(partition by fid) r from c
                              ) a
                        ) b
                  ) c
              ) d
          ) e
      ) f
)
select * from d rows 0;

quit;
