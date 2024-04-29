@echo off
setlocal
color 1f

echo   //////////////////////////////////
echo  //  Windows Multiboot Selector  //
echo //////////////////////////////////
echo.


bcdedit >>nul 
if %errorlevel% == 1 goto NOADMIN 


set count=0

rem Get 'identifier' and 'decription' and save 'ID[n]' and 'DESC[n]' (n is number)
for /f "usebackq tokens=1*" %%i  in (`bcdedit`) do (
	if "%%i"=="identifier" (
		if not "%%j"=="{bootmgr}" (
			set /a count+=1
			call:SET_ID %%j
		)
	)
	if "%%i"=="description" (
		if not "%%j"=="Windows Boot Manager" (
			call:SET_DESC %%j
		)
	)
)
set /a cancel=%count%+1

echo   !! Be sure to save your work as it will force shutdown. !!
echo.
for /L %%i in (1,1,%count%) do (
	call:ECHO_ID_DESC %%i
)
echo   %cancel% : Cancel without shutting down this windows.
echo.
set /p str="  Select OS to reboot(only number)> "

if "%str%"=="%cancel%" (
	goto NO
) else if "%str%" gtr "%cancel%" (
	goto WRONG
) else (
	echo.
	for /L %%i in (%str%,1,%str%) do (
		call:ECHO_DESC %%i
		call:REBOOT %%i
	)
	rem bcdedit /default "%target%"
	rem shutdown /r /t 0
)
exit/b


:REBOOT
call bcdedit /default %%ID[%1]%%
shutdown /r /t 0
goto END
exit/b

:NO
echo.
echo Cancel rebooting.
goto END

:WRONG
echo.
echo Wrong number.
echo Cancel rebooting.
goto END

:ECHO_ID
call echo %%ID[%1]%%
exit/b

:ECHO_DESC
call echo   Try rebooting into %%DESC[%1]%%.
exit/b

:ECHO_ID_DESC
call echo   %1 : %%DESC[%1]%% : %%ID[%1]%%
exit/b

:SET_ID
set ID[%count%]=%1
exit/b

:SET_DESC
set DESC[%count%]=%*
exit/b

:NOADMIN
echo Please run as administrator.
goto END


:END
pause > nul
exit/b


