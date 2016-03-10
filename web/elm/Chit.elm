module Chit where

import String exposing (join)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address, Mailbox, mailbox)

import StartApp.Simple as StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)



---- MODEL

type alias Model =
  { userName : String
  , chitRooms : List String
  , chitData : List Chit
  , currentRoom : String
  , chit2send : String
  }


type alias Chit =
  { roomName : String
  , user : String
  , msg : String
  }


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
  | NoOp


update : Action -> Model -> Model
update action model =
  case action of
    Chitting message ->
      { model | chit2send = message }
                                
    ChangeRoom room ->
      { model | currentRoom = room }

    SendChit ->
      { model | chit2send = "" }

    UpdateName name ->
      { model | userName = name }

    NoOp -> model

----VIEW

view : Address Action -> Model -> Html
view address model =
  div
    [ id "chitoudl" ]
    [ viewRooms address model
    , viewChits model
    , viewChiterer address model
    ]

viewRooms : Address Action -> Model -> Html
viewRooms address model =
  let
    clickEvent room =
      onClick address (ChangeRoom room)
  in
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
        , on "input" targetValue (Signal.message address << UpdateName)
        ]
        []

    , input
        [ placeholder "the body here"
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

main =
  StartApp.start
            { view = view
            , update = update
            , model = init
            }
