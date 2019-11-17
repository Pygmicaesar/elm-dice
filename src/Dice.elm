module Dice exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Browser
import Svg exposing (svg, Svg, rect, circle)
import Svg.Attributes exposing (..)
import Random


-- MAIN --

main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }  


-- MODEL --

type alias Model =
    { faces : List Int
    }

init : () -> (Model, Cmd Msg)
init _ =
    (Model [1, 2, 3, 4, 5], Cmd.none)


-- UPDATE --

type Msg
    = Roll
    | NewFaces (List Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Roll ->
            (model, Random.generate NewFaces (Random.list 5 (Random.int 1 6)))

        NewFaces i ->
                (Model i, Cmd.none)


-- DICE IMPLEMENTATION --

dot n valid x y = 
    if (List.member n valid) then
        circle [cx x, cy y, r "7", fill "white"] []
    else
        circle [cx x, cy y, r "7", fill "tomato"] []
                          

die n = 
    [ rect [x "10", y "10", width "100", height "100", rx "5", ry "5", style "fill: tomato" ] []
    , dot n [4, 5, 6] "40" "40"
    , dot n [6] "60" "40"
    , dot n [4, 5, 6] "80" "40"
             
    , dot n [2, 3] "40" "60"
    , dot n [1, 3, 5] "60" "60"
    , dot n [2, 3] "80" "60"

    , dot n [4, 5, 6] "40" "80"
    , dot n [6] "60" "80"
    , dot n [4, 5, 6] "80" "80"
    ]
    
svgDie k = 
    Svg.svg
    [ onClick Roll, width "120", height "120" , viewBox "0 0 120 120" ]
    ( die k )


-- VIEW --

view : Model -> Html Msg
view model =
    div [ style "text-align: center"]
        [ h1 [] [text "Roll the dice!"]
        , div [] (List.map svgDie model.faces)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none