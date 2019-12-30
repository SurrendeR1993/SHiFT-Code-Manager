rem ########################NOTES############################
rem 
rem :TODO:
rem
rem -Activity-Filter optimieren (verdammt lahm!)
rem -Multi-Use-Fix: Aktuell kann nur ein Benutzer gleichzeitig das Programm ausführen wegen dem Zwischenspeicher. Lösung: Dateien mit ID. voran schreiben und lesen
rem 
rem #########################################################
rem Written in Rapidbatch: http://rb5.phorward-software.com/
rem #########################################################
include 'dialog.rb'
dec [2kcnt], [gk.code.old], [rgk.errorcode], [rc.counter3], [rc.ppos], [CODES], [Confirm_Title], [Echo_Title], [carriagereturn], [case_sensitivity], [cnt], [code], [console], [cookie], [count.appear], [creatorcheck], [cw.command], [cw.data], [cw.old], [cw.output], [data.email], [data.line], [data.out2], [data.out], [decrypt.counter], [decrypt.decryptedchar], [decrypt.input], [decrypt.key], [decrypt.maxchar], [decrypt.return], [decrypt.tok], [dispname], [editdata.cnt], [editdata.delete], [editdata.email], [editdata.encryptedpw], [editdata.password], [editdata.return], [editdata.todo], [email.cnt], [email], [emailcheck], [emaillist], [encrypt.char], [encrypt.chr], [encrypt.counter], [encrypt.encryptedchar], [encrypt.input], [encrypt.inputlen], [encrypt.random], [encrypt.return], [encrypt.salt], [epiccnt], [exit], [facebookcnt], [filepw], [found], [getcookie.charat], [getcookie.cookie.len], [getcookie.cookie.pos], [getcookie.cookie], [getcookie.counter2], [getcookie.counter], [getcookie.header], [getcookie.input], [getcookie.redirect], [getcookie.response], [getcookie.return], [getcookie.x-ct-redirect.counter], [getcookie.x-ct-redirect.len], [getcookie.x-ct-redirect.pos], [getpoints.data], [getpoints.input], [getpoints.redpoints], [getpoints.return], [getpoints.totalpoints], [1.cookie], [getredeemed.counter], [getredeemed.creator], [getredeemed.creatorcnt], [getredeemed.creatorlist], [getredeemed.email], [getredeemed.emailcnt], [getredeemed.emaillist], [getredeemed.notes:'250'], [getredeemed.response], [getredeemed.return], [getredeemed.stop], [getredeemed.title:'250'], [getredeemed.vault], [getredeemed.vaultcnt], [getredeemed.vaultlist], [gkcheck], [http.response.file], [http.response.out], [http.response.return], [json.arg.len], [json.arg], [json.charat], [json.clamp.close], [json.clamp.counter], [json.clamp.open], [json.clampmode], [json.cnt], [json.halt], [json.input.pos], [json.input], [json.pos.counter], [json.return], [linefeed], [login.data], [platforms], [playstationcnt], [points], [pwd], [rc.cntvar], [rc.counter2], [rc.counter], [rc.creatorcheck], [rc.emailcheck], [rc.found], [rc.gk.len], [rc.gk.raw.entry], [rc.gk.raw.exit], [rc.gk.raw.list], [rc.gk.raw], [rc.gkcheck], [rc.newcode.code:'250'], [rc.newcode.type:'250'], [rc.newcode.value:'250'], [rc.newcode], [rc.newcodes.raw], [rc.quit], [rc.redcodes.creator:'250'], [rc.redcodes.creator], [rc.redcodes.email:'250'], [rc.redcodes.email], [rc.redcodes.raw], [rc.redcodes.vault:'250'], [rc.redcodes.vault], [rc.repeat.quit], [rc.response], [rc.return], [rc.tok], [rc.vaultcheck], [redcc], [redcodes.data], [redcodescomplete], [redec], [redpoints], [redres], [redvc], [result], [retry], [rgk.jobid], [rgk.key], [rgk.platform], [rgk.return], [rgk.tmp], [save.login], [saved.data], [schmeissweg], [selected.username], [shiftid], [status], [steamcnt], [totpoints], [twitchcnt], [twittercnt], [userline], [xboxcnt], [xs.cntcom], [xs.cntvar], [xs.counter], [xs.data], [xs.input], [xs.session], [xsession]
[case_sensitivity] = [false]
[eol] = ''
[Echo_Title] = 'SHiFT Code-Manager'
[Confirm_Title] = 'SHiFT Code-Manager'
[actual.version] = '1.6'

delfile 'console.txt'

proc silent: [s.user], [s.options]
	%onlinecheck
	call 'curl.exe -X GET http://www.google.com -i -o onlinecheck.txt', 'hide'
	fileexists [s.onlinecheck] = 'onlinecheck.txt'
	if [s.onlinecheck] = [true]
		delfile 'onlinecheck.txt'
		getpassword [s.pw] = [s.user]
		if [s.pw] ! 'USER_NOT_FOUND'
			login [s.return] = [s.user], [s.pw]
			readfile [s.logindata] = 'login.txt', '0'
			getplatforms [s.platforms] = [s.logindata]
			getcookie [s.cookie] = [s.logindata]
			if [s.return] = 'LOGIN_SUCCEEDED'
				xsession [s.xsession] = 'login.txt'
				if [s.xsession] ! 'failed'
					delfile 'login.txt'
					gettok [s.vault] = [s.options], '|', '1'
					replacevar [s.vault] = [s.vault], [s.user], ''
					gettok [s.email] = [s.options], '|', '2'
					gettok [s.creator] = [s.options], '|', '3'
					gettok [s.gk] = [s.options], '|', '4'
					gettok [s.vip] = [s.options], '|', '5'
					getpoints [s.points] = [s.cookie]
					redeemcodes [result] = [s.vault], [s.email], [s.creator], [s.gk], [s.vip], [s.cookie], [s.platforms], [s.xsession]
					refresh [s.points] = [s.points], [s.cookie]
					logout [s.logout.status] = [s.xsession], [true]
				endif
			endif
		endif
	else
		wait '10000'
		goto 'onlinecheck'
	endif
endproc

func getplatforms: [gp.logindata]
	json [gp.platforms] = [gp.logindata], 'platforms', '1'
	cntvar [gp.steamcnt] = [gp.platforms], 'steam'
	cntvar [gp.playstationcnt] = [gp.platforms], 'psn'
	cntvar [gp.xboxcnt] = [gp.platforms], 'xbox'
	cntvar [gp.epiccnt] = [gp.platforms], 'epic'
	cntvar [gp.2kcnt] = [gp.platforms], '2k'
	cntvar [gp.twitchcnt] = [gp.platforms], 'twitch'
	cntvar [gp.twittercnt] = [gp.platforms], 'twitter'
	cntvar [gp.facebookcnt] = [gp.platforms], 'facebook'
	ret [gp.steamcnt]#'|'#[gp.playstationcnt]#'|'#[gp.xboxcnt]#'|'#[gp.epiccnt]#'|'#[gp.2kcnt]#'|'#[gp.twitchcnt]#'|'#[gp.twittercnt]#'|'#[gp.facebookcnt]
endfunc

func getpassword: [gp.username]
	[gp.cnt] = '0'
	[gp.varcnt] = '0'
	[gp.exit] = [false]
	fileexists [errorcode] = 'data.dat'
	if [errorcode] ! [false]
		repeat
			[gp.cnt] + '1'
			readfile [gp.data] = 'data.dat', [gp.cnt]
			if [gp.data] ! 'EOF'
				cntvar [gp.varcnt] = [gp.data], [gp.username]
			endif
			if [gp.varcnt] = '1'
				gettok [gp.pw] = [gp.data], '=', '2'
				decryptpw [gp.decrypt] = [gp.pw]
				ret [gp.decrypt]
			endif
			if [gp.data] = 'EOF'
				[gp.exit] = [true]
				ret 'USER_NOT_FOUND'
			endif
		until [gp.exit] = [true]
	endif
endfunc

func login: [login.email], [login.password]
		call 'curl.exe -X POST https://api.2k.com/borderlands/users/authenticate -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -d "{\"username\":\"'#[login.email]#'\",\"password\":\"'#[login.password]#'\"}" -i -o login.txt', 'hide'
		httpresponse [login.rescode] = 'login.txt'
		if [login.rescode] = '403 Forbidden'
			echo 'Login failed. Wrong E-Mail/Password.'
			ret 'LOGIN_FAILED'
		elseif [login.rescode] = 'R/W_Error'
			echo 'Could not save login data. Do you need admin privilegs to write to files in this folder? Logged in anyway.'
			ret 'LOGIN_SUCCEEDED'
		elseif [login.rescode] = ''
			echo 'Got no response from the server. Please check your internet connection!'
			ret 'LOGIN_FAILED'
		elseif [login.rescode] ! '200 OK'
			echo 'Unexpected response from the server. (HTTP Code: '#[login.rescode]#')'
			ret 'LOGIN_FAILED'
		elseif [login.rescode] = '200 OK'
			console 'continue', 'SUCCESS!'
			ret 'LOGIN_SUCCEEDED'
		endif
endfunc

proc console: [cw.command], [cw.data]
	writefile 'console.txt', [cw.data]#''#[new_line]
	if [cw.command] = 'enable'
		rem --- creating code for widget "SHiFT Code-Manager [CONSOLE]"
		newdialog 'SHiFT Code-Manager [CONSOLE]', 'DIALOG', '0|0|519|394'
		letdialog 'SHiFT Code-Manager [CONSOLE]', 'caption', 'SHiFT Code-Manager [CONSOLE]'
		letdialog 'SHiFT Code-Manager [CONSOLE]', 'STYLE', 'DIALOG'

		rem --- creating code for widget "consoleoutput"
		newdialog 'SHiFT Code-Manager [CONSOLE]:consoleoutput', 'EDIT_LINEWRAP', '0|0|515|376'
		letdialog 'SHiFT Code-Manager [CONSOLE]:consoleoutput', 'readonly', [true]
		letdialog 'SHiFT Code-Manager [CONSOLE]:consoleoutput', 'TEXT', [cw.output2]

		rem --- make the dialog window visible
		letdialog 'SHiFT Code-Manager [CONSOLE]', 'visible', [true]
	elseif [cw.command] = 'disable'
		deldialog 'SHiFT Code-Manager [CONSOLE]'
	elseif [cw.command] = 'clear'
		[cw.output] = [null]
		[cw.output2] = [null]
	elseif [cw.command] = 'write'
		if [cw.output] = ''
			[cw.output] = [cw.data]#'|'
		else
			[cw.output] = [cw.data]#'|'#[cw.output]
		endif
	elseif [cw.command] = 'rewrite'
		gettok [cw.tok] = [cw.output], '|', '1'
		replacevar [cw.output] = [cw.output], [cw.tok], [cw.data]
	elseif [cw.command] = 'continue'
		gettok [cw.tok] = [cw.output], '|', '1'
		[cw.tok] = [cw.tok]
		replacevar [cw.output] = [cw.output], [cw.tok]#'|', [cw.tok]#''#[cw.data]#'|'
	endif
	if [cw.command] ! 'enable' & [cw.command] ! 'disable' & [cw.command] ! 'clear'
		replacevar [cw.output2] = [cw.output], '|', [new_line]
		letdialog 'SHiFT Code-Manager [CONSOLE]:consoleoutput', 'TEXT', [cw.output2]
	endif
endproc

proc clearfiles
	delfile 'logoff.txt'
	delfile 'redcodes.txt'
	delfile 'activevipcodes.txt'
	delfile 'activeshiftcodes.txt'
	delfile 'redres.txt'
	delfile 'points.txt'
	delfile 'cookie.txt'
	delfile 'login.txt'
	delfile 'version.txt'
	delfile 'activities2.txt'
	delfile 'vipactivities.txt'
	delfile 'vipactres.txt'
endproc

clearfiles

