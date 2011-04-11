#!/bin/bash

../../../robust ../src/base/ic.v -od out -I ../src/gen -list iclist.txt -listpath -header

echo Completed RobustVerilog fabric run - results in run/out/
