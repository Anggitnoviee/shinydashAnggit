
source("global.R", local = TRUE)

# Define UI for application that draws a histogram

ui<- shinyUI(
  
  dashboardPage(
   skin = "green",
   title = "Dashboard Visualisasi RS An-NISA Tangerang",
   
   #Header
   dashboardHeader(title = "RS AN-NISA",titleWidth = 230),
   
   
   # Side bar of the Dashboard
   dashboardSidebar(
     selectInput(
       inputId = "spesialis",
       label = "Dokter Spesialist:",
       choices = dokter_spesialist_list,
       selected = "DL",
       selectize = FALSE),
    selectInput(
      inputId = "dokter",
      label = "Dokter:",
      choices = dokter_list,
      selected = "DL",
      selectize = FALSE),
    
    # Side menu of the Dashboard
    sidebarMenu(
      selectInput(
        inputId = "month",
        label = "Month:",
        choices = month_list,
        selected = 99,
        size = 13,
        selectize = FALSE)
    )),
   # The body of the dashboard
   dashboardBody(
     tabsetPanel(id = "tabs",
                 tabPanel(title = "WTRJ",
                          value = "page1",
                          fluidRow(valueBoxOutput("total_pasien"),
                                   valueBoxOutput("per_day"),
                                   valueBoxOutput("tester"))
   
   
    )
   )
  )
 )
)
                 