func httpresponse: [http.response.file]
	[http.response.return] = [null]
	readfile [http.response.out] = [http.response.file], '1'
	if [errorcode] = [false]
		[http.response.return] = 'R/W_Error'
		goto 'http.return'
	endif
	gettok [http.response.out] = [http.response.out], ' ', '2'
	if [http.response.out] = '100'
		[http.response.return] = [http.response.out]#' Continue'
	elseif [http.response.out] = '101'
		[http.response.return] = [http.response.out]#' Switching Protocols'
	elseif [http.response.out] = '102'
		[http.response.return] = [http.response.out]#' Processing'
	elseif [http.response.out] = '200'
		[http.response.return] = [http.response.out]#' OK'
	elseif [http.response.out] = '201'
		[http.response.return] = [http.response.out]#' Created'
	elseif [http.response.out] = '202'
		[http.response.return] = [http.response.out]#' Accepted'
	elseif [http.response.out] = '203'
		[http.response.return] = [http.response.out]#' Non-Authoritative Information'
	elseif [http.response.out] = '204'
		[http.response.return] = [http.response.out]#' No Content'
	elseif [http.response.out] = '205'
		[http.response.return] = [http.response.out]#' Reset Content'
	elseif [http.response.out] = '206'
		[http.response.return] = [http.response.out]#' Partial Content'
	elseif [http.response.out] = '207'
		[http.response.return] = [http.response.out]#' Multi-Status'
	elseif [http.response.out] = '208'
		[http.response.return] = [http.response.out]#' Already Reported'
	elseif [http.response.out] = '226'
		[http.response.return] = [http.response.out]#' IM Used'
	elseif [http.response.out] = '300'
		[http.response.return] = [http.response.out]#' Multiple Choices'
	elseif [http.response.out] = '301'
		[http.response.return] = [http.response.out]#' Moved Permanently'
	elseif [http.response.out] = '302'
		[http.response.return] = [http.response.out]#' Found (Moved Temporarily)'
	elseif [http.response.out] = '303'
		[http.response.return] = [http.response.out]#' See Other'
	elseif [http.response.out] = '304'
		[http.response.return] = [http.response.out]#' Not Modified'
	elseif [http.response.out] = '305'
		[http.response.return] = [http.response.out]#' Use Proxy'
	elseif [http.response.out] = '307'
		[http.response.return] = [http.response.out]#' Temporary Redirect'
	elseif [http.response.out] = '308'
		[http.response.return] = [http.response.out]#' Permanent Redirect'
	elseif [http.response.out] = '400'
		[http.response.return] = [http.response.out]#' Bad Request'
	elseif [http.response.out] = '401'
		[http.response.return] = [http.response.out]#' Unauthorized'
	elseif [http.response.out] = '402'
		[http.response.return] = [http.response.out]#' Payment Required'
	elseif [http.response.out] = '403'
		[http.response.return] = [http.response.out]#' Forbidden'
	elseif [http.response.out] = '404'
		[http.response.return] = [http.response.out]#' Not Found'
	elseif [http.response.out] = '405'
		[http.response.return] = [http.response.out]#' Method Not Allowed'
	elseif [http.response.out] = '406'
		[http.response.return] = [http.response.out]#' Not Acceptable'
	elseif [http.response.out] = '407'
		[http.response.return] = [http.response.out]#' Proxy Authentication Required'
	elseif [http.response.out] = '408'
		[http.response.return] = [http.response.out]#' Request Timeout'
	elseif [http.response.out] = '409'
		[http.response.return] = [http.response.out]#' Conflict'
	elseif [http.response.out] = '410'
		[http.response.return] = [http.response.out]#' Gone'
	elseif [http.response.out] = '411'
		[http.response.return] = [http.response.out]#' Length Required'
	elseif [http.response.out] = '412'
		[http.response.return] = [http.response.out]#' Precondition Failed'
	elseif [http.response.out] = '413'
		[http.response.return] = [http.response.out]#' Request Entity Too Large'
	elseif [http.response.out] = '414'
		[http.response.return] = [http.response.out]#' URI Too Long'
	elseif [http.response.out] = '415'
		[http.response.return] = [http.response.out]#' Unsupported Media Type'
	elseif [http.response.out] = '416'
		[http.response.return] = [http.response.out]#' Requested range not satisfiable'
	elseif [http.response.out] = '417'
		[http.response.return] = [http.response.out]#' Expectation Failed'
	elseif [http.response.out] = '420'
		[http.response.return] = [http.response.out]#' Policy Not Fulfilled'
	elseif [http.response.out] = '421'
		[http.response.return] = [http.response.out]#' Misdirected Request'
	elseif [http.response.out] = '422'		
		[http.response.return] = [http.response.out]#' Unprocessable Entity'
	elseif [http.response.out] = '423'
		[http.response.return] = [http.response.out]#' Locked'
	elseif [http.response.out] = '424'
		[http.response.return] = [http.response.out]#' Failed Dependency'
	elseif [http.response.out] = '426'
		[http.response.return] = [http.response.out]#' Upgrade Required'
	elseif [http.response.out] = '428'
		[http.response.return] = [http.response.out]#' Precondition Required'
	elseif [http.response.out] = '429'
		[http.response.return] = [http.response.out]#' Too Many Requests'
	elseif [http.response.out] = '431'
		[http.response.return] = [http.response.out]#' Request Header Fields Too Large'
	elseif [http.response.out] = '451'
		[http.response.return] = [http.response.out]#' Unavailable For Legal Reasons'
	elseif [http.response.out] = '500'
		[http.response.return] = [http.response.out]#' Internal Server Error'
	elseif [http.response.out] = '501'
		[http.response.return] = [http.response.out]#' Not Implemented'
	elseif [http.response.out] = '502'
		[http.response.return] = [http.response.out]#' Bad Gateway'
	elseif [http.response.out] = '503'
		[http.response.return] = [http.response.out]#' Service Unavailable'
	elseif [http.response.out] = '504'
		[http.response.return] = [http.response.out]#' Gateway Timeout'
	elseif [http.response.out] = '505'
		[http.response.return] = [http.response.out]#' HTTP Version not supported'
	elseif [http.response.out] = '506'
		[http.response.return] = [http.response.out]#' Variant Also Negotiates'
	elseif [http.response.out] = '507'
		[http.response.return] = [http.response.out]#' Insufficient Storage'
	elseif [http.response.out] = '508'
		[http.response.return] = [http.response.out]#' Loop Detected'
	elseif [http.response.out] = '509'
		[http.response.return] = [http.response.out]#' Bandwidth Limit Exceeded'
	elseif [http.response.out] = '510'
		[http.response.return] = [http.response.out]#' Not Extended'
	elseif [http.response.out] = '511'
		[http.response.return] = [http.response.out]#' Network Authentication Required'
	endif
	%http.return
	ret [http.response.return]
endfunc

func jsoncontent: [jc.input]
	[jc.counter] = '0'
	[jc.argend] = ''
	[jc.open] = '0'
	[jc.open2] = '0'
	[jc.close] = '0'
	[jc.close2] = '0'
	[jc.content] = ''
	repeat
		[jc.counter] + '1'
		getcharat [jc.charat] = [jc.input], [jc.counter]
		if [jc.charat] = '['
			[jc.argend] = [true]
		endif
		if [jc.charat] = '{'
			[jc.argend] = [true]
		endif
	until [jc.argend] = [true]
	[jc.argend] = [false]
	[jc.counter] - '1'
	repeat
		[jc.counter] + '1'
		getcharat [jc.charat] = [jc.input], [jc.counter]
		if [jc.charat] = '{'
			[jc.open2] + '1'
		endif
		if [jc.charat] = '}'
			[jc.close2] + '1'
		endif
		if [jc.charat] = '['
			[jc.open] + '1'
		endif
		if [jc.charat] = ']'
			[jc.close] + '1'
		endif
		[jc.content] = [jc.content]#''#[jc.charat]
	until [jc.open] = [jc.close] & [jc.open2] = [jc.close2]
	ret [jc.content]
endfunc

func json: [json.input], [json.arg], [json.cnt]
	[json.counter] = '0'
	[json.mark] = '0'
	[json.pos] = ''
	[json.argend] = [false]
	[json.return] = ''
	[json.exists] = ''
	[json.eclamp] = '0'
	[json.sclamp] = '0'
	getpos [json.exists] = [json.input], [json.arg], [json.cnt]
	if [json.exists] >= '1'
		getpos [json.pos] = [json.input], [json.arg], [json.cnt]
		[json.counter] = [json.pos] - '2'
		repeat
			[json.counter] + '1'
			getcharat [json.charat] = [json.input], [json.counter]
			if [json.charat] = '"' & [json.mark] = '0'
				[json.mark] + '1'
			elseif [json.charat] = '"' & [json.mark] = '1'
				[json.mark] - '1'
			endif
			if [json.charat] = ':'
				[json.argend] = [true]
			else
				[json.argend] = [false]
			endif
		until [json.mark] = '0' & [json.argend] = [true]
		repeat
			[json.counter] + '1'
			getcharat [json.charat] = [json.input], [json.counter]
			if [json.charat] = '['
				[json.eclamp] + '1'
			elseif [json.charat] = ']'
				[json.eclamp] - '1'
			endif
			if [json.charat] = '{'
				[json.sclamp] + '1'
			elseif [json.charat] = '}'
				[json.sclamp] - '1'
			endif
			if [json.charat] = '"' & [json.mark] = '0'
				[json.mark] = '1'
			elseif [json.charat] = '"' & [json.mark] = '1'
				[json.mark] = '0'
			endif
			[json.return] = [json.return]#''#[json.charat]
		until [json.eclamp] = '0' & [json.sclamp] = '0' & [json.mark] = '0'
	else
		[json.return] = 'JSONARG_NOT_IN_INPUT'
	endif
	ret [json.return]
endfunc

func logout: [lo.xsession], [lo.quit]
	[points] = ''
	console 'write', 'Logging out...'
	call 'curl.exe -X DELETE https://api.2k.com/borderlands/users/me -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -H "X-SESSION: '#[lo.xsession]#'" -i -o logoff.txt', 'hide'
	httpresponse [lo.response] = 'logoff.txt'
	delfile 'logoff.txt'
	wait '200'
	if [lo.response] ! '200 OK'
		console 'continue', 'failed'
		confirm [lo.retry] = 'Logout was not successfully. It is safer to logout correctly, but you can also just continue. Do you want to retry?'
		if [lo.retry] = [true]
			logout [lo.null] = [lo.xsession], [lo.quit]
		endif
	else
		console 'continue', 'SUCCESS!'
	endif
	if [lo.quit] = [true]
		goto 'exit'
	else
		goto 'login'
	endif
endfunc

proc gkwrite: [gk.code]
	if [gk.code.old] ! [gk.code]
		writefile [shiftid]#'.codes', [gk.code]#''#[new_line]	
	endif
	[gk.code.old] = [gk.code]
endproc

func getredeemed: [gr.cookie]
	console 'write', 'Getting already Redeemed Codes...'
	call 'curl.exe -X POST https://2kgames.crowdtwist.com/request?widgetId=9470 -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -H "Cookie: '#[gr.cookie]#'" -d "{\"model_data\":{\"activity\":{\"newest_activities\":{\"properties\":[\"notes\",\"title\"],\"query\":{\"type\":\"user_activities_me\",\"args\":{\"row_start\":1,\"row_end\":99999}}}}}}" -i -o redcodes.txt', 'hide'
	readfile [redcodes.data] = 'redcodes.txt', '0'
	httpresponse [gr.response] = 'redcodes.txt'
	delfile 'redcodes.txt'
	jsoncontent [redcodes.data] = [redcodes.data]
	if [gr.response] = '403 Forbidden'
		echo 'Server had forbid the access. Try to start this program again and login again to get a new session.'
		[gr.return] = 'failed'
	elseif [gr.response] = 'R/W_Error'
		echo 'Cannot read file. Do you need Admin Privilegs in this folder?'
		[gr.return] = 'failed'
	elseif [gr.response] ! '200 OK'
		echo 'Unexpected Response from Server! '#[gr.response]
		[gr.return] = 'failed'
	endif
	console 'continue', 'SUCCESS!'
	[gr.vaultcnt] = '0'
	[gr.emailcnt] = '0'
	[gr.creatorcnt] = '0'
	if [gr.return] ! 'failed'
		[gr.counter2] = '0'
		repeat
			getpos [gr.pos] = [redcodes.data], '{', '4'
			[gr.pos] - '1'
			[gr.out] = '0'
			[gr.counter] = [gr.pos]
			[gr.open] = '0'
			[gr.close] = '0'
			[gr.string] = ''			
			[gr.counter2] + '1'
			repeat
				[gr.counter] + '1'
				getcharat [gr.charat] = [redcodes.data], [gr.counter]
				if [gr.charat] = '{'
					[gr.open] + '1'
				endif
				if [gr.charat] = '}'
					[gr.close] + '1'
				endif
				[gr.string] = [gr.string]#''#[gr.charat]
			until [gr.open] = [gr.close]			
			json [gr.notes:[gr.counter2]] = [gr.string], '"notes"', '1'
			json [gr.title:[gr.counter2]] = [gr.string], '"title"', '1'
			if [gr.notes:[gr.counter2]] = 'JSONARG_NOT_IN_INPUT'
				[gr.out] + '1'
			endif
			if [gr.title:[gr.counter2]] = 'JSONARG_NOT_IN_INPUT'
				[gr.out] + '1'
			endif
			if [gr.out] < '2'
				replacevar [gr.notes:[gr.counter2]] = [gr.notes:[gr.counter2]], '"', ''
				replacevar [gr.title:[gr.counter2]] = [gr.title:[gr.counter2]], '"', ''
				replacevar [redcodes.data] = [redcodes.data], [gr.string]#',', [null]
				replacevar [redcodes.data] = [redcodes.data], [gr.string], [null]
				upvar [gr.notes:[gr.counter2]] = [gr.notes:[gr.counter2]]
				[gr.vault] = '0'
				[gr.email] = '0'
				[gr.creator] = '0'
				cntvar [gr.vault] = [gr.title:[gr.counter2]], 'Redeem a Vault Code'
				cntvar [gr.email] = [gr.title:[gr.counter2]], 'Redeem an Email Code'
				cntvar [gr.creator] = [gr.title:[gr.counter2]], 'Redeem a Creator Code'
				if [gr.vault] = '1'
					[gr.vaultcnt] + '1'
					if [gr.vaultcnt] = '1'
						[gr.vaultlist] = [gr.notes:[gr.counter2]]
					else
						[gr.vaultlist] = [gr.vaultlist]#'|'#[gr.notes:[gr.counter2]]
					endif
				elseif [gr.email] = '1'
					[gr.emailcnt] + '1'
					if [gr.emailcnt] = '1'
						[gr.emaillist] = [gr.notes:[gr.counter2]]
					else
						[gr.emaillist] = [gr.emaillist]#'|'#[gr.notes:[gr.counter2]]
					endif
				elseif [gr.creator] = '1'
					[gr.creatorcnt] + '1'
					if [gr.creatorcnt] = '1'
						[gr.creatorlist] = [gr.notes:[gr.counter2]]
					else
						[gr.creatorlist] = [gr.creatorlist]#'|'#[gr.notes:[gr.counter2]]
					endif
				endif
			else
				[gr.notes:[gr.counter2]] = [null]
				[gr.title:[gr.counter2]] = [null]
			endif
		until [gr.out] >= '2'
		fileexists [gr.gkcheck] = [shiftid]#'.codes'
		if [gr.gkcheck] = [true]
			readfile [gr.gkred] = [shiftid]#'.codes', '0'
			replacevar [gr.gkred] = [gr.gkred], [new_line], '|'
		endif
		[gr.return] = [gr.vaultlist]#'|=-\'#[gr.emaillist]#'|=-\'#[gr.creatorlist]#'|=-\'#[gr.gkred]
	elseif
		[gr.return] = 'FAILED'
	endif
	[redcodes.data] = [null]
	ret [gr.return]
endfunc

