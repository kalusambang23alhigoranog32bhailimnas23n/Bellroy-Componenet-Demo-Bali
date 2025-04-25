module Main exposing (main)

import Browser
import Components.ProductCard as ProductCard
import Html exposing (..)
import Html.Attributes exposing (..)


-- MAIN

{-
   The main function initializes the Elm application.
   It uses Browser.element to create a component that takes over a specific HTML element.
-}
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


-- MODEL

{-
   The Product type represents all data for a product.
   This mirrors the structure in the ProductCard component but is defined here
   for use in the Main module.
-}
type alias Product =
    { id : Int
    , name : String
    , price : Float
    , originalPrice : Float  -- Original price before discount
    , discountPercentage : Int  -- Discount percentage (e.g., 35 for 35% off)
    , rating : Float  -- Product rating (e.g., 4.9)
    , stockCount : Int  -- Number of items in stock
    , soldCount : Float  -- Number of items sold (can be in thousands, e.g., 8.4K)
    , images : List { url : String, alt : String }
    , isBestseller : Bool
    , description : String
    , colors : List { name : String, hex : String, isSelected : Bool }
    }

{-
   The Model represents the application state:
   - productCards: A list of product cards, each with its own state and data
-}
type alias Model =
    { productCards : List ( ProductCard.Model, Product )
    }


{-
   The init function sets up the initial application state:
   - Creates product data for all products
   - Creates initial state for each product card
   - Returns the model and any commands to run (none in this case)
-}
init : () -> ( Model, Cmd Msg )
init _ =
    let
        products =
            [ { id = 1
              , name = "Phone Case - 3 Card"
              , price = 49
              , originalPrice = 75
              , discountPercentage = 35
              , rating = 4.9
              , stockCount = 30
              , soldCount = 8400
              , images =
                  [ { url = "/images/phone covers.avif", alt = "Phone Case - 3 Card, Sage green color, front view" }
                  , { url = "/images/phone image.avif", alt = "Phone Case - 3 Card, Sage green color, back view" }
                  , { url = "/images/phoneimage1.avif", alt = "Phone Case - 3 Card, Black color" }
                  ]
              , isBestseller = True
              , description = "A minimalist wallet and case for your iPhone"
              , colors =
                  [ { name = "Black", hex = "#1D1D1D", isSelected = False }
                  , { name = "Navy", hex = "#1C3156", isSelected = False }
                  , { name = "Sage", hex = "#A2AAA2", isSelected = True }
                  , { name = "Teal", hex = "#2F555D", isSelected = False }
                  , { name = "Brown", hex = "#4B3329", isSelected = False }
                  , { name = "Orange", hex = "#9E4D32", isSelected = False }
                  ]
              }
            , { id = 2
              , name = "Leather Phone Case"
              , price = 52
              , originalPrice = 65
              , discountPercentage = 20
              , rating = 4.8
              , stockCount = 45
              , soldCount = 4800
              , images =
                  [ { url = "/images/leatherphone.webp", alt = "Leather Phone Case Image 1" }
                  , { url = "/images/leatherphone1.webp", alt = "Leather Phone Case Image 2" }
                  , { url = "/images/leatherphone2.webp", alt = "Leather Phone Case Image 3" }
                  ]
              , isBestseller = False
              , description = "Premium leather protection for your iPhone"
              , colors =
                  [ { name = "Brown", hex = "#4B3329", isSelected = True }
                  , { name = "Black", hex = "#1D1D1D", isSelected = False }
                  , { name = "Orange", hex = "#9E4D32", isSelected = False }
                  ]
              }
            , { id = 3
              , name = "Laptop Sleeve"
              , price = 55
              , originalPrice = 55
              , discountPercentage = 0
              , rating = 4.7
              , stockCount = 75
              , soldCount = 6000
              , images =
                  [ { url = "/images/laptopsleev.avif", alt = "Laptop Sleeve Image 1" }
                  , { url = "/images/laptopsleev1.avif", alt = "Laptop Sleeve Image 2" }
                  , { url = "/images/laptopsleev2.avif", alt = "Laptop Sleeve Image 3" }
                  ]
              , isBestseller = True
              , description = "Carry your essentials with your phone"
              , colors =
                  [ { name = "Brown", hex = "#4B3329", isSelected = True }
                  , { name = "Black", hex = "#1D1D1D", isSelected = False }
                  , { name = "Navy", hex = "#1C3156", isSelected = False }
                  ]
              }
            , { id = 4
              , name = "Tech Kit"
              , price = 15
              , originalPrice = 20
              , discountPercentage = 25
              , rating = 4.5
              , stockCount = 18
              , soldCount = 1800
              , images =
                  [ { url = "/images/techkit.avif", alt = "Tech Kit Image 1" }
                  , { url = "/images/techkit2.avif", alt = "Tech Kit Image 2" }
                  , { url = "/images/techkit3.avif", alt = "Tech Kit Image 3" }

                  ]
              , isBestseller = False
              , description = "Secure grip for your phone"
              , colors =
                  [ { name = "Black", hex = "#000000", isSelected = True }
                  , { name = "Blue", hex = "#1C3156", isSelected = False }
                  , { name = "Red", hex = "#FF0000", isSelected = False }
                  ]
              }
            , { id = 5
              , name = "Pixel Watch Strap"
              , price = 27
              , originalPrice = 45
              , discountPercentage = 40
              , rating = 4.9
              , stockCount = 22
              , soldCount = 4500
              , images =
                  [ { url = "/images/watch.avif", alt = "Pixel Watch Strap Image 1" }
                  , { url = "/images/watch1.avif", alt = "Pixel Watch Strap Image 2" }
                  , { url = "/images/watch2.avif", alt = "Pixel Watch Strap Image 3" }
                  ]
              , isBestseller = True
              , description = "Protect your phone in a sleek sleeve"
              , colors =
                  [ { name = "Gray", hex = "#A2AAA2", isSelected = True }
                  , { name = "Blue", hex = "#1C3156", isSelected = False }
                  , { name = "Black", hex = "#1D1D1D", isSelected = False }
                  ]
              }
            , { id = 6
              , name = "Passport Cover"
              , price = 35
              , originalPrice = 35
              , discountPercentage = 0
              , rating = 4.7
              , stockCount = 100
              , soldCount = 9000
              , images =
                  [ { url = "/images/wallet.avif", alt = "Passport Cover Image 1" }
                  , { url = "/images/wallet1.avif", alt = "Passport Cover Image 2" }
                  ]
              , isBestseller = False
              , description = "Versatile mount for your phone"
              , colors =
                  [ { name = "Black", hex = "#000000", isSelected = True }
                  , { name = "Silver", hex = "#C0C0C0", isSelected = False }
                  ]
              }
            
            ]
        
        -- Initialize each product card with default state
        productCards =
            List.map (\product -> ( ProductCard.init, product )) products
    in
    ( { productCards = productCards }
    , Cmd.none
    )


