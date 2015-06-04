.pragma library

function grabPlayerJavascript(ytplayer, mediagrabber, urldecoder)
{
    //var playerid = /html5player-([^/]+)\/html5player.js/.exec(ytplayer.assets.js);
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var funcname = /a.set\("signature",([a-z0-9]+)\([a-z]\)\);/i.exec(req.responseText);

            if(!funcname || !funcname[1]) {
                mediagrabber.grabFailed = true;
                return;
            }

            var funcbodyrgx = new RegExp("function " + funcname[1] + "\\(a\\){(.*?)};");
            var funcbody = funcbodyrgx.exec(req.responseText);

            if(!funcbody || !funcbody[1]) {
                mediagrabber.grabFailed = true;
                return;
            }

            var decodeobjname = /([a-z]{2,})\.[a-z]+\(/.exec(funcbody[1]);

            if(!decodeobjname || !decodeobjname[1]) {
                mediagrabber.grabFailed = true;
                return;
            }

            var decodeobjrgx = new RegExp("var " + decodeobjname[1] + "={(.*?)};");
            var decodeobj = decodeobjrgx.exec(req.responseText);

            if(!decodeobj || !decodeobj[1]) {
                mediagrabber.grabFailed = true;
                return;
            }

            var decodeobjstring = "var " + decodeobjname[1] + " = {" + decodeobj[1] + "};";
            var decodefunc = new Function("a", decodeobjstring + funcbody[1]);
            urldecoder(ytplayer.args.url_encoded_fmt_stream_map, mediagrabber, decodefunc);
        }
    }

    var playerurl = ytplayer.assets.js;

    if(playerurl.indexOf("//") === 0) /* Adjust URL, if needed */
        playerurl = "http:" + ytplayer.assets.js;

    req.open("GET", playerurl);
    req.send();
}

function decodeCipheredVideo(videoid, mediagrabber, urldecoder)
{
    mediagrabber.clearVideos(); /* Delete Ciphered URLs, if any */

    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var cap = /ytplayer.config = {(.*?)};/.exec(req.responseText);

            if(!cap || !cap[1]) {
                mediagrabber.grabFailed = true;
                return;
            }

            grabPlayerJavascript(JSON.parse("{" + cap[1] + "}"), mediagrabber, urldecoder);
        }
    }

    req.open("GET", "http://www.youtube.com/watch?v=" + videoid + "&gl=US&persist_gl=1&hl=en&persist_hl=1");
    req.send();
}
