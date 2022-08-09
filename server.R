library(shiny)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {
  tab_list <- NULL
  

  
  output$inputdokter <- renderUI({
    
    temp <- wtrj_clean %>% 
      filter(Spesialis == input$spesialis) %>% 
      pull(Nama.Dokter)
    
    
    
    selectInput(
      inputId = "dokter",
      label = "Dokter:",
      choices = unique(temp),
      selected = "DL",
      selectize = FALSE)
    
  })
  
  base_wtrj <- reactive({
    if(input$month == "All"){
      temp <- wtrj_clean %>%
        filter(Spesialis == input$spesialis, Nama.Dokter == input$dokter)
    } else {
      
      temp <- wtrj_clean %>%
        filter(Spesialis == input$spesialis, Nama.Dokter == input$dokter, Bulan == input$month)
    }
  })
  
  # Total Pasien (server) ------------------------------------------
  output$total_pasien <- renderValueBox({
    # The following code runs inside the database.
    # pull() bring the results into R, which then
    # it's piped directly to a valueBox()
    plot1 <- base_wtrj() %>% 
      tally() %>%
      pull() %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>% 
      valueBox(icon = icon("chart-bar"), color = "olive",subtitle = "Pasien per Bulan")
  })
  
  # Avg per Day (server) --------------------------------------------
  output$per_day <- renderValueBox({
    # The following code runs inside the database
    plot_2 <- base_wtrj() %>% 
      group_by(Hari, Bulan) %>%
      tally() %>%
      ungroup() %>%
      summarise(avg = mean(n)) %>%
      pull(avg) %>%
      round() %>%
      prettyNum(big.mark = ",") %>%
     valueBox(icon = icon("balance-scale"), color = "green",subtitle = "Average Flights per day") 
  })
  
  # Sementara (server) --------------------------------------------
  output$tester <- renderValueBox({
    # The following code runs inside the database
    plot_3 <- base_wtrj() %>% 
      group_by(Hari, Bulan) %>%
      tally() %>%
      ungroup() %>%
      summarise(avg = mean(n)) %>%
      pull(avg) %>%
      round() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(icon = icon("percent"), color = "lime",subtitle = "$kuota") 
  })
   
})
