@echo off
rem Raja script
mode con: cols=180 lines=70
Title User Account Lockout Finder
powershell.exe -executionpolicy Bypass -command "& 'C:\path\to\AccountLock_Script.ps1'" > "C:\path\to\Lockeduser_Info.txt"






