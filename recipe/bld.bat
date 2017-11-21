mkdir build
cd build

:: this is probably not the right revision.  I'm not sure how much it matters - just incorrect info.
::    This should be generatable but requires a bash shell
echo #define GEOS_REVISION "0" > geos_revision.h


:: Configure.
cmake -G "%CMAKE_GENERATOR%" ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D GEOS_BUILD_STATIC=OFF ^
      %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
ctest -C Release
if errorlevel 1 exit 1
