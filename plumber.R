
#* @apiTitle HatsForCats.me Sales API
#* @apiDescription Query the sales history by day or region
#* @apiTag sales Functionality having to do with sales history

sales <- readRDS("sales.rds") %>% select(-latitude, -longitude)
library(dplyr)

#* @get /sales/daily/
#* @tag sales
#* @param date:character Date to filter to in the format of "2019-01-01". Defaults to today.
#* @param state:character The two-letter abbreviation of the state to filter to. If empty, doesn't filter to a particular state.
function(state, date){
  if (missing(date)){
    # Default to today
    date <- Sys.Date()
  } else {
    date <- as.Date(date)
  }
  
  filt <- sales %>% filter(Date == date)
  if (!missing(state)){
    # Filter to a particular state
    # The column and variable name are the same, so we have to force evaluation
    # of the state variable.
    filt <- filt %>% filter(state == !!state)
  }
  
  filt
}
