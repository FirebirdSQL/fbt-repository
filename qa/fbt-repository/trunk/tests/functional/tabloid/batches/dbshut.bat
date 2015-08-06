@echo off

@rem ############################
@rem #####   D B  S H U T   #####
@rem ############################

@rem Batch for investigating of SHUTDOWN process features when
@rem database is subject to DML workload of different level.
@rem 
@rem Run this batch to get requirements and syntax if usage with examples.

setlocal enabledelayedexpansion enableextensions

set path=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\system32\WBEM

if .%1.==.. goto syntax
set fbarch=%1

set worker_num=%2
if .%2.==.. set worker_num=1

if not exist %~n0.conf goto noconf

::::::::::::::::::::::::  read fbt-run.conf  ::::::::::::::::::::::
call :readcfg %~n0.conf
:: Result:
:: get values of all necessary env. variables (fbNNhome, fbNNport)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if /i .%fbarch%.==.SS30. (
  set fbhome=%fb30sShome%
  set fbport=%fb30sSport%
) else if /i .%fbarch%.==.CS30. (
  set fbhome=%fb30Cshome%
  set fbport=%fb30Csport%
) else if /i .%fbarch%.==.SC30. (
  set fbhome=%fb30sChome%
  set fbport=%fb30sCport%
) else if /i .%fbarch%.==.SS25. (
  set fbhome=%fb25sShome%
  set fbport=%fb25sSport%
) else if /i .%fbarch%.==.CS25. (
  set fbhome=%fb25Cshome%
  set fbport=%fb25Csport%
) else if /i .%fbarch%.==.SC25. (
  set fbhome=%fb25sChome%
  set fbport=%fb25sCport%
)

echo Runtime parameters:
echo.
echo Used FB home: %fbhome%, port: %fbport%
echo Number of ISQL sessions: %worker_num%
echo.
echo Configurated parameters:
echo.
findstr /i /r /c:"^[^#;fb]" %~n0.conf
echo.

set fbvers=0
set equ_delimeter=
echo.%1 | findstr /c:"25">nul
if errorlevel 1 (
  set fbvers=30
  set equ_delimeter= = 
) else (
  set fbvers=25
)

if .%fbhome%.==.. goto syntax

md %tmpdir% 2>nul
del %tmpdir%\%~n0-*.log 2>nul

set tmpfile=%~n0_tmp.tmp
del %tmpfile% 2>nul

mtee /? 1>%tmpfile%
findstr /i /c "usage" %tmpfile% 1>nul 2>&1
if errorlevel 1 (
  del %tmpfile%
  echo.
  echo MTEE utility (Commandline Standard Stream Splitter^) is required for this batch.
  echo.
  echo Download it from http://www.commandline.co.uk/mtee/ and make it enable to call via PATH.
  echo.
  pause
  goto end
)
del %tmpfile%


@rem Name of auxiliary batch that is created here on basis of setting and organizes work
@rem of each launched ISQL session on the basis "connect => loop with echoes" + pipe result to ISQL
@rem (so called "worker-batch")
set auxbat=%~n0_worker.tmp.bat
del %auxbat% 2>nul

@rem File for being checked by each ISQL sessions, inside worker-batch loop.
@rem Also it will be stored timestapms of finish for every worker-batch instance
set stopfile=%~n0_stopping_log.txt
del %stopfile% 2>nul

@rem Config for trace:
set trccfg=%~n0_trace_cfg.tmp
del %trccfg% 2>nul

@rem Full log of trace since ISQL workers start:
set trclog=%~n0_trace_full.log
del %trclog% 2>nul

@rem What activity was in trace log after 1st occurence of 'shutdown':
set trcevn=%~n0_trace_after.log
del %trcevn% 2>nul

@rem Key phrases to analysis in logs:

set dml_run_msg=START_DML
set shut_point1=FIRST_POINT_OF_SHUTDOWN
set bye_bye_msg=BYE_BYE_FROM_WORKER_BAT
::bye-bye from %auxbat%

