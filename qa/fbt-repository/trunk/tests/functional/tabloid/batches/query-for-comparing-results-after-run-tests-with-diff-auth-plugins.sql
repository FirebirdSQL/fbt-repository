with
last_run as (
    select r.ver,r.build,r.person as auth_plugin, r.arch, max(r.created) as last_run_dts,max(r.pk) as last_run_id
    from runs r
    group by 1,2,3,4
)
,run_results as (
    select o.run_id, o.test_id, o.outcome, o.run_time, t.name as test_name, r.ver, r.build, r.arch, r.auth_plugin, r.last_run_dts, r.last_run_id
    from outcomes o
    join tests t on o.test_id  = t.pk
    join last_run r on o.run_id = r.last_run_id
)
--select * from run_results
,run_for_grp as (
    select a.build, a.arch, a.test_id, a.test_name, a.run_time as run_time_leg, a.outcome as outcome_leg, cast('00:00:00' as time) as run_time_srp, ' ' as outcome_srp
    from run_results a
    where auth_plugin = 'plugin_legacy_auth'
    union all
    select a.build, a.arch, a.test_id, a.test_name, cast('00:00:00' as time) as run_time_leg, ' ' as outcome_leg, a.run_time as run_time_srp, a.outcome as outcome_srp
    from run_results a
    where auth_plugin = 'plugin_srp'
)
--select * from run_for_grp g
select
    build
    ,arch
    --,test_id
    ,test_name
    ,max(outcome_leg) as outcome_leg
    ,max(outcome_srp) as outcome_srp
    ,iif(max(outcome_leg) != max(outcome_srp), 'PLUGIN TROUBLE', decode(max(outcome_leg), 'F','RUN FAILED', 'E', 'EXCEPTION OCCURED', 'S','SKIPPED', '') ) as run_result
    ,max(run_time_leg) as run_time_leg
    ,max(run_time_srp) as run_time_srp
from run_for_grp g
group by 1,2,3
order by
    iif(max(outcome_leg) != max(outcome_srp), 0, 1),
    decode( max(outcome_leg), 'E', 0, 'F', 10, 'S', 20, 'U', 30, 'P', 99,  -1 ),
    arch,
    test_name
;