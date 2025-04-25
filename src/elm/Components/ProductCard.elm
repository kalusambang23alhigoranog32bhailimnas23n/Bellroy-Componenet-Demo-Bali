module Components.ProductCard exposing (Model, Msg, init, update, view, Product, Color, Image)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Basics


-- MODEL
{- 
   The Color type represents a color option for the product.
   It includes:
   - name: The display name of the color
   - hex: The hex code to display the color
   - isSelected: Whether this color is currently selected
-}
type alias Color =
    { name : String
    , hex : String
    , isSelected : Bool
    }

{-
   The Image type represents an image for the product.
   It includes:
   - url: The source URL of the image
   - alt: The alt text for accessibility
-}
type alias Image =
    { url : String
    , alt : String
    }

{-
   The Product type represents all data for a product.
   It includes:
   - id: Unique identifier
   - name: Display name
   - price: Current (discounted) price in Euros
   - originalPrice: Original price before discount
   - discountPercentage: Percentage discount (e.g., 35 for 35% off)
   - rating: Product rating (e.g., 4.9)
   - stockCount: Number of items in stock
   - soldCount: Number of items sold (e.g., 8.4K)
   - images: List of product images
   - isBestseller: Whether to show the bestseller tag
   - description: Short product description
   - colors: Available color options
-}
type alias Product =
    { id : Int
    , name : String
    , price : Float
    , originalPrice : Float
    , discountPercentage : Int
    , rating : Float
    , stockCount : Int
    , soldCount : Float
    , images : List Image
    , isBestseller : Bool
    , description : String
    , colors : List Color
    }

{-
   The Model stores the component's internal state:
   - currentImageIndex: Which image is currently displayed
   - selectedColor: Which color is currently selected (if any)
   - inWishlist: Whether the product is in the user's wishlist
-}
type alias Model =
    { currentImageIndex : Int
    , selectedColor : Maybe String
    , inWishlist : Bool
    }

{-
   Initializes the component with default values:
   - Image index starts at 0 (first image)
   - No color is selected by default
   - Product is not in wishlist by default
-}
init : Model
init =
    { currentImageIndex = 0
    , selectedColor = Nothing
    , inWishlist = False
    }


-- UPDATE

{-
   Msg represents all possible actions that can be taken on the component:
   - SelectColor: User selects a color
   - NextImage: User clicks to see the next image
   - PrevImage: User clicks to see the previous image
   - SelectImage: User clicks directly on a specific image thumbnail
   - ToggleWishlist: User toggles whether the product is in their wishlist
-}
type Msg
    = SelectColor String
    | NextImage
    | PrevImage
    | SelectImage Int
    | ToggleWishlist