set dbpath=%~dp0
set dbname=%~n0_test_fdb.tmp


::---------------------------------------------------------
(
if .%fbvers%.==.25. (
  echo ^<database %%[\\/]%dbname% ^>
) else (
  echo database = %%[\\/]%dbname%
  echo {
)
echo    enabled %equ_delimeter% true
echo    log_errors %equ_delimeter% true
echo    log_connections %equ_delimeter% true
echo    log_transactions %equ_delimeter% true
echo    log_statement_prepare %equ_delimeter% true
echo    log_statement_start %equ_delimeter% true
echo    log_statement_finish %equ_delimeter% true
echo    log_statement_free %equ_delimeter% true
if .%fbvers%.==.25. (
  echo ^</database^>
) else (
  echo }
)
) > %trccfg%

::---------------------------------------------------------

::echo on
:: Generate statements in %auxbat%
(
  echo @echo off
  echo @rem Generated auto, do not edit. This batch is called from %~dp0%~nx0
  echo @rem This batch should be called like this:
  echo @rem %auxbat% ^| %fbhome%\isql -b -n -q 1^>^>%%log%% 2^>^>%%err%%
  echo setlocal enabledelayedexpansion enableextensions
  echo set this_id=%%1
  echo set this_log=%%2


  echo echo connect 'localhost/%fbport%:%dbpath%%dbname%' user 'SYSDBA' password 'masterkey';

  echo echo set echo on;
  echo echo show database;
  echo echo set bail on;
  echo echo commit;

  echo :m1
	  echo.
	  echo     echo -- Pause on each iter before checking that all attachments are here: %check_delay_ms% ms - is taken from CONFIG file for to %~nx0
	  echo     echo set echo on;
	  echo     echo -- ^^^!time^^^! - take pause %check_delay_ms% ms. . .
	  echo     echo set echo off;
	  echo.
	  echo     ping -n 1 -w %check_delay_ms% 1.1.1.1 ^>nul ^|^| time /t ^>nul
	  echo.
	  echo     echo set echo on;
	  echo     echo -- ^^^!time^^^! - yep, I'm here and check again who has came to us. . .
	  echo     echo set echo off;
	  echo.
	  echo     echo set list on;
	  echo     echo select current_transaction from rdb$database;
	  echo     echo set count on;
	  echo     echo set echo on;
	  echo     echo -- NB: this produce 'affected rows: 0' in 2.5.x when row already exist and UPDATE is done:
	  echo     echo update or insert into test(id^) values( -%%this_id%% ^) matching(id^); 
	  echo     echo set echo off;
	  echo     echo set count off;
	  echo     echo commit;
	  echo.
	  echo     echo set list off;
	  echo     echo set count on;
	  echo     echo select iif( abs(id^) = %%this_id%%, '*', ' '^) ^^^|^^^| abs(id^) as who_came from test where id ^^^< 0 order by abs(id^);
	  echo     echo set count off;
	  echo     echo set list on;
	  echo.
	  echo     echo set term ^^^^;
	  echo     echo execute block returns(msg varchar(100^)^) as
	  echo     echo     declare v_cnt int;
	  echo     echo     declare v_min int = %worker_num%; -- this is command-line argument for %~nx0
	  echo     echo     declare v_lim int = %limit_dml_rows%; -- this is from CONFIG file for %~nx0
	  echo     echo begin
	  echo     echo     select count( id ^) from test where id ^^^< 0 into v_cnt;
	  echo     echo     if ( v_cnt ^^^>= v_min ^) then
	  echo     echo         msg=cast('now' as timestamp^)^^^|^^^|' - all '^^^|^^^| v_min ^^^|^^^| ' attachments are here so I can %dml_run_msg%';
	  echo     echo     else
	  echo     echo         msg=cast('now' as timestamp^)^^^|^^^|' - NOT all of '^^^|^^^| v_min ^^^|^^^| ' come yet, only '^^^|^^^| v_cnt ^^^|^^^|'. I will wait for a while. . .';
	  echo     echo     suspend;
	  echo     echo end
	  echo     echo ^^^^
	  echo     echo set term ;^^^^
	  echo.
	  echo     echo set echo on;
	  echo     findstr "%dml_run_msg%" %%this_log%% 1^>nul
	  echo     if errorlevel 1 (
	  echo        echo -- ^^^!time^^^! Outer batch message: NOT all connect were established at this moment,
	  echo        echo --             or I'm not yet see last message from previous EB. Make ### .L.O.O.P.  ###
	  echo        goto m1
	  echo     ^) else (
	  echo        echo -- ^^^!time^^^! Outer batch message: ALL expected sessions are ready. Point before start DML.
	  echo     ^)
	  echo     echo set echo off;
	  echo.
	  echo     echo set echo on;
	  echo     echo set term ^^^^;
	  echo     echo execute block returns(msg varchar(100^)^) as
	  echo     echo     declare v_cnt int;
	  echo     echo     declare v_min int = %worker_num%; -- this is command-line argument for %~nx0
	  echo     echo     declare v_lim int = %limit_dml_rows%; -- this is from CONFIG file for %~nx0
	  echo     echo begin
	  echo     echo     select count( id ^) from test where id ^^^< 0 into v_cnt;
	  echo     echo     if ( v_cnt ^^^>= v_min ^) then
	  echo     echo         begin
	  echo     echo             msg=cast('now' as timestamp^)^^^|^^^|' - starting loop with DML.'; 
	  echo     echo             suspend;
	  echo     echo             while ( v_lim ^^^> 0 ^) do
	  echo     echo             begin
	  echo     echo                 -- insert into test( id ^) values( gen_id(g, 1^) ^);
	  echo     echo                 insert into fix(id, x, y, z, d, s ^)
	  echo     echo                 values( 
	  echo     echo                         gen_id( g, 1^) -- id
	  echo     echo                         ,rand(^) * 10000    -- x
	  echo     echo                         ,rand(^) * 10000    -- y
	  echo     echo                         ,rand(^) * 10000    -- z
	  echo     echo                         ,dateadd( cast(rand(^)*1000000 as int^) second to timestamp '01.01.2000 00:00:00'^)
	  echo     echo                         ,rpad('', 1 + rand(^)*49, uuid_to_char(gen_uuid(^)^) ^)  -- s
	  echo     echo                 ^); 
	  echo     echo                 v_lim = v_lim - 1;
	  echo     echo             end
	  echo     echo             msg=cast('now' as timestamp^)^^^|^^^|' - I finished and none had iterrupt me.';
	  echo     echo             suspend;
	  echo     echo         end
	  echo     echo     else
	  echo     echo         begin
	  echo     echo             msg=cast('now' as timestamp^)^^^|^^^|' - NOT all of '^^^|^^^| v_min ^^^|^^^| ' come yet, only '^^^|^^^| v_cnt ^^^|^^^|'. I will wait for a while. . .';
	  echo     echo             suspend;
	  echo     echo         end
	  echo     echo end
	  echo     echo ^^^^
	  echo     echo set term ;^^^^

	  echo     goto end

  echo goto m1

  echo :end
  
  echo.
  echo echo set echo on;
  echo echo -- %bye_bye_msg%
  echo.
  echo echo quit;
  echo.
  echo exit 
) >>%auxbat%

