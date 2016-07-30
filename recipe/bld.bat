mkdir build
cd build

:: Configure.
cmake -G "NMake Makefiles" ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D CMAKE_BUILD_TYPE=Release ^
      %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
nmake
if errorlevel 1 exit 1

:: Test.
ctest
if errorlevel 1 exit 1

:: Install.
nmake install
if errorlevel 1 exit 1


copy lib\*.exp %LIBRARY_LIB%\ || exit 1
copy lib\*.lib %LIBRARY_LIB%\ || exit 1
copy include\geos.h %LIBRARY_INC%\geos.h || exit 1
