
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
       multiple = TRUE,
       selectize = TRUE),
    uiOutput(
      outputId = "inputdokter"
    ),
    
    # Side menu of the Dashboard
    sidebarMenu(
      selectInput(
        inputId = "month",
        label = "Month:",
        choices = month_list,
        selected = "DL",
        multiple = TRUE,
        size = 13,
        selectize = FALSE),
      
    # side menu Hari
      selectInput(
        inputId = "hari",
        label = "Hari:",
        choices = unique(hari_list),
        selected = "DL",
        multiple = TRUE,
        selectize = TRUE
      ))
    ),
   # The body of the dashboard
   dashboardBody(
     tabsetPanel(id = "tabs",
                 tabPanel(title = "WTRJ",
                          value = "page1",
                          fluidRow(valueBoxOutput("total_pasien"),
                                   valueBoxOutput("per_day"),
                                   valueBoxOutput("tester")),
                          fluidRow(column(width = 6,d3Output("group_totals")),
                                   column(width = 6,d3Output("boxplot")))),
                 tabPanel(title = "WTRJ2",
                          value = "page2"))
)
)
)

                 


