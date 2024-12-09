open VS developer CLI to have all the tools available to the commadns and all the vscode linkers and compilers at hand.

cd C:\Users\SavageX6\Desktop\PythonBuilder\Tools\msi\
get_externals.bat


cd C:\Users\SavageX6\Desktop\PythonBuilder\PCbuild\
get_externals.bat




cd C:\Users\SavageX6\Desktop\PythonBuilder\PCbuild

build.bat --regen
build.bat -m -p x64 --regen
build.bat
build.bat -m -p x64
build.bat -m -p x64 --pgo-job "-m test --pgo"
build.bat -m -p x64 --pgo
rt.bat -q



cd C:\Users\SavageX6\Desktop\PythonBuilder\PCbuild\amd64\

python.exe -m test -u all


cd C:\Users\SavageX6\Desktop\PythonBuilder\Doc
make.bat html


cd C:\Users\SavageX6\Desktop\PythonBuilder\Tools\msi\

buildrelease.bat -x64

cd C:\Users\SavageX6\Desktop\PythonBuilder\Tools\msi\bundle


msbuild releaseweb.wixproj /p:BuildForRelease=true
msbuild releaselocal.wixproj /p:BuildForRelease=true


the installers will be located at: 
C:\Users\SavageX6\Desktop\PythonBuilder\PCbuild\amd64\en-us