{-
   The update function handles state changes based on user actions:
   - Selecting a color updates the selectedColor field
   - Image navigation updates the currentImageIndex
   - For circular navigation, indices wrap around using modBy
   - Toggling wishlist inverts the inWishlist boolean
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectColor colorName ->
            { model | selectedColor = Just colorName }

        NextImage ->
            { model | currentImageIndex = model.currentImageIndex + 1 }

        PrevImage ->
            { model | currentImageIndex = model.currentImageIndex - 1 }

        SelectImage index ->
            { model | currentImageIndex = index }
            
        ToggleWishlist ->
            { model | inWishlist = not model.inWishlist }


-- VIEW

{-
   Helper function to format the number of items sold with K suffix for thousands
   For example: 8400 -> "(8.4) K Sold"
   The number is placed in brackets as requested
-}
formatSoldCount : Float -> String
formatSoldCount count =
    if count >= 1000 then
        let
            thousands = count / 1000
            -- Format with one decimal place if needed
            formatted = 
                if thousands == toFloat (round thousands) then
                    String.fromInt (round thousands)
                else
                    String.fromFloat (toFloat (round (thousands * 10)) / 10)
        in
        "(" ++ formatted ++ ") K Sold"
    else
        "(" ++ String.fromFloat count ++ ") Sold"

{-
   The view function renders the ProductCard component.
   It takes:
   - product: The product data to display
   - model: The current state
   - toParentMsg: A function to convert local messages to parent's message type
-}
view : Product -> Model -> (Msg -> msg) -> Html msg
view product model toParentMsg =
    let
        totalImages = List.length product.images

        -- Calculate the effective image index with wrapping/circular behavior
        currentImageIndex =
            if totalImages == 0 then
                0
            else
                modBy totalImages 
                    (if model.currentImageIndex < 0 then
                        totalImages + model.currentImageIndex
                     else
                        model.currentImageIndex
                    )

        -- Get the current image to display
        currentImage =
            List.drop currentImageIndex product.images
                |> List.head
                |> Maybe.withDefault { url = "", alt = "" }

        -- Renders a single color selection circle
        viewColorOption color =
            let
                borderClass =
                    case model.selectedColor of
                        Just selected ->
                            if selected == color.name then
                                "ring-2 ring-offset-1 ring-black"
                            else
                                ""

                        Nothing ->
                            if color.isSelected then
                                "ring-2 ring-offset-1 ring-black"
                            else
                                ""
            in
            div
                [ Attr.class ("color-option cursor-pointer rounded-full w-5 h-5 " ++ borderClass)
                , Attr.style "background-color" color.hex
                , onClick (toParentMsg (SelectColor color.name))
                , Attr.title color.name
                , Attr.attribute "role" "button"
                , Attr.attribute "aria-label" ("Select " ++ color.name ++ " color")
                ]
                []

    in
    div [ Attr.class "product-card w-full bg-white p-2 shadow-md rounded-md" ]
        [ div [ Attr.class "relative overflow-hidden" ]
            [ img
                [ Attr.src currentImage.url
                , Attr.class "w-full h-64 object-cover"
                , Attr.alt currentImage.alt
                , Attr.attribute "loading" "eager"
                , Attr.attribute "decoding" "sync"
                , Attr.style "object-position" "center"
                ]
                []
            , if product.isBestseller then
                div
                    [ Attr.class "absolute top-0 left-0 bg-[#FF5A00] text-white text-xs px-2 py-1"
                    ]
                    [ text "Bestseller" ]
              else
                text ""
              
            -- Discount badge (only shown if discountPercentage > 0)
            , if product.discountPercentage > 0 then
                div
                    [ Attr.class "absolute top-2 right-2 bg-white text-[#333333] font-medium text-sm px-2 py-1 rounded-md shadow-sm"
                    ]
                    [ text (String.fromInt product.discountPercentage ++ "% OFF") ]
              else
                text ""
                
            -- Stock count badge
            , div
                [ Attr.class "absolute bottom-0 left-0 bg-[#FF0000] text-white text-xs px-2 py-1"
                ]
                [ text (String.fromInt product.stockCount ++ " Items in Stock") ]
                
            , button
                [ Attr.class "absolute left-2 top-1/2 transform -translate-y-1/2 bg-white rounded-full p-2 shadow-md"
                , onClick (toParentMsg PrevImage)
                , Attr.attribute "aria-label" "Previous image"
                ]
                [ div [ Attr.class "flex items-center justify-center text-black" ] [ text "←" ] ]
            , button
                [ Attr.class "absolute right-2 top-1/2 transform -translate-y-1/2 bg-white rounded-full p-2 shadow-md"
                , onClick (toParentMsg NextImage)
                , Attr.attribute "aria-label" "Next image"
                ]
                [ div [ Attr.class "flex items-center justify-center text-black" ] [ text "→" ] ]
            ]
        , if totalImages > 1 then
            -- Thumbnail gallery for image navigation
            div [ Attr.class "flex justify-center gap-2 mt-3" ]
                (List.indexedMap
                    (\index image ->
                        div
                            [ Attr.class
                                (if index == currentImageIndex then
                                    "border-2 border-[#FF5A00] rounded overflow-hidden cursor-pointer w-[80px] h-[80px]"
                                else
                                    "border border-gray-200 rounded overflow-hidden cursor-pointer w-[80px] h-[80px] hover:border-gray-400"
                                )
                            , onClick (toParentMsg (SelectImage index))
                            , Attr.attribute "aria-label" ("View image " ++ String.fromInt (index + 1))
                            ]
                            [ img
                                [ Attr.src image.url
                                , Attr.class "w-full h-full object-cover"
                                , Attr.alt ("Thumbnail " ++ String.fromInt (index + 1))
                                , Attr.attribute "loading" "eager"
                                ]
                                []
                            ]
                    )
                    product.images
                )
          else
            text ""
        , div [ Attr.class "mt-4" ]
            [ h3 [ Attr.class "text-[#333333] text-lg font-medium" ] [ text product.name ]
            
            -- Product rating display with star icons
            , div [ Attr.class "flex items-center mt-1" ]
                [ div [ Attr.class "flex text-[#FFC107]" ]
                    (List.map (\_ -> span [ Attr.class "text-lg" ] [ text "★" ]) (List.range 1 5))
                , span [ Attr.class "ml-1 text-sm text-gray-600" ] 
                    [ text ("(" ++ String.fromFloat product.rating ++ ")") ]
                ]
                
            -- All price info, sold count and wishlist heart in one flex container
            , div [ Attr.class "flex justify-between items-center mb-1" ]
                [ 
                  -- Price information on the left
                  div [ Attr.class "flex items-center" ]
                    [ 
                      -- Current price 
                      span [ Attr.class "text-[#FF5A00] font-bold text-xl" ]
                        [ text ("€" ++ String.fromFloat product.price) ]
                      
                      -- Original price (slightly elevated)
                      , if product.discountPercentage > 0 then
                        span [ Attr.class "text-gray-500 line-through ml-2 -mb-[10px]" ]
                            [ text ("€" ++ String.fromFloat product.originalPrice) ]
                        else
                        text ""
                    ]
                
                  -- Sold count and wishlist heart on the right
                  , div [ Attr.class "flex items-center" ]
                    [ 
                      -- Sold count
                      span [ Attr.class "text-sm text-gray-500" ]
                        [ text (formatSoldCount product.soldCount) ]
                      
                      -- Small gap
                      , div [ Attr.class "w-[3px]" ] []
                      
                      -- Wishlist heart button that turns red when clicked
                      , button 
                        [ Attr.class 
                            (if model.inWishlist then
                                "text-2xl text-red-500 transition-colors border-none bg-transparent cursor-pointer outline-none" 
                             else 
                                "text-2xl text-gray-300 hover:text-red-500 transition-colors border-none bg-transparent cursor-pointer border border-black"
                            )
                        , onClick (toParentMsg ToggleWishlist)
                        , Attr.attribute "aria-label" "Add to wishlist"
                        ]
                        [ text "♥" ]
                    ]
                ]
            ]
        , div [ Attr.class "flex flex-wrap gap-1 my-2" ]
            (List.map viewColorOption product.colors)
        , p [ Attr.class "text-gray-600 text-sm" ] [ text product.description ]
        ]
