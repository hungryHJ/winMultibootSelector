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

echo   !! 강제종료 되므로 반드시 작업을 저장하세요 !!
echo.
for /L %%i in (1,1,%count%) do (
	call:ECHO_ID_DESC %%i
)
echo   %cancel% : 윈도우 종료하지 않고 취소
echo.
set /p str="  재부팅할 OS를 선택하세요(숫자만 입력)> "

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
echo 재부팅을 취소합니다.
goto END

:WRONG
echo.
echo 번호가 올바르지 않습니다.
echo 재부팅을 취소합니다.
goto END

:ECHO_ID
call echo %%ID[%1]%%
exit/b

:ECHO_DESC
call echo   %%DESC[%1]%% 으로 재부팅을 시도합니다.

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
echo 우클릭해서 관리자권한으로 실행해 주세요.
goto END


:END
pause > nul
exit/b