::          exit

::---------------------------------------------------------

:: Creating database and starting TRACE

del %dbpath%%dbname% 2>nul
echo create database 'localhost/%fbport%:%dbpath%%dbname%' page_size %page_size%; create table test(id int primary key^); create sequence g; show version; | %fbhome%\isql -q

if .%fw_on%.==.0. (
  %fbhome%\gfix -w async %dbpath%%dbname% -user sysdba -password masterkey
)


(
  echo recreate table fix(id int constraint fix_pk primary key, x int, y int, z int, d timestamp, s varchar(50^) ^);

  if /i .%loading_mode%.==.tiny. (
    echo commit;
  ) else if /i .%loading_mode%.==.small. (
    echo create index fix_idx_01 on fix( x ^);
    echo create descending index fix_idx_02 on fix( y ^);
  ) else if /i .%loading_mode%.==.middle. (
    echo create index fix_idx_01 on fix( x ^);
    echo create descending index fix_idx_02 on fix( y ^);
    echo create index fix_idx_03 on fix( d ^);
    echo create index fix_idx_04 on fix( s ^);
    echo create descending index fix_idx_05 on fix( id ^);
  ) else if /i .%loading_mode%.==.heavy. (
    echo create index fix_idx_01 on fix( y ^);
    echo create descending index fix_idx_02 on fix( y ^);
    echo create index fix_idx_03 on fix( d ^);
    echo create index fix_idx_04 on fix( s ^);
    echo create descending index fix_idx_05 on fix( id ^);
    echo create descending index fix_idx_06 on fix( z ^);
    echo create descending index fix_idx_07 on fix( d ^);
    echo create descending index fix_idx_08 on fix( s ^);
  )
  echo commit;
  echo set echo on;
  echo show table fix; 
  echo show index;
) >%tmpfile%