func redeemcodes: [rc.vaultcheck], [rc.emailcheck], [rc.creatorcheck], [rc.gkcheck], [rc.vipcheck], [rc.cookie], [rc.platforms], [rc.xsession]
	gettok [rc.platform.steam] = [rc.platforms], '|', '1'
	gettok [rc.platform.playstation] = [rc.platforms], '|', '2'
	gettok [rc.platform.xbox] = [rc.platforms], '|', '3'
	gettok [rc.platform.epic] = [rc.platforms], '|', '4'
	if [rc.vipcheck] = [true]
		console 'write', 'Getting activity data...'
		getactivities [rc.activities] = [rc.cookie]
		[rc.cnt] = '0'
		cntvar [rc.actnamecnt] = [rc.activities], '"name"'
		console 'write', 'Filter activity names (1 of '#[rc.actnamecnt]#')...'
		repeat
			[rc.cnt] + '1'
			json [rc.actname] = [rc.activities], '"name"', [rc.cnt]
			if [rc.actname] ! 'JSONARG_NOT_IN_INPUT'
				console 'rewrite', 'Filter activity names ('#[rc.cnt]#' of '#[rc.actnamecnt]#' Activities)...'
				replacevar [rc.actname] = [rc.actname], '"', '\"'
				if [rc.cnt] = '1'
					[rc.actnames] = ''#[rc.actname]#''
				else
					[rc.actnames] = [rc.actnames]#','#[rc.actname]#''
				endif
			endif
		until [rc.actname] = 'JSONARG_NOT_IN_INPUT'
		console 'write', 'Getting user-related activity data...'
		call 'curl.exe -X POST https://2kgames.crowdtwist.com/request?widgetId=9446 -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://2kgames.crowdtwist.com" -H "Referer: https://2kgames.crowdtwist.com/widgets/t/activity-list/9446" -H "Cookie: '#[rc.cookie]#'" -d "{\"model_data\":{\"activity\":{\"activities\":{\"properties\":[\"link_href\",\"name\",\"num_points\",\"user_activity_status\"],\"query\":{\"type\":\"activities_by_name\",\"args\":{\"names\":['#[rc.actnames]#']}}}}}}" -i -o activities2.txt', 'hide'
		httpresponse [rc.response] = 'activities2.txt'
		if [rc.response] = '200 OK'
			console 'continue', 'DONE!'
			readfile [rc.activitydata] = 'activities2.txt', '0'
			delfile 'activities2.txt'
			jsoncontent [rc.activitydata] = [rc.activitydata]
			cntvar [rc.actnamecnt2] = [rc.activitydata], '"name"'
			console 'write', 'Processing activity 1 of '#[rc.actnamecnt2]#'...'
			[rc.counter] = '0'
			[rc.counter2] = '0'
			repeat
				[rc.counter] + '1'
				json [rc.activity.cap] = [rc.activitydata], '"has_reached_freq_cap"', [rc.counter]
				if [rc.activity.cap] ! 'JSONARG_NOT_IN_INPUT'
					console 'rewrite', 'Processing activity '#[rc.counter]#' of '#[rc.actnamecnt2]#'...'
				endif
				if [rc.activity.cap] = 'f'
					[rc.counter2] + '1'
					json [rc.activity.link:[rc.counter2]] = [rc.activitydata], '"link_href"', [rc.counter]
					replacevar [rc.activity.link:[rc.counter2]] = [rc.activity.link:[rc.counter2]], '"', ''
					[rc.cntvar] = '0'
					cntvar [rc.cntvar] = [rc.activity.link:[rc.counter2]], 'locale-redirect.html'
					if [rc.cntvar] = '0'
						replacevar [rc.activity.link:[rc.counter2]] = [rc.activity.link:[rc.counter2]], '\/', '/'
						json [rc.activity.name:[rc.counter2]] = [rc.activitydata], '"name"', [rc.counter]
					else
						[rc.activity.link:[rc.counter2]] = [null]
						[rc.counter2] - '1'
					endif
				endif
			until [rc.activity.cap] = 'JSONARG_NOT_IN_INPUT'
			[rc.counter] = '0'
			if [rc.counter2] ! '0'
				repeat
					[rc.counter] + '1'
					console 'write', 'Doing activity '#[rc.activity.name:[rc.counter]]#'...'
					call 'curl.exe -X GET '#[rc.activity.link:[rc.counter]]#' -H "Cookie: '#[rc.cookie]#'" -i -o vipactres.txt', 'hide'
					httpresponse [rc.response] = 'vipactres.txt'
					delfile 'vipactres.txt'
					if [rc.response] = '200 OK!'
						console 'continue', 'SUCCESS!'
					elseif [rc.response] = '301 Moved Permanently'
						console 'continue', 'SUCCESS!'
					else
						console 'continue', 'FAILED!'
					endif
				until [rc.counter] = [rc.counter2]
			else
				console 'write', 'No untapped activities at this time!'
			endif
		endif
	endif
	[rc.checksum] = [rc.vaultcheck] + [rc.emailcheck] + [rc.creatorcheck] + [rc.gkcheck]
	if [rc.checksum] >= '-3'
		[rc.redeemvip] = [false]
		getredeemed [rc.redcodes.raw] = [rc.cookie]
		console 'write', 'Preparing already redeemed codes...'
		if [rc.vaultcheck] = [true]
			gettok [rc.redcodes.vault] = [rc.redcodes.raw], '=-\', '1'
			[rc.counter] = '0'
			[rc.redeemvip] = [true]
			repeat
				[rc.counter] + '1'
				gettok [rc.redcodes.vault:[rc.counter]] = [rc.redcodes.vault], '|', '1'
				replacevar [rc.redcodes.vault] = [rc.redcodes.vault], [rc.redcodes.vault:[rc.counter]]#'|', ''
				upvar [rc.redcodes.vault:[rc.counter]] = [rc.redcodes.vault:[rc.counter]]
			until [rc.redcodes.vault:[rc.counter]] = ''
		endif
		if [rc.emailcheck] = [true]
			gettok [rc.redcodes.email] = [rc.redcodes.raw], '=-\', '2'
			[rc.counter] = '0'
			[rc.redeemvip] = [true]
			repeat
				[rc.counter] + '1'
				gettok [rc.redcodes.email:[rc.counter]] = [rc.redcodes.email], '|', '1'
				replacevar [rc.redcodes.email] = [rc.redcodes.email], [rc.redcodes.email:[rc.counter]]#'|', ''
				upvar [rc.redcodes.email:[rc.counter]] = [rc.redcodes.email:[rc.counter]]
			until [rc.redcodes.email:[rc.counter]] = ''
		endif
		if [rc.creatorcheck] = [true]
			gettok [rc.redcodes.creator] = [rc.redcodes.raw], '=-\', '3'
			[rc.counter] = '0'
			[rc.redeemvip] = [true]
			repeat
				[rc.counter] + '1'
				gettok [rc.redcodes.creator:[rc.counter]] = [rc.redcodes.creator], '|', '1'
				replacevar [rc.redcodes.creator] = [rc.redcodes.creator], [rc.redcodes.creator:[rc.counter]]#'|', ''
				upvar [rc.redcodes.creator:[rc.counter]] = [rc.redcodes.creator:[rc.counter]]
			until [rc.redcodes.creator:[rc.counter]] = ''
		endif
		if [rc.gkcheck] = [true]
			[rc.counter] = '0'
			gettok [rc.redcodes.gk] = [rc.redcodes.raw], '=-\', '4'
			if [rc.redcodes.gk] ! ''
				repeat
					[rc.counter] + '1'
					gettok [rc.redcodes.gk:[rc.counter]] = [rc.redcodes.gk], '|', '1'
					replacevar [rc.redcodes.gk] = [rc.redcodes.gk], [rc.redcodes.gk:[rc.counter]]#'|', ''
					upvar [rc.redcodes.gk:[rc.counter]] = [rc.redcodes.gk:[rc.counter]]
				until [rc.redcodes.gk:[rc.counter]] = ''
			endif
		endif
		console 'continue', 'DONE!'
		[rc.redcodes.raw] = [null]
		if [rc.redeemvip] = [true]
			console 'write', 'Data provided by Orcicorns SHiFT and VIP Code archive. Visit him on Twitter!'
			console 'write', 'Getting new VIP Codes...'
			call 'curl.exe -X GET https://shift.orcicorn.com/vip-code/index.json -i -o activevipcodes.txt', 'hide'
			httpresponse [rc.response] = 'activevipcodes.txt'
			if [rc.response] = '403 Forbidden'
				echo 'Server had forbid the access. Could not get new codes. There is nothing you can do.'
				[rc.return] = 'failed'
			elseif [rc.response] = 'R/W_Error'
				echo 'Cannot read file. Do you need Admin Privilegs in this folder?'
				[rc.return] = 'failed'
			elseif [rc.response] ! '200 OK'
				echo 'Unexpected Response from Server! '#[rc.response]
				[rc.return] = 'failed'
			endif
			if [rc.return] = 'failed'
				goto 'rc.end'
			endif
			console 'continue', 'SUCCESS!'
			console 'write', 'Filtering and sorting new VIP codes...'
			readfile [rc.data] = 'activevipcodes.txt', '0'
			delfile 'activevipcodes.txt'
			jsoncontent [rc.data] = [rc.data]
			cntvar [rc.code.counter] = [rc.data], '"code"'
			getpos [rc.pos] = [rc.data], '[', '2'
			[rc.counter2] = '0'
			console 'write', 'Processing VIP-Code 1 of '#[rc.code.counter]
			repeat
				[rc.counter] = [rc.pos]
				[rc.open] = '0'
				[rc.close] = '0'
				[rc.string] = [null]
				repeat
					[rc.counter] + '1'
					getcharat [rc.charat] = [rc.data], [rc.counter]
					if [rc.charat] = '{'
						[rc.open] + '1'
					endif
					if [rc.charat] = '}'
						[rc.close] + '1'
					endif
					[rc.string] = [rc.string]#''#[rc.charat]
				until [rc.open] = [rc.close]
				[rc.counter2] + '1'
				json [rc.newcode.code:[rc.counter2]] = [rc.data], '"code"', '1'
				if [rc.newcode.code:[rc.counter2]] ! 'JSONARG_NOT_IN_INPUT'
					console 'rewrite', 'Processing VIP-Code '#[rc.counter2]#' of '#[rc.code.counter]
					upvar [rc.newcode.code:[rc.counter2]] = [rc.newcode.code:[rc.counter2]]
					replacevar [rc.newcode.code:[rc.counter2]] = [rc.newcode.code:[rc.counter2]], '"', ''
					json [rc.newcode.platform:[rc.counter2]] = [rc.data], '"platform"', '1'
					upvar [rc.newcode.platform:[rc.counter2]] = [rc.newcode.platform:[rc.counter2]]
					replacevar [rc.newcode.platform:[rc.counter2]] = [rc.newcode.platform:[rc.counter2]], '"', ''
					json [rc.newcode.reward:[rc.counter2]] = [rc.data], '"reward"', '1'
					replacevar [rc.newcode.reward:[rc.counter2]] = [rc.newcode.reward:[rc.counter2]], '"', ''
					json [rc.newcode.type:[rc.counter2]] = [rc.data], '"type"', '1'
					upvar [rc.newcode.type:[rc.counter2]] = [rc.newcode.type:[rc.counter2]]
					replacevar [rc.newcode.type:[rc.counter2]] = [rc.newcode.type:[rc.counter2]], '"', ''
					replacevar [rc.data] = [rc.data], [rc.string]#',', [null]
					replacevar [rc.data] = [rc.data], [rc.string], [null]				
				endif
			until [rc.newcode.code:[rc.counter2]] = 'JSONARG_NOT_IN_INPUT'
		endif
		if [rc.gkcheck] = [true]
			console 'write', 'Data provided by Orcicorns SHiFT and VIP Code archive. Visit him on Twitter!'
			console 'write', 'Getting new SHiFT Codes...'
			call 'curl.exe -X GET https://shift.orcicorn.com/shift-code/index.json -i -o activeshiftcodes.txt', 'hide'
			httpresponse [rc.response] = 'activeshiftcodes.txt'
			if [rc.response] = '403 Forbidden'
				echo 'Server had forbid the access. Could not get new codes. There is nothing you can do.'
				[rc.return] = 'failed'
			elseif [rc.response] = 'R/W_Error'
				echo 'Cannot read file. Do you need Admin Privilegs in this folder?'
				[rc.return] = 'failed'
			elseif [rc.response] ! '200 OK'
				echo 'Unexpected Response from Server! '#[rc.response]
				[rc.return] = 'failed'
			endif
			if [rc.return] = 'failed'
				goto 'rc.end'
			endif
			console 'continue', 'SUCCESS!'
			console 'write', 'Filtering and sorting new SHiFT codes...'
			readfile [rc.data] = 'activeshiftcodes.txt', '0'
			delfile 'activeshiftcodes.txt'
			jsoncontent [rc.data] = [rc.data]
			cntvar [rc.code.counter] = [rc.data], '"code"'
			getpos [rc.pos] = [rc.data], '[', '2'
			if [rc.redeemvip] = [true]
				[rc.counter2] - '1'
			else
				[rc.counter] = '0'
			endif
			[rc.counter3] = '0'
			console 'rewrite', 'Processing SHiFT-Code 1 of '#[rc.code.counter]
			repeat
				[rc.counter] = [rc.pos]
				[rc.open] = '0'
				[rc.close] = '0'
				[rc.string] = [null]
				repeat
					[rc.counter] + '1'
					getcharat [rc.charat] = [rc.data], [rc.counter]
					if [rc.charat] = '{'
						[rc.open] + '1'
						endif
					if [rc.charat] = '}'
						[rc.close] + '1'
					endif
					[rc.string] = [rc.string]#''#[rc.charat]
				until [rc.open] = [rc.close]
				[rc.counter2] + '1'
				json [rc.newcode.code:[rc.counter2]] = [rc.data], '"code"', '1'
				if [rc.newcode.code:[rc.counter2]] ! 'JSONARG_NOT_IN_INPUT'
					[rc.counter3] + '1'
					console 'rewrite', 'Processing SHiFT-Code '#[rc.counter3]#' of '#[rc.code.counter]
					upvar [rc.newcode.code:[rc.counter2]] = [rc.newcode.code:[rc.counter2]]
					replacevar [rc.newcode.code:[rc.counter2]] = [rc.newcode.code:[rc.counter2]], '"', ''
					json [rc.newcode.platform:[rc.counter2]] = [rc.data], '"platform"', '1'
					upvar [rc.newcode.platform:[rc.counter2]] = [rc.newcode.platform:[rc.counter2]]
					replacevar [rc.newcode.platform:[rc.counter2]] = [rc.newcode.platform:[rc.counter2]], '"', ''
					json [rc.newcode.reward:[rc.counter2]] = [rc.data], '"reward"', '1'
					replacevar [rc.newcode.reward:[rc.counter2]] = [rc.newcode.reward:[rc.counter2]], '"', ''
					json [rc.newcode.type:[rc.counter2]] = [rc.data], '"type"', '1'
					upvar [rc.newcode.type:[rc.counter2]] = [rc.newcode.type:[rc.counter2]]
					replacevar [rc.newcode.type:[rc.counter2]] = [rc.newcode.type:[rc.counter2]], '"', ''
					replacevar [rc.data] = [rc.data], [rc.string]#',', [null]
					replacevar [rc.data] = [rc.data], [rc.string], [null]
				endif
			until [rc.newcode.code:[rc.counter2]] = 'JSONARG_NOT_IN_INPUT'
		endif
		[rc.counter] = '1'
		[rc.counter2] = '0'
		[rc.found] = [false]
		[rc.repeat.quit] = [false]
		repeat
			if [rc.newcode.type:[rc.counter]] = 'VIP'
				if [rc.newcode.platform:[rc.counter]] = 'VAULT' & [rc.vaultcheck] = [true]
					repeat
						[rc.counter2] + '1'
						if [rc.newcode.code:[rc.counter]] = [rc.redcodes.vault:[rc.counter2]]
							[rc.repeat.quit] = [true]
							[rc.newcode.code:[rc.counter]] = [null]
							[rc.newcode.platform:[rc.counter]] = [null]
							[rc.newcode.reward:[rc.counter]] = [null]
						endif
						if [rc.redcodes.vault:[rc.counter2]] = ''
							[rc.repeat.quit] = [true]
						endif
						if [rc.newcode.code:[rc.counter]] = ''
							[rc.repeat.quit] = [true]
						endif
					until [rc.repeat.quit] = [true]
				elseif [rc.newcode.platform:[rc.counter]] = 'EMAIL' & [rc.emailcheck] = [true]
					repeat
						[rc.counter2] + '1'
						if [rc.newcode.code:[rc.counter]] = [rc.redcodes.email:[rc.counter2]]
							[rc.repeat.quit] = [true]
							[rc.newcode.code:[rc.counter]] = [null]
							[rc.newcode.platform:[rc.counter]] = [null]
							[rc.newcode.reward:[rc.counter]] = [null]
						endif
						if [rc.redcodes.email:[rc.counter2]] = ''
							[rc.repeat.quit] = [true]
						endif
						if [rc.newcode.code:[rc.counter]] = ''
							[rc.repeat.quit] = [true]
						endif
					until [rc.repeat.quit] = [true]
				elseif [rc.newcode.platform:[rc.counter]] = 'CREATOR' & [rc.creatorcheck] = [true]
					repeat
						[rc.counter2] + '1'
						if [rc.newcode.code:[rc.counter]] = [rc.redcodes.creator:[rc.counter2]]
							[rc.repeat.quit] = [true]
							[rc.newcode.code:[rc.counter]] = [null]
							[rc.newcode.platform:[rc.counter]] = [null]
							[rc.newcode.reward:[rc.counter]] = [null]
						endif
						if [rc.redcodes.creator:[rc.counter2]] = ''
							[rc.repeat.quit] = [true]
						endif
						if [rc.newcode.code:[rc.counter]] = ''
							[rc.repeat.quit] = [true]
						endif
					until [rc.repeat.quit] = [true]
				endif
			elseif [rc.newcode.type:[rc.counter]] = 'SHIFT' & [rc.gkcheck] = [false]
				[rc.newcode.platform:[rc.counter]] = [null]
				[rc.newcode.code:[rc.counter]] = [null]
			elseif [rc.newcode.type:[rc.counter]] = 'SHIFT' & [rc.gkcheck] = [true]
				repeat
					[rc.counter2] + '1'
					if [rc.newcode.code:[rc.counter]] = [rc.redcodes.gk:[rc.counter2]]
						[rc.repeat.quit] = [true]
						[rc.newcode.code:[rc.counter]] = [null]
						[rc.newcode.platform:[rc.counter]] = [null]
						[rc.newcode.reward:[rc.counter]] = [null]
					endif
					if [rc.redcodes.gk:[rc.counter2]] = ''
						[rc.repeat.quit] = [true]
					endif
					if [rc.newcode.code:[rc.counter]] = ''
						[rc.repeat.quit] = [true]
					endif
				until [rc.repeat.quit] = [true]
			endif
			[rc.repeat.quit] = [false]
			[rc.counter] + '1'
			[rc.counter2] = '0'
		until [rc.newcode.code:[rc.counter]] = 'JSONARG_NOT_IN_INPUT'
		[rc.counter] = '0'
		repeat
			[rc.counter] + '1'
			[steamval] = '0'
			[xboxval] = '0'
			[psnval] = '0'
			[epicval] = '0'
			if [rc.newcode.code:[rc.counter]] ! 'JSONARG_NOT_IN_INPUT'
				if [rc.newcode.platform:[rc.counter]] = 'VAULT' & [rc.vaultcheck] = [true]
					console 'write', 'Redeeming VAULT Code "'#[rc.newcode.code:[rc.counter]]#'"...'
					call 'curl.exe -X POST https://2kgames.crowdtwist.com/code-redemption-campaign/redeem?cid=5261 -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -H "Cookie: '#[rc.cookie]#'" -d "{\"code\":\"'#[rc.newcode.code:[rc.counter]]#'\"}" -i -o redres.txt', 'hide'
					httpresponse [redres] = 'redres.txt'
					delfile 'redres.txt'
					if [redres] ! '200 OK'
						console 'continue', 'failed! Code is invalid.'
					elseif [redres] = '200 OK'
						console 'continue', 'SUCCESS! Your reward: '#[rc.newcode.reward:[rc.counter]]
					endif
				elseif [rc.newcode.platform:[rc.counter]] = 'EMAIL' & [rc.emailcheck] = [true]
					console 'write', 'Redeeming EMAIL Code "'#[rc.newcode.code:[rc.counter]]#'"... '
					call 'curl.exe -X POST https://2kgames.crowdtwist.com/code-redemption-campaign/redeem?cid=5264 -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -H "Cookie: '#[rc.cookie]#'" -d "{\"code\":\"'#[rc.newcode.code:[rc.counter]]#'\"}" -i -o redres.txt', 'hide'
					httpresponse [redres] = 'redres.txt'
					delfile 'redres.txt'
					if [redres] ! '200 OK'
						console 'continue', 'failed! Code is invalid.'
					elseif [redres] = '200 OK'
						console 'continue', 'SUCCESS! Your reward: '#[rc.newcode.reward:[rc.counter]]
					endif
				elseif [rc.newcode.platform:[rc.counter]] = 'CREATOR' & [rc.creatorcheck] = [true]
					console 'write', 'Redeeming CREATOR Code "'#[rc.newcode.code:[rc.counter]]#'"... '
					call 'curl.exe -X POST https://2kgames.crowdtwist.com/code-redemption-campaign/redeem?cid=5263 -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -H "Cookie: '#[rc.cookie]#'" -d "{\"code\":\"'#[rc.newcode.code:[rc.counter]]#'\"}" -i -o redres.txt', 'hide'
					httpresponse [redres] = 'redres.txt'
					delfile 'redres.txt'
					if [redres] ! '200 OK'
						console 'continue', 'failed! Code is invalid.'
					elseif [redres] = '200 OK'
						console 'continue', 'SUCCESS! Your reward: '#[rc.newcode.reward:[rc.counter]]
					endif
				elseif [rc.newcode.platform:[rc.counter]] = 'UNIVERSAL' & [rc.gkcheck] = [true]
					[steamval] = '1'
					[xboxval] = '1'
					[psnval] = '1'
					[epicval] = '1'
				elseif [rc.newcode.platform:[rc.counter]] = 'PLAYSTATION' & [rc.gkcheck] = [true]
					[psnval] = '1'
				elseif [rc.newcode.platform:[rc.counter]] = 'XBOX' & [rc.gkcheck] = [true]
					[xboxval] = '1'
				elseif [rc.newcode.platform:[rc.counter]] = 'STEAM' & [rc.gkcheck] = [true]
					[steamval] = '1'
				elseif [rc.newcode.platform:[rc.counter]] = 'EPIC' & [rc.gkcheck] = [true]
					[epicval] = '1'
				endif
				if [steamval] = '1' & [rc.platform.steam] >= '1'
					console 'write', 'Redeeming SHIFT Code '#[rc.newcode.code:[rc.counter]]#' for Steam... '
					rundialog [schmeissweg] = '1000'
					redeemgk [status] = 'steam', [rc.newcode.code:[rc.counter]], [rc.xsession]
					if [status] = 'SUCCESS'
						console 'continue', 'success! You got '#[rc.newcode.reward:[rc.counter]]#''
						cntvar [rc.gkcounter] = [rc.newcode.reward:[rc.counter]], 'Gold Key'
						if [rc.gkcounter] >= '1'
							gettok [rc.gktok] = [rc.newcode.reward:[rc.counter]], ' ', '1'
							[rc.steamgk] = [rc.steamgk] + [rc.gktok]
						else
							if [rc.steamre] = ''
								[rc.steamre] = [rc.newcode.reward:[rc.counter]]
							else
								[rc.steamre] = [rc.steamre]#', '#[rc.newcode.reward:[rc.counter]]
							endif
						endif
					elseif [status] = 'FAILED_NOTABLE'
						confirm [rc.notable.question] = 'It was not possible to redeem "'#[rc.newcode.code:[rc.counter]]#'". Would you like to mark it as redeemed, so the code will be skipped next time?'
						if [rc.notable.question] = [true]
							gkwrite [rc.newcode.code:[rc.counter]]
						endif
					elseif [status] = 'EMERGENCY_QUIT'
						goto 'rc.end'
					endif
				endif
				if [xboxval]  = '1' & [rc.platform.xbox] >= '1'
					console 'write', 'Redeeming SHIFT Code '#[rc.newcode.code:[rc.counter]]#' for XBOX... '
					rundialog [schmeissweg] = '1000'
					redeemgk [status] = 'xboxlive', [rc.newcode.code:[rc.counter]], [rc.xsession]
					if [status] = 'SUCCESS'
						console 'continue', 'success! You got '#[rc.newcode.reward:[rc.counter]]#''
						cntvar [rc.gkcounter] = [rc.newcode.reward:[rc.counter]], 'Gold Key'
						if [rc.gkcounter] >= '1'
							gettok [rc.gktok] = [rc.newcode.reward:[rc.counter]], ' ', '1'
							[rc.xboxgk] = [rc.xboxgk] + [rc.gktok]
						else
							if [rc.xboxre] = ''
								[rc.xboxre] = [rc.newcode.reward:[rc.counter]]
							else
								[rc.xboxre] = [rc.xboxre]#', '#[rc.newcode.reward:[rc.counter]]
							endif
						endif
					elseif [status] = 'FAILED_NOTABLE'
						confirm [rc.notable.question] = 'It was not possible to redeem "'#[rc.newcode.code:[rc.counter]]#'". Would you like to mark it as redeemed, so the code will be skipped next time?'
						if [rc.notable.question] = [true]
							gkwrite [rc.newcode.code:[rc.counter]]
						endif
					elseif [status] = 'EMERGENCY_QUIT'
						goto 'rc.end'
					endif
				endif
				if [psnval] = '1' & [rc.platform.playstation] >= '1'
					console 'write', 'Redeeming SHIFT Code '#[rc.newcode.code:[rc.counter]]#' for PlayStation... '
					rundialog [schmeissweg] = '1000'
					redeemgk [status] = 'psn', [rc.newcode.code:[rc.counter]], [rc.xsession]
					if [status] = 'SUCCESS'
						console 'continue', 'success! You got '#[rc.newcode.reward:[rc.counter]]#''
						cntvar [rc.gkcounter] = [rc.newcode.reward:[rc.counter]], 'Gold Key'
						if [rc.gkcounter] >= '1'
							gettok [rc.gktok] = [rc.newcode.reward:[rc.counter]], ' ', '1'
							[rc.psgk] = [rc.psgk] + [rc.gktok]
						else
							if [rc.psre] = ''
								[rc.psre] = [rc.newcode.reward:[rc.counter]]
							else
								[rc.psre] = [rc.psre]#', '#[rc.newcode.reward:[rc.counter]]
							endif
						endif
					elseif [status] = 'FAILED_NOTABLE'
						confirm [rc.notable.question] = 'It was not possible to redeem "'#[rc.newcode.code:[rc.counter]]#'". Would you like to mark it as redeemed, so the code will be skipped next time?'
							if [rc.notable.question] = [true]
							gkwrite [rc.newcode.code:[rc.counter]]
						endif
					elseif [status] = 'EMERGENCY_QUIT'
						goto 'rc.end'
					endif
				endif
				if [epicval] = '1' & [rc.platform.epic] >= '1'
					console 'write', 'Redeeming SHIFT Code '#[rc.newcode.code:[rc.counter]]#' for Epic... '
					rundialog [schmeissweg] = '1000'
					redeemgk [status] = 'epic', [rc.newcode.code:[rc.counter]], [rc.xsession]
					if [status] = 'SUCCESS'
						console 'continue', 'success! You got '#[rc.newcode.reward:[rc.counter]]#''
						cntvar [rc.gkcounter] = [rc.newcode.reward:[rc.counter]], 'Gold Key'
						if [rc.gkcounter] >= '1'
							gettok [rc.gktok] = [rc.newcode.reward:[rc.counter]], ' ', '1'
							[rc.epicgk] = [rc.epicgk] + [rc.gktok]
						else	
							if [rc.epicre] = ''
								[rc.epicre] = [rc.newcode.reward:[rc.counter]]
							else
								[rc.epicre] = [rc.epicre]#', '#[rc.newcode.reward:[rc.counter]]
							endif
						endif
					elseif [status] = 'FAILED_NOTABLE'
						confirm [rc.notable.question] = 'It was not possible to redeem "'#[rc.newcode.code:[rc.counter]]#'". Would you like to mark it as redeemed, so the code will be skipped next time?'
						if [rc.notable.question] = [true]
							gkwrite [rc.newcode.code:[rc.counter]]
						endif
					elseif [status] = 'EMERGENCY_QUIT'
						goto 'rc.end'
					endif
				endif	
			endif
		until [rc.newcode.code:[rc.counter]] = 'JSONARG_NOT_IN_INPUT'
	endif
	
	console 'write', '##### SUMMARY #####'
	if [rc.steamgk] ! ''
		console 'write', 'Steam rewards: '#[rc.steamgk]#' new golden keys!'
		if [rc.steamre] ! ''
			console 'continue', ', '#[rc.steamre]
		endif
	endif
	if [rc.steamre] ! '' & [rc.steamgk] = ''
		console 'write', 'Steam rewards: '#[rc.steamre]
	endif
	
	if [rc.xboxgk] ! ''
		console 'write', 'Xbox rewards: '#[rc.xboxgk]#' new golden keys!'
		if [rc.xboxre] ! ''
			console 'continue', ', '#[rc.xboxre]
		endif
	endif
	if [rc.xboxre] ! '' & [rc.xboxgk] = ''
		console 'write', 'Xbox rewards: '#[rc.xboxre]
	endif
	
	if [rc.psgk] ! ''
		console 'write', 'PlayStation rewards: '#[rc.psgk]#' new golden keys!'
		if [rc.psre] ! ''
			console 'continue', ', '#[rc.psre]
		endif
	endif
	if [rc.psre] ! '' & [rc.psgk] = ''
		console 'write', 'PlayStation rewards: '#[rc.psre]
	endif
	
	if [rc.epicgk] ! ''
		console 'write', 'Epic rewards: '#[rc.epicgk]#' new golden keys!'
		if [rc.epicre] ! ''
			console 'continue', ', '#[rc.epicre]
		endif
	endif
	if [rc.epicre] ! '' & [rc.epicgk] = ''
		console 'write', 'Epic rewards: '#[rc.epicre]
	endif
	
	if [rc.steamgk] = '' & [rc.steamre] = '' & [rc.xboxgk] = '' & [rc.xboxre] = '' & [rc.psgk] = '' & [rc.psre] = '' & [rc.epicgk] = '' & [rc.epicre] = ''
		console 'write', 'No new rewards at this time!'
	endif
	[rc.steamgk] = ''
	[rc.steamre] = ''
	[rc.xboxgk] = ''
	[rc.xboxre] = ''
	[rc.psgk] = ''
	[rc.psre] = ''
	[rc.epicgk] = ''
	[rc.epicre] = ''
			
	%rc.end
	ret [rc.return]
