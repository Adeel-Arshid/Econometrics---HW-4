
#Group Name = Adeel Arshid, Safinaz Ali, Victoria Karadimas





load("/Users/adeelarshid/Desktop/acs2017_ny/acs2017_ny_data.RData")





borough_f <- factor((in_Bronx + 2*in_Manhattan + 3*in_StatenI + 4*in_Brooklyn + 5*in_Queens), levels=c(1,2,3,4,5),labels = c("Bronx","Manhattan","Staten Island","Brooklyn","Queens"))

norm_varb <- function(X_in) {
  (X_in - min(X_in, na.rm = TRUE))/( max(X_in, na.rm = TRUE) - min(X_in, na.rm = TRUE) )
}

is.na(FAMSIZE) <- which(FAMSIZE == 9999999)
Fam_cotw <- FAMSIZE + COSTWATR
norm_inc_tot <- norm_varb(INCTOT)
norm_fam_cotw<- norm_varb(Fam_cotw)


data_use_prelim <- data.frame(norm_inc_tot,norm_fam_cotw)
good_obs_data_use <- complete.cases(data_use_prelim,borough_f)
dat_use <- subset(data_use_prelim,good_obs_data_use)
y_use <- subset(borough_f,good_obs_data_use)


set.seed(12345)
NN_obs <- sum(good_obs_data_use == 1)
select1 <- (runif(NN_obs) < 0.8)
train_data <- subset(dat_use,select1)
test_data <- subset(dat_use,(!select1))
cl_data <- y_use[select1]
true_data <- y_use[!select1]


summary(cl_data)

prop.table(summary(cl_data))

summary(train_data)



require(class)
for (indx in seq(1, 9, by= 2)) {
  pred_borough <- knn(train_data, test_data, cl_data, k = indx, l = 0, prob = FALSE, use.all = TRUE)
  num_correct_labels <- sum(pred_borough == true_data)
  correct_rate <- num_correct_labels/length(true_data)
  print(c(indx,correct_rate))
}



cl_data_n <- as.numeric(cl_data)

model_ols1 <- lm(cl_data_n ~ train_data$norm_inc_tot + train_data$norm_fam_cotw)

y_hat <- fitted.values(model_ols1)

mean(y_hat[cl_data_n == 1])

mean(y_hat[cl_data_n == 2])

mean(y_hat[cl_data_n == 3])

mean(y_hat[cl_data_n == 4])

mean(y_hat[cl_data_n == 5])


# maybe try classifying one at a time with OLS

cl_data_n1 <- as.numeric(cl_data_n == 1)
model_ols_v1 <- lm(cl_data_n1 ~ train_data$norm_inc_tot + train_data$norm_fam_cotw)
y_hat_v1 <- fitted.values(model_ols_v1)

mean(y_hat_v1[cl_data_n1 == 1])
mean(y_hat_v1[cl_data_n1 == 0])



is.na(HHINCOME) <- which(HHINCOME == 9999999) 
housing_cost <- FAMSIZE + ROOMS
norm_inc_tot <- norm_varb(INCTOT)
norm_hhincome <- norm_varb(HHINCOME)
norm_household <- norm_varb(HHINCOME)
norm_total_family_inc <- norm_varb(FTOTINC)
norm_famsize <- norm_varb(FAMSIZE)
norm_rooms <- norm_varb(ROOMS)


data_use_prelim <- data.frame(norm_hhincome, norm_famsize,norm_rooms)
good_obs_data_use <- complete.cases(data_use_prelim,borough_f)
dat_use <- subset(data_use_prelim,good_obs_data_use)
y_use <- subset(borough_f,good_obs_data_use)

set.seed(12345)
NN_obs <- sum(good_obs_data_use == 1)
select1 <- (runif(NN_obs) < 0.8)
train_data <- subset(dat_use,select1)
test_data <- subset(dat_use,(!select1))
cl_data <- y_use[select1]
true_data <- y_use[!select1]

summary(cl_data)
prop.table(summary(cl_data))
summary(train_data)


