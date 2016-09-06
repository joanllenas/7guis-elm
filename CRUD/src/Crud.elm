module Crud exposing (..)

import Html exposing (Html, input, div, select, option, text, button)
import Html.App as Html
import Html.Attributes exposing (value, size, style, placeholder, disabled)
import Html.Events exposing (onInput, onClick, on, targetValue)
import Json.Decode as Json
import String
import Styles


main : Program Never
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }



-- MODEL


type alias User =
    { id : String
    , name : String
    , surname : String
    }


type alias Model =
    { users : List User
    , all_users : List User
    , selectedUserId : String
    , editUser : Maybe User
    , filterText : String
    , lastUserId : Int
    }


initialUsers : List User
initialUsers =
    [ { id = "1", name = "Joan", surname = "Llenas" }
    , { id = "2", name = "Raúl", surname = "Jimenez" }
    ]


initialModel : Model
initialModel =
    { users = initialUsers
    , all_users = initialUsers
    , selectedUserId = ""
    , editUser = Nothing
    , filterText = ""
    , lastUserId = 2
    }



-- UPDATE


type Action
    = FilterChanged String
    | SelectUser String
    | UpdateUser
    | CreateUser
    | DeleteUser
    | EditUserNameChanged String
    | EditUserSurnameChanged String


userFilterFunction : String -> User -> Bool
userFilterFunction filter user =
    String.contains filter user.name || String.contains filter user.surname


userHasId : String -> User -> Bool
userHasId userId user =
    user.id == userId


updateUserWithId : String -> Maybe User -> User -> User
updateUserWithId userId editUser user =
    case editUser of
        Nothing ->
            user

        Just editUser ->
            if (userHasId userId user) then
                User user.id editUser.name editUser.surname
            else
                user


update : Action -> Model -> Model
update action model =
    case action of
        FilterChanged filter ->
            { model
                | users = List.filter (userFilterFunction filter) model.all_users
                , filterText = filter
                , editUser = Nothing
                , selectedUserId = ""
            }

        SelectUser userId ->
            let
                selectedUser =
                    List.filter (userHasId userId) model.users |> List.head
            in
                { model
                    | selectedUserId = userId
                    , editUser = selectedUser
                }

        UpdateUser ->
            let
                updatedList =
                    List.map (updateUserWithId model.selectedUserId model.editUser) model.all_users
            in
                { model
                    | all_users = updatedList
                    , users = List.filter (userFilterFunction model.filterText) updatedList
                }

        CreateUser ->
            case model.editUser of
                Nothing ->
                    model

                Just editUser ->
                    let
                        newUserId =
                            model.lastUserId + 1

                        newEditUser =
                            { editUser | id = toString newUserId }

                        updatedList =
                            newEditUser :: model.all_users
                    in
                        { model
                            | all_users = updatedList
                            , users = List.filter (userFilterFunction model.filterText) updatedList
                            , lastUserId = newUserId
                            , editUser = Nothing
                            , selectedUserId = ""
                        }

        DeleteUser ->
            let
                editUser =
                    Maybe.withDefault (User "" "" "") model.editUser

                updatedList =
                    List.filter (\user -> editUser.id /= user.id) model.all_users
            in
                { model
                    | all_users = updatedList
                    , users = List.filter (userFilterFunction model.filterText) updatedList
                    , editUser = Nothing
                    , selectedUserId = ""
                }

        EditUserNameChanged name ->
            let
                currentEditUser =
                    Maybe.withDefault (User "" "" "") model.editUser
            in
                { model | editUser = Just (User "" name currentEditUser.surname) }

        EditUserSurnameChanged surname ->
            let
                currentEditUser =
                    Maybe.withDefault (User "" "" "") model.editUser
            in
                { model | editUser = Just (User "" currentEditUser.name surname) }



-- VIEW


createUserRow : User -> Html Action
createUserRow user =
    option [ value user.id ] [ text (user.surname ++ ", " ++ user.name ++ " - " ++ user.id) ]


createUserList : List User -> String -> Html Action
createUserList users selectedUserId =
    let
        baseAttrs =
            [ size 100
            , style Styles.selectStyles
            , on "change" (Json.map SelectUser targetValue)
            ]

        selectAttrs =
            if selectedUserId == "" then
                baseAttrs
            else
                value selectedUserId :: baseAttrs
    in
        div [ style Styles.userListStyles ] [ select selectAttrs (List.map createUserRow users) ]


createUserFilter : String -> Html Action
createUserFilter filter =
    div [ style Styles.userFilterStyles ]
        [ input
            [ onInput FilterChanged
            , value filter
            , placeholder "Filter prefix"
            ]
            []
        ]


createUserForm : Maybe User -> Html Action
createUserForm editUser =
    let
        baseAttrs =
            ( [ onInput EditUserNameChanged, placeholder "Name" ], [ onInput EditUserSurnameChanged, placeholder "Surname" ] )

        inputAttrs =
            case editUser of
                Nothing ->
                    baseAttrs

                Just editUser ->
                    ( value editUser.name :: fst baseAttrs, value editUser.surname :: snd baseAttrs )
    in
        div [ style Styles.userFormStyles ]
            [ input (fst inputAttrs) []
            , input (snd inputAttrs) []
            ]


view : Model -> Html Action
view model =
    div [ style Styles.crudContainerStyles ]
        [ createUserFilter model.filterText
        , createUserList model.users model.selectedUserId
        , createUserForm model.editUser
        , div [ style Styles.crudButtonBarStyles ]
            [ button [ onClick CreateUser, disabled (model.editUser == Nothing) ] [ text "Create" ]
            , button [ onClick UpdateUser, disabled (model.selectedUserId == "") ] [ text "Update" ]
            , button [ onClick DeleteUser, disabled (model.selectedUserId == "") ] [ text "Delete" ]
            ]
        ]
