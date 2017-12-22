 Sentry 2.0
 ----------

  Labeled Sentry 2.0 Beta RC 7+++ to Sentry 2.0 

 Sentry 2.0 Beta (RC 7+++)
 -------------------------

  - Fixed bug when Specific Response is cleared in Proxy Analyzer. Defaults now back to 401. (Eternal)
  - Fixed bug with Reload Settings in Progression Frame. (Eternal)
  - If using Header Key Phrases, you can now use Source Key Phrases also.
  - Fixed minor bug when appending '/' at the end of URL's with '?' in them.
  - Fixed bug when no POST Data was extracted with Refresh Session Data's GET Request.

 Sentry 2.0 Beta (RC 7++) (15-4-05)
 ------------------------

  - Fixed bug when using Global Failure Key Phrases when Source Failure Key Phrases was empty. (Psykodelik)
  - Fixed graphical bug in About Box. (Psykodelik)
  - Fixed My List Statistics bug. (Psykodelik)
  - Made Blacklist multiselect.
  - Fixed bug when sending Proxies To Blacklist in Analyzer and My List. Ports were not trimmed. (Psykodelik)
  - History is now linked with Progression Frame, so you can see your new hits when you go to the History Frame
    while a bruteforce session is being run.
  - Upgraded History Saving. History is now saved when the Progression Frame is freed. (Eternal)
  - Upgraded Form Parsing Engine.
  - Fixed nag screen about not building a correct header with POST Requests. (chillerz)
  - Fixed bug when sending a POST Request in HTTP Debugger and not filling out POST Data. (chillerz)
  - Fixed bug if User-Agent List file did not exist. (chillerz)
  - Added Send To HTTP Debugger in My List and Proxy Analyzer.

 Sentry 2.0 Beta (RC 7+) (8-4-05)
 -----------------------

  - Added POST Data to Popup Memo.
  - Added Sent Header to Debug Data.
  - POST Request Wizard now follows redirects.
  - Fixed bug when refreshing cookies in POST Requests.
  - Added Right Click Menu to Blacklist.
  - Added Delete Selected Proxies in Blacklist.
  - Added Send Proxies To Blacklist in Analyzer and My List. (splendidly_null)

 Sentry 2.0 Beta (RC 7) (2-4-05)
 ----------------------

  - Fixed bug when an engine completed and you were not at the engine's frame, the frame would never be freed.
    This was the cause for the History Frame unable to be displayed. 
  - Fixed bug which caused a rare chance of changing a site without Sentry not resetting some features (form data,
    and wordlist position).
  - Fixed bug which caused some redirects not to be followed.
  - Added Send Proxies To Analyzer in My List Frame in Right Click Menu. (splendidly_null)
  - Added Load Settings From Snap Shot and Save Settings From Snap Shot.
  - Fixed bug when saving wordlist to SnapShot if the wordlist's name contained a '.'.
  - Removed POST Data sanity check when exiting HTTP Header Frame.
  - Fixed bug with POST Wizard when username or password fields had a value in them. (sPlico)
  - POST Wizard now automatically analyzes the site if the Form Data is blank. (sPlico)
  - POST Wizard now loads data from the previous time. (sPlico)
  - Fixed bug with HTTP Basic Auth with HTTP Debugger. It didn't work because of a RC 6+ change. (Psykodelik)
  - Fixed bug when banning a proxy in Progression Frame when list was empty. It added a blank line.

 Sentry 2.0 Beta (RC 6+) (13-3-05)
 ----------------------
  
  - Fixed POST requests. They didn't work in previous releases.
  - Fixed bug when banning a proxy in Progression Frame when list was empty.
  - Fixed bug when selecting Edit Keyword and the Keyword list is empty. (splendidly_null)
  - Fixed bug when using Custom Headers with POST. This applied to the bruteforcer as well. (Itchy)
  - Fixed bug when running a combo list with less combos than bots. Dynamic bots were created.
  - Fixed bug when clearing banned proxies from My List. It didn't remove them from Statistic's Window. (hottshotz)
  - Upgraded Form Parser wizard.

 Sentry 2.0 Beta (RC 6) (02-3-05)
 ----------------------

  - Implemented Server banner on bruteforce sessions.
  - Fixed bug with Ban Proxy in Progression Frame hit/fake/redirect boxes. (splendidly_null)
  - Fixed bug when changing the site and having the progression frame focused, it would not reset wordlist position.
  - Fixed ntdll.dll bug when aborting a test. This happened because a snapshot was created with the wordlist
    name incorrectly. (splendidly_null)
  - Added save feature to Blacklist.
  - Updated Proxy Analyzer to be compliant with azenv 1.03.
  - Fixed small bug when reimporting proxies from Charon to Sentry which were previously marked as anon by Sentry but
    unchecked by Charon were marked as bad.

 Sentry 2.0 Beta (RC 5) (21-2-05)
 ----------------------

  - Updated Splash Screen Image. (Thanks Maximum)
  - Inserted some debug code to give more accurate bug reports.
  - Added minimize to tray. (Malu)
  - Fixed bug when redirects are added to redirect window. The '@' was missing. (splendidly_null)
  - Major improvements in Form Engine.
  - Added some bot debug info in Debug Engine form.
  - Added option to ban proxy and add to blacklist in Progression Frame hit/fake/redirect boxes. (Eternal, Malu)
  - Implemented Proxy Blacklist.
  - Fixed bug where judgement state of the bot was not being cleared after retries. I don't think this affected the
    Basic Engine, but it caused a lot of unnecessary retries in Form Engine.
  - Fixed a gateway parsing problem when using Internal Proxyjudge.
  - Added ability to load multiple files at once in History, MyList, and Proxy Analyzer.
  - Changed Retrying Bot Reply to show Status Information.
  - Added option to ban proxy in Progression Frame hit/fake/redirect boxes. (splendidly_null)
  - Added option to disable Page Viewer in HTTP Debugger. (Psykodelik)
  - Added Copy Combo menu option in Progression Frame hit/fake/redirect boxes. (Malu)
  - Fixed bug with Use Random Proxy from MyList in HTTP Debugger. It was never implemented. (Psykodelik)
  - Fixed bad bug with keywords. The engine only used the first one. (Psykodelik)
  - Upgraded Form Parser Engine.
  - Fixed bug with Debug Engine form. It caused an AV during certain circumstances.
  - Added option in Proxy Analyzer to auto delete timeouts and bad proxies after test completion.
  - Added copy selected combos to clipboard in History Frame Popupmenu. (Psykodelik)
  - Added right-click Clear option in My List Frame. (Psykodelik)
  - Added status information to the application bar when running a bruteforce session. (Eternal)

 Sentry 2.0 Beta (RC 4) (12-2-05)
 ----------------------

  - Added button to reload engine settings on hover panel in Progression Frame. Now you can change some settings
    and press this button instead of stopping and starting the engine for the new settings to take effect.
  - Removed Popup Menu on Progression Listview and replaced the menu items with buttons on the hover panel.
  - Added a hover panel to Progression Frame. To activate this panel, move your mouse to the right edge of the
    Progression Listview.
  - Implemented Form Engine.
  - Added Debug Engine Form in Progression -> Right Click Progression ListView -> Debug Engine.
  - Added Horizontal Scroll Bars to the Keyword ListBoxes in Keywords Frame.
  - Fixed bug when finding a banned keyword that was caused by the combo. It will now only retry the combo 5
    times until declaring it bad and moving on.
  - Changed scope of Header Keywords. They can now be used in GET requests.
  - Fixed bug when using History or Proxy Analyzer Engine and going to Progression Frame and changing wordlist
    position using the slider.
  - Changed Resolve Host Before Attack to be unchecked as default. This can cause some scripts to 403 every
    attempt.
  - Added Status Code in Retrying Bot message.
  - Main Site ComboBox now has sorting enabled.
  - Added dynamic bots to the Bruteforcer.
  - Fixed bug with Snap Shots wordlist position. If you chose cancel, it still read the Snap Shot wordlist
    position.
  - Fixed bug where Retrying bots or Fake Bots didn't update Statistics until the bot completed.
  - Added check in Settings -> HTTP Header: If user chooses POST Request without entering POST Data, the
    Form Wizard will be launched.
  - Changed Follow Redirects intelligence. Now Sentry will only automatically Follow Redirects if using GET
    and any type of Source Keywords, otherwise it listens to the Follow Redirects option.
  - Added right click menu to Debug Popup Memo.
  - Added Cookie and Referer parameters in Form Wizard if needed to retrieve Form Data.
  - Changed most of the History Menu Items (Edit XXX) to allow editing of multiple sites. This way, you can
    load a list of sites and edit all their failure keywords at the same time.
  - Made clickable area longer in the OutlookBar Bar on the left side.
  - List -> Wordlist: Replaced ListBox with a ListView to fix Win9x big wordlist loading errors.
  - Fixed bug in Proxy Analyzer that allowed you to start a Specific Site Test without a site entered. (sPlico)
  - Fix bug in Basic Auth. Engine that didn't count some 3xx (other than 302) responses as redirects.
  - Fixed infinite retry bug when After FingerPrint returned a 200 and the proxy died before a 200 or 401
    was returned. It will now try 5 retries, and if all 5 are errors, then the current proxy is disabled and
    the combo is retried from the beginning of the fake procedure.
  - Added option to not display wordlist in ListBox. Hopefully this fixed the Win9x big wordlist loading problems.


 Sentry 2.0 Beta (RC 3) (14-1-05)
 ----------------------

  - Added Horizontal ScrollBar for Hits/Fakes/Redirects List. (sPlico)
  - Implemented Snap Shots.
  - Fixed bug when using Global Failure Keywords and not having Failure Keywords checked. It didn't work. (sPlico)
  - Fixed Use proxy in X in History Frame. It was there but never implemented.
  - Added Settings -> ProxySettings: Reactivate proxies when X proxies are left.
  - Progress bar now moves when you change the wordlist position in Progression Frame when not running
    a test. (sPlico)
  - Fixed Timeout bug in BruteForcer. Because I forgot to turn on an option, it didn't work right in
    previous releases. (sPlico, slysnake)
  - Fixed History/Logfile/Debug saving problems. There was a small chance the file wouldn't get updated. Because
    of this, you cannot view the history tab while running a bruteforcing session. (sPlico)
  - Added append '/' to URL if there is no document name specified in the URL and the URL lacks '/'
    at the end. (sPlico)
  - Removed HEAD/GET label in HttpHeader Frame because it no longer applies. (sPlico)
  - Fixed visual bug with Auto-Build Header checkbox. (sPlico)
  - Fixed securibox.net mirror link in About Box. It didn't work.
  - Fixed visual bug in About Box when highlighting a link.
  - Added Copy Selected Proxy in Clipboard in Hits/Fakes/Redirects List (s0nic)
  - Added Copy Selected Proxies to Clipboard in History. (s0nic)


 Sentry 2.0 Beta (RC 2) (22-12-04) 
 ----------------------

  - Added Send Selected Proxies To My List and Send All Proxies To My List in Right Click Menu in Proxy Analyzer.
  - Added option to only send selected proxies to My List. (sPlico)
  - Added OK button to Proxy Analyzer Options Dialog. (Flyer)
  - Get External IP is now default to False so no network connections on program open.
  - Changed tooltip times to wait 10 seconds before closing. (Psykodelik)
  - Added Send To History in Popup Menu to the Hits/Fakes/Redirects ListBox. (Psykodelik)
  - Fixed visual bug when maximizing Integration page. The Opera Help button was out of position. (Psykodelik)
  - Added Copy URL to Clipboard in Popup Menu to the Hits/Fakes/Redirects ListBox. (Psykodelik)
  - Added Show Popup Memo (if there is data in it) in Popup Menu in Progression List. (Psykodelik)
  - Added Open Debug.txt to Popup Menu in Progression List.  
  - Wordlist position is now reset intelligently depending on if you change your site, like in Sentry 1.x.
  - Sites now save in Main Site ComboBox.
  - Added option Auto-Build Header in Settings -> HTTPHeader for GET and HEAD requests. (Default is True)
  - Upgraded intelligence of prompting when the user needs to build an HTTP Header.
  - Fixed bug with Progression List not clearing on beginning of a new test. (sPlico)
  - Fixed Statistics Bug. It didn't keep track of Status Code replies.
  - Fixed bug when trying to start a test when a wordlist was not being used.
  - Moved Bots Slider and Wordlist Position Slider into Progression Frame.
  - Implemented Wordlist Position Slider to work with the engine in Lists -> Wordlist. I forgot this in RC 1.
  - Fixed bug when beginning a test: Sentry started at the 2nd combo, not the first one.
  - When HTTP Debugger completes it now displays Status Code and Status Reply in the StatusBar. (Psykodelik)
  - Fixed bug when sorting sites by Site Name. It didn't account for emails in the username. (Psykodelik)
  - When displaying a Header from the OutlookBar that only has 1 page, this page is automatically displayed. (sPlico)
  - Fixed bug when BruteForcer engine was being initialized. It read the URL from the INI File, not the ComboBox
    on the Main Form. (Psykodelik)


 Sentry 2.0 Beta (RC 1) (18-12-04)
 ----------------------

  - Rewritten from scratch. Nothing is the same as in previous 1.x versions. I left the changelog in here to show a
    complete history of Sentry. 


 Sentry 1.4 (14-3-04)
 ----------

  - Fixed Proxy Reactivation bug which caused Sentry to freeze.
  - Added Find Dialog in Debugger Window.
  - Write Debug to File now saves when program closes.
  - Fixed Success Key Phrase bug. It didn't work correctly in 1.3 CE.
  - Fixed bug which didn't show new lines properly in HTTP Debugger.
  - Added option to modify the proxy stored with the site in History.
  - Fixed visual bug when maximizing the HTTP Debugger.


 Sentry 1.3 (25-12-03)
 ----------

  - Added HTML Syntax Highlighting to HTTP Debugger Output screen.
  - Added Copy Fake To Clipboard.
  - Added append option to append saved history to a file.
  - Added Wordlist variable to Save Filter.
  - Added Wordlist Column in History.
  - Double click on History Item now launches in default browser.
  - Added "Use Main Site" button in Specific Analyzer. This will make Sentry use the URL in the main Site
    combobox instead of the Specific Site combobox.
  - History now saved immediately after a hit is logged. No more History losses because of a crash.
  - Fixed bug when saving an email as a username in History. The username and site both didn't save correctly.
  - Added Convert Hostname To IP option in Proxy Analyzer.
  - Removed Blackmarket as default proxyjudge.  (Finally ;) )
  - Added option to check 401 response when using Internal ProxyJudge against a Specific Site instead of using
    Sentry's websever to do this check.
  - Added Copy Selected Proxies to clipboard in History Section.
  - Added use random proxy from My List in HTTP Debugger.
  - Added Ref=Site button in HTTP Debugger.
  - Added After Fingerprinting. This tries a random combo after a hit to check for a proxy error. Fake protection
    AccessDiver uses. Cannot be used with Key Phrases. Do not write to Debug.txt when using this option because
    you will get the return source from the 401 response. (Used in SnapShots)
  - Fixed External IP parsing.
  - Fixed resize bug with the Launch Proxyjudge button.
  - Fixed Access Violation after POSTing in Debugger.


