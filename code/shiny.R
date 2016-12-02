library(shiny)
library(ggplot2)
library(stringr)

load("../data/imputed.Rdata")
load("../data/repayment.Rdata")
features <- c("COUNT_NWNE_P10","MN_EARN_WNE_P10","COUNT_WNE_INDEP0_P10","COUNT_WNE_INDEP0_INC1_P10","D150_4_POOLED","PCTFLOAN","DEBT_MDN","DEBT_N","DEP_DEBT_N","LOAN_EVER")
label <- as.numeric(repayment.data)
model.variables <- data.frame(as.matrix(sapply(imp.data[features], as.numeric)))
comb.data <- cbind(label, model.variables)

outliers = NULL
for (feature in features){
  predictor <- comb.data[,feature]
  outliers[[feature]] <- which((predictor - mean(predictor))/sd(predictor) > 2)
}

ui <- fluidPage(
  selectInput(inputId = 'variable', 
              label = "Choose a variable", 
              choices = features),
  plotOutput("scatterplot")
)

server <- function(input, output) {
  output$scatterplot <- renderPlot({ 
    predictor <- comb.data[,input$variable]
    outliers <- which(abs(predictor - mean(predictor))/sd(predictor) > 2)
    if (length(outliers) == 0){
      plot(label ~ predictor, 
           xlab = "Variable of Interest", 
           ylab = '3-Yr Default Rate',
           cex = 0.3) 
    }else{
      plot(label[-outliers] ~ predictor[-outliers], 
                                          xlab = "Variable of Interest", 
                                          ylab = '3-Yr Default Rate',
                                          cex = 0.3) 
      }
    })
}

shinyApp(server=server, ui=ui)