echo.
echo Creating table to be processed:
echo.
%fbhome%\isql -q localhost/%fbport%:%dbpath%%dbname% -i %tmpfile%

%fbhome%\gstat -h %dbpath%%dbname% -user sysdba -password masterkey | findstr /i /c:"page size" /c:"attributes"

(
  set trccmd=%fbhome%\fbsvcmgr localhost/%fbport%:service_mgr user sysdba password masterkey action_trace_start trc_cfg %trccfg% 1^>%trclog% 2^>^&1
  @echo Starting trace: !trccmd!
  start /min cmd /c !trccmd!
)

::---------------------------------------------------------

:: Starting ISQL sessions with adding timestamps to every produced messages - use utility MTEE

echo.
echo %time% - starting %worker_num% ISQL workers:
for /l %%i in (1, 1, %worker_num%) do (
  set /a k=1000+%%i
  @rem set wlog=%dbpath%%~n0-!k:~1,3!.log
  set wlog=%tmpdir%\%~n0-!k:~1,3!.log
  
  @rem set wcmd=%~dp0%auxbat% %%i !wlog! ^| %fbhome%\isql -b -q -n -pag 999 1^>!wlog! 2^>^&1

  @rem set run_isql=%fbc%\isql %dbconn% -now -q -n -pag 9999 -i %sql% %dbauth% 2^>^&1 1^>^>%log% ^| mtee /t/+ %err% ^>nul
  @rem set wcmd=%~dp0%auxbat% %%i !wlog! ^| %fbhome%\isql -b -q -n -pag 999 2^>^&1 1^>!wlog! ^| mtee /t ^>nul
  set wcmd=%~dp0%auxbat% %%i !wlog! ^| %fbhome%\isql -b -q -n -pag 999 2^>^&1 ^| mtee /t !wlog! ^>nul

  if .%%i.==.1. ( echo !time! - launch ISQL session # %%i: !wcmd! ) else ( echo !time! - launch ISQL session # %%i)
  start /min cmd /c !wcmd!

  @rem Add small delay before opening subsequent ISQL - avoid to establish too much connections at the same moment
  ping -n 1 -w %subseq_isql_delay% 1.1.1.1 1>nul 2>&1
)



:: ---------------------------------------------------------

@rem Now we have to periodically check that *each* of ISQL logs:
@rem 1) does exist (i.e. has been created in previous loop using start /min cmd /c ...)
@rem 2) does contain string '%dml_run_msg%'

