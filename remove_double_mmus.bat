@echo off

REM SPDX-License-Identifier: MIT
REM The content of this file has been developed in the context of the MOSIM research project.
REM Original author(s): Bhuvaneshwaran Ilanthirayan

set "basepath=.\\build\\Environment\\MMUs"

RMDIR /s/q %basepath%\\CarryMMU
RMDIR /s/q %basepath%\\CarryMMUNested
RMDIR /s/q %basepath%\\CarryMMUSimple
RMDIR /s/q %basepath%\\MoveMMU
RMDIR /s/q %basepath%\\MoveMMUSimple
RMDIR /s/q %basepath%\\ReachMMU
RMDIR /s/q %basepath%\\ReleaseMMU
