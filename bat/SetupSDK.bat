:user_configuration

:: Path to Flex SDK
set AIR_SDK=C:\SDK\AIR\AIR3.7


:validation
if not exist "%AIR_SDK%" goto flexsdk
goto succeed

:flexsdk
echo.
echo ERROR: incorrect path to Flex SDK in 'bat\SetupSDK.bat'
echo.
echo %AIR_SDK%
echo.
if %PAUSE_ERRORS%==1 pause
exit

:succeed
set PATH=%PATH%;%AIR_SDK%\bin

