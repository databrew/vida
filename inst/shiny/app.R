library(shiny)
library(shinydashboard)
library(dplyr)
library(leaflet)
library(vida)
library(ggplot2)
library(DT)
library(RColorBrewer)
library(shinyjs)


source('global.R')
header <- dashboardHeader(title="VIDA app")
sidebar <- dashboardSidebar(
  sidebarMenu(
    id = 'tabs',
    menuItem(
      text="Main",
      tabName="main",
      icon=icon("database")),
    menuItem(
      text="Output",
      tabName="output",
      icon=icon("eye")),
    menuItem(
      text = 'Babel',
      tabName = 'babel',
      icon = icon('book')
    ),
    menuItem(
      text = 'About',
      tabName = 'about',
      icon = icon('stethoscope')))
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  useShinyjs(),
  hidden(
    lapply(seq(n_tabs), function(i) {
      div(
        # class = "page",
        # id = paste0("step", i),
        # "Step", i
      )
    })
  ),
  
  
  tabItems(
    tabItem(
      tabName="main",
      fluidPage(
        fluidRow(
          h1('VIDA data translator', align = 'center')),
        fluidRow(
          column(3,
                 h3('Upload a .csv file'),
                 # Input: Select a file ----
                 fileInput("file1", "",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv")),
                 
                 # Horizontal line ----
                 tags$hr(),
                 helpText('If you don\'t have any data for upload but want to test the app, click below to download some fake data and then upload it to the app.'),
                 downloadButton('download_fake_data',
                                'Download fake data from Kenya'),
                 # tags$hr(),
                 downloadButton('download_fake_data_mali',
                                'Download fake data from Mali'),
                 downloadButton('download_fake_data_gambia',
                                'Download fake data from Gambia')
          ),
          column(6,
                 uiOutput('translate_ui')),
          column(3, 
                 uiOutput('go_ui'),
                 uiOutput('translated_ui'))
        ),
        fluidRow(
          textOutput("text")
        ),
        fluidRow(
          column(12,
                 uiOutput('preview_ui'))
        )
        
      )),
    tabItem(
      tabName = 'output',
      uiOutput('translated_data_ui')
    ),
    tabItem(
      tabName = 'troubleshooting',
      uiOutput('troubleshooting_ui')
    ),
    tabItem(
      tabName = 'babel',
      fluidPage(
        fluidRow(downloadButton('downloadBabel',
                       'Download Complete Babel')),
        fluidRow(DT::dataTableOutput('babel'))
      )
    ),
    tabItem(
      tabName = 'about',
      fluidPage(
        fluidRow(column(12,
                        h1('This application',
                           align = 'center'))),
        fluidRow(column(12,
                        p('Some details will go here...',
                          align = 'center'))),
        fluidRow(column(12,
                        h1('VIDA (Vaccine Impact on Diarrhea in Africa)',
                           align = 'center'))),
        fluidRow(
          valueBox(value = 'Goal',
                   subtitle = 'Assess the impact of rotavirus vaccine introduction on the incidence, etiology, and adverse clinical consequences of MSD',
                   color = 'blue',
                   icon = icon("location-arrow")),
          valueBox(value = 'Sites',
                   subtitle = 'Le Centre pour le Développement des Vaccines du Mali (CVD-Mali), Bamako, Mali; Medical Research Center (MRC), Basse, The Gambia; Centers for Disease Control and Prevention (CDC)/Kenya Medical Research Institute (KEMRI)',
                   color = 'blue',
                   icon = icon("group")),
          valueBox(value = 'The team',
                   subtitle = 'Kathleen Neuzil, Karen Kotloff (more names to go here)',
                   color = 'blue',
                   icon = icon("microchip"))),
        
        fluidRow(
          column(12,
                 h3('App construction and hosting'),
                 align = 'center')
        ),
        fluidRow(
          div(img(src='logo_clear.png', align = "center"), style="text-align: center;"),
          h4('This web application was built in partnership with ',
             a(href = 'http://databrew.cc',
               target='_blank', 'Databrew'),
             align = 'center'),
          p('Empowering research and analysis through collaborative data science.', align = 'center'),
          div(a(actionButton(inputId = "email", label = "info@databrew.cc", 
                             icon = icon("envelope", lib = "font-awesome")),
                href="mailto:info@databrew.cc",
                align = 'center')), 
          style = 'text-align:center;'
        )
      )
    )),
  br(),
  actionButton("prevBtn", "< Previous"),
  actionButton("nextBtn", "Next >")
)

# UI
ui <- dashboardPage(header, sidebar, body, skin="blue")

# Server
server <- function(input, output, session) {
  
  
  # Define a reactive value which is the currently selected tab number
  rv <- reactiveValues(page = 1)
  
  observe({
    toggleState(id = "prevBtn", condition = rv$page > 1)
    toggleState(id = "nextBtn", condition = rv$page < n_tabs)
    hide(selector = ".page")
    show(paste0("step", rv$page))
  })
  
  # Define function for changing the tab number in one direction or the 
  # other as a function of forward/back clicks
  navPage <- function(direction) {
    rv$page <- rv$page + direction
  }
  
  # Observe the forward/back clicks, and update rv$page accordingly
  observeEvent(input$prevBtn, {
    # Update rv$page
    navPage(-1)
  })
  observeEvent(input$nextBtn, {
    # Update rv$page
    navPage(1)
  })
  
  # Observe any changes to rv$page, and update the selected tab accordingly
  observeEvent(rv$page, {
    tab_number <- rv$page
    tab_name <- tab_dict %>% filter(number == tab_number) %>% .$name
    updateTabsetPanel(session, inputId="tabs", selected=tab_name)
  })
  
  # Observe any click on the left tab menu, and update accordingly the rv$page object
  observeEvent(input$tabs, {
    tab_name <- input$tabs
    tab_number <- tab_dict %>% filter(name == tab_name) %>% .$number
    message(paste0('Selected tab is ', input$tabs, '. Number: ', tab_number))
    rv$page <- tab_number
  })
  
  raw_data <- reactive({
    if(!is.null(input$file1)){
      df <- read.csv(input$file1$datapath)
      df
    } else {
      NULL
    }
    
  })
  
  output$babel <- DT::renderDataTable({
    x <- vida::mapper
    if(!is.null(x)){
      x
    } else {
      NULL
    }
  })
  
  output$contents <- DT::renderDataTable({
    x <- raw_data()
    if(!is.null(x)){
      head(x)
    } else {
      NULL
    }
  })
  
  output$preview_ui <- renderUI({
    x <- raw_data()
    if(!is.null(x)){
      fluidPage(
        column(12, align = 'center',
               h3('Your uploaded data',align = 'center'),
               p('The below shows what your uploaded data (pre-translation) looks like:'),
               DT::dataTableOutput("contents")
        )
      )
    } else {
      NULL
    }
  })
  
  output$translate_ui <- renderUI({
    x <- raw_data()
    if(!is.null(x)){
      fluidPage(
        h3('Select translation parameters'),
        selectInput('format', 'Input format', choices = c('Automatically detect',
                                                          formats),
                    selected = 'Automatically detect')
      )
    }
  })
  
  output$go_ui <- renderUI({
    x <- raw_data()
    if(!is.null(x)){
      fluidPage(
        fluidRow(
          h3('Click to translate')
        ),
        fluidRow(align = 'center',
                 actionButton('go_button', 'Translate!',
                              icon = icon('thumbs-up'),
                              width = '100%')
        ))
    } else {
      NULL
    }
  })
  
  translated <- reactiveValues()
  observeEvent(input$go_button, {
    # Get input data
    x <- raw_data()
    
    # Get input format
    input_format <- input$format
    if(input_format == 'Automatically detect'){
      input_format <- NULL
    } 
    
    # Translate
    withCallingHandlers({
      shinyjs::html("text", "")
      out <- translate(df = x,
                       input_format = input_format,
                       mapper = vida::mapper)
    },
    message = function(m) {
      shinyjs::html(id = "text", html = m$message, add = TRUE)
    })
    print(head(out))
    translated$data <- out
  })
  
  output$translated_ui <- renderUI({
    x <- translated$data
    ok <- FALSE
    if(!is.null(x)){
      if(nrow(x) > 0){
        ok <- TRUE
      }
    }
    if(ok){
      fluidPage(
        fluidRow(align = 'center',
                 actionButton('examine_button', 'Examine translated data!',
                              icon = icon('arrow'),
                              width = '100%'))
      )
    } else {
      NULL
    }
  })
  
  observeEvent(input$examine_button, {
    navPage(1)
  })
  
  observeEvent(input$go_back, {
    navPage(-1)
  })
  
  output$translated_data_dt <- DT::renderDataTable({
    x <- translated$data
    ok <- FALSE
    if(!is.null(x)){
      if(nrow(x) > 0){
        ok <- TRUE
      }
    }
    if(ok){
      x
    } else {
      NULL
    }
  })
  
  output$translated_data_ui <-
    renderUI({
      x <- translated$data
      ok <- FALSE
      if(!is.null(x)){
        if(nrow(x) > 0){
          ok <- TRUE
        }
      }
      if(ok){
        fluidPage(
          fluidRow(h1('Translated data')),
          fluidRow(
            downloadButton('downloadData',
                         'Download translated data')
          ),
          fluidRow(p('Here is a preview of the translated data:')),
          fluidRow(
            column(12,
                   DT::dataTableOutput('translated_data_dt'))
          )
        )
      } else {
        fluidPage(
          h1('Translated data will go here'),
          h3('Go to the previous page to upload data for translation'),
          fluidRow(
            column(12,
                   align = 'center',
                   actionButton('go_back', 'Previous page'))
          )
        )
      }
      
    })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('translated', ".csv", sep = "")
    },
    content = function(file) {
      x <- translated$data
      write.csv(x, file, row.names = FALSE)
    }
  )
  
  output$downloadBabel <- downloadHandler(
    filename = function() {
      paste('babel', ".csv", sep = "")
    },
    content = function(file) {
      x <- vida::mapper
      write.csv(x, file, row.names = FALSE)
    }
  )
  
  output$download_fake_data <- downloadHandler(
    filename = function() {
      paste('fake', ".csv", sep = "")
    },
    content = function(file) {
      fake <- vida::fake
      write.csv(fake, file, row.names = FALSE)
    }
  )
  
  output$download_fake_data_mali <- downloadHandler(
    filename = function() {
      paste('fake', ".csv", sep = "")
    },
    content = function(file) {
      fake <- vida::fake_mali
      write.csv(fake, file, row.names = FALSE)
    }
  )
  
  output$download_fake_data_gambia <- downloadHandler(
    filename = function() {
      paste('fake', ".csv", sep = "")
    },
    content = function(file) {
      fake <- vida::fake_gambia
      write.csv(fake, file, row.names = FALSE)
    }
  )
  
  output$troubleshooting_ui <- renderUI({
    h1('Troubleshooting')
  })
  
}

shinyApp(ui, server)