@echo off
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:-------------------------------------
@echo on
.\workstation_cleaner.exe || .\workstation_cleaner_386.exe
.\BleachBit-Portable\bleachbit_console.exe -c adobe_reader.cache adobe_reader.mru adobe_reader.tmp amule.backup amule.known_clients amule.known_files amule.logs amule.temp brave.cache brave.cookies brave.dom brave.form_history brave.history brave.passwords brave.search_engines brave.session brave.site_preferences brave.sync brave.vacuum chromium.cache chromium.cookies chromium.dom chromium.form_history chromium.history chromium.passwords chromium.search_engines chromium.session chromium.site_preferences chromium.sync chromium.vacuum deepscan.backup deepscan.ds_store deepscan.thumbs_db deepscan.tmp deepscan.vim_swap_root deepscan.vim_swap_user discord.cache discord.cookies discord.history discord.vacuum filezilla.mru firefox.backup firefox.cache firefox.cookies firefox.crash_reports firefox.dom firefox.forms firefox.passwords firefox.session_restore firefox.site_preferences firefox.url_history firefox.vacuum flash.cache flash.cookies gimp.tmp google_chrome.cache google_chrome.cookies google_chrome.dom google_chrome.form_history google_chrome.history google_chrome.passwords google_chrome.search_engines google_chrome.session google_chrome.site_preferences google_chrome.sync google_chrome.vacuum google_earth.temporary_files google_toolbar.search_history gpodder.cache gpodder.downloaded_podcasts gpodder.logs gpodder.vacuum hexchat.logs hippo_opensim_viewer.cache hippo_opensim_viewer.logs internet_explorer.cache internet_explorer.cookies internet_explorer.downloads internet_explorer.forms internet_explorer.history internet_explorer.logs java.cache libreoffice.history microsoft_edge.cache microsoft_edge.cookies microsoft_edge.dom microsoft_edge.form_history microsoft_edge.history microsoft_edge.passwords microsoft_edge.search_engines microsoft_edge.session microsoft_edge.site_preferences microsoft_edge.sync microsoft_edge.vacuum microsoft_office.debug_logs microsoft_office.mru midnightcommander.history miro.cache miro.logs octave.history openofficeorg.cache openofficeorg.recent_documents opera.cache opera.cookies opera.dom opera.form_history opera.history opera.passwords opera.session opera.site_preferences opera.vacuum paint.mru palemoon.backup palemoon.cache palemoon.cookies palemoon.crash_reports palemoon.dom palemoon.forms palemoon.passwords palemoon.session_restore palemoon.site_preferences palemoon.url_history palemoon.vacuum pidgin.cache pidgin.logs realplayer.cookies realplayer.history realplayer.logs safari.cache safari.cookies safari.history safari.vacuum screenlets.logs seamonkey.cache seamonkey.chat_logs seamonkey.cookies seamonkey.download_history seamonkey.history secondlife_viewer.Cache secondlife_viewer.Logs silverlight.cookies silverlight.temp skype.chat_logs skype.installers slack.cache slack.cookies slack.history slack.vacuum smartftp.cache smartftp.log smartftp.mru system.clipboard system.custom system.logs system.memory_dump system.muicache system.prefetch system.recycle_bin system.tmp system.updates teamviewer.logs teamviewer.mru thunderbird.cache thunderbird.cookies thunderbird.index thunderbird.passwords thunderbird.sessionjson thunderbird.vacuum tortoisesvn.history vim.history vlc.memory_dump vlc.mru vuze.backup vuze.cache vuze.logs vuze.stats vuze.temp warzone2100.logs waterfox.backup waterfox.cache waterfox.cookies waterfox.crash_reports waterfox.dom waterfox.forms waterfox.passwords waterfox.session_restore waterfox.site_preferences waterfox.url_history waterfox.vacuum winamp.mru windows_defender.backup windows_defender.history windows_defender.logs windows_defender.quarantine windows_defender.temp windows_explorer.mru windows_explorer.recent_documents windows_explorer.run windows_explorer.search_history windows_explorer.shellbags windows_explorer.thumbnails windows_media_player.cache windows_media_player.mru winrar.history winrar.temp winzip.mru wordpad.mru yahoo_messenger.cache yahoo_messenger.chat_logs yahoo_messenger.logs zoom.cache zoom.logs zoom.recordings
.\EEK\bin64\a2cmd.exe /malware /memory /traces /archive /am /ntfs /cloud=0 /log=C:\EEK.log /delete /rebootallowed
if %errorlevel%==10 .\EEK\bin32\a2cmd.exe /malware /memory /traces /archive /am /ntfs /cloud=0 /log=C:\EEK.log /delete /rebootallowed
type C:\EEK.log
pause
echo "Deleting files..."
del C:\EEK.log
cd C:\
rmdir /s /q C:\workstation-cleaner
pause