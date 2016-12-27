//	WebHelp 5.10.001
var garrSortChar=new Array();
var gaFtsStop=new Array();
var gaFtsStem=new Array();
var gbWhLang=false;


gaFtsStop[0] = "a";
gaFtsStop[1] = "about";
gaFtsStop[2] = "after";
gaFtsStop[3] = "against";
gaFtsStop[4] = "all";
gaFtsStop[5] = "also";
gaFtsStop[6] = "among";
gaFtsStop[7] = "an";
gaFtsStop[8] = "and";
gaFtsStop[9] = "are";
gaFtsStop[10] = "as";
gaFtsStop[11] = "at";
gaFtsStop[12] = "be";
gaFtsStop[13] = "became";
gaFtsStop[14] = "because";
gaFtsStop[15] = "been";
gaFtsStop[16] = "between";
gaFtsStop[17] = "but";
gaFtsStop[18] = "by";
gaFtsStop[19] = "can";
gaFtsStop[20] = "come";
gaFtsStop[21] = "do";
gaFtsStop[22] = "during";
gaFtsStop[23] = "each";
gaFtsStop[24] = "early";
gaFtsStop[25] = "for";
gaFtsStop[26] = "form";
gaFtsStop[27] = "found";
gaFtsStop[28] = "from";
gaFtsStop[29] = "had";
gaFtsStop[30] = "has";
gaFtsStop[31] = "have";
gaFtsStop[32] = "he";
gaFtsStop[33] = "her";
gaFtsStop[34] = "his";
gaFtsStop[35] = "however";
gaFtsStop[36] = "in";
gaFtsStop[37] = "include";
gaFtsStop[38] = "into";
gaFtsStop[39] = "is";
gaFtsStop[40] = "it";
gaFtsStop[41] = "its";
gaFtsStop[42] = "late";
gaFtsStop[43] = "later";
gaFtsStop[44] = "made";
gaFtsStop[45] = "many";
gaFtsStop[46] = "may";
gaFtsStop[47] = "me";
gaFtsStop[48] = "med";
gaFtsStop[49] = "more";
gaFtsStop[50] = "most";
gaFtsStop[51] = "near";
gaFtsStop[52] = "no";
gaFtsStop[53] = "non";
gaFtsStop[54] = "not";
gaFtsStop[55] = "of";
gaFtsStop[56] = "on";
gaFtsStop[57] = "only";
gaFtsStop[58] = "or";
gaFtsStop[59] = "other";
gaFtsStop[60] = "over";
gaFtsStop[61] = "several";
gaFtsStop[62] = "she";
gaFtsStop[63] = "some";
gaFtsStop[64] = "such";
gaFtsStop[65] = "than";
gaFtsStop[66] = "that";
gaFtsStop[67] = "the";
gaFtsStop[68] = "their";
gaFtsStop[69] = "then";
gaFtsStop[70] = "there";
gaFtsStop[71] = "these";
gaFtsStop[72] = "they";
gaFtsStop[73] = "this";
gaFtsStop[74] = "through";
gaFtsStop[75] = "to";
gaFtsStop[76] = "under";
gaFtsStop[77] = "until";
gaFtsStop[78] = "use";
gaFtsStop[79] = "was";
gaFtsStop[80] = "we";
gaFtsStop[81] = "were";
gaFtsStop[82] = "when";
gaFtsStop[83] = "where";
gaFtsStop[84] = "which";
gaFtsStop[85] = "who";
gaFtsStop[86] = "with";
gaFtsStop[87] = "you";

gaFtsStem[0] = "ed";
gaFtsStem[1] = "es";
gaFtsStem[2] = "er";
gaFtsStem[3] = "e";
gaFtsStem[4] = "s";
gaFtsStem[5] = "ingly";
gaFtsStem[6] = "ing";
gaFtsStem[7] = "ly";


// as javascript 1.3 support unicode instead of ISO-Latin-1
// need to transfer come code back to ISO-Latin-1 for compare purpose
// Note: Different Language(Code page) maybe need different array:
var gaUToC=new Array();
gaUToC[8364]=128;
gaUToC[8218]=130;
gaUToC[402]=131;
gaUToC[8222]=132;
gaUToC[8230]=133;
gaUToC[8224]=134;
gaUToC[8225]=135;
gaUToC[710]=136;
gaUToC[8240]=137;
gaUToC[352]=138;
gaUToC[8249]=139;
gaUToC[338]=140;
gaUToC[381]=142;
gaUToC[8216]=145;
gaUToC[8217]=146;
gaUToC[8220]=147;
gaUToC[8221]=148;
gaUToC[8226]=149;
gaUToC[8211]=150;
gaUToC[8212]=151;
gaUToC[732]=152;
gaUToC[8482]=153;
gaUToC[353]=154;
gaUToC[8250]=155;
gaUToC[339]=156;
gaUToC[382]=158;
gaUToC[376]=159;

var gsBiggestChar="";
function getBiggestChar()
{
	if(gsBiggestChar.length==0)
	{
		if(garrSortChar.length<256)
			gsBiggestChar=String.fromCharCode(255);
		else
		{
			var nBiggest=0;
			var nBigChar=0;
			for(var i=0;i<=255;i++)
			{
				if(garrSortChar[i]>nBiggest)
				{
					nBiggest=garrSortChar[i];
					nBigChar=i;
				}
			}
			gsBiggestChar=String.fromCharCode(nBigChar);
		}

	}	
	return gsBiggestChar;
}

function getCharCode(str,i)
{
	var code=str.charCodeAt(i)
	if(code>256)
	{
		code=gaUToC[code];
	}
	return code;
}

function compare(strText1,strText2)
{
	if(garrSortChar.length<256)
	{
		var strt1=strText1.toLowerCase();
		var strt2=strText2.toLowerCase();
		if(strt1<strt2) return -1;
		if(strt1>strt2) return 1;
		return 0;
	}
	else
	{
		for(var i=0;i<strText1.length&&i<strText2.length;i++)
		{
			if(garrSortChar[getCharCode(strText1,i)]<garrSortChar[getCharCode(strText2,i)]) return -1;
			if(garrSortChar[getCharCode(strText1,i)]>garrSortChar[getCharCode(strText2,i)]) return 1;
		}
		if(strText1.length<strText2.length) return -1;
		if(strText1.length>strText2.length) return 1;
		return 0;
	}
}
gbWhLang=true;