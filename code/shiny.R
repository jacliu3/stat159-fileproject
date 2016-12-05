library(shiny)
library(ggplot2)
library(stringr)

load("../data/fitted-gbm.Rdata")
load("../data/imputed.Rdata")
load("../data/repayment.Rdata")
features <- c("COUNT_NWNE_P10","MN_EARN_WNE_P10","COUNT_WNE_INDEP0_P10","COUNT_WNE_INDEP0_INC1_P10","D150_4_POOLED","PCTFLOAN","DEBT_MDN","DEBT_N","DEP_DEBT_N","LOAN_EVER")
model.label <- as.numeric(repayment.data)
model.variables <- data.frame(as.matrix(sapply(imp.data[features], as.numeric)))
comb.data <- cbind(model.label, model.variables)

choices <- c(features, "RESULT")
ui <- fluidPage(
  selectInput(inputId = 'variable', 
              label = "Choose a variable", 
              choices = choices),
  plotOutput("scatterplot")
)

server <- function(input, output) {
  output$scatterplot <- renderPlot({ 
    #Plot Observed vs Predicted Value
    if (input$variable == "RESULT"){
      plot(pred, label, ylab = "Observed", xlab = "Predicted")
      abline(a = 0, b = 1, col = "blue") 
    }else{
      #Plot CDR3 vs selected predictor
      predictor <- comb.data[,input$variable]
      outliers <- which(abs(predictor - mean(predictor))/sd(predictor) > 2)
      #If there's no outliers, plot the whole data set
      if (length(outliers) == 0){
        plot(model.label ~ predictor, 
             xlab = "Variable of Interest", 
             ylab = '3-Yr Default Rate',
             cex = 0.3) 
      }else{
          #Remove outliers from the plot
          plot(model.label[-outliers] ~ predictor[-outliers], 
                                            xlab = "Variable of Interest", 
                                            ylab = '3-Yr Default Rate',
                                            cex = 0.3)
      }
    }
  })
}

shinyApp(server=server, ui=ui)

