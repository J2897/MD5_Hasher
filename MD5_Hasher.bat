:: Released under the GNU General Public License version 3 by J2897.

@echo OFF
pushd "%~dp0"
cls

REM Get the OS #-Bit...
set BIT=64
if %PROCESSOR_ARCHITECTURE% == x86 (
	if not defined PROCESSOR_ARCHITEW6432 (set BIT=32)
)

REM Set the appropriate md5deep executable...
if %BIT% == 64 (
	(set MD5DEEP_EXE="%CD%\md5deep\md5deep64.exe") 
) else (
	(set MD5DEEP_EXE="%CD%\md5deep\md5deep.exe")
)

set FILES_2_B_HASHED="%CD%\hashed"
set HASH_DB="%CD%\hashes.dat"
set TEMP_HASH_DB="%CD%\temp_hashes.dat"

REM Create a FILES_2_B_HASHED folder if necessary...
if not exist %FILES_2_B_HASHED% (
	(md %FILES_2_B_HASHED%)
)

echo Place the "files to be hashed" inside this folder...
echo %FILES_2_B_HASHED%
echo.
start %WINDIR%\explorer.exe %FILES_2_B_HASHED%
pause

REM Generate a HASH_DB file from the files in the FILES_2_B_HASHED folder...
if exist %HASH_DB% (
	(%MD5DEEP_EXE% -X %HASH_DB% -b -r %FILES_2_B_HASHED% > %TEMP_HASH_DB%)
) else (
	(%MD5DEEP_EXE% -b -r %FILES_2_B_HASHED% > %HASH_DB%) && (goto :End)
)

REM Append the Hashes in the TEMP_HASH_DB file to the HASH_DB file...
type %TEMP_HASH_DB% >> %HASH_DB%

REM Delete the TEMP_HASH_DB file...
del %TEMP_HASH_DB%

:End
popd

start %WINDIR%\system32\notepad.exe %HASH_DB%
