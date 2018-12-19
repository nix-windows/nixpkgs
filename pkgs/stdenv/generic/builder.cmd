md %out%

rem echo set shell=%shell%                                        > %out%\setup.cmd
rem echo set initialPath=%initialPath%                           >> %out%\setup.cmd
rem echo set defaultNativeBuildInputs=%defaultNativeBuildInputs% >> %out%\setup.cmd
rem echo set defaultBuildInputs=%defaultBuildInputs%             >> %out%\setup.cmd
rem
rem rem echo rem begin preHook                                   >> %out%\setup.cmd
rem rem echo %preHook%                                           >> %out%\setup.cmd
rem rem echo rem end preHook                                     >> %out%\setup.cmd
rem
rem echo rem begin setup                                         >> %out%\setup.cmd
rem type %setup%                                                 >> %out%\setup.cmd
rem echo rem end setup                                           >> %out%\setup.cmd