endfunc

func getactivities: [ga.cookie]
	call 'curl.exe -X GET https://2kgames.crowdtwist.com/widgets/conf/activity-list/9446?f=setupConf -H "Referer: https://borderlands.com/en-US/vip/" -H "Cookie: '#[ga.cookie]#'" -i -o vipactivities.txt', 'hide'
	httpresponse [ga.response] = 'vipactivities.txt'
	if [ga.response] ! '200 OK'
		ret 'FAILED_UNEXPECTED_RESPONSE'
	endif
	[ga.cnt] = '0'
	repeat
		[ga.cnt] + '1'
		readfile [ga.linedata] = 'vipactivities.txt', [ga.cnt]
		cntvar [ga.varcnt] = [ga.linedata], 'setupConf'
		if [ga.varcnt] = '1'
			[ga.repout] = [true]
		endif
		if [ga.linedata] = 'EOF'
			[ga.repout] = [true]
		endif
	until [ga.repout] = [true]
	delfile 'vipactivities.txt'
	if [ga.linedata] = 'EOF'
		ret 'FAILED_INVALID_DATA'
	endif
	ret [ga.linedata]
endfunc

func refresh: [ref.oldpoints], [ref.cookie]
	console 'write', 'Getting Points-Data...'
	getpoints [ref.points] = [ref.cookie]
	if [ref.points] = 'failed'
		console 'continue', 'failed!'
		ret 'failed'
	endif
	gettok [ref.redpoints] = [ref.points], '|', '1'
	gettok [ref.totpoints] = [ref.points], '|', '2'
	if [ref.oldpoints] = [ref.points]
		console 'continue', 'SUCCESS!'
		console 'write', 'No new VIP-Points!'
	elseif [ref.oldpoints] ! '' & [ref.oldpoints] ! [ref.points]
		console 'continue', 'SUCCESS!'
		[ref.newpoints] = [ref.points] - [ref.oldpoints]
		console 'write', 'You got '#[ref.newpoints]#' more VIP-Points!'
	endif
	[ref.ret] = [ref.redpoints]#'|'#[ref.totpoints]
	ret [ref.ret]