:chk_all_dml_start
  echo.
  echo %time% - delay %check_delay_ms% ms before checking that all ISQLs did begin their DML
  echo.
  ping -n 1 -w %check_delay_ms% 1.1.1.1>nul
  set repeat=0
  for /l %%i in (1, 1, %worker_num%) do (
    set /a k=1000+%%i
    set wlog=%tmpdir%\%~n0-!k:~1,3!.log
    findstr "%dml_run_msg%" !wlog! 1>nul
    if errorlevel 1 (
      echo Not all of ISQL logs have required message about readiness to do their work. 
      echo Required string not found in !wlog!
      echo !time! - continue this checking after some pause.
      set repeat=1
      goto out_of_loop
    )
  )

:out_of_loop
  if .%repeat%.==.1. (
    echo !time! - out from checking loop, repeat=!repeat! - need to wait for rest ISQL sessions be ready.
    goto chk_all_dml_start
  ) else (
    echo !time! - all ISQL sessions have started their work. Now we can run shutdown process.
  )

echo.
echo %time% - delay %shut_delay% ms before starting to SHUTDOWN database - let ISQLs work for a while. . .
echo.
ping -n 1 -w %shut_delay% 1.1.1.1.>nul

echo.
echo %time% - get server version and fb_info:
echo on
%fbhome%\fbsvcmgr localhost/%fbport%:service_mgr user sysdba password masterkey info_server_version info_svr_db_info
@echo off

:: ---------------------------------------------------------

:: Starting SHUTDOWN process

set shut_beg=%time%
echo.
echo %time% - start shutdown, point just before run it:
@echo on
%fbhome%\fbsvcmgr localhost/%fbport%:service_mgr user sysdba password masterkey action_properties dbname %dbpath%%dbname% prp_shutdown_mode prp_sm_full prp_force_shutdown 0
@echo off
set shut_end=%time%
echo.
echo %time% - return from shutdown process.
echo.

for /f "tokens=1-3" %%i in ('%fbhome%\fbsvcmgr localhost/%fbport%:service_mgr user sysdba password masterkey action_trace_list ^| findstr "Session"') do (
  echo Trace ID to be stopped: %%k
  %fbhome%\fbsvcmgr localhost/%fbport%:service_mgr user sysdba password masterkey action_trace_stop trc_id %%k
)

@echo Wait %flush_log_delay% ms for FBSVCMGR will flush all its log on disk. . .
ping -n 1 -w %flush_log_delay% 1.1.1.1>nul

::---------------------------------------------------------------------

:: Parsing TRACE log: extract messages from it that are stored AFTER 1st message with 'shutdown' word:

echo|set /p=%time% - starting parse trace log, its size now: 
for /f "tokens=3-4" %%a in ('dir /-c %trclog% ^| findstr /i /c:"%trclog%"') do echo %%a %%b

for /f "tokens=1" %%a in ( 'findstr /R /N "^" %trclog% ^| find /c ":"' ) do set lines=%%a
set shutdn_1st_row=0
for /f "tokens=1 delims=:" %%a in ('type %trclog% ^| findstr /n /i "shutdown"') do (
  set /a shutdn_1st_row=%%a
  goto m1
)
:m1

echo.
echo Word "shutdown" found at line %shutdn_1st_row% of trace log %trclog%
echo.

set k=1
if %shutdn_1st_row% GTR 0 (
  echo Trace log after line %shutdn_1st_row% with statements that can be considered as activity:
  echo ------------------------------------------------------------------------------
  for /f "tokens=1-8 delims=:" %%a in ('type %trclog% ^| findstr /n /i "ATTACH_DATABASE START_TRANSACTION COMMIT_TRANSACTION PREPARE_STATEMENT EXECUTE_STATEMENT_START EXECUTE_STATEMENT_FINISH CLOSE_CURSOR FREE_STATEMENT"  ^| findstr /i /v "FAILED"') do (
    set /a row=%%a
    if !row! GTR %shutdn_1st_row% (
        set line=%%a: %%b %%b %%d %%e %%f %%g %%h
        echo !line!>>%trcevn%
        if !k! LSS 3 (
          echo !line! 
        ) else if !k! EQU 4 (
          echo . . . see more in file %trcevn% . . .
        )
        set /a k=!k!+1
        @rem %%a: %%b %%b %%d %%e %%f %%g %%h
    )
  )
  echo ------------------------------------------------------------------------------
  if !k! EQU 1 ( echo Looks strange: no events in trace after `shutdown` ?.. )
) else (
  echo TRACE LOG DOES NOT CONTAIN MESSAGE ABOUT SHUTDOWN, MAY BE IT WAS NOT ENTIRELY FLUSHED ON DISK.
  echo Increase value of 'flush_log_delay' setting, ms
  echo.
)