-- UPDATE

{-
   The Msg type represents all possible actions in the application:
   - ProductCardMsg: Messages from child ProductCard components
     with an index to identify which product card sent the message
-}
type Msg
    = ProductCardMsg Int ProductCard.Msg


{-
   The update function handles state changes based on user actions:
   - It updates the specific product card identified by index
   - Leaves other product cards unchanged
   - Returns the updated model and any commands (none in this case)
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductCardMsg index productCardMsg ->
            let
                -- Helper function to update only the product card at the specified index
                updateProductCard i (cardModel, product) =
                    if i == index then
                        (ProductCard.update productCardMsg cardModel, product)
                    else
                        (cardModel, product)
                
                -- Apply the update to all product cards (affecting only the one at index)
                updatedCards =
                    List.indexedMap updateProductCard model.productCards
            in
            ( { model | productCards = updatedCards }
            , Cmd.none
            )


-- VIEW

{-
   The view function renders the entire application:
   - It creates a responsive grid layout for product cards
   - Maps over each product card to render it
   - Passes each product's data and state to the ProductCard component
-}
view : Model -> Html Msg
view model =
    div [ class "max-w-7xl mx-auto px-6 py-8" ]
        [ h1 [ class "text-3xl font-bold text-[#333333] mb-6" ] [ text "Phone Cases & Accessories" ]
        , div [ class "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-6 gap-y-12" ]
            (List.indexedMap
                (\index (productCardModel, product) ->
                    ProductCard.view product productCardModel (ProductCardMsg index)
                )
                model.productCards
            )
        ]