Sentry 1.2 (20-7-03)
----------

  - Sentry 1.2 RC 2 ported for public use. 


 Beta 1.2 (RC 2) (Internal, never released)
 ---------------

  - Added option in My List to Send proxy to blacklist. (theFarmer)
  - Added ability to compile and send custom headers in HTTP Debugger (Post Data is still handled by the Post Data
    field).
  - Fixed small memory leak when using POST with HTTP Debugger.
  - Bolded the font in the Source tab in HTTP Debugger. This should make it easier to read. (cobradiver)
  - Changed "Source.tmp" to "Source.html" because the IE component tried to download the file instead of viewing it
    on some systems. (cobradiver)
  - Fixed Graphical bug when maxmizing the HTTP Debugger. It didn't maximize properly. (cobradiver)


 Beta 1.2 (RC 1) (18-8-03)
 ---------------

  - Made main Site combobox not alphabetical order anymore. It will put the last tested site at the top of the list.
    (theFarmer)
  - Added agent randomizer. This is used by default. Also used in History Checker. See below for details.
  - Added option to assume a certain redirect is a fake. This is helpful if you think/know the site redirects
    to a certain member's URL or just want to see better your redirects that aren't this path. This can be used
    together with the other redirect options. (Used in Snap Shots) (Wolfman)
  - Added option to not reactivate proxies banned for fake replies. Made it part of the default settings. This is
    good if you only want to ban fake proxies, and not all 200 reply proxies. (Used in Snap Shots)
  - Snapshots couldn't save if a ":" was present in the URL (because of a port number).
  - Changed both Manager Lists to Multi-Select. (theFarmer)
  - Added option to Sort History by Image. Good if you want to put hits/misses/redirects together.
  - Fixed bug with writing to Debug file. There was no way to stop Sentry of doing this in last version because it
    was broken.
  - Recoded the History Select code. Much more accurate and efficient now.
  - Fixed bug with Limit Retry code. It didn't reset the count when you abort and start a new test.
  - Rewrote some of the Set Proxy code. In extreme cases, it could have caused problems.
  - Fixed graphical bug when resizing the form with "Check for Update" command button.
  - Fixed a bug with reactivating proxies.
  - Turned off Hide Selection on History Listview. I don't know why I had it enabled in the first place.
  - Fixed bug with banning Fake proxies. Sentry used to ban the proxies it used with Check Hits X Times, even though
    they could still be good proxies.
  - Sentry will now remember what directory you use when opening files with Proxy Analyzer. (PhanTom)
  - Fixed major bug when you do not have simultaneous testing checked and you have sites in that list. Sentry only
    tried the first combo. (WD40)
  - Fixed Bug when not using "http://" infront of a site. It will now save correctly. (ItalianGuy)
  - Added Accept Language Field in HTTP Debugger.
  - Fixed bug with loading proxies and having invalid integer with ports. (Sniper)