endfunc

func redeemgk: [rgk.platform], [rgk.key], [rgk.xsession]
	call 'curl.exe -X POST https://api.2k.com/borderlands/code/'#[rgk.key]#'/redeem/'#[rgk.platform]#' -H "Origin: https://borderlands.com" -H "X-SESSION: '#[rgk.xsession]#'" -H "Referer: https://borderlands.com/en-US/vip/" -i -o redres.txt', 'hide'
	httpresponse [redres] = 'redres.txt'
	[rgk.return] = ''
	[rgk.warning.ignore] = [false]
	if [redres] ! '201 Created'
		[rgk.return] = 'DROP_FAILED'
	elseif [redres] = '201 Created'
		rundialog [schmeissweg] = '100'
	else
		ret [redres]
	endif
	if [rgk.return] ! 'DROP_FAILED'
		readfile [rgk.tmp] = 'redres.txt', '0'
		delfile 'redres.txt'
		jsoncontent [rgk.tmp] = [rgk.tmp]
		json [rgk.jobid] = [rgk.tmp], '"job_id"', '1'
		call 'curl.exe -X GET https://api.2k.com/borderlands/code/'#[rgk.key]#'/job/'#[rgk.jobid]#' -H "Origin: https://borderlands.com" -H "X-SESSION: '#[rgk.xsession]#'" -H "Referer: https://borderlands.com/en-US/vip/" -i -o redres.txt', 'hide'
		httpresponse [redres] = 'redres.txt'
		if [redres] ! '200 OK'
			readfile [rgk.tmp] = 'redres.txt', '0'
			delfile 'redres.txt'
			json [rgk.errorcode] = [rgk.tmp], '"errors"', '1'
			if [rgk.errorcode] = '["CODE_ALREADY_REDEEMED"]'
				console 'continue', 'already redeemed.'
				gkwrite [rgk.key]
			elseif [rgk.errorcode] = '["CODE_HAS_EXPIRED"]'
				console 'continue', 'expired.'
				gkwrite [rgk.key]
			else
				[rgk.return] = 'FAILED_NOTABLE'
			endif
		elseif [redres] = '200 OK'
			gkwrite [rgk.key]
			[rgk.return] = 'SUCCESS'
		endif
	else
		readfile [rgk.dropfail] = 'redres.txt', '0'
		delfile 'redres.txt'
		json [rgk.dropfail] = [rgk.dropfail], '"code"', '1'
		if [rgk.dropfail] = '"RATE_LIMITED"' & [rgk.warning.ignore] = [false]
			confirm [rgk.dropfail.confirm] = 'WARNING! The server did not accept the request because too many requests were sent or too fast. After an unknown time, inquiries are possible again but it is recommended to cancel the current process.'#[new_line]#'Do you want to cancel?'
			if [rgk.dropfail.confirm] = [true]
				console 'continue', 'drop failed. Limit exceeded. Process canceled.'
				[rgk.return] = 'EMERGENCY_QUIT'
			else
				console 'continue', 'drop failed. Limit exceeded. IGNORED'
				[rgk.warning.ignore] = [true]
			endif
		endif
	endif
	ret [rgk.return]
endfunc

func encryptpw: [encrypt.input], [encrypt.salt]
	[encrypt.counter] = '0'
	if [encrypt.salt] = ''
		repeat
			randvar [encrypt.random] = '300'
		until [encrypt.random] >= '100'
	else
		[encrypt.random] = [encrypt.salt]
	endif
	getlen [encrypt.inputlen] = [encrypt.input]
	[encrypt.inputlen] + '1'
	repeat
		[encrypt.inputlen] - '1'
		[encrypt.counter] + '1'
		getcharat [encrypt.char] = [encrypt.input], [encrypt.inputlen]
		getasc [encrypt.chr] = [encrypt.char]
		[encrypt.encryptedchar] = [encrypt.chr] + [encrypt.random]
		if [encrypt.counter] = '1'
			[encrypt.return] = [encrypt.random]#','#[encrypt.encryptedchar]
		else
			[encrypt.return] = [encrypt.return]#','#[encrypt.encryptedchar]
		endif
	until [encrypt.inputlen] = '1'
	[encrypt.random] = ''
ret [encrypt.return]
endfunc

func decryptpw: [decrypt.input]
	gettok [decrypt.key] = [decrypt.input], ',', '1'
	[decrypt.counter] = '0'
	repeat
		[decrypt.counter] + '1'
		gettok [decrypt.tok] = [decrypt.input], ',', [decrypt.counter]
	until [decrypt.tok] = ''
	[decrypt.maxchar] = [decrypt.counter]
	[decrypt.return] = ''
	repeat
		[decrypt.maxchar] - '1'
		gettok [decrypt.tok] = [decrypt.input], ',', [decrypt.maxchar]
		[decrypt.tok] = [decrypt.tok] - [decrypt.key]
		getchr [decrypt.decryptedchar] = [decrypt.tok]
		[decrypt.return] = [decrypt.return]#''#[decrypt.decryptedchar]
	until [decrypt.maxchar] = '2'
	ret [decrypt.return]
endfunc

func getpoints: [getpoints.input]
	[getpoints.return] = ''
	[getpoints.totalpoints] = ''
	call 'curl.exe -X POST https://2kgames.crowdtwist.com/request?widgetId=9468 -H "Content-Type: application/json;charset=UTF-8" -H "Origin: https://borderlands.com" -H "Referer: https://borderlands.com/en-US/vip/" -H "Cookie: '#[getpoints.input]#'" -d "{\"model_data\":{\"user\":{\"me\":{\"properties\":[\"total_points\",\"redeemable_points\"],\"query\":{\"type\":\"me\"}}}}}" -i -o points.txt', 'hide'
	httpresponse [code] = 'points.txt'
	if [code] = '403 Forbidden'
		echo 'Server had forbid the access. Try to start this program again and login again to get a new session.'
		[getpoints.return] = 'failed'
	elseif [code] = 'R/W_Error'
		echo 'Cannot read file. Do you need Admin Privilegs in this folder?'
		[getpoints.return] = 'failed'
	elseif [code] ! '200 OK'
		echo 'Unexpected Response from Server! '#[code]
		[getpoints.return] = 'failed'
	endif
	readfile [getpoints.data] = 'points.txt', '0'
	delfile 'points.txt'
	jsoncontent [getpoints.data] = [getpoints.data]
	getpos [getpoints.tp.cnt] = [getpoints.data] , '"total_points"', '1'
	repeat
		[getpoints.tp.cnt] + '1'
		getcharat [getpoints.tp.charat] = [getpoints.data], [getpoints.tp.cnt]
		if [getpoints.tp.charat] = ':'
			repeat
				[getpoints.tp.cnt] + '1'
				getcharat [getpoints.tp.charat] = [getpoints.data], [getpoints.tp.cnt]
				if [getpoints.tp.charat] ! ','
					[getpoints.totalpoints] = [getpoints.totalpoints]#''#[getpoints.tp.charat]
				endif
			until [getpoints.tp.charat] = ','
		endif
	until [getpoints.tp.charat] = ','
	json [getpoints.redpoints] = [getpoints.data], '"redeemable_points"', '1'
	replacevar [getpoints.redpoints] = [getpoints.redpoints], '"', ''
	replacevar [getpoints.totalpoints] = [getpoints.totalpoints], '"', ''
	if [getpoints.return] = ''
		[getpoints.return] = [getpoints.redpoints]#'|'#[getpoints.totalpoints]
	endif
	[getpoints.data] = [null]
	ret [getpoints.return]
endfunc