::---------------------------------------------------------------------

:: Extract timestamps of actual QUIT events from ISQL sessions (using prefixes that were added by `mtee` utility):

for /f %%a in ('dir /ON /b %tmpdir%\%~n0-???.log') do (
  for /f "tokens=*" %%i in ('findstr /i /c:"%bye_bye_msg%" %tmpdir%\%%a') do (
    set line=%%i
    echo !line:~0,12! %%a>>%stopfile%
    @rem set line=!line:SQL^> =!
    @rem echo !line:~3,11! %%a>>%stopfile%
  )
)
@rem Result: %stopfile% contains moments of '%bye_bye_msg%' from ISQL logs. Output it in ordered view:

set msg=Check timestamps when ISQL sessions were actually finishing
echo.
@echo %msg% in %stopfile%
echo.
type %stopfile% | sort > %tmpfile%

del %stopfile% 2>nul
(
  echo Runtime parameters:
  echo.
  echo Used FB home: %fbhome%, port: %fbport%
  echo Number of ISQL sessions: %worker_num%
  echo.
  echo Configurated parameters:
  echo.
  findstr /i /r /c:"^[^#;fb]" %~n0.conf
  echo.
) >>%stopfile%

echo Command on shutdown database was given at %shut_beg% >> %stopfile%
echo Control from shutdown process was back at %shut_beg% >> %stopfile%
echo.>> %stopfile%
echo %msg%: >> %stopfile%
echo.>> %stopfile%
type %tmpfile% >> %stopfile%
echo.>> %stopfile%
echo Details of ISQL sessions see in %tmpdir%\*.log >> %stopfile%


del %tmpfile% 2>nul


%fbhome%\gstat localhost/%fbport%:%dbpath%%dbname% -user sysdba -password masterkey -h | findstr /i "%dbname% Attributes"

::------------------------------------------------------------------------

:: Return to ONLINE and run validation:

echo %time% - before return database to online mode
@rem ::: CAN HANG, do NOT use it! ::: %fbhome%\gfix %dbpath%%dbname% -user sysdba -password masterkey -online
@echo on
%fbhome%\fbsvcmgr localhost/%fbport%:service_mgr user sysdba password masterkey action_properties dbname %dbpath%%dbname% prp_db_online
@echo off
echo %time% - after return database to online mode

@rem %fbhome%\gfix localhost/%fbport%:%dbpath%%dbname% -user sysdba -password masterkey -online
echo show sequ;|%fbhome%\isql localhost/%fbport%:%dbpath%%dbname%
echo.
echo %time% - run validation of database:
%fbhome%\fbsvcmgr.exe localhost/%fbport%:service_mgr user sysdba password masterke ^
    action_validate dbname %dbpath%%dbname%

del %trccfg% 2>nul

::------------------------------------------------------------------------

:: Counting number of logs which contain phrase about internal FB consist. check:

set /a fbcc=0
for /f %%a in ('dir /b %tmpdir%\%~n0-???.log') do (
  findstr /i /c:"internal Firebird consistency check" %tmpdir%\%%a >nul
  if not errorlevel 1 (
     @rem if !fbcc! GTR 0 del /q %%a
     set /a fbcc=!fbcc!+1
  ) else (
     @rem del /q %%a
  )
)
if %fbcc% GTR 0 echo Found message "internal Firebird consistency check" in %fbcc% logs.

::-------------------------------------------------------------------------

:: === F I N I S H  ===

goto end

