
echo off

..\..\..\robust.exe ../src/base/ic.v -od out -I ../src/gen -list list.txt -listpath -header

echo Completed RobustVerilog fabric run - results in run/out/
