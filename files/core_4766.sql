    set list on;
    connect '%(dsn)s' user %(user_name)s password '%(user_password)s';

    set term ^;
    create or alter procedure sp_cleanup as
    begin
        begin
            execute statement 'drop user tmp_4766_boss using plugin %(current_auth_plugin)s' with autonomous transaction;
            when any do begin end
        end
     
        begin
        execute statement 'drop user tmp_4766_mngr using plugin %(current_auth_plugin)s' with autonomous transaction;
            when any do begin end
        end
    end
    ^
    set term ;^
    commit;

    -- removed 27.01.2020 because unneeded for this test:
    -- select mon$user,mon$remote_protocol,mon$auth_method from mon$attachments where mon$attachment_id=current_connection;
    -- commit;

    execute procedure sp_cleanup;
    commit;

    create user tmp_4766_boss password '123' using plugin %(current_auth_plugin)s grant admin role;
    commit;
    
    select u.sec$user_name boss_sec_name, u.sec$plugin boss_sec_plugin, u.sec$admin boss_sec_is_admin
    from rdb$database r
    left join sec$users u on u.sec$user_name = upper('tmp_4766_boss');

    set term ^;
    execute block as
    begin
        execute statement 'create user tmp_4766_mngr password ''456'' using plugin %(current_auth_plugin)s'
        as user 'tmp_4766_boss' password '123' role 'RDB$ADMIN';
    end
    ^
    set term ;^
    commit;

    set bail on;
    rollback; -- Crash is reproduced here, WI-T3.0.0.31374 Firebird 3.0 Beta 1 (build 24-nov-2014).
    set bail off;
    
    select u.sec$user_name mngr_sec_name, u.sec$plugin mngr_sec_plugin, u.sec$admin mngr_sec_is_admin
    from rdb$database r
    left join sec$users u on u.sec$user_name = upper('tmp_4766_mngr');

    set term ^;
    execute block as
    begin
        execute statement 'drop user tmp_4766_mngr using plugin %(current_auth_plugin)s'
        as user 'tmp_4766_boss' password '123' role 'RDB$ADMIN';
    end
    ^
    set term ;^
    commit;

    rollback; -- otherwise "rolling back work", despite that COMMIT was done just now, see previous line !
    connect '%(dsn)s' user %(user_name)s password '%(user_password)s';

    --                                    ||||||||||||||||||||||||||||
    -- ###################################|||  FB 4.0+, SS and SC  |||##############################
    --                                    ||||||||||||||||||||||||||||
    -- If we check SS or SC and ExtConnPoolLifeTime > 0 (config parameter FB 4.0+) then current
    -- DB (bugs.core_NNNN.fdb) will be 'captured' by firebird.exe process and fbt_run utility
    -- will not able to drop this database at the final point of test.
    -- Moreover, DB file will be hold until all activity in firebird.exe completed and AFTER this
    -- we have to wait for <ExtConnPoolLifeTime> seconds after it (discussion and small test see
    -- in the letter to hvlad and dimitr 13.10.2019 11:10).
    -- This means that one need to kill all connections to prevent from exception on cleanup phase:
    -- SQLCODE: -901 / lock time-out on wait transaction / object <this_test_DB> is in use
    -- #############################################################################################
    delete from mon$attachments where mon$attachment_id != current_connection;
    commit;

    execute procedure sp_cleanup;
    commit; 
