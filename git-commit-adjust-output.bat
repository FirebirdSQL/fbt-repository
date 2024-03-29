@echo off
setlocal enabledelayedexpansion enableextensions
set fbt_tests_root=C:\MIX\firebird\QA\fpt-repo\tests\
set file_ext=^<fbt_file^>
set git_text=Updated "!file_ext!": adjust expected stdout/stderr to current FB version.
if .%1.==.. goto syntax

set fbt_file=%1

if NOT .%2.==.. (
    set /a i=0
    @rem echo all inp arguments: ^|"%*"^|
    for /f "tokens=1* delims= " %%a in ("%*") do (
        set customer_comment=%%b
    )
    @rem echo customer  comment: ^|!customer_comment!^|

    set git_text=Added/Updated "!file_ext!": !customer_comment!
)

set joblog=%~dpn0.log
set tmplog=%~dpn0.tmp

del !joblog! 2>nul
del !tmplog! 2>nul

for /f %%a in ("!fbt_file!") do (
    @rem set file_ext=%%~nxa
    set file_ext=%%a
    set text_chk=!file_ext:%fbt_tests_root%=!
    if .!text_chk!.==.!file_ext!. (
        @rem .fbt was specified WITHOUT path
        set file_ext=%cd%\!file_ext!
    ) 
    set file_ext=!file_ext:%fbt_tests_root%=!

)
set git_text=!git_text:^<fbt_file^>=%file_ext%!

(
    echo Log for: %~f0 !fbt_file!
    echo Created !date! !time! on host '%COMPUTERNAME%'
    echo.
    echo Comment is: git_text=!git_text!
) >>!joblog!

set msg=!date! !time! Processing command: git add !fbt_file!
echo !msg!
echo !msg!>>!joblog!

@rem ############################
@rem ###    g i t    a d d    ###
@rem ############################
git add !fbt_file! 1>!tmplog! 2>&1
set /a elevel=!errorlevel!
echo elevel=!elevel!
echo elevel=!elevel!>>!joblog!

type !tmplog!
type !tmplog! >>!joblog!

if !elevel! GTR 0 (
   echo ERROR OCCURED. Check log:
   echo -------------------------
   type !tmplog!
   echo -------------------------
   del !tmplog!
   goto :final
)

git status !fbt_file! 1>>!joblog! 2>&1

set msg=!date! !time! Processing command: git commit -m "!git_text!" -- !fbt_file!
echo !msg!
echo !msg!>>!joblog!

@rem ##################################
@rem ###    g i t    c o m m i t    ###
@rem ##################################
git commit -m "!git_text!" -- !fbt_file! 1>!tmplog! 2>&1
set elevel=!errorlevel!
echo elevel=!elevel!
echo elevel=!elevel!>>!joblog!
type !tmplog! >>!joblog!
if !elevel! GTR 0 (
   echo ERROR OCCURED. Check log:
   echo -------------------------
   type !tmplog!
   echo -------------------------
   del !tmplog!
   goto :final
)


set msg=!date! !time! Processing command: git push 
echo !msg!
echo !msg!>>!joblog!

@rem ##############################
@rem ###    g i t    p u s h    ###
@rem ##############################
git push 1>!tmplog! 2>&1
set elevel=!errorlevel!
echo elevel=!elevel!
echo elevel=!elevel!>>!joblog!
type !tmplog! >>!joblog!
if !elevel! GTR 0 (
   echo ERROR OCCURED. Check log:
   echo -------------------------
   type !tmplog!
   echo -------------------------
   del !tmplog!
   goto :final
)

del !tmplog! 2>nul

echo ------ OVERALL LOG: --------
type !joblog!
echo ----------------------------

set msg=!date! !time! Check result of commits here:
echo !msg!
git config --get remote.origin.url
(
    echo !msg!
    git config --get remote.origin.url
) >> !joblog!

@rem #######################################
@rem ###    s e n d i n g     m a i l    ###
@rem #######################################
call %~dp0qa-sendmail.bat "!git_text!" !joblog!

@rem https://github.com/FirebirdSQL/fbt-repository.git

goto final

:syntax
    echo.
    echo Syntax: 
    echo 1. %~f0 ^<fbt_file^>
    echo.
    echo.    Commit will be done with comment:
    echo.    !git_text!
    echo.
    echo.
    echo 2. %~f0 ^<fbt_file^> some very clever comment here
    echo.
    echo.    Commit will be done with comment:
    echo.    some very clever comment here
    echo.
    pause
    goto final
:final
    echo Bye-bye from %~f0

