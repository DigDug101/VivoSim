/*
 * terminal-messages_indicator.lsl
 * Message manager for VivoSim - Indicator
 * @version	6.00
 * @date	14 March 2023
*/

integer xpFace = 0;					// XP_FACE			; Set to -1 if not used
integer msgFace = 2;				// MSG_FACE			; Set to -1 if not used
string  fontName = "Tahoma";        // FONT=Tahoma		; Also Arial or Georgia etc. See https://www.w3schools.com/cssref/css_websafe_fonts.php
integer fontSize = 100;
string  noMsgIcon = "icon_msg-white";
string  newMsgIcon = "icon_msg-green";
string  logoIcon = "vslogo";

integer newMsgCount = 0;
string ourXP = "-";

integer DEBUGMODE = FALSE;

debug(string text)
{
    if (DEBUGMODE == TRUE) llOwnerSay("DB_" + llToUpper(llGetScriptName()) + " " + text);
}

displayNumber(integer num, integer face)
{
	if (face != -1)
	{
		vector size;
		string body = "width:256,height:256,Alpha:2";
		string commandList = "";

		// Set up font details
		commandList = osSetFontName(commandList, fontName);

		// Move pen and set colour
		if (face == msgFace)
		{
			// Set colour indicator for unread/read message count
			if (num >0)
			{
				llSetTexture(newMsgIcon, face);
				commandList = osSetPenColor(commandList, "GreenYellow" );
			}
			else
			{
				llSetTexture(noMsgIcon, face);
				commandList = osSetPenColor(commandList, "White" );

			}
			
			commandList = osMovePen(commandList, 150, 60);
			commandList = osSetFontSize(commandList, fontSize);
			// Set font to Bold
			commandList += "FontProp B;";
		}
		else
		{
			llSetTexture(logoIcon, face); 
			commandList = osSetPenColor(commandList, "Gold" );
			commandList = osSetFontSize(commandList, fontSize - 40);

			// Center the text horizontally
			vector Extents = osGetDrawStringSize( "vector", (string)num, fontName, fontSize - 40);
			integer xpos = 128 - ((integer) Extents.x >> 1);
			commandList = osMovePen(commandList, xpos, 165 );
		}

		// Set font to Bold
		commandList += "FontProp B;";

		// Write text		
		commandList = osDrawText(commandList, (string)num);

		// Output the result
		osSetDynamicTextureDataBlendFace("", "vector", commandList, body, TRUE, 2, 0, 255, face);
	}
}

saveData()
{
	llSetObjectDesc("V;" +(string)newMsgCount +";" +(string)ourXP);
}

default
{
	on_rez(integer n)
	{
		llResetScript();
	}

	state_entry()
	{
		list descValues = llParseString2List(llGetObjectDesc(), [";"], [""]);

		if (msgFace != -1) llSetTexture(noMsgIcon, msgFace);
        
		if (llList2String(descValues, 0) == "V")
		{
			newMsgCount = llList2Integer(descValues, 1);
			ourXP = llList2String(descValues, 2);
		}
		else
		{
			saveData();
		}
	
		displayNumber((integer)ourXP, xpFace);

		displayNumber(newMsgCount, msgFace);
	}

    link_message(integer sender_num, integer num, string msg, key id)
    {
		debug("link_message:" + msg +" NUM=" +(string)num +"  From:" +(string)sender_num);
        list tok = llParseStringKeepNulls(msg, ["|"], []);
        string cmd = llList2String(tok,0);

        if (cmd == "NEW_MESSAGE")
        {
			newMsgCount = num;
			saveData();
			displayNumber(num, msgFace);
        }
		else if ((cmd == "CMD_XP") || (cmd == "XP"))
		{
			ourXP = llList2String(tok, 1);
			saveData();
			displayNumber((integer)ourXP, xpFace);
		}
		else if (cmd == "TOUCHED")
		{
			newMsgCount = 0;
			saveData();
			displayNumber(newMsgCount, msgFace);
		}
		else if (cmd == "CMD_DEBUG")
		{
			DEBUGMODE = llList2Integer(tok, 1);
		}
    }

}
