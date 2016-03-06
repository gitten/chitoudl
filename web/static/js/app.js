// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

var elmDiv = document.getElementById('elm-main')

, elmApp = Elm.embed(Elm.Chit, elmDiv, { inchits : { user : "system", body : "sometings"} } );

let channel = socket.channel("chits:general", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


elmApp.ports.outgoingChit.subscribe(pushChit);

function pushChit(chit) {
    console.log('out chitters: ', {chits: chit})
    channel.push("from:elm", chit)

      
    scrollTo(0, document.body.scrollHeight)
    
}

channel.on("from:elm", data =>{
    console.log('in chitters', data)
    elmApp.ports.inchits.send(data)
})