Sentry 1.1 (20-7-03)
----------

  - Sentry 1.1 RC 2++ ported for public use. 

  IMPORTANT: Read over all the changes in this file, and then if you need further help, look at the program/manual.
             Some help is already inside the program. The manual didn't get a full update, because I didn't think
             it was necessary.


 Beta 1.1 (RC 2++) (Internal, never released)
 -----------------

  - Turned AutoComplete off with the combobox for HTTP Debugger. (Falk0n)
  - Added an Updater so you can always check to see if you are using the latest version of Sentry.
  - Fixed List Out of Bounds bug in History Checking.
  - All Bots now default to 1 to prevent hammering on sites. (theFarmer)
  - Fixed various bugs with limit Retry Engine.
  - Removed Custom Hit Response, because defining Header Success Key Phrases is much more effective and does the
    same thing but in more detail.
  - Made the textboxes for the length filter's to handle double digits. (wolverine)
  - Made all listboxes (Key Phrases) multi-select.
  - Made simultaneous listbox multi-select and it now sorts alphabetically. (cobradiver)
  - Put an option so you don't need to reset your wordlist every time you test a new site. Sentry will auto-detect
    it now (cobradiver)
  - Fixed bad bug with Paste Proxies into My List. It didn't work, now it does.

 Beta 1.1 (RC 2+) (15-7-03)
 ----------------

  - Added option to limit Retries and to limit them to an exact number. (theFarmer)  
  - If you get a hit and the exact hit is already in your history, it will not be added, but the Time column
    and proxy column will be updated.
  - Fixed bug when all your proxies are banned and cannot be reactivated. It caused an access violation error.
  - Added Paste Proxies To My List. This uses the append option, so if you want to append the pasted proxies,
    then make sure you have Append to My List checked. (cobradiver)
  - Fixed bad bug when you checked Filter Length and you had a combo at the end of your wordlist that got 
    filtered. It caused a list out of bounds error. (vronique)
  - Added option to Copy Proxy To Clipboard in the Hit list. (cobradiver)
  - Fixed Copy to Clipboard in Hit ListBox to just copy the URL and not the proxy information.
  - Fixed bug with Defining a Failure Header Key Phrase. It didn't record hits.

 Beta 1.1 (RC 2) (08-7-03)
 ---------------

  - Added option to Append to My List instead of clearing it every time it is updated. (theFarmer)
  - Added option to Update My List with Selected proxies only. (theFarmer)
  - When seleting a wordlist, the Open Dialog will default to the last directory of a wordlist you opened. (PhanTom)
  - Added an option to make a popup memo which displays debug data. This is useful if you do not want to always
    check the Debug.txt file after every hit. You can also use this to verify if the hit is really a hit without
    wasting time by checking the L:P manually.
  - Right Clicking the list which has your hits in Progress Window has new option Use Proxy In IE. (Ph|nd)
  - Added Copy Hit To Clipboard and Copy Redirect To Clipboard.
  - Fixed Bug in redirect engine. If you use an applied key phrase, Sentry will retry the redirect as many times
    as you chose and all other fake protection is ignored. If you chose Retry Redirects 0 Times (recommended), 
    then the redirect with the key phrase is automatically marked as a hit.
  - Fixed Graphical Bug with Deleting items from a ListView. Now, Sentry will Deselect the list when it is done
    deleting selected. (theFarmer)
  - Fixed bug with pasting History From Clipboard. The Proxy Analyzer ListView became blank.
  - Added 3 Sort options to the History. You can now Sort on Site, Username, or Password. Clicking the same option
    twice will sort the opposite direction, just like the column headers do.
  - Made Save History save only selected items. 
  - Added Save Filter to Sentry's History. Now you can completely customize how you want to Sentry to save your
    History by using Variables.
  - Fixed Update My List Checkbox's ToolTip. It displayed the same as the Delete Bad Proxies CheckBox.
  - Because of the change in Remove Duplicates in Proxy Analyzer, bug fixed with Removing Duplicates. Now it will
    remove all duplicated with 1 press like it's supposed to.
  - Changed Proxy Analyzer Remove Duplicates to consider ports also. (e.g. 127.0.0.1:80 and 127.0.0.1:8080 are now
    duplicates) 
  - Fixed bug with Proxy Gateway Deletion. If the gateway field was empty, the proxy was deleted. (WD40)
  - Added option to check History with the same proxy you found the login with. If a proxy is not assigned to an item,
    then one from My List will be used. (PhanTom)
  - LogFile.log now displays time you found the hit also. 
  - Added "Time Added/Verified" to History. Now you know when each item was added or last verified. (PhanTom)
  - Fixed bug with Check Hits X Times. If a 200 reply was returned and its verifier needed to be retried then
    it would reset. (e.g. Checking For Fake 1/1 -> 404 - Retrying -> Checking For Fake 1/1) <- old way
    (Checking For Fake 1/1 -> 404 - Retrying -> 200 - Hit) <- new way 
  - Fixed Annoying Win2K closing bug. You can thank M$ for this one, because Win2K couldn't handle the name
    "SpecificSites.ini". This also fixes the bug with Specific Site Analyzer with Win2K. (wolverine - thanks so much)
  - Added Bots Slider in the Progression Window also, both are linked which makes it easier for the user to change bots
    while testing.
  - Changed Speed to Bots because this was a false statement to a certain extent.
  - Referer and Agent fields now work for History Checking (Referer = <MEMBER URL> can check for possible spoofs. It's
    a good idea to set Referer to that before checking History).
  - You can now lower/add bots during a test. Bots are finally dynamic like in AD. (I did some extensive testing and
    changing Bots will NOT skip or abort any combos, your list will still be completely tested accurately. Not sure
    if AD can say this :P )
  - Fixed Bug with My List Usable Proxies Statistic. If you ran a site and it marked some proxies as bad, then updated
    the list, it didn't count all the proxies as good.
  - Went back to the version of ICS that APL 1.3 uses. The current Beta Version I was in Sentry seemed to cause too
    many freezing problems.
  - Fixed bug with port checking on loading proxies in Proxy Analyzer. Very rarely a bad one slipped through. (R@nger)
  - Fixed bug when Sentry decided to abort on whatever you did after you clicked the abort button to stop a test. (DCC)
  - Added option to Retry Timeouts X Times in Proxy Analyzer. (Not used with Specific Site Analyzer)
  - If user abort on Proxy Analyzer and it's not 100% done, then Sentry will not apply the automatics at the bottom.
    (DaBest)
  - Added option to follow redirects until 200 repsonse, then apply the subdirectory keyword match. (The way AD did it)
    (Used in Snap Shots). (cobradiver)
  - Put Redirect options in Settings Page.
  - Added option to clear proxy analyzer list. (right click) (DaBest)
  - Added option to send Redirects To History. (cobradiver)
  - Added some code to let your cpu catch up to Sentry during cracking. (Ashes)
  - Fixed bad bug with Set Proxy code, I couldn't even get a test running. (Made a last addition to RC 1 and I
    never tested it).
  - Fixed small memory leak in Get External IP Address.
  - Get External IP is now upgraded so if http://checkip.dyndns.org/ changes their source again, it won't matter.
  - Fixed Bug when opening a list of saved auto-pilot jobs and then pressing cancel, the Open Dialog never reset its
    filters.
  - Put Data To Post and Referer on the bottom anchored, so you can see them on every tab you select in HTTP Debugger.
    (Victoria)
  - Locked the Data To Post TextBox when GET or HEAD is selected in HTTP Debugger. (Victoria)
  - Added option to Send Proxy From Analyzer To HTTP Debugger. (Victoria)
  - Added RAS Connection Manager, so you can specify which dial-up connection to set IE's proxy, instead of always
    sending it to the LAN. (Victoria)

 Beta 1.1 (RC 1) (28-6-03)
 ---------------

  - Added 2 options to not reactivate proxies (On 200 Response and on Bad Key Phrase found). (Used in Snap Shots)
  - Fixed bad bug when hits were done in simultaneous mode. Some routines added the site from the combobox when in
    fact, it could have been one of the sites from the simultaneous list.
  - Added Retry Redirects X Times. Default is set to 0, because it is an advanced option and rarely needed.
    (Used in Snap Shots)
  - Added more redirect protection, if a site is redirecting, I strongly suggest you use GET Source Key Phrases,
    unless you specify a redirect path as a hit.
  - Added option to specify a redirect path as a hit. (Also used in Snap Shots)
  - Added more options for History Saving (save SITE l: p: format and Detailed History Saving).
  - When loading a combo list, Sentry now deletes all trailing and leading spaces on each combo.
  - When a test ended, Sentry automatically aborted regardless of a combo needing a retry. This is fixed except if
    you click the abort button, combos will not be retried if they do. (You clicked the abort button so don't blame
    me)
  - Moved Referer and Data To Post Fields to the Main Page in HTTP Debugger. These options are the most common to
    modify and this makes it easier.
  - Added 3 new saving options under the history (Save Combos, Save URLs, Save Base URLs)
  - Made History Checking "select only", meaning you need to select the sites you want to verify. ("a" selects
    the entire list). 
  - Added Parse Proxy Key Phrase under Specific Site. (See Below)
  - Moved Proxy Rotation and Ban Proxy options  to the Proxy Options tab.
  - Made a New tab Proxy -> Proxy Options (Deals with actual proxy options during a test).
  - Changed tab Proxy -> Options to Proxy -> Analyzer Options (Only deals with the Proxy Analyzer).
  - Fixed bad freezing bug with external ProxyJudge.
  - Added a Horizontal Splitter in the progression tab. You can now resize the Listview and the tabs at the bottom.
  - Upgraded the GET Parsing engine so that you can now use Failure and Success Key Phrases. Success Key Phrases have
    priority over Failure Key Phrases.
  - Added an option to abort a site after x hits. (Under Fake Tab, used in Snap Shots also)
    Note: This will abort when total hits equals X, so keep this in mind when doing Simultaneous Sites
  - Fixed a small memory problem with the internal judge.
  - Added option to update My List after proxy analyzing completes.
  - Added option to Delete Bad and Timeout Proxies Automatically after proxy analyzing completes.

 First Public Release - Version 1.0 (22-6-03)
 ----------------------------------

  - No real changes from Beta RC 6+, just that it is public :)
  
  I decided to leave the Beta Readme as a part of the real readme, because this way you can see how Sentry grew and
  you might understand some more of the options by looking chronologically how they have been added.

