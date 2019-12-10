library(fpp)
library(stringr)
library(forecast)

#dados <- read.table("/home/paulinho/Downloads/data/paper_01/paper_01-processo-clc.txt", header=TRUE, dec=",") #user says
#dados <- read.table("/home/paulinho/Downloads/data/paper_03/paper_03-foursquared.txt", header=TRUE, dec=",") #user says

metodo_principal <- function(coluna, limite_recurso, frequencia, start_ts, end_ts, horizonte, drift, r_linear, 
                             s_exponential, holt, hw, arima, x_label, y_label){
  
  
  if (file.exists("/tmp/cc_uag")){
    setwd("/tmp/cc_uag")
  }else {
    dir.create("/tmp/cc_uag", showWarnings = FALSE)
    setwd("/tmp/cc_uag")
  }
  
  if(is.null(start_ts) & is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], start = 0, frequency = as.numeric(frequencia)) #user says
  }else if(!is.null(start_ts) & is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], start = as.numeric(start_ts/frequencia), 
               frequency = as.numeric(frequencia)) #user says
  }else if(is.null(start_ts) & !is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], end = as.numeric(end_ts/frequencia), 
               frequency = as.numeric(frequencia)) #user says
  }else if(!is.null(start_ts) & !is.null(end_ts)){
    base <- ts(dados[,as.numeric(coluna)], start = as.numeric(start_ts/frequencia),
               end = as.numeric(end_ts/frequencia), frequency = as.numeric(frequencia)) #user says
  }
  
  
  min_time <- min(time(base))
  max_time <- max(time(base))
  
  treino <- window(base, start = min_time, end = as.numeric(min_time + (((max_time - min_time)/100)*80)))
  teste <- window(base, start = as.numeric(min_time + (((max_time - min_time)/100)*80)), end = max_time)
  
  #numero_linhas <- nrow(dados)
  #min_y <- min(dados[,as.numeric(coluna)],na.rm=TRUE)
  #max_y <- max(dados[,as.numeric(coluna)],na.rm=TRUE)
  
  #plot(base)
  acuracia_mape <- c(100, 100, 100, 100, 100, 100)
  acuracia_mae <- c(100, 100, 100, 100, 100, 100)
  
  #drift
  if(drift){
    fc3 <- rwf(treino, drift = TRUE, h=horizonte)
    
    png(filename = 'drift.png', width = 265, height = 200, units = 'px')
    
    plot(fc3, col="blue", xlab = x_label, ylab = y_label,
         main = "Drift Method")
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Training","Test","Drift"))
    options(scipen = 1000)
    acuracia_mape[1] <- accuracy(fc3)[5]
    acuracia_mae[1] <- accuracy(fc3)[3]
    
    dev.off()
  }
  
  
  
  
  
  
  #regressao linear
  if(r_linear){
    fc7 <- forecast(tslm(treino ~ trend + season), h = horizonte)
    
    png(filename = 'linear_regression.png', width = 265, height = 200, units = 'px')
    
    plot(fc7, col="blue", xlab = x_label, ylab = y_label,
         main = "Linear Regression")
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Training","Test","L. Regression"))
    
    options(scipen = 1000)
    acuracia_mape[2] <- accuracy(fc7)[5]
    acuracia_mae[2] <- accuracy(fc7)[3]
    
    dev.off()
  }
  
  
  
  
  
  #simple exponential
  if(s_exponential){
    fit <- ets(treino, model = "ANN", damped = FALSE)
    fc5 <- forecast(fit, h = horizonte)
    
    png(filename = 'simple_exponential.png', width = 265, height = 200, units = 'px')
    
    plot(fc5, col="blue", xlab = x_label, ylab = y_label,
         main = "Simple Exponential Smoothing Method")
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Training","Test","SES"))
    options(scipen = 1000)
    acuracia_mape[3] <- accuracy(fc5)[5]
    acuracia_mae[3] <- accuracy(fc5)[3]
    
    dev.off()
  }
  
  
  
  
  #holt
  if(holt){
    fit <- ets(treino, model = "AAN", damped = FALSE)
    fc6 <- forecast(fit, h = horizonte)
    
    png(filename = 'holt.png', width = 265, height = 200, units = 'px')
    
    plot(fc6, col="blue", xlab = x_label, ylab = y_label, 
         main = "Holt Method")
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Training","Test","Holt"))
    options(scipen = 1000)
    acuracia_mape[4] <- accuracy(fc6)[5]
    acuracia_mae[4] <- accuracy(fc6)[3]
    
    dev.off()
  }
  
  
  
  
  
  
  #holt-winters
  if(hw){
    fit <- ets(treino, model = "AAA", damped = FALSE)
    fc <- forecast(fit, h = horizonte)
    
    png(filename = 'hw.png', width = 265, height = 200, units = 'px')
    
    plot(fc, col="blue", xlab = x_label, ylab = y_label,
         main = "Holt-Winters Method")
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Training","Test","H-Winters"))
    options(scipen = 1000)
    
    acuracia_mape[5] <- accuracy(fc)[5]
    acuracia_mae[5] <- accuracy(fc)[3]
    
    dev.off()
  }
  
  
  
  
  
  
  #arima
  if(arima){
    fit <- auto.arima(treino)
    m_arima <- forecast(fit, h = horizonte)
    
    png(filename = 'arima.png', width = 265, height = 200, units = 'px')
    
    plot(m_arima, col="blue", xlab = x_label, ylab = y_label,
         main = "ARIMA Method")
    lines(teste, col=34)
    lines(treino, col=24)
    legend("topleft",lty=1,col=c(24,34,"blue"),
           legend=c("Training","Test","ARIMA"))
    options(scipen = 1000)
    
    acuracia_mape[6] <- accuracy(m_arima)[5]
    acuracia_mae[6] <- accuracy(m_arima)[3]
    
    dev.off()
    
  }
  
  
  
  
  if((which.min(acuracia_mape) == 1 | which.min(acuracia_mae) == 1) & drift == TRUE){
    fc3 <- rwf(base, drift = TRUE, h=horizonte)
    
    png(filename = 'best.png', width = 450, height = 350, units = 'px')
    
    plot(fc3, col="blue", xlab = x_label, ylab = y_label, main = "The Highest Accuracy: Drift")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Database", "Drift"))
    
    if(!is.null(limite_recurso)){
      p <- fc3$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc3$mean)[(intersect + 1)]
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    dev.off()
    
  }
  
  if((which.min(acuracia_mape) == 2 | which.min(acuracia_mae) == 2) & r_linear == TRUE){
    fc7 <- forecast(tslm(base ~ trend + season), h = horizonte)
    
    png(filename = 'best.png', width = 450, height = 350, units = 'px')
    
    plot(fc7, col="blue", xlab = x_label, ylab = y_label, main = "The Highest Accuracy: Linear Regression")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Database", "L. Regression"))
    
    if(!is.null(limite_recurso)){
      p <- fc7$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc7$mean)[(intersect + 1)]
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    dev.off()
    
  }
  
  if((which.min(acuracia_mape) == 3 | which.min(acuracia_mae) == 3) & s_exponential == TRUE){
    fit <- ets(base, model = "ANN", damped = FALSE)
    fc5 <- forecast(fit, h = horizonte)
    
    png(filename = 'best.png', width = 450, height = 350, units = 'px')
    
    plot(fc5, col="blue", xlab = x_label, ylab = y_label, main = "The Highest Accuracy: SES")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Database", "SES"))
    
    if(!is.null(limite_recurso)){
      p <- fc5$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc5$mean)[(intersect + 1)]
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    dev.off()
    
  }
  
  if((which.min(acuracia_mape) == 4 | which.min(acuracia_mae) == 4) & holt == TRUE){
    fit <- ets(base, model = "AAN", damped = FALSE)
    fc6 <- forecast(fit, h = horizonte)
    
    png(filename = 'best.png', width = 450, height = 350, units = 'px')
    
    plot(fc6, col="blue", xlab = x_label, ylab = y_label, main = "The Highest Accuracy: Holt")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Database", "Holt"))
    
    if(!is.null(limite_recurso)){
      p <- fc6$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc6$mean)[(intersect + 1)]
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    dev.off()
    
  }
  
  if((which.min(acuracia_mape) == 5 | which.min(acuracia_mae) == 5) & hw == TRUE){
    fit <- ets(base, model = "AAA", damped = FALSE)
    fc <- forecast(fit, h = horizonte)
    
    png(filename = 'best.png', width = 450, height = 350, units = 'px')
    
    plot(fc, col="blue", xlab = x_label, ylab = y_label, main = "The Highest Accuracy: Holt-Winters")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Database", "H.-Winters"))
    
    if(!is.null(limite_recurso)){
      p <- fc$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(fc$mean)[(intersect + 1)]
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    dev.off()
    
  }
  
  if((which.min(acuracia_mape) == 6 | which.min(acuracia_mae) == 6) & arima == TRUE){
    fit <- auto.arima(base)
    m_arima <- forecast(fit, h = horizonte)
    
    png(filename = 'best.png', width = 450, height = 350, units = 'px')
    
    plot(m_arima, col="blue", xlab = x_label, ylab = y_label, main = "The Highest Accuracy: ARIMA")
    lines(base, col="black")
    legend("topleft",lty=1,col=c("black","blue"),
           legend=c("Database", "ARIMA"))
    
    if(!is.null(limite_recurso)){
      p <- m_arima$mean <= limite_recurso
      intersect <- which(diff(p)!=0)
      limiar <- time(m_arima$mean)[(intersect + 1)]
      abline(h = limite_recurso, v = limiar, col="red")
      options(scipen = 1000)
      axis(1, at=limiar,labels = format(round(limiar, 2), nsmall = 2), mgp = c(0, 2, 0))
    }
    dev.off()
  }
  
  #print(acuracia_mape)
  #print(acuracia_mae)
  
  return(which.min(acuracia_mae))
}

