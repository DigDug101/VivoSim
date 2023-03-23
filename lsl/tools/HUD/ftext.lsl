/**
 * ViviSim HUD - Float text anchor
 * Generates float text so as to be positioned nicely over background screen prim
**/

float version = 6.0;   //  23 March 2023

default
{

    state_entry()
    {
        //
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {
        list tk = llParseStringKeepNulls(msg , ["|"], []);
        string cmd = llList2String(tk, 0);

        if (cmd == "SHOWTEXT")
        {
            // SHOWTEXT|message|<color>
			string ourText = llList2String(tk, 1);
			if (ourText != "")
			{
            	llSetText(ourText, llList2Vector(tk, 2), 1.0);
			}
			else
			{
				llSetText("", ZERO_VECTOR, 0.0);
				llMessageLinked(LINK_SET, 1, "SCREENOFF", "");
			}
        }
        else if (cmd == "SCREENOFF")
        {
            llSetText("", ZERO_VECTOR, 0.0);
        }
    }

}