========================================================================================================================

 Beta (RC 6+) (17-6-03)
 ------------

  - Fixed very bad bug with retrieving IP Externally.  It didn't clear the source from the array which meant if you
    tried to do a proxycheck afterwards, the source from that webpage would be appended to the source of your first          proxy, making it appear not anonymous when infact it very well could be anonymous.  
  - Launch Base Site in Browser (the globe icon next to the site combobox) now supports (http://members.somesite.com).
  - Fixed bad bug with History (List out of bounds error). Was an error in the proxy setting routine.

 Beta (RC 6) (14-6-03)
 -----------

  - Added an option to get External IP on startup.  (I'm now behind a router ;) )
  - Minor stuff not worth mentioning.
  - New Splash Picture. (Thanks Maxi)
  - Fixed bad bug in HTTP Debugger.  It didn't work right because of a upgrade I did to the abort section last version.
  - Added Tooltips.
  - If use History Key Phrase is checked, GET Request method is now automatically used during History Checking. 
  - Fixed bug if you click the Get External IP twice before it finishes.
  - Added Proxy Filter for proxy analyzer, now only good proxies will get though.


 Beta (RC 5) (Thanks DaBest :) ) (07-6-03)
 -----------

  - Added option to Check Hits x times using the same proxy it got the hit with.
  - Changed Edit Wordlist in Auto-Pilot to Open Dialog Box.
  - Added load Proxies to My List option. Proxies are compared against Blacklist and then loaded to My List.
  - Fixed 2 bugs regarding the AutoPilot popup menu. If no jobs in list, then gave a exception error.
  - Fixed bug when loading Sentry, wordlist position didn't load right.
  - Fixed bug with Wordlist from disk, you can now set a start position using the wordlist position slider.
  - Very bad bug in GET Engine, with failure key phrase used and content-length not checked. No hits were
    recorded.
  - More fixes on Read Wordlist From Disk.
  - Fixed a bug with adding proxies to the proxy analyzer. Some bad ports slipped through.
  - Fixed cosmetic bug with Internal ProxyJudge panel. There was a way you can make it not dissapear and it
    was not checked.
  - Added option to save a list of URLs in Auto-Pilot.
  - Added option to load a list of URLs with "Regular Settings" and your Current Wordlist in Auto-Pilot.

 Beta (RC 4) (Thanks R@nge® for all your input and help) (04-6-03)
 -----------

  - Added an Auto-Pilot system. See Below.
  - Added a Control Panel Section. Includes Loading and Saving of Snap Shots, and Send Site To AutoPilot. 
  - Tightened up the GET Engine. Should see a small speed increase when using GET Request Method.
  - Upgraded all Key Phrase parsing with the code I used to parse the Headers.
  - Added Retrying with History Checker on Abnormal Replies.
  - Added Save History menu item in the History Popup Menu.
  - Added option to Retrieve Proxy From IE for HTTP Debugger.
  - Fixed bug with Test Specific Site CheckBox. If it is checked and Internal Server is running. It shuts the
    Server down and takes priority.
  - Fixed bug during a test it was possible to change the site you were testing. I disabled the Site ComboBox
    while running a test.
  - Added Header Parsing. See Below.
  - Fixed bug with removing bad proxies. Redirects from the Internal Server weren't deleted.
  - Added option to write Debug Information on Hits. This information includes the Header Response which was
    received from the server, the source of the page (if HEAD was used then this will be blank).
  - Added Snap Shots. See Below.
  - Changed KeyPhrase CheckListBoxes to ListBoxes. Reason for doing this was it clashed with my Snap Shot code.
  - Added Paste Sites To History from clipboard button.
  - Sentry will only reset its initializing variables when the main ComboBox for Site is changed. For example
    the Hit ListBox, Responses, etc.
  - Added option to customize Hit Responses. Now 404, 403, or 302's can be considered hits along with any other
    HTTP Response. Do Not use for 200, because a lot of fake protection won't be used.
  - Added Sound on Abort and Hits.
  - Added option to only use a specified single proxy without deleting your My List.
  - Added an option to retrieve External IP.
  - Added Redirect detection to History Checker.
  - Rewrote a lot of the Redirect code. Now handles redirects more effectively.
  - Removed the Docking Windows to make the form maximize efficiently.
  - Fixed bug with pasting proxies from clipboard to the analyzer.
  - Fixed Read Wordlist From Disk bug. Didn't work because I implemented it during the early dev. of RC3
    and it got changed while I was doing another feature.
  - Fixed bad bug in the refreshing of the blacklist. If a combolist wasn't loaded, the blacklist didn't refresh
    past item 1. This was due to a bad copy/paste mistake.

 Beta (RC 3) (Special Thanks to Wolfman for his various inputs. Your help is greatly appreciated :) (27-5-03)
 -----------

  - Added an option to reactivate all proxies when the active proxies equal or go below x amount.
  - Added an Internal ProxyJudge. Works the same as Proxyrama except for HTTPS and Country Locator.
    See below for more information. (Thanks Gaa Moa for your Open Source)
  - Fixed Bug with Delete Gateway. If Gateway was blank, the proxy was deleted.
  - History now saves on the fly to a file called "Logfile.log".
  - Added a use No Proxy Option. This Option does not save.
  - Fixed Bug with removing duplicates when a new wordlist is added to Wordlist History.
  - Added a Proxy Blacklist. This is used to compare whether a proxy should be loaded into My List when you
    click Update My List.
  - Added a Page Viewer in the HTTP Debugger. It simply just displays in HTML the source which the debugger
    returned.
  - Fixed HTTP Debugger when posting data. It didn't work correctly and caused an error most of the time.
  - Fixed bad bug with "Ban Proxy on 200 Reply". It banned all proxies because I misplaced it in an if/then
    statement.
  - Fixed bug with calculating attempts when aborting. It missed the aborted attempts.
  - Fixed division by zero bug on very slow starting tests.
  - Fixed Bad bug when aborting a test. Was a bug in the retry engine when test was aborted and combos
    that were going to be retried were passed as hits.
  - Added an AboutBox Page
  - Added a randomize function under Proxy Analyzer (Randomize them and then send them to MyList)
  - Added simple manipulation features.
  - Changing wordlist position can now be done on the fly. (I though this was already implemented until
    I realized I forgot to do it when recoding some things for the wordlist from disk option).
  - Added Read wordlist from disk to save memory for big wordlists.
  - Added a button that extracts proxies from clipboard to the analyzer.
  - Added a reset button on the wordlist position panel.
  - Sentry now automatically uses Get request method if you are using a fake prevention that
    requires this request method.

 Beta (RC 2) (All that I can remember) (07-5-03)
 -----------

  - Fixed the bad bug with the comboboxes. They now work.
  - Added an option "Ban Proxy on 200 Reply" under Fake Tab. This was talked about in one of the 
    forums to not use proxies after they returned a hit.
  - Fixed how the Http Debugger displays the source. It now is more easily readable. (Thanks tbscope) 
  - Added Statistics under the Progression tab.  Includes Speed, Elapsed Time, Time Remaining etc.
  - Split the cracking engine into two separate procedures.  Get and Head.  This should quicken
    the code for each, especially Head.
  - Added a QuickLaunch Menu and Editor. This option enables you to quickly run your favorite
    programs easily from within Sentry.
  - Fixed problem with proxy loading for the analyzer. It now verifies the ports to see
    if the proxy is ok to load. (Thanks slysnake)

 Beta (RC 1)   (Date: 25-4-03)
 -----------

  - First release ever.