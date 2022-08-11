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
      multiple = TRUE,
      selectize = TRUE)
    
  })
  
  base_wtrj <- reactive({
    if(input$month == "All"){
      temp <- wtrj_clean %>%
        filter(Spesialis == input$spesialis, Nama.Dokter == input$dokter)
    } else {
      
      temp <- wtrj_clean %>%
        filter(Spesialis == input$spesialis, Nama.Dokter == input$dokter, Bulan == input$month, Hari == input$hari)
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
#-------------------------------------------------------------------------------
  
 # group total
   output$group_totals <- renderD3({
     
     base_wtrj <- wtrj_clean %>% 
       group_by(Bulan) %>% 
       summarise(total=n())  %>% 
       ungroup()
     base_wtrj$Bulan <- factor(base_wtrj$Bulan, levels = c("April","May","June"))
     base_wtrj %>% 
       arrange(Bulan)
     
     hist_total<- plot_ly(base_wtrj, 
                          x = ~Bulan, 
                          y = ~total, 
                          type = 'bar', 
                          name = 'Bulan',
                          marker = list(color = 'rgb(149,173,160)',
                                        line = list(color = 'rgb(74,86,80)',
                                                    width = 1.5)))
     hist_total  <- hist_total  %>% layout(title = "TOTAL KUNJUNGAN PER-BULAN",
                                           xaxis = list(title = "BULAN"),
                                           yaxis = list(title = "JUMLAH PASIEN"))
   })
   
  #boxplot
   
   output$boxplot <- renderD3({
     
     resep_dokter <- datawtrj %>%
       group_by(jam_resep_dokter, Hari, Tanggal) %>% 
       summarise(jumlah = n()) %>% 
       mutate(persen = jumlah*100/nrow(wtrj_clean),
              Tanggal = as.factor(Tanggal),
              jam_resep_dokter = as.factor(jam_resep_dokter)) %>% 
       ungroup() %>% 
       filter(!jam_resep_dokter %in% c('5','6','7','21','22','23'))
     resep_dokter$Hari <- factor(resep_dokter$Hari, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
     resep_dokter %>% 
       arrange(Hari)
     plot_resep_dokter <- ggplot(resep_dokter, aes(x = jam_resep_dokter, y = jumlah, fill=jam_resep_dokter)) +
       geom_boxplot() +
       scale_y_continuous(labels = label_number())+
       facet_wrap(~Hari, ncol=7)
     ggplotly(plot_resep_dokter)
   })
  
#-------------------------------------------------------------------------------  
   
})
