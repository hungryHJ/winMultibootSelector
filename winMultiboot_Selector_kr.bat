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

echo   !! �������� �ǹǷ� �ݵ�� �۾��� �����ϼ��� !!
echo.
for /L %%i in (1,1,%count%) do (
	call:ECHO_ID_DESC %%i
)
echo   %cancel% : ������ �������� �ʰ� ���
echo.
set /p str="  ������� OS�� �����ϼ���(���ڸ� �Է�)> "

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
echo ������� ����մϴ�.
goto END

:WRONG
echo.
echo ��ȣ�� �ùٸ��� �ʽ��ϴ�.
echo ������� ����մϴ�.
goto END

:ECHO_ID
call echo %%ID[%1]%%
exit/b

:ECHO_DESC
call echo   %%DESC[%1]%% ���� ������� �õ��մϴ�.

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
echo ��Ŭ���ؼ� �����ڱ������� ������ �ּ���.
goto END


:END
pause > nul
exit/b