func getcookie: [getcookie.input]
	[getcookie.return] = [null]
	getpos [getcookie.x-ct-redirect.pos] = [getcookie.input], 'x-ct-redirect:', '1'
	if [getcookie.x-ct-redirect.pos] = '0' & [getcookie.input] ! [null]
		[getcookie.return] = 'failed_no_redirect'
		ret [getcookie.return]
	endif
	getlen [getcookie.x-ct-redirect.len] = 'x-ct-redirect:'
	[getcookie.counter] = '0'
	[getcookie.redirect] = [null]
	[getcookie.x-ct-redirect.counter] = [getcookie.x-ct-redirect.pos] + [getcookie.x-ct-redirect.len]
	getchr [carriagereturn] = '13'
	getchr [linefeed] = '10'
	repeat
		[getcookie.x-ct-redirect.counter] + '1'
		getcharat [getcookie.charat] = [getcookie.input], [getcookie.x-ct-redirect.counter]
		if [getcookie.charat] ! [new_line]
			[getcookie.redirect]  = [getcookie.redirect]#''#[getcookie.charat]
		endif
	until [getcookie.charat] = [new_line]
	replacevar [getcookie.redirect] = [getcookie.redirect], [carriagereturn], [null]
	replacevar [getcookie.redirect] = [getcookie.redirect], [linefeed], [null]
	call 'curl.exe -X HEAD '#[getcookie.redirect]#' -H "Referer: https://borderlands.com/en-US" -H "Origin: https://borderlands.com" -i -o cookie.txt', 'hide'
	readfile [getcookie.header] = 'cookie.txt', '0'
	httpresponse [getcookie.response] = 'cookie.txt'
	delfile 'cookie.txt'
	if [getcookie.response] = '403 Forbidden'
		echo 'Server had forbid the access. Try to start this program again and login again to get a new session.'
		[getcookie.return] = 'failed'
	elseif [getcookie.response] = 'R/W_Error'
		echo 'Cannot read file. Do you need Admin Privilegs in this folder?'
		[getcookie.return] = 'failed'
	elseif [getcookie.response] = '302 Found (Moved Temporarily)'
		[null] = [null]
	elseif [getcookie.response] ! '200 OK'
		echo 'Unexpected Response from Server! '#[getcookie.response]
		[getcookie.return] = 'failed'
	endif
	if [getcookie.return] ! 'failed'
		[getcookie.counter] = '0'
		[getcookie.counter2] = '0'
		[getcookie.cookie] = [null]
		repeat
			[getcookie.counter] + '1'
			getpos [getcookie.cookie.pos] = [getcookie.header], 'set-cookie:', [getcookie.counter]
			getlen [getcookie.cookie.len] = 'set-cookie:'
			[getcookie.counter2] = [getcookie.cookie.pos] + [getcookie.cookie.len]
			repeat
				[getcookie.counter2] + '1'
				getcharat [getcookie.charat] = [getcookie.header], [getcookie.counter2]
				if [getcookie.charat] ! ';'
					[getcookie.cookie] = [getcookie.cookie]#''#[getcookie.charat]
				endif
				if [getcookie.charat] = ';' & [getcookie.counter] = '1'
					[getcookie.cookie] = [getcookie.cookie]#'; '
				endif
			until [getcookie.charat] = ';'
		until [getcookie.counter] = '2'
	endif
	if [getcookie.return] = ''
		[getcookie.return] = [getcookie.cookie]
	endif
	[getcookie.header] = [null]
	ret [getcookie.return]
endfunc

func editdata: [editdata.todo], [editdata.delete], [editdata.email], [editdata.password]
	[editdata.return] = ''
	if [editdata.todo] = 'replace'
		fileexists [errorcode] = 'data.dat'
		if [errorcode] = [false] & [editdata.delete] ! [true]
			newfile 'data.dat'
			encryptpw [editdata.encryptedpw] = [editdata.password], ''
			writefile 'data.dat', [editdata.email]#'='#[editdata.encryptedpw]#''#[new_line]
			[editdata.todo] = 'read'
		elseif [errorcode] = [false] & [editdata.delete] = [true]
			[editdata.return] = 'FILE_NOT_FOUND'
		else
			[editdata.cnt] = '0'
			[data.line] = ''
			[data.out2] = ''
			repeat
				[editdata.cnt] + '1'
				readfile [data.out] = 'data.dat', [editdata.cnt]
				cntvar [email.cnt] = [data.out], [editdata.email]
				if [email.cnt] = '1'
					[data.line] = [editdata.cnt]
				endif
			until [data.out] = 'EOF'
			if [data.line] ! ''
				[editdata.cnt] = '0'
				repeat
					[editdata.cnt] + '1'
					readfile [data.out] = 'data.dat', [editdata.cnt]
					if [data.out] ! 'EOF' & [editdata.cnt] ! [data.line]
						if [data.out] ! ''
							if [data.out2] = ''
								[data.out2] = [data.out]#''#[new_line]
							else
								[data.out2] = [data.out2]#''#[new_line]#''#[data.out]
							endif
						endif
					endif
				until [data.out] = 'EOF'
				[data.out] = [data.out2]
				delfile 'data.dat'
				writefile 'data.dat', [data.out]#''#[new_line]
				if [editdata.delete] ! [true]
					encryptpw [editdata.encryptedpw] = [editdata.password], ''
					writefile 'data.dat', [editdata.email]#'='#[editdata.encryptedpw]#''#[new_line]
				endif
				[editdata.todo] = 'read'
			elseif [data.line] = '' & [editdata.delete] ! [true]
				encryptpw [editdata.encryptedpw] = [editdata.password], ''
				writefile 'data.dat', [editdata.email]#'='#[editdata.encryptedpw]#''#[new_line]
				[editdata.todo] = 'read'
			elseif [data.line] = '' & [editdata.delete] = [true]
				[editdata.return] = 'EMAIL_NOT_FOUND'
			else
				[editdata.return] = 'UNKNOWN_ERROR_EDITDATA_REP'
			endif
		endif
	endif
	if [editdata.todo] = 'read'
		[emaillist] = ''
		fileexists [errorcode] = 'data.dat'
		if [errorcode] ! [false]
			[cnt] = '0'
			repeat
				[cnt] + '1'
				readfile [data.out] = 'data.dat', [cnt]
				if [data.out] ! 'EOF'
					gettok [data.email] = [data.out], '=', '1'
					if [data.email] ! ''
						if [data.email] ! [new_line]
							if [emaillist] = ''
								[emaillist] = [data.email]
							else
								[emaillist] = [emaillist]#'|'#[data.email]
							endif
						endif
					endif
				endif
			until [data.out] = 'EOF'
			letdialog 'SHiFT Code-Manager [LOGIN]:savedlogin', 'ITEMS', [emaillist]
		endif
	endif
	if [editdata.return] = ''
		ret 'SUCCESS'
	else
		ret [editdata.return]
	endif
endfunc

func xsession: [xs.input]
	[xs.counter] = '0'
	repeat
		[xs.counter] + '1'
		readfile [xs.data] = [xs.input], [xs.counter]
		cntvar [xs.cntvar] = [xs.data], 'X-SESSION-SET:'
		[xs.cntcom] = [xs.cntvar] 
		cntvar [xs.cntvar] = [xs.data], 'x-session-set:'
		[xs.cntcom] = [xs.cntcom] + [xs.cntvar]
		if [xs.cntcom] >= '1'
			replacevar [xs.session] = [xs.data], 'X-SESSION-SET:', ''
			replacevar [xs.session] = [xs.data], 'x-session-set:', ''
			[xs.data] = 'EOF'
		endif
	until [xs.data] = 'EOF'
	if [xs.session] = ''
		[xs.session] = 'failed'
	endif
	ret [xs.session]
endfunc

proc checkversion
	console 'write', 'Checking for new version...'
	call 'curl.exe -X GET https://raw.githubusercontent.com/SurrendeR1993/SHiFT-Code-Manager/master/version.json -i -o version.txt', 'hide'
	fileexists [cv.exists] = 'version.txt'
	if [cv.exists] = [true]
		httpresponse [cv.response] = 'version.txt'
		if [cv.response] = '200 OK'
			readfile [cv.content] = 'version.txt', '0'
			json [cv.newversion] = [cv.content], '"version"', '1'
			replacevar [cv.newversion] = [cv.newversion], '"', [null]
		else
			console 'continue', 'unexpected response from server...'
		endif
		if [cv.newversion] ! [actual.version]
			console 'continue', 'version '#[cv.newversion]#' available!'
			confirm [cv.confirm] = 'New version '#[cv.newversion]#' is available!'#[new_line]#'It is highly recommended to download the newest version.'#[new_line]#'Would you like to visit GitHub?'
			if [cv.confirm] = [true]
				console 'write', 'Opening GitHub...'
				open 'https://github.com/SurrendeR1993/SHiFT-Code-Manager'
			else
				console 'write', 'New version ignored. Please update as soon as possible!'
				echo 'Please update as soon as possible!'
			endif
		else
			console 'continue', 'up to date.'
		endif
	else
		console 'continue', 'GitHub connection failed.'
	endif
	delfile 'version.txt'
endproc

fileexists [curl] = 'curl.exe'
if [curl] ! [true]
	echo 'You need curl for windows to use this program. Please google for it and copy the program into this directory.'
	halt
endif

if [command] ! ''
	cntvar [parcnt] = [command], ';'
	if [parcnt] >= '1'
		gettok [par1] = [command], ';', '1'
		if [par1] = 'silent' & [parcnt] = '2'
			gettok [par2] = [command], ';', '2'
			gettok [par3] = [command], ';', '3'
			silent [par2], [par3]
		endif
	endif
	goto 'exit'
endif

console 'enable', ''
checkversion

%login
deldialog 'SHiFT Code-Manager'
rem --- creating code for widget "SHiFT Code-Manager [LOGIN]"
newdialog 'SHiFT Code-Manager [LOGIN]', 'DIALOG', '648|413|407|175'
letdialog 'SHiFT Code-Manager [LOGIN]', 'caption', 'SHiFT Code-Manager v'#[actual.version]#' [LOGIN]'
letdialog 'SHiFT Code-Manager [LOGIN]', 'STYLE', 'DIALOG'

rem --- creating code for widget "savedlogin"
newdialog 'SHiFT Code-Manager [LOGIN]:savedlogin', 'LIST_SORTED', '10|30|155|85'
letdialog 'SHiFT Code-Manager [LOGIN]:savedlogin', 'event_change', [true]

rem --- creating code for widget "emailin"
newdialog 'SHiFT Code-Manager [LOGIN]:emailin', 'INPUT', '185|45|200|25'
letdialog 'SHiFT Code-Manager [LOGIN]:emailin', 'text', 'exs@mp.le'

rem --- creating code for widget "logingr"
newdialog 'SHiFT Code-Manager [LOGIN]:logingr', 'GROUP', '175|10|220|140'
letdialog 'SHiFT Code-Manager [LOGIN]:logingr', 'caption', 'Login'

rem --- creating code for widget "sloging"
newdialog 'SHiFT Code-Manager [LOGIN]:sloging', 'GROUP', '5|10|165|140'
letdialog 'SHiFT Code-Manager [LOGIN]:sloging', 'caption', 'Saved Login'

rem --- creating code for widget "emailt"
newdialog 'SHiFT Code-Manager [LOGIN]:emailt', 'LABEL', '185|30|100|16'
letdialog 'SHiFT Code-Manager [LOGIN]:emailt', 'caption', 'E-Mail'
letdialog 'SHiFT Code-Manager [LOGIN]:emailt', 'font', 'X|8|2|5'

rem --- creating code for widget "pwt"
newdialog 'SHiFT Code-Manager [LOGIN]:pwt', 'LABEL', '185|75|100|16'
letdialog 'SHiFT Code-Manager [LOGIN]:pwt', 'caption', 'Password'
letdialog 'SHiFT Code-Manager [LOGIN]:pwt', 'font', 'X|8|2|5'

rem --- creating code for widget "pwin"
newdialog 'SHiFT Code-Manager [LOGIN]:pwin', 'PWD', '185|90|200|25'
letdialog 'SHiFT Code-Manager [LOGIN]:pwin', 'text', '123456789'

rem --- creating code for widget "loginbtn"
newdialog 'SHiFT Code-Manager [LOGIN]:loginbtn', 'BUTTON', '285|120|100|25'
letdialog 'SHiFT Code-Manager [LOGIN]:loginbtn', 'caption', 'Login'
letdialog 'SHiFT Code-Manager [LOGIN]:loginbtn', 'font', 'X|8|2|5'

rem --- creating code for widget "savelogin"
newdialog 'SHiFT Code-Manager [LOGIN]:savelogin', 'OPTION', '185|120|75|25'
letdialog 'SHiFT Code-Manager [LOGIN]:savelogin', 'caption', 'Save Login'
letdialog 'SHiFT Code-Manager [LOGIN]:savelogin', 'checked', [true]

rem --- creating code for widget "rems"
newdialog 'SHiFT Code-Manager [LOGIN]:rems', 'BUTTON', '40|120|100|25'
letdialog 'SHiFT Code-Manager [LOGIN]:rems', 'caption', 'Delete Login'
letdialog 'SHiFT Code-Manager [LOGIN]:rems', 'font', 'X|8|2|5'

centerdialog 'SHiFT Code-Manager [LOGIN]'

rem --- make the dialog window visible
letdialog 'SHiFT Code-Manager [LOGIN]', 'visible', [true]

editdata [errorcode] = 'read', [false], '', ''
%login_repeat
letdialog 'SHiFT Code-Manager [LOGIN]', 'visible', [true]
repeat
	rundialog [event] = '0'

	rem --- event handling for click on "loginbtn"
	if [event] = 'click_SHiFT Code-Manager [LOGIN]:loginbtn'
		rem *** insert event code here ***
		letdialog 'SHiFT Code-Manager [LOGIN]', 'visible', [false]
		getdialog [email] = 'SHiFT Code-Manager [LOGIN]:emailin', 'TEXT'
		console 'write', 'Logging '#[email]#' in...'
		getdialog [pwd] = 'SHiFT Code-Manager [LOGIN]:pwin', 'TEXT'
		if [pwd] = ''
			echo 'Please enter a password!'
			goto 'login_repeat'
		endif
		if [email] = ''
			echo 'Please enter a email!'
			goto 'login_repeat'
		endif
		login [login.return] = [email], [pwd]
		if [login.return] = 'LOGIN_FAILED'
			goto 'login_repeat'
		endif
		readfile [login.data] = 'login.txt', '0'
		xsession [xsession] = 'login.txt'
		delfile 'login.txt'
		if [xsession] = 'failed'
			echo 'Could not get session data! Please try again!'
			goto 'login_repeat'
		endif
		getdialog [save.login] = 'SHiFT Code-Manager [LOGIN]:savelogin', 'CHECKED'
		if [save.login] = [true]
			editdata [errorcode] = 'replace', [false], [email], [pwd]
			if [errorcode] ! 'SUCCESS'
				echo 'ERROR: '#[errorcode]
			endif
		endif
		goto 'main'
		
		rem --- event handling for change on "savedlogin"
	elseif [event] = 'change_SHiFT Code-Manager [LOGIN]:savedlogin'
		rem *** insert event code here ***
		getdialog [selected.username] = 'SHiFT Code-Manager [LOGIN]:savedlogin', 'SELECTION'
		if [selected.username] ! ''
			getpassword [decryptedpw] = [selected.username]
			letdialog 'SHiFT Code-Manager [LOGIN]:pwin', 'text', [decryptedpw]
			letdialog 'SHiFT Code-Manager [LOGIN]:emailin', 'text', [selected.username]
		endif
		
	rem --- event handling for click on "rems"
	elseif [event] = 'click_SHiFT Code-Manager [LOGIN]:rems'
		rem *** insert event code here ***
		getdialog [email] = 'SHiFT Code-Manager [LOGIN]:savedlogin', 'SELECTION'
		editdata [errorcode] = 'replace', [true], [email], [pwd]
		if [errorcode] ! 'SUCCESS'
			echo 'ERROR: '#[errorcode]
		endif
	endif

