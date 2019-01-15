library(shiny)
library(shinydashboard)

dashboardPage(
    dashboardHeader(title = "HatsForCats.me Dashboard"),
    dashboardSidebar(
        sidebarMenu(
            dateRangeInput("range", "Dates: ", start=Sys.Date()-30, end=Sys.Date(), startview = "year")
        )
    ),
    dashboardBody(
        fluidRow(
            uiOutput("projection"),
            box(plotOutput("sales", height = 300), width=12),
            box(plotOutput("coh", height = 300), width=12)
        )
    )
)