:readcfg

set cfg=%1
for /F "tokens=*" %%a in ('findstr /i /r /c:"^[ 	]*[a-z,0-9]" %cfg%') do (
  if "%%a" neq "" (

    @rem Detect whether value of parameter contain quotes or no. If yes than this
    @rem value should NOT be changed by removing its whitespaces.

    echo %%a|find """">nul

    if errorlevel 1 ( 
      @rem @echo ^|%%a^| - does NOT contain quotes
      for /F "tokens=1-2 delims==" %%i in ("%%a") do (
        @rem echo Parsed-NON-quoted: param="%%i" val="%%j"
        if "%%j"=="" (
          set err_setenv=1
          echo. && echo ### NO VALUE found for parameter "%%i" ### && echo.
        ) else (

          @rem _NAME_ and _VALUE_ of parameter (both can be with leading and trailing whitespaces):
          set par=%%i
          set val=%%j

          @rem -----------------------------------
          @rem When "delims=" clause is NOT specified then default delimeters are TAB and SPACE.
          @rem If we take 1st token from such string than it will be WITHOUT whitespaces.
          @rem Similarly for _VALUE_ of parameter:
          @rem -----------------------------------
          for /F "tokens=1" %%p in ("!par!") do (
            @rem echo param=^|%%i^|, name w/o white-spaces=^|%%p^|
            for /F "tokens=1" %%u in ("!val!") do (
              set %%p=%%u
              @rem echo param=^|%%p^|, value w/o white-spaces=^|%%u^|
            )
          )
        )
      )

    ) else (

      @rem @echo ^|%%a^| - DOES contain quotes
      for /F "tokens=1-2 delims==" %%i in ("%%a") do (
        @rem echo Parsed-quoted: param="%%i" val="%%j"
        set par=%%i

        if "%%j"=="" (
          set err_setenv=1
          echo. && echo ### NO VALUE found for parameter "%%i" ### && echo.
        ) else (
          @rem We can remove all white-spaces only from _NAME_ of parameter
          @rem but NOT from its _VALUE_
          for /F "tokens=1" %%p in ("!par!") do (
            set %%p=%%j
            @rem echo param=^|%%p^|, value w/o white-spaces=^|%%j^|
          )
        )
      )
    )
  )
)
goto:eof

:noconf
  @echo off
  cls
  echo.
  echo Config file %~n0.conf is missed.
  echo.
  pause
  goto end
:syntax
  @echo off
  cls
  echo.
  echo Syntax: %~nx0 ^<FB^> ^<NN^> ^| mtee /t ^<log^>
  echo.
  echo where:
  echo   ^<FB^>  is case-insensitive abbrev. of architecture ( SS ^| SC ^|CS) concatenated with FB version ( 25 ^| 30 );
  echo   ^<NN^>  is number of opening ISQL sessions;
  echo   ^<log^> is name of log file that should store console output.
  echo.
  echo Usage samples:
  echo.
  echo 1) test FB 2.5 Classic with opening 20 ISQL sessions: 
  echo.
  echo    %~nx0 cs25 20 ^| mtee /t %~n0_cs25_att20.log
  echo.
  echo 2) test FB 3.0 SuperClassic with opening 35 ISQL sessions:
  echo.
  echo    %~nx0 ss30 35 ^| mtee /t %~n0_sc30_att35.log
  echo.
  echo 3) test FB 3.0 Super with opening 40 ISQL sessions:   
  echo.
  echo    %~nx0 ss30 40 ^| mtee /t %~n0_ss30_att40.log
  echo.
  echo ------------------------------------------------
  echo.
  echo ### N.O.T.E.S ###
  echo.
  echo 1. Ensure that you have MTEE.EXE -- Standard Stream Splitter for Windows
  echo    Download it from http://www.commandline.co.uk/mtee/ and make it enable to call via PATH.
  echo.
  echo 2. Verify content of file %~n0.conf and correct its settings appropriately.
  echo.
  pause
  goto end
:end
