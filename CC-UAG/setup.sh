#!/bin/bash

clear

sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-key update
sudo apt-get update
sudo apt-get --assume-yes install default-jdk
sudo apt-get --assume-yes install r-base-core r-base r-base-dev
wget http://cran.us.r-project.org/src/contrib/rJava_0.9-8.tar.gz
wget http://cran.us.r-project.org/src/contrib/fpp_0.5.tar.gz
wget http://cran.us.r-project.org/src/contrib/fma_2.2.tar.gz
wget http://cran.us.r-project.org/src/contrib/forecast_7.2.tar.gz
wget http://cran.us.r-project.org/src/contrib/expsmooth_2.3.tar.gz
wget http://cran.us.r-project.org/src/contrib/lmtest_0.9-34.tar.gz
wget http://cran.us.r-project.org/src/contrib/tseries_0.10-35.tar.gz
wget http://cran.us.r-project.org/src/contrib/zoo_1.7-13.tar.gz
wget http://cran.us.r-project.org/src/contrib/quadprog_1.5-5.tar.gz
wget http://cran.us.r-project.org/src/contrib/timeDate_3012.100.tar.gz
wget http://cran.us.r-project.org/src/contrib/fracdiff_1.4-2.tar.gz
wget http://cran.us.r-project.org/src/contrib/Rcpp_0.12.7.tar.gz
wget http://cran.us.r-project.org/src/contrib/colorspace_1.2-6.tar.gz
wget http://cran.us.r-project.org/src/contrib/RcppArmadillo_0.7.400.2.0.tar.gz
wget http://cran.us.r-project.org/src/contrib/ggplot2_2.1.0.tar.gz
wget http://cran.us.r-project.org/src/contrib/digest_0.6.10.tar.gz
wget http://cran.us.r-project.org/src/contrib/gtable_0.2.0.tar.gz
wget http://cran.us.r-project.org/src/contrib/plyr_1.8.4.tar.gz
wget http://cran.us.r-project.org/src/contrib/reshape2_1.4.1.tar.gz
wget http://cran.us.r-project.org/src/contrib/stringr_1.1.0.tar.gz
wget http://cran.us.r-project.org/src/contrib/scales_0.4.0.tar.gz
wget http://cran.us.r-project.org/src/contrib/stringi_1.1.1.tar.gz
wget http://cran.us.r-project.org/src/contrib/magrittr_1.5.tar.gz
wget http://cran.us.r-project.org/src/contrib/RColorBrewer_1.1-2.tar.gz
wget http://cran.us.r-project.org/src/contrib/dichromat_2.0-0.tar.gz
wget http://cran.us.r-project.org/src/contrib/munsell_0.4.3.tar.gz
wget http://cran.us.r-project.org/src/contrib/labeling_0.3.tar.gz
sudo R CMD INSTALL rJava_0.9-8.tar.gz
sudo R CMD INSTALL zoo_1.7-13.tar.gz
sudo R CMD INSTALL lmtest_0.9-34.tar.gz
sudo R CMD INSTALL quadprog_1.5-5.tar.gz
sudo R CMD INSTALL tseries_0.10-35.tar.gz
sudo R CMD INSTALL timeDate_3012.100.tar.gz
sudo R CMD INSTALL fracdiff_1.4-2.tar.gz
sudo R CMD INSTALL Rcpp_0.12.7.tar.gz
sudo R CMD INSTALL colorspace_1.2-6.tar.gz
sudo R CMD INSTALL RcppArmadillo_0.7.400.2.0.tar.gz
sudo R CMD INSTALL digest_0.6.10.tar.gz
sudo R CMD INSTALL gtable_0.2.0.tar.gz
sudo R CMD INSTALL plyr_1.8.4.tar.gz
sudo R CMD INSTALL stringi_1.1.1.tar.gz
sudo R CMD INSTALL magrittr_1.5.tar.gz
sudo R CMD INSTALL RColorBrewer_1.1-2.tar.gz
sudo R CMD INSTALL dichromat_2.0-0.tar.gz
sudo R CMD INSTALL munsell_0.4.3.tar.gz
sudo R CMD INSTALL labeling_0.3.tar.gz
sudo R CMD INSTALL scales_0.4.0.tar.gz
sudo R CMD INSTALL stringr_1.1.0.tar.gz
sudo R CMD INSTALL reshape2_1.4.1.tar.gz
sudo R CMD INSTALL ggplot2_2.1.0.tar.gz
sudo R CMD INSTALL forecast_7.2.tar.gz
sudo R CMD INSTALL expsmooth_2.3.tar.gz
sudo R CMD INSTALL fma_2.2.tar.gz
sudo R CMD INSTALL fpp_0.5.tar.gz
sudo R CMD javareconf
sudo rm *.tar.gz
export R_HOME="$(find /usr/lib/R | grep INSTALL | head -1 | cut -d 'R' -f1 && sudo find /usr/local/lib/R | grep INSTALL | head -1 | cut -d 'R' -f1)R"
export CLASSPATH=".:$(find /usr/lib/R | grep jri | head -1 && sudo find /usr/local/lib/R | grep jri | head -1)"
export LD_LIBRARY_PATH="$(find /usr/lib/R | grep jri | head -1 && sudo find /usr/local/lib/R | grep jri | head -1)"
sudo echo "java -Djava.library.path=$(find /usr/lib/R | grep jri | head -1 && sudo find /usr/local/lib/R | grep jri | head -1) -jar dist/ProjetoTCC_rJava.jar" > CC-UAG.sh
sudo chmod +x CC-UAG.sh
