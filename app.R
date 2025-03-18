

library(rvest)
library(magrittr)
library(tidyr)
library(dplyr)
library(magick)
library(tidyverse)
library(ggplot2)
library(scales)
library(shiny)
library(shinyjs)
library(readxl)
library(shinyjs)
library(shinythemes)
library(shinyWidgets)

best_books_expanded <- read_excel("best_books_expanded.xlsx")

ui <- fluidPage(
  theme = shinytheme("flatly"),
  useShinyjs(),  
  
  titlePanel("The Bestseller Palette"),
  
  sidebarLayout(
    sidebarPanel(
      pickerInput("category_select", "Select a category:",
                  choices = c("All", unique(best_books_expanded$category)),
                  selected = "All", multiple = FALSE, 
                  options = list(style = "btn-primary")),
      
      pickerInput("author_select", "Select an author:",
                  choices = c("All"),
                  selected = "All", multiple = FALSE, 
                  options = list(style = "btn-info"))
    ),
    
    mainPanel(
      tabsetPanel(id = "selected_tab",
                  tabPanel("Book covers", fluidRow(uiOutput("book_images"))),
                  tabPanel("Platform Palette", plotOutput("colorTiles")),
                  tabPanel("Author Analysis", 
                           plotOutput("colorPlot"),
                           uiOutput("bookImages"))
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Filter data
  filtered_data <- reactive({
    data <- best_books_expanded %>% filter(!is.na(category))
    
    if (input$category_select != "All") {
      data <- data %>% filter(category == input$category_select)
    }
    
    if (input$author_select != "All") {
      data <- data %>% filter(author == input$author_select)
    }
    
    return(data)
  })
  
  # Update author dropdown based on category
  observeEvent(input$category_select, {
    category_data <- filtered_data()
    
    updatePickerInput(session, "author_select", 
                      choices = c("All", unique(category_data$author)),
                      selected = "All")
    
    # Enable the author dropdown only if a category is selected
    shinyjs::toggleState("author_select", input$category_select != "All")
  })
  
  # Render book images with color palettes
  output$book_images <- renderUI({
    data <- filtered_data()
    
    if (nrow(data) == 0 || is.null(data$colors)) {
      return(tags$p("No books found matching the selected filters."))
    }
    
    image_elements <- lapply(unique(data$title), function(title) {
      book_data <- data %>% filter(title == !!title)
      
      colors_list <- unlist(strsplit(as.character(book_data$colors), ", "))
      
      color_tiles <- tags$div(
        style = "display: flex; justify-content: center; margin-top: 5px;",
        lapply(colors_list, function(color) {
          tags$div(
            style = paste("background-color:", color, "; width: 30px; height: 30px; margin: 3px; border-radius: 3px;")
          )
        })
      )
      
      color_bar <- tags$div(
        style = paste("background: linear-gradient(to right, ", paste(colors_list, collapse = ", "), "); 
                      height: 30px; width: 200px; margin-top: 5px; border-radius: 3px;")
      )
      
      img_element <- tags$div(
        style = "text-align: center; margin: 5px;",
        tags$img(src = book_data$img_url[1], width = "150px", height = "225px")
      )
      
      combined_element <- tags$div(
        style = "width: 18%; max-width: 180px; display: flex; flex-direction: column; align-items: center; margin: 30px;",
        img_element,
        color_tiles,
        color_bar
      )
      
      combined_element
    })
    
    tags$div(
      style = "display: flex; flex-wrap: wrap; justify-content: center; 
               max-width: 100%; margin-left: auto; margin-right: auto; gap: 30px;",
      do.call(tagList, image_elements)
    )
  })
  
  output$colorTiles <- renderPlot({
    # Filter top_colors_all based on category selection and remove NAs
    color_data <- top_colors_all %>% filter(!is.na(representative_color))
    
    if (input$category_select != "All") {
      color_data <- color_data %>% filter(category == input$category_select)
    }
    
    # Handle case where there is no matching data
    if (nrow(color_data) == 0) {
      return(NULL)
    }
    
    # Plot the color tiles
    ggplot(color_data, aes(x = factor(position, levels = unique(color_data$position)), 
                           y = webpage, fill = representative_color)) +
      geom_tile(width = 0.95, height = 0.95) +
      scale_fill_identity() +
      theme_minimal() +
      labs(title = "", x = "", y = "") +
      theme(axis.text.x = element_blank(), 
            axis.ticks.x = element_blank(), 
            panel.grid = element_blank())
  })
  
  # Author color analysis
  output$colorPlot <- renderPlot({
    data <- filtered_data() %>% 
      count(author, colors, sort = TRUE) %>% 
      slice_head(n = 6) %>% 
      mutate(rank = row_number()) %>% 
      mutate(text_color = ifelse(
        (col2rgb(colors)[1,] * 0.299 +
           col2rgb(colors)[2,] * 0.587 +
           col2rgb(colors)[3,] * 0.114) > 150, 
        "black", "white"
      ))
    
    ggplot(data, aes(x = rank, y = reorder(author, -n), fill = colors)) +
      geom_tile(color = "white", size = 0.5) +
      geom_text(aes(label = colors, color = text_color), size = 5, fontface = "bold") +
      scale_fill_identity() +
      scale_color_identity() +
      theme_minimal() +
      labs(title = "", x = "", y = "") +
      theme(axis.text.x = element_blank(), 
            axis.ticks.x = element_blank(),
            panel.grid = element_blank())
  })
  # Mostrar imágenes de libros
  output$bookImages <- renderUI({
    books <- filtered_data() %>% distinct(title, img_url)  # Keep only one row per book
    
    if (nrow(books) == 0 || is.null(books$img_url)) {
      return(tags$p("No books found matching the selected filters."))
    }
    
    img_tags <- lapply(books$img_url, function(url) {
      tags$img(src = url, width = "100px", style = "margin: 5px; border-radius: 5px;")
    })
    
    tags$div(style = "display: flex; flex-wrap: wrap; justify-content: center; gap: 10px;", 
             do.call(tagList, img_tags))
  })
  
}

shinyApp(ui = ui, server = server)

