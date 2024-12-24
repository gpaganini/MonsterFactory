@echo off
rem Raja script
mode con: cols=180 lines=70
Title User Account Lockout Finder
powershell.exe -executionpolicy Bypass -command "& 'C:\Users\giovani.paganini\Documents\powershellson\ad\Lockout Finder\AccountLock_Script.ps1'" > "C:\Users\giovani.paganini\Documents\powershellson\ad\Lockout Finder\Lockeduser_Info.txt"






