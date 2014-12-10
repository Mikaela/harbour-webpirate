.pragma library

var defaultsearchengines = [ { "name": "DuckDuckGo",
                               "query": "http://duckduckgo.com/?q=" },

                             { "name": "Google",
                               "query": "https://www.google.it/search?q=" } ];

function load(db, searchengines)
{
    var i = 0;

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS SearchEngines (name TEXT PRIMARY KEY, query TEXT)");
        var res = tx.executeSql("SELECT * FROM SearchEngines;");

        if(res.rows.length > 0)
        {
            for(i = 0; i < res.rows.length; i++)
                searchengines.append({ "name": res.rows[i].name, "query": res.rows[i].query });
        }
        else
        {
            for(i = 0; i < defaultsearchengines.length; i++)
                add(db, searchengines, defaultsearchengines[i].name, defaultsearchengines[i].query);
        }
    });
}

function add(db, searchengines, name, query)
{
    searchengines.append({ "name": name, "query": query })

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO SearchEngines (name, query) VALUES (?, ?);", [name, query]);
    });
}
