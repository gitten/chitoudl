import Signal

import Html exposing (Html)
import Html.Attributes exposing (Attribute)
import Html.Events as Events
import StartApp


main =
  app.html


app =
  StartApp.start
            { init =
            , update = update
            , view = view
            , inputs = []
            }


----MODEL

import Login

type Page
  = LoginPage


type alias Model =
  { login : Login.Model
  , currentPage : Page
  }


init : (Model, Effects Action)
init =
  let
    model =
      { login = Login.init
      , currentPage = Login
      }
  in
    (model, Effects.none)


----UPDATE

type Action
  = LoginPageAction Login.Action
  | NoOp


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)


----VIEW

