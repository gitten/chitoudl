module LoginPage where

import Signal exposing (Address)

import Html exposing (Html, div, input, text, button)
import Html.Events as Events exposing (onClick)
import Effects exposing (Effects, Never)
import StartApp 
import RouteHash exposing (HashUpdate)

main = app.html

app =
  StartApp.start
            { init = init
            , update = update
            , view = view
            , inputs = []
            }


init : (Model, Effects Action)
init =
  let
    model =
      { userName = ""
      , gender = []
      }
  in
    (model, Effects.none)

----MODEL

type alias Model =
  { userName : String
  , gender : List String
  }


----UPDATE

type Action
  = UpdateName String
  | SelectGender
  | Next
            

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    UpdateName string ->
      ({ model | userName = string }, Effects.none)

    SelectGender -> (model, Effects.none)

    Next -> (model, Effects.none)


----VIEW

view : Address Action -> Model -> Html
view address model =
  div [] <|
        [ viewName address model
        , nextButton address
        ]


viewName : Address Action -> Model -> Html
viewName address model =
  input 
    [ Events.on "input" Events.targetValue
              (Signal.message address << UpdateName)
    ]
    []


nextButton : Address Action  -> Html
nextButton address =
  button
    [ onClick address Next ]
    [ text "Next" ]


----ROUTING

delta2update : Model -> Model -> Maybe HashUpdate
delta2update previous current =
  Just RouteHash.set [ toString current ]


loaction2action : List String -> List Action
loaction2action list =
  case list of
    head :: tail ->
      case toInt head ->
        Ok value ->
          [ Set value ]

        Err _ ->
          []

  _ -> []
