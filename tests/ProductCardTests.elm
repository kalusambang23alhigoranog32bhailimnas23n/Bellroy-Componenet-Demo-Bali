module ProductCardTests exposing (..)

{-
   This module contains tests for the ProductCard component.
   It uses elm-test to verify that the component renders correctly
   and behaves as expected when users interact with it.
-}

import Components.ProductCard as ProductCard
import Expect
import Html
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector

{-
   Mock product data for testing purposes.
   This provides a consistent set of data for all tests.
-}
mockProduct : ProductCard.Product
mockProduct =
    { id = 1
    , name = "Test Product"
    , price = 49.99
    , images =
        [ { url = "/test-image.jpg", alt = "Test image" }
        , { url = "/test-image-2.jpg", alt = "Test image 2" }
        ]
    , isBestseller = True
    , description = "Test description"
    , colors =
        [ { name = "Black", hex = "#000000", isSelected = True }
        , { name = "White", hex = "#FFFFFF", isSelected = False }
        ]
    }

{-
   Mock model for the ProductCard component.
   This represents the initial state of the component.
-}
mockModel : ProductCard.Model
mockModel =
    { currentImageIndex = 0
    , selectedColor = Nothing
    }

{-
   The suite of tests for the ProductCard component.
   This includes tests for rendering and interaction.
-}
suite : Test
suite =
    describe "ProductCard Component"
        [ describe "View Tests"
            [ test "displays product name" <|
                \_ ->
                    ProductCard.view mockProduct mockModel (\_ -> ())
                        |> Query.fromHtml
                        |> Query.find [ Selector.tag "h3" ]
                        |> Query.has [ Selector.text "Test Product" ]
            , test "displays bestseller badge when product is bestseller" <|
                \_ ->
                    ProductCard.view mockProduct mockModel (\_ -> ())
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.text "Bestseller" ]
                        |> Query.count (Expect.equal 1)
            , test "displays correct price" <|
                \_ ->
                    ProductCard.view mockProduct mockModel (\_ -> ())
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.containing [ Selector.text "€49.99" ] ]
                        |> Query.count (Expect.equal 1)
            , test "displays thumbnails when there are multiple images" <|
                \_ ->
                    ProductCard.view mockProduct mockModel (\_ -> ())
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.attribute (Html.Attributes.attribute "aria-label" "View image 1") ]
                        |> Query.count (Expect.equal 1)
            , test "shows color options" <|
                \_ ->
                    ProductCard.view mockProduct mockModel (\_ -> ())
                        |> Query.fromHtml
                        |> Query.findAll [ Selector.class "color-option" ]
                        |> Query.count (Expect.equal 2)
            ]
        , describe "Update Tests"
            [ test "next image updates the currentImageIndex" <|
                \_ ->
                    let
                        updatedModel = ProductCard.update ProductCard.NextImage mockModel
                    in
                    Expect.equal 1 updatedModel.currentImageIndex
            , test "prev image decrements the currentImageIndex" <|
                \_ ->
                    let
                        initialModel = { mockModel | currentImageIndex = 1 }
                        updatedModel = ProductCard.update ProductCard.PrevImage initialModel
                    in
                    Expect.equal 0 updatedModel.currentImageIndex
            , test "selecting an image sets the currentImageIndex" <|
                \_ ->
                    let
                        updatedModel = ProductCard.update (ProductCard.SelectImage 1) mockModel
                    in
                    Expect.equal 1 updatedModel.currentImageIndex
            , test "selecting a color updates the selectedColor" <|
                \_ ->
                    let
                        updatedModel = ProductCard.update (ProductCard.SelectColor "White") mockModel
                    in
                    Expect.equal (Just "White") updatedModel.selectedColor
            ]
        ] 