@echo off

set DO_E2E=%1

echo:
echo ####### RESTFUL-BOOKER-PLATFORM #######
echo ####                               ####
echo ####    STARTING APPLICATION...    ####
echo ####                               ####
echo #######################################
echo:


@echo off

for %%a in (auth\target\*-exec.jar) do set "auth_jar=%%a"
START /B java -Dspring.profiles.active=dev -jar "%auth_jar%" > auth.log 2>&1

for %%a in (booking\target\*-exec.jar) do set "booking_jar=%%a"
START /B java -Dspring.profiles.active=dev -jar "%booking_jar%" > booking.log 2>&1

for %%a in (room\target\*-exec.jar) do set "room_jar=%%a"
START /B java -Dspring.profiles.active=dev -jar "%room_jar%" > room.log 2>&1

for %%a in (report\target\*-exec.jar) do set "report_jar=%%a"
START /B java -Dspring.profiles.active=dev -jar "%report_jar%" > report.log 2>&1

for %%a in (branding\target\*-exec.jar) do set "branding_jar=%%a"
START /B java -Dspring.profiles.active=dev -jar "%branding_jar%" > branding.log 2>&1

for %%a in (message\target\*-exec.jar) do set "message_jar=%%a"
START /B java -Dspring.profiles.active=dev -jar "%message_jar%" > message.log 2>&1


cd assets
START /B npm run dev

cd ..

call node .utilities/monitor/local_monitor.js

echo:
echo \n
echo ####### RESTFUL-BOOKER-PLATFORM #######
echo ####                               ####
echo ####    RUNNING E2E CHECKS         ####
echo ####                               ####
echo #######################################

if "%DO_E2E%" == "true" (
  cd %cmdFileDirectory%end-to-end-tests
  call mvn clean test
  cd ..
) else (
  echo:
  echo:         SKIPPING E2E TESTS
  echo:  Add true argument to run E2E tests
)

echo:
echo ####### RESTFUL-BOOKER-PLATFORM #######
echo ####                               ####
echo ####      APPLICATION READY        ####
echo ####                               ####
echo ####         Available at:         ####
echo ####     http://localhost:3003     ####
echo ####                               ####
echo ####      PRESS ENTER TO QUIT      ####
echo ####                               ####
echo #######################################
echo:
set /p=

echo Exiting Restful-booker-platform....
taskkill /f /im java.exe
taskkill /f /im node.exe