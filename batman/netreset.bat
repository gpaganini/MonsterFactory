@echo on
NETSH INT IP RESET all
NETSH WINSOCK RESET all
ipconfig /release
ipconfig /flushdns
ipconfig /renew
