module Chit where

import String exposing (join)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address, Mailbox, mailbox)

import StartApp.Simple as StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)

<<<<<<< HEAD
import Debug




=======

>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2

---- MODEL

type alias Model =
  { userName : String
  , chitRooms : List String
  , chitData : List Chit
  , currentRoom : String
  , chit2send : String
  }


type alias Chit =
<<<<<<< HEAD
  { roomname : String
=======
  { roomName : String
>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2
  , user : String
  , msg : String
  }
    


<<<<<<< HEAD

----UPDATE
=======
init : Model
init =
  { userName = "yurnaim"
  , chitRooms = initRooms
  , chitData = genChit :: moreChit ++ initChitData
  , currentRoom = "general"
  , chit2send = ""
  }


initRooms : List String
initRooms = [ "general", "ninja", "pirate", "unicorn", "rainbow" ]


initChitData =
    List.map initChit initRooms


initChit : String -> Chit
initChit string =
  { roomName = string
  , user = "chitBot"
  , msg = " your base R belonging to I"
  }

--------test data
genChit =
  {roomName = "general", user = "Kyle", msg = " I R lisp"}

>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2

moreChit =
  [ {roomName = "ninja", user = "a wild ninja", msg = " I R Ninjer"}
  , {roomName = "pirate", user = "a wild pirate", msg = " I Arrrrrg"}
  , {roomName = "unicorn", user = "a wild unicorn", msg = " I R Neeey?"}
  , {roomName = "rainbow", user = "skittles", msg = " I R taste"}
  ]
    

----UPDATE
type Action
  = ChangeRoom String
  | Chitting String
  | SendChit
  | UpdateName String
<<<<<<< HEAD
  | ReceiveChit Chit
  | ChitSent
=======
  | NoOp
>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2


update : Action -> Model -> Model
update action model =
  case action of
    Chitting message ->
<<<<<<< HEAD
      ({ model | chit2send = message }, Effects.none)
                                
    ChangeRoom room ->
      ({ model | currentRoom = room }, Effects.none)

    SendChit ->
      (model, sendChitFx model)
        
    UpdateName name ->
      ({ model | userName = name }, Effects.none)

    ChitSent ->
      ({ model | chit2send = "" },  Effects.none)

    ReceiveChit chit ->
      ({ model | chitData = chit :: model.chitData },  Effects.none)




----EFFECTS

sendChitFx : Model -> Effects Action    
sendChitFx { currentRoom, userName, chit2send} =
  format2chit currentRoom userName chit2send
    |> Signal.send portOutChitMb.address
    |> Effects.task
    |> Effects.map (\_ -> ChitSent)

format2chit : String -> String -> String -> Chit       
format2chit room userName msg =
  { roomname = room, user = userName, msg = msg }




=======
      { model | chit2send = message }
                                
    ChangeRoom room ->
      { model | currentRoom = room }

    SendChit ->
      { model | chit2send = "" }

    UpdateName name ->
      { model | userName = name }

    NoOp -> model

>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2
----VIEW

view : Address Action -> Model -> Html
view address model =
  div
    [ id "chitoudl" ]
<<<<<<< HEAD
    [ div
        [ id "chit-container" ]
        [ viewRooms address model, viewChits model ]
=======
    [ viewRooms address model
    , viewChits model
>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2
    , viewChiterer address model
    ]

viewRooms : Address Action -> Model -> Html
viewRooms address model =
  let
    clickEvent room =
      onClick address (ChangeRoom room)
  in
<<<<<<< HEAD
    ul
      [ id "rooms" ]
      ( List.map
          (\s -> li [ clickEvent s ] [ a [] [ text s ] ])
          model.chitRooms
      )


viewChits : Model -> Html
viewChits model =
  div
    [ id "chits" ]
    ( model.chitData
    |> List.filter (isRoom model.currentRoom)
    |> List.map formatChit
    |> List.reverse
    )
    
isRoom : String -> Chit -> Bool
isRoom currentRoom {roomname} =
  if roomname == currentRoom then True else False
        

viewChiterer : Address Action -> Model -> Html      
viewChiterer address model =
  div
    [ id "footer" ]
    [ input
        [ id "input-name"
        , value model.userName
=======
    div
      [ id "rooms" ]
      (List.map (\s -> li [ clickEvent s ] [text s]) model.chitRooms)


viewChits : Model -> Html
viewChits model =
  div
    [ id "chits" ]
    ( model.chitData
      |> List.filter (isRoom model.currentRoom)
      |> List.map formatChit
      |> List.reverse
    )

isRoom : String -> Chit -> Bool
isRoom currentRoom {roomName} =
  if roomName == currentRoom then True else False
        

viewChiterer : Address Action -> Model -> Html      
viewChiterer address model =
  div
    [ id "footer" ]
    [ input
        [ value model.userName
>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2
        , on "input" targetValue (Signal.message address << UpdateName)
        ]
        []

    , input
<<<<<<< HEAD
        [ id "input-msg"
        , placeholder "the body here"
=======
        [ placeholder "the body here"
>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2
        , value model.chit2send
        , on "input" targetValue (Signal.message address << Chitting)
        ]
        []

    , button [ onClick address SendChit ] [ text "Send" ]
    ]


formatChit : Chit -> Html
formatChit { user, msg} =
  p
    []
    [ String.join "" [ "[ ", user, " ] : ", msg ] |> text ]




<<<<<<< HEAD
----WIRING

main = app.html


app =
  StartApp.start
            { init = init
            , view = view
            , update = update
            , inputs = [ incomingChit ]
            }


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


port inChits : Signal Chit

incomingChit : Signal Action
incomingChit =
  Signal.map ReceiveChit inChits
    

port outChit : Signal Chit
port outChit =
  portOutChitMb.signal

portOutChitMb : Mailbox Chit
portOutChitMb =
  mailbox (initChit "general")




----INITIAL VALUES

init : (Model, Effects Action)
init =
  let model =
    { userName = "yurnaim"
    , chitRooms = initRooms
    , chitData = genChit :: moreChit ++ initChitData
    , currentRoom = "general"
    , chit2send = ""
    }
  in
    (model, Effects.none)  


initRooms : List String
initRooms = [ "general", "ninja", "pirate", "unicorn", "rainbow" ]

initChitData =
    List.map initChit initRooms


initChit : String -> Chit
initChit room =
  { roomname = room
  , user = "chitBot"
  , msg = " you're base R belonging to I"
  }




--------test data

genChit =
  {roomname = "general", user = "Kyle", msg = " I R lisp"}


moreChit =
  [ {roomname = "ninja", user = "a wild ninja", msg = " I R Ninjer"}
  , {roomname = "pirate", user = "a wild pirate", msg = " I Arrrrrg"}
  , {roomname = "unicorn", user = "a wild unicorn", msg = " I R Neeey?"}
  , {roomname = "rainbow", user = "skittles", msg = " I R taste"}
  ]
=======
  


----WIRING

main =
  StartApp.start
            { view = view
            , update = update
            , model = init
            }
>>>>>>> bc51fb6d5d326ffe3c3423f05fa17a0fe67a03e2
