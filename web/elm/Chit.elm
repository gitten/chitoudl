module Chit where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Address, Mailbox, mailbox)

import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)

main : Signal Html
main =
  app.html


app =
  StartApp.start
            { init = model
            , update = update
            , view = view
            , inputs = [incomingChit]
            }


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


port inchits : Signal Chit

               
incomingChit =
  Signal.map ReceiveChit inchits
 

---- model


type alias Model =
  { userName : String
  , chitToSend : String
  , chits : List Chit
  }

                 
type alias Chit =
  { user : String
  , body : String
  }


model : (Model, Effects Action)
model =
  let
    model =
      { userName = "useMePls"
      , chitToSend = ""
      , chits = [initChit]
      }
  in
    (model, Effects.none)


initChit =
  { user = "your face hyar"
  , body = "your poops hyar"
  }


---- update

type Action
  = UpdateUserName String
  | Chitting String
  | SendChit
  | ChitSent
  | ReceiveChit Chit


chitFormat : String -> String -> Chit    
chitFormat userName chitToSend =
  { user = userName, body = chitToSend }


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    UpdateUserName str ->
      ({ model | userName = str }, Effects.none)

    Chitting str ->
      ({ model | chitToSend = str }, Effects.none)

    ReceiveChit chit ->
      ({ model | chits = chit :: model.chits }, Effects.none)
                    
    SendChit ->
      (model, sendChitFx model.userName model.chitToSend)

    ChitSent ->
      ({model | chitToSend = ""}, Effects.none)

----Output chits to js
port outgoingChit : Signal Chit
port outgoingChit =
  portOutgoingChitMb.signal
                
portOutgoingChitMb : Mailbox Chit
portOutgoingChitMb =
  mailbox initChit

format2chit : String -> String -> Chit
format2chit userName msg =
  { user = userName, body = msg }

sendChitFx : String -> String -> Effects Action    
sendChitFx user msg =
  format2chit user msg
    |> Signal.send portOutgoingChitMb.address
    |> Effects.task
    |> Effects.map (\_ -> ChitSent)








---- view

view : Address Action -> Model -> Html
view action model =
  div
    [ id "chitoudl" ]
    [ chitWindow action model
    , chiterer action model 
    ]


chitWindow : Address Action -> Model -> Html
chitWindow _ model =
  let
    newChit chit =
      p
        []
        [ text ("[" ++ chit.user ++ "] : " ++ chit.body) ]
  in
    div
      [ id "messages" ]
      (List.reverse (List.map newChit  model.chits))

    

chiterer : Address Action -> Model -> Html
chiterer address model =
  div
    [id "footer"]
    [ input
        [ value model.userName
        , on "input" targetValue (Signal.message address << UpdateUserName)
        ]
        []

    , text " : "
           
    , input
        [ placeholder "my body"
        , value model.chitToSend
        , on "input" targetValue (Signal.message address << Chitting)
        ]
        []
        
    , button [ onClick address SendChit ] [ text "send" ]
    ]

