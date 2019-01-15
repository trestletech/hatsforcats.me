
library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(shinydashboard)

all_sales <- readRDS("../sales.rds")

cash <- readRDS("../cash.rds")

raise <- as.Date("2017-01-01")

shinyServer(function(input, output) {
    sales <- reactive({
        all_sales %>% 
            filter(Date >= input$range[1] & Date <= input$range[2])
    })
    
    unit <- reactive({
        if (input$range[2] - input$range[1] < 32){
            return("day")
        } else {
            return("month")
        }
    })
    
    output$sales <- renderPlot({
        ds <- sales()
        if (unit() == "month"){
            # Group by month
            day(ds$Date) <- 1
            ds <- ds %>%
                group_by(y=year(Date), m=month(Date))
            
        }
        ds <- ds <- ds %>% 
            group_by(Date) %>% 
            tally()
        
        ggplot(ds, aes(Date, n)) +
            geom_line() + geom_point() +
            ylab("Total Sales") +
            ggtitle(paste("Total sales by", unit()))
    })
    
    coh <- reactive({
        fc <- cash %>% 
            filter(Date >= input$range[1] & Date <= input$range[2])
        
        fc
    })
    
    output$coh <- renderPlot({
        p <- ggplot(coh(), aes(Date, Cash)) +
            geom_line() +
            geom_hline(yintercept=0) +
            ggtitle("Cash on hand")
        
        if (input$range[1] <= raise){
            p <- p + geom_vline(xintercept = raise, color="blue") +
                annotate(geom="text", x=raise-11, y=500000, label="Series A", 
                         color="blue", angle=90)
        }
        
        p
    })
    
    output$projection <- renderUI({
        projection <- 100
        
        ca <- coh()
        
        if (input$range[1] < raise) {
            # Only predict on the more recent part of the model
            ca <- ca %>% filter(Date > raise)
        }
        
        clm <- lm(Cash~Date, data=ca)
        range <- input$range[2] - input$range[1]
        days <- round(range * .25)
        
        if (days > 100){
            days <- 100
        }
        
        pred <- input$range[2] + days
        
        p <- predict(clm, data.frame(Date=pred))
        
        p <- round(p, digits=2)
        
        status <- "green"
        if (p < 100000) {
            status <- "yellow"    
        }
        if (p < 0){
            status <- "red"
        }
        
        neg <- ""
        if (p < 0){
            neg <- "-"
        }
        
        p <- format(abs(p), big.mark=",", nsmall=2)
        
        title <- paste0("Projected cash on hand in ", days, " days")
        
        shinydashboard::valueBox(paste0(neg, "$", p), subtitle=title, color=status, width=12)
    })

})
