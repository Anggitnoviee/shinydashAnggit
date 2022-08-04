library(shiny)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {
  tab_list <- NULL
  
  base_wtrj <- reactive({
  })
  
  # Total Pasien (server) ------------------------------------------
  output$total_pasien <- renderValueBox({
    # The following code runs inside the database.
    # pull() bring the results into R, which then
    # it's piped directly to a valueBox()
    plot1 <- wtrj_clean %>% 
      tally() %>%
      pull() %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>% 
      valueBox(icon = icon("chart-bar"), color = "olive",subtitle = "Pasien per Bulan")
  })
  
  # Avg per Day (server) --------------------------------------------
  output$per_day <- renderValueBox({
    # The following code runs inside the database
    plot_2 <- wtrj_clean %>% 
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
    plot_3 <- wtrj_clean %>% 
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
