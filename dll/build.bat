call "%VS120COMNTOOLS%vsvars32.bat"

cl gm82joy.c /O1 /GS- /nologo /link /nologo /dll /out:gm82joy.dll

pause