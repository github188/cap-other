function getCookieVal(b){var a=document.cookie.indexOf(";",b);if(a==-1){a=document.cookie.length}return unescape(document.cookie.substring(b,a))}function getCookie(d){var b=d+"=";var f=b.length;var a=document.cookie.length;var e=0;while(e<a){var c=e+f;if(document.cookie.substring(e,c)==b){return getCookieVal(c)}e=document.cookie.indexOf(" ",e)+1;if(e==0){break}}return""}function setCookie(b,d,a,f,c,e){document.cookie=b+"="+escape(d)+((a)?"; expires="+a:"")+((f)?"; path="+f:"")+((c)?"; domain="+c:"")+((e)?"; secure":"")}function deleteCookie(a,d,b){if(getCookie(a)){var c=new Date();c.setTime(c.getTime()-10000);document.cookie=a+"="+((d)?"; path="+d:"")+((b)?"; domain="+b:"")+"; expires="+c.toGMTString()}};