@echo off
SET scriptPath=%~dp0Find_Mac_Device_IP.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%scriptPath%'"
#pause # kod tamamlandıktan sonra açık olan ve Press any key to continue . . . yazısı kalan cmd terminalini kapatmak için pause kullanılmamalıdır. Eger pencerenin acık kalması isteniyorsa # işareti kaldırılarak pause kullanılmalıdır.