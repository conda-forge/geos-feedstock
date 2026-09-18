:: Configure.
:: Note that CMAKE_ARGS defines: CMAKE_BUILD_TYPE, CMAKE_INSTALL_PREFIX, CMAKE_INSTALL_LIBDIR, etc.
cmake %CMAKE_ARGS% ^
      -G Ninja ^
      -D BUILD_SHARED_LIBS=ON ^
      -D BUILD_TESTING=ON ^
      -S %SRC_DIR% -B build
if errorlevel 1 exit 1

:: Build.
cmake --build build
if errorlevel 1 exit 1

:: Test.
cd build
ctest --output-on-failure
if errorlevel 1 exit 1
cd ..

:: Install.
cmake --install build
if errorlevel 1 exit 1
