module Chit where

import String exposing (join)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address, Mailbox, mailbox)

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)

import Debug





---- MODEL

type alias Model =
  { userName : String
  , chitRooms : List String
  , chitData : List Chit
  , currentRoom : String
  , chit2send : String
  }


type alias Chit =
  { roomname : String
  , user : String
  , msg : String
  }
    



----UPDATE

type Action
  = ChangeRoom String
  | Chitting String
  | SendChit
  | UpdateName String
  | ReceiveChit Chit
  | ChitSent


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Chitting message ->
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




----VIEW

view : Address Action -> Model -> Html
view address model =
  div
    [ id "chitoudl" ]
    [ div
        [ id "chit-container" ]
        [ viewRooms address model, viewChits model ]
    , viewChiterer address model
    ]

viewRooms : Address Action -> Model -> Html
viewRooms address model =
  let
    clickEvent room =
      onClick address (ChangeRoom room)
  in
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
        , on "input" targetValue (Signal.message address << UpdateName)
        ]
        []

    , input
        [ id "input-msg"
        , placeholder "the body here"
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