until [event] = 'close_SHiFT Code-Manager [LOGIN]'
if [event] = 'close_SHiFT Code-Manager [LOGIN]'
	goto 'exit'
endif

%main
rundialog [event] = '500'
console 'write', 'Getting Account data...'
deldialog 'SHiFT Code-Manager [LOGIN]'
rem --- creating code for widget "SHiFT Code-Manager"
newdialog 'SHiFT Code-Manager', 'DIALOG', '647|298|488|250'
letdialog 'SHiFT Code-Manager', 'caption', 'SHiFT Code-Manager'
letdialog 'SHiFT Code-Manager', 'icon', 'img\icon.ico'
letdialog 'SHiFT Code-Manager', 'menu', 'SHiFT Code-Manager:Autostart|Help|About|Visit:SCM on Reddit|SCM on GitHub|Orcicorn on Twitter;|Quit;SHiFT-Account:Refresh|Redeemed Codes;Logout;'
letdialog 'SHiFT Code-Manager', 'style', 'DIALOG'

rem --- creating code for widget "uinfo"
newdialog 'SHiFT Code-Manager:uinfo', 'GROUP', '10|10|275|105'
letdialog 'SHiFT Code-Manager:uinfo', 'caption', 'User Info'

rem --- creating code for widget "username"
newdialog 'SHiFT Code-Manager:username', 'LABEL', '95|30|185|15'
letdialog 'SHiFT Code-Manager:username', 'caption', 'Megakiller1234567890'
letdialog 'SHiFT Code-Manager:username', 'font', 'X|8|2'

rem --- creating code for widget "usernamet"
newdialog 'SHiFT Code-Manager:usernamet', 'LABEL', '40|30|55|15'
letdialog 'SHiFT Code-Manager:usernamet', 'caption', 'Username:'

rem --- creating code for widget "useridt"
newdialog 'SHiFT Code-Manager:useridt', 'LABEL', '52|50|40|15'
letdialog 'SHiFT Code-Manager:useridt', 'caption', 'User-ID:'

rem --- creating code for widget "userid"
newdialog 'SHiFT Code-Manager:userid', 'LABEL', '95|50|185|15'
letdialog 'SHiFT Code-Manager:userid', 'caption', '01234567890'
letdialog 'SHiFT Code-Manager:userid', 'font', 'X|8|2'

rem --- creating code for widget "steamimg"
newdialog 'SHiFT Code-Manager:steamimg', 'IMAGE', '295|25|40|40'
letdialog 'SHiFT Code-Manager:steamimg', 'image', 'img\steambw.bmp'
letdialog 'SHiFT Code-Manager:steamimg', 'event_click', [true]

rem --- creating code for widget "psnimg"
newdialog 'SHiFT Code-Manager:psnimg', 'IMAGE', '340|25|40|40'
letdialog 'SHiFT Code-Manager:psnimg', 'image', 'img\psbw.bmp'
letdialog 'SHiFT Code-Manager:psnimg', 'event_click', [true]

rem --- creating code for widget "xboximg"
newdialog 'SHiFT Code-Manager:xboximg', 'IMAGE', '385|25|40|40'
letdialog 'SHiFT Code-Manager:xboximg', 'image', 'img\livebw.bmp'
letdialog 'SHiFT Code-Manager:xboximg', 'event_click', [true]

rem --- creating code for widget "epicimg"
newdialog 'SHiFT Code-Manager:epicimg', 'IMAGE', '430|25|40|40'
letdialog 'SHiFT Code-Manager:epicimg', 'image', 'img\epicbw.bmp'
letdialog 'SHiFT Code-Manager:epicimg', 'event_click', [true]

rem --- creating code for widget "2kimg"
newdialog 'SHiFT Code-Manager:2kimg', 'IMAGE', '295|70|40|40'
letdialog 'SHiFT Code-Manager:2kimg', 'image', 'img\2kbw.bmp'
letdialog 'SHiFT Code-Manager:2kimg', 'event_click', [true]

rem --- creating code for widget "twitchimg"
newdialog 'SHiFT Code-Manager:twitchimg', 'IMAGE', '340|70|40|40'
letdialog 'SHiFT Code-Manager:twitchimg', 'image', 'img\twitchbw.bmp'
letdialog 'SHiFT Code-Manager:twitchimg', 'event_click', [true]

rem --- creating code for widget "twitterimg"
newdialog 'SHiFT Code-Manager:twitterimg', 'IMAGE', '385|70|40|40'
letdialog 'SHiFT Code-Manager:twitterimg', 'image', 'img\twitterbw.bmp'
letdialog 'SHiFT Code-Manager:twitterimg', 'event_click', [true]

rem --- creating code for widget "fbimg"
newdialog 'SHiFT Code-Manager:fbimg', 'IMAGE', '430|70|40|40'
letdialog 'SHiFT Code-Manager:fbimg', 'image', 'img\facebookbw.bmp'
letdialog 'SHiFT Code-Manager:fbimg', 'event_click', [true]

rem --- creating code for widget "Avpoints"
newdialog 'SHiFT Code-Manager:Avpoints', 'LABEL', '22|70|75|15'
letdialog 'SHiFT Code-Manager:Avpoints', 'caption', 'Current Points:'

rem --- creating code for widget "totpoints"
newdialog 'SHiFT Code-Manager:totpoints', 'LABEL', '32|90|65|15'
letdialog 'SHiFT Code-Manager:totpoints', 'caption', 'Total Points:'

rem --- creating code for widget "curpoints"
newdialog 'SHiFT Code-Manager:curpoints', 'LABEL', '95|70|75|15'
letdialog 'SHiFT Code-Manager:curpoints', 'caption', '01234567890'
letdialog 'SHiFT Code-Manager:curpoints', 'font', 'X|8|2'

rem --- creating code for widget "totalpoints"
newdialog 'SHiFT Code-Manager:totalpoints', 'LABEL', '95|90|75|15'
letdialog 'SHiFT Code-Manager:totalpoints', 'caption', '01234567890'
letdialog 'SHiFT Code-Manager:totalpoints', 'font', 'X|8|2'

rem --- creating code for widget "vc"
newdialog 'SHiFT Code-Manager:vc', 'OPTION', '20|135|70|25'
letdialog 'SHiFT Code-Manager:vc', 'caption', 'Vault Code'
letdialog 'SHiFT Code-Manager:vc', 'checked', [false]

rem --- creating code for widget "redeemgroup"
newdialog 'SHiFT Code-Manager:redeemgroup', 'GROUP', '10|120|465|45'
letdialog 'SHiFT Code-Manager:redeemgroup', 'caption', 'Activities'

rem --- creating code for widget "email"
newdialog 'SHiFT Code-Manager:email', 'OPTION', '105|135|80|25'
letdialog 'SHiFT Code-Manager:email', 'caption', 'E-Mail Code'
letdialog 'SHiFT Code-Manager:email', 'checked', [false]

rem --- creating code for widget "creator"
newdialog 'SHiFT Code-Manager:creator', 'OPTION', '195|135|85|25'
letdialog 'SHiFT Code-Manager:creator', 'caption', 'Creator Code'
letdialog 'SHiFT Code-Manager:creator', 'checked', [false]

rem --- creating code for widget "gk"
newdialog 'SHiFT Code-Manager:gk', 'OPTION', '290|135|75|25'
letdialog 'SHiFT Code-Manager:gk', 'caption', 'SHiFT Code'
letdialog 'SHiFT Code-Manager:gk', 'checked', [false]

rem --- creating code for widget "redeem"
newdialog 'SHiFT Code-Manager:redeem', 'BUTTON', '10|165|100|30'
letdialog 'SHiFT Code-Manager:redeem', 'caption', 'Do selected'
letdialog 'SHiFT Code-Manager:redeem', 'font', 'X|8|2'

rem --- creating code for widget "linked"
newdialog 'SHiFT Code-Manager:linked', 'GROUP', '290|10|185|105'
letdialog 'SHiFT Code-Manager:linked', 'caption', 'Linked Platforms'

rem --- creating code for widget "vipact"
newdialog 'SHiFT Code-Manager:vipact', 'OPTION', '385|135|85|25'
letdialog 'SHiFT Code-Manager:vipact', 'caption', 'VIP-Activities'
letdialog 'SHiFT Code-Manager:vipact', 'checked', [false]

rem --- creating code for widget "redev"
newdialog 'SHiFT Code-Manager:redev', 'BUTTON', '115|165|125|30'
letdialog 'SHiFT Code-Manager:redev', 'caption', 'Hell, do everything!'
letdialog 'SHiFT Code-Manager:redev', 'font', 'X|8|2'

centerdialog 'SHiFT Code-Manager'

getplatforms [platforms] = [login.data]
gettok [steamcnt] = [platforms], '|', '1'
gettok [playstationcnt] = [platforms], '|', '2'
gettok [xboxcnt] = [platforms], '|', '3'
gettok [epiccnt] = [platforms], '|', '4'
gettok [2kcnt] = [platforms], '|', '5'
gettok [twitchcnt] = [platforms], '|', '6'
gettok [twittercnt] = [platforms], '|', '7'
gettok [facebookcnt] = [platforms], '|', '8'

if [steamcnt] = '1'
	letdialog 'SHiFT Code-Manager:steamimg', 'image', 'img\steamc.bmp'
endif
if [playstationcnt] = '1'
	letdialog 'SHiFT Code-Manager:psnimg', 'image', 'img\psc.bmp'
endif
if [xboxcnt] = '1'
	letdialog 'SHiFT Code-Manager:xboximg', 'image', 'img\livec.bmp'
endif
if [epiccnt] = '1'
	letdialog 'SHiFT Code-Manager:epicimg', 'image', 'img\epicc.bmp'
endif
if [2kcnt] = '1'
	letdialog 'SHiFT Code-Manager:2kimg', 'image', 'img\2kc.bmp'
endif
if [twitchcnt] = '1'
	letdialog 'SHiFT Code-Manager:twitchimg', 'image', 'img\twitchc.bmp'
endif
if [twittercnt] = '1'
	letdialog 'SHiFT Code-Manager:twitterimg', 'image', 'img\twitterc.bmp'
endif
if [facebookcnt] = '1'
	letdialog 'SHiFT Code-Manager:fbimg', 'image', 'img\facebookc.bmp'
endif
jsoncontent [login.data.json] = [login.data]
json [shiftid] = [login.data.json], '"shiftUserId"', '1'
replacevar [shiftid] = [shiftid], '"', ''
letdialog 'SHiFT Code-Manager:userid', 'caption', [shiftid]
json [dispname] = [login.data.json], '"displayName"', '1'
replacevar [dispname] = [dispname], '"', ''
letdialog 'SHiFT Code-Manager:username', 'caption', [dispname]
console 'continue', 'DONE!'
console 'write', 'Getting Session-Data...'
getcookie [cookie] = [login.data]
if [cookie] = 'failed'
	[Confirm_Title] = 'Whoopsie! Try again?'
	confirm [retry] = 'Failed to get session, but it is necessary!'#[new_line]#'Would you like to log in and to try it again? Otherwise the tool will quit.'
	if [retry] = [true]
		goto 'login'
	else
		goto 'exit'
	endif
elseif [cookie] = 'failed_no_redirect'
	echo 'It was not possible to get the session but the performed login was successfull.'#[new_line]#'Are you signed to the Vault Insider Program? If not, please goto "borderlands.com", login there and sign up for the VIP, because this is necessary to use this tool. After you have done this, you can restart SHiFT Code-Manager!'
	goto 'exit'
endif
console 'continue', 'SUCCESS!'
console 'write', 'Getting Points-Data...'
[oldpoints] = [points]
getpoints [points] = [cookie]
if [points] = 'failed'
	[Confirm_Title] = 'Whoopsie! Try again?'
	confirm [retry] = 'Failed to get points.'#[new_line]#'Would you like to log in again? Otherwise program will quit.'
	if [retry] = [true]
		goto 'login'
	else
		halt
	endif
endif
gettok [redpoints] = [points], '|', '1'
gettok [totpoints] = [points], '|', '2'
console 'continue', 'SUCCESS!'
letdialog 'SHiFT Code-Manager:curpoints', 'caption', [redpoints]
letdialog 'SHiFT Code-Manager:totalpoints', 'caption', [totpoints]
letdialog 'SHiFT Code-Manager', 'visible', [true]

%mainrundialog
repeat
	rundialog [event] = '0'
		
	rem --- event handling for click on "redeem"
	if [event] = 'click_SHiFT Code-Manager:redeem'
		rem *** insert event code here ***
		getdialog [vccheck] = 'SHiFT Code-Manager:vc', 'checked'
		getdialog [emailcheck] = 'SHiFT Code-Manager:email', 'checked'
		getdialog [creatorcheck] = 'SHiFT Code-Manager:creator', 'checked'
		getdialog [gkcheck] = 'SHiFT Code-Manager:gk', 'checked'
		getdialog [vipcheck] = 'SHiFT Code-Manager:vipact', 'checked'
		[checkcheck] = [vccheck] + [emailcheck] + [creatorcheck] + [gkcheck] + [vipcheck]
		if [checkcheck] >= '-4'
			redeemcodes [result] = [vccheck], [emailcheck], [creatorcheck], [gkcheck], [vipcheck], [cookie], [platforms], [xsession]
			refresh [points] = [points], [cookie]
			gettok [redpoints] = [points], '|', '1'
			gettok [totpoints] = [points], '|', '2'
			letdialog 'SHiFT Code-Manager:curpoints', 'caption', [redpoints]
			letdialog 'SHiFT Code-Manager:totalpoints', 'caption', [totpoints]
		else
			echo 'Redeeming nothing is impossible... You need to check at least one box!'
			goto 'mainrundialog'
		endif
		
	rem --- event handling for click on "redev"
	elseif [event] = 'click_SHiFT Code-Manager:redev'
		rem *** insert event code here ***
		console 'write', 'Okay! You want it!'
		redeemcodes [result] = [true], [true], [true], [true], [true], [cookie], [platforms], [xsession]
		refresh [points] = [points], [cookie]
		gettok [redpoints] = [points], '|', '1'
		gettok [totpoints] = [points], '|', '2'
		letdialog 'SHiFT Code-Manager:curpoints', 'caption', [redpoints]
		letdialog 'SHiFT Code-Manager:totalpoints', 'caption', [totpoints]
		
	rem --- event handling for click on "redeemed"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Redeemed Codes'
		rem *** insert event code here ***
		goto 'codewindow'
		
	rem --- event handling for click on "refresh"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Refresh'
		rem *** insert event code here ***
		refresh [points] = [points], [cookie]
		gettok [redpoints] = [points], '|', '1'
		gettok [totpoints] = [points], '|', '2'
		letdialog 'SHiFT Code-Manager:curpoints', 'caption', [redpoints]
		letdialog 'SHiFT Code-Manager:totalpoints', 'caption', [totpoints]
		
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Help'
		echo 'Huh? Oh you got me... Here is nothing right now... If you really need help, visit my reddit post and ask for help! Thank you :)'
		
	elseif [event] = 'click_SHiFT Code-Manager:Menu_About'
		echo 'SHiFT Code-Manager is developed by me, SurrendeR1993. I found the idea of automatically redeeming SHiFT codes interesting and found, after a short search, a similar tool. But it did not satisfy me in some aspects.'#[new_line]#'So I decided to write my very own tool for automatic redemption of SHiFT codes. As I have some good knowledge in the pretty unknown but very easy scripting language "RapidBATCH", I started to make a prototype and after hours I had a nicely program on my desktop, first called "VIP-Manager".'#[new_line]#'I worked it more and more out, found an excellent source for the SHiFT and VIP codes (Thank you my friend, Orcicorn =) ) and finally released it on Github and Reddit. As you are reading this, I assume, that you are using this little tool (or you are just investigating the source :D) and I hope you are satisfied with it. I would really appreciate it, if you then upvote it on reddit!'#[new_line]#''#[new_line]#'I will continue to improve the tool in the future, so stay tuned for updates!'#[new_line]#''#[new_line]#'Ah and to those, who are worried about their login data (no matter if you just investigate the source or you are using the tool): I am really not interested into your account. You can study the source so intense as you want, change cURL with the compiled source code from Github, capture the internet traffic or do whatever you want, you would not find any clues because there are no! (I can just guarantee this, if you have downloaded the tool or the source code from my post on reddit or from github! Do not trust any other source!!!).'#[new_line]#'Thank you!'#[new_line]#''#[new_line]#'-SurrendeR1993'
		
	rem --- event handling for menu item "Logout"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Logout'
		rem *** insert event code here ***
		logout [logoff_status] = [xsession], [false]
		
	rem --- event handling for menu item "Quit"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Quit'
		rem *** insert event code here ***
		logout [logoff_status] = [xsession], [true]
		
	rem --- event handling for menu item "SCM on Reddit"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_SCM on Reddit'
		rem *** insert event code here ***
		open 'https://www.reddit.com/r/borderlands3/comments/duldqz/shift_codemanager_an_automatic_redemption_program/'
		
	rem --- event handling for menu item "SCM on GitHub"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_SCM on GitHub'
		rem *** insert event code here ***
		open 'https://github.com/SurrendeR1993/SHiFT-Code-Manager'
		
	rem --- event handling for menu item "Orcicorn on Twitter"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Orcicorn on Twitter'
		rem *** insert event code here ***
		open 'https://twitter.com/orcicorn'
	rem --- event handling for menu item "Configure"
	elseif [event] = 'click_SHiFT Code-Manager:Menu_Autostart'
		rem *** insert event code here ***
		goto 'autostart'
	endif

until [event] = 'close_SHiFT Code-Manager'
logout [logoff_status] = [xsession], [true]

%autostart
letdialog 'SHiFT Code-Manager', 'visible', [false]
rem --- creating code for widget "myDialog"
newdialog 'SHiFT Code-Manager_autostart', 'DIALOG', '667|454|405|140'
letdialog 'SHiFT Code-Manager_autostart', 'caption', 'SHiFT Code-Manager'
letdialog 'SHiFT Code-Manager_autostart', 'icon', 'img\icon.ico'
letdialog 'SHiFT Code-Manager_autostart', 'style', 'DIALOG'

rem --- creating code for widget "infot"
newdialog 'SHiFT Code-Manager_autostart:infot', 'LABEL', '5|5|390|55'
letdialog 'SHiFT Code-Manager_autostart:infot', 'caption', 'This will create a shortcut in your autostart directory. SHiFT Code-Manager will then start on Windows startup and do its job with the actual logged in account and the selected code types in silent mode. You will not get any information except errors.'

rem --- creating code for widget "create"
newdialog 'SHiFT Code-Manager_autostart:create', 'BUTTON', '275|60|115|25'
letdialog 'SHiFT Code-Manager_autostart:create', 'caption', 'Create shortcut'

rem --- creating code for widget "open"
newdialog 'SHiFT Code-Manager_autostart:open', 'BUTTON', '275|85|115|25'
letdialog 'SHiFT Code-Manager_autostart:open', 'caption', 'Open autostart folder'

rem --- creating code for widget "vault"
newdialog 'SHiFT Code-Manager_autostart:vault', 'OPTION', '5|60|80|20'
letdialog 'SHiFT Code-Manager_autostart:vault', 'caption', 'Vault Codes'
letdialog 'SHiFT Code-Manager_autostart:vault', 'checked', [false]

rem --- creating code for widget "email"
newdialog 'SHiFT Code-Manager_autostart:email', 'OPTION', '5|85|80|20'
letdialog 'SHiFT Code-Manager_autostart:email', 'caption', 'E-Mail Codes'
letdialog 'SHiFT Code-Manager_autostart:email', 'checked', [false]

rem --- creating code for widget "creator"
newdialog 'SHiFT Code-Manager_autostart:creator', 'OPTION', '95|60|85|20'
letdialog 'SHiFT Code-Manager_autostart:creator', 'caption', 'Creator Codes'
letdialog 'SHiFT Code-Manager_autostart:creator', 'checked', [false]

rem --- creating code for widget "shift"
newdialog 'SHiFT Code-Manager_autostart:shift', 'OPTION', '95|85|85|20'
letdialog 'SHiFT Code-Manager_autostart:shift', 'caption', 'SHiFT Codes'
letdialog 'SHiFT Code-Manager_autostart:shift', 'checked', [false]

rem --- creating code for widget "activities"
newdialog 'SHiFT Code-Manager_autostart:activities', 'OPTION', '190|60|65|20'
letdialog 'SHiFT Code-Manager_autostart:activities', 'caption', 'Activities'
letdialog 'SHiFT Code-Manager_autostart:activities', 'checked', [false]

rem --- make the dialog window visible
centerdialog 'SHiFT Code-Manager_autostart'
letdialog 'SHiFT Code-Manager_autostart', 'visible', [true]

repeat
	rundialog [event] = '0'

	rem --- event handling for click on "create"
	if [event] = 'click_SHiFT Code-Manager_autostart:create'
		rem *** insert event code here ***
		getdialog [as.vault] = 'SHiFT Code-Manager_autostart:vault', 'checked'
		getdialog [as.email] = 'SHiFT Code-Manager_autostart:email', 'checked'
		getdialog [as.creator] = 'SHiFT Code-Manager_autostart:creator', 'checked'
		getdialog [as.shift] = 'SHiFT Code-Manager_autostart:shift', 'checked'
		getdialog [as.activ] = 'SHiFT Code-Manager_autostart:activities', 'checked'
		[as.checkcheck] = [as.vault] + [as.email] + [as.creator] + [as.shift] + [as.activ]
		if [as.checkcheck] ! '-5'
			[as.cnt] = '0'
			repeat
				[as.cnt] + '1'
				fileexists [as.exists] = 'C:\Users\'#[curuser]#'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\SHiFT Code-Manager'#[as.cnt]#'.lnk'
			until [as.exists] = [false]
			shortcut 'C:\Users\'#[curuser]#'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\SHiFT Code-Manager'#[as.cnt]#'', [ownname], 'silent;'#[email]#';'#[as.vault]#'|'#[as.email]#'|'#[as.creator]#'|'#[as.shift]#'|'#[as.activ]#'', [current], [current]#'\img\icon.ico', 'show'
			echo 'Shortcut created!'
		else
			echo 'Please check at least one box!'
		endif
	rem --- event handling for click on "open"
	elseif [event] = 'click_SHiFT Code-Manager_autostart:open'
		rem *** insert event code here ***
		open 'C:\Users\'#[curuser]#'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
	endif

until [event] = 'close_SHiFT Code-Manager_autostart'
deldialog 'SHiFT Code-Manager_autostart'
letdialog 'SHiFT Code-Manager', 'visible', [true]
goto 'mainrundialog'

%codewindow
letdialog 'SHiFT Code-Manager', 'visible', [false]

rem --- creating code for widget "SHiFT Code-Manager [CODES]"
newdialog 'SHiFT Code-Manager [CODES]', 'DIALOG', '395|324|995|455'
letdialog 'SHiFT Code-Manager [CODES]', 'caption', 'SHiFT Code-Manager [CODES]'
letdialog 'SHiFT Code-Manager [CODES]', 'style', 'TOOL'
letdialog 'SHiFT Code-Manager [CODES]', 'STYLE', 'DIALOG'

rem --- creating code for widget "Gold Keys"
newdialog 'SHiFT Code-Manager [CODES]:Gold Keys', 'GROUP', '10|5|235|425'
letdialog 'SHiFT Code-Manager [CODES]:Gold Keys', 'caption', 'Shift Codes'

rem --- creating code for widget "Vault Codes"
newdialog 'SHiFT Code-Manager [CODES]:Vault Codes', 'GROUP', '255|5|235|425'
letdialog 'SHiFT Code-Manager [CODES]:Vault Codes', 'caption', 'Redeemed Vault Codes'

rem --- creating code for widget "Email Codes"
newdialog 'SHiFT Code-Manager [CODES]:Email Codes', 'GROUP', '500|5|235|425'
letdialog 'SHiFT Code-Manager [CODES]:Email Codes', 'caption', 'Redeemed E-mail Codes'

rem --- creating code for widget "creator Codes"
newdialog 'SHiFT Code-Manager [CODES]:creator Codes', 'GROUP', '745|5|235|425'
letdialog 'SHiFT Code-Manager [CODES]:creator Codes', 'caption', 'Redeemed Creator Codes'

rem --- creating code for widget "sc"
newdialog 'SHiFT Code-Manager [CODES]:sc', 'LIST_SORTED', '15|20|225|405'

rem --- creating code for widget "vc"
newdialog 'SHiFT Code-Manager [CODES]:vc', 'LIST_SORTED', '260|20|225|405'

rem --- creating code for widget "ec"
newdialog 'SHiFT Code-Manager [CODES]:ec', 'LIST_SORTED', '505|20|225|405'

rem --- creating code for widget "cc"
newdialog 'SHiFT Code-Manager [CODES]:cc', 'LIST_SORTED', '750|20|225|405'

rem --- make the dialog window visible
letdialog 'SHiFT Code-Manager [CODES]', 'visible', [true]
getredeemed [redcodescomplete] = [cookie]
if [redcodescomplete] = 'failed'
	[Confirm_Title] = 'Whoopsie! Try again?'
	confirm [retry] = 'Failed to get redeemed Codes, but they are necessary!'#[new_line]#'Would you like to log in again? Otherwise program will quit.'
	if [retry] = [true]
		deldialog 'SHiFT Code-Manager [CODES]'
		goto 'login'
	else
		halt
	endif
endif
gettok [redvc] = [redcodescomplete], '=-\', '1'
gettok [redcc] = [redcodescomplete], '=-\', '3'
gettok [redec] = [redcodescomplete], '=-\', '2'
gettok [redshift] = [redcodescomplete], '=-\', '4'
if [redshift] ! ''
	letdialog 'SHiFT Code-Manager [CODES]:sc', 'items', [redshift]
else
	letdialog 'SHiFT Code-Manager [CODES]:sc', 'items', '1 No records found.|2 You need to run the redeeming process|3 with SHiFT checked at least once.'
endif

letdialog 'SHiFT Code-Manager [CODES]:vc', 'items', [redvc]
letdialog 'SHiFT Code-Manager [CODES]:cc', 'items', [redcc]
letdialog 'SHiFT Code-Manager [CODES]:ec', 'items', [redec]

repeat
	rundialog [event] = '0'
until [event] = 'close_SHiFT Code-Manager [CODES]'
deldialog 'SHiFT Code-Manager [CODES]'
letdialog 'SHiFT Code-Manager', 'visible', [true]
goto 'mainrundialog'

%exit
clearfiles
end