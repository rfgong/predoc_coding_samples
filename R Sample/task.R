## ----setup, include=FALSE-----------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- echo=FALSE, warning=FALSE-----------------------------
library(pacman)
p_load("tidyverse", "stargazer", "ggplot2", "gridExtra", "ivpack")
df <- read.csv("project2020_dd.csv")
df_male <- df[df$female == 0,]
df_fem <- df[df$female == 1,]


## ---- echo=FALSE, warning=FALSE, results="asis"-------------
# Table 1
chars <- c("educ", "age", "y", "owage2", "exp", "female")
all_means <- apply(select(df, all_of(chars)), 2, mean)
male_means <- apply(select(df_male, all_of(chars)), 2, mean)
fem_means <- apply(select(df_fem, all_of(chars)), 2, mean)
t_stat <- c(round(t.test(df_male$educ, df_fem$educ)$statistic, 3), 
            round(t.test(df_male$age, df_fem$age)$statistic, 3), 
            round(t.test(df_male$y, df_fem$y)$statistic, 3), 
            round(t.test(df_male$owage2, df_fem$owage2)$statistic, 3),
            round(t.test(df_male$exp, df_fem$exp)$statistic, 3),
            NaN)
tab1 <- data.frame(all_means, male_means, fem_means, t_stat)
colnames(tab1) <- c("All Mean","Male Mean","Female Mean", "T-Stat Diff.")
rownames(tab1) <- chars
stargazer(tab1, type="latex",style="qje", title="Mean Characteristics", summary=FALSE, header=FALSE, digits=3, table.layout = ("llll"))
# Fractions in education groups
all_educ_frac <- c(sum(df$educ == 6), sum(df$educ == 9), sum(df$educ == 12), sum(df$educ == 16)) / length(df$educ)
male_educ_frac <- c(sum(df_male$educ == 6), sum(df_male$educ == 9), sum(df_male$educ == 12), sum(df_male$educ == 16)) / length(df_male$educ)
fem_educ_frac <- c(sum(df_fem$educ == 6), sum(df_fem$educ == 9), sum(df_fem$educ == 12), sum(df_fem$educ == 16)) / length(df_fem$educ)
totals <- c(sum(all_educ_frac), sum(male_educ_frac), sum(fem_educ_frac))
tab1_a <- data.frame(all_educ_frac, male_educ_frac, fem_educ_frac)
tab1_a <- rbind(tab1_a, totals)
colnames(tab1_a) <- c("All Frac.","Male Frac.","Female Frac.")
rownames(tab1_a) <- c("educ 6", "educ 9", "educ 12", "educ 16", "Sum")
stargazer(tab1_a, type="latex",style="qje", title="Education Distribution", summary=FALSE, header=FALSE, digits=3, table.layout = ("llll"))
# Fraction in overall wage quartiles
quartiles <- quantile(df$y)
all_y_frac <- c(sum((df$y >= quartiles[1]) & (df$y < quartiles[2])),
                sum((df$y >= quartiles[2]) & (df$y < quartiles[3])), 
                sum((df$y >= quartiles[3]) & (df$y < quartiles[4])), 
                sum((df$y >= quartiles[4]) & (df$y < quartiles[5]))) / length(df$y)
male_y_frac <- c(sum((df_male$y >= quartiles[1]) & (df_male$y < quartiles[2])),
                sum((df_male$y >= quartiles[2]) & (df_male$y < quartiles[3])), 
                sum((df_male$y >= quartiles[3]) & (df_male$y < quartiles[4])), 
                sum((df_male$y >= quartiles[4]) & (df_male$y < quartiles[5]))) / length(df_male$y)
fem_y_frac <- c(sum((df_fem$y >= quartiles[1]) & (df_fem$y < quartiles[2])),
                sum((df_fem$y >= quartiles[2]) & (df_fem$y < quartiles[3])), 
                sum((df_fem$y >= quartiles[3]) & (df_fem$y < quartiles[4])), 
                sum((df_fem$y >= quartiles[4]) & (df_fem$y < quartiles[5]))) / length(df_fem$y)
totals <- c(sum(all_y_frac), sum(male_y_frac), sum(fem_y_frac))
tab1_b <- data.frame(all_y_frac, male_y_frac, fem_y_frac)
tab1_b <- rbind(tab1_b, totals)
colnames(tab1_b) <- c("All Frac.","Male Frac.","Female Frac.")
rownames(tab1_b) <- c("Q1 All", "Q2 All", "Q3 All", "Q4 All", "Sum")
stargazer(tab1_b, type="latex",style="qje", title="Wage (y) Distribution", summary=FALSE, header=FALSE, digits=3, table.layout = ("llll"))

## ---- echo=FALSE, warning=FALSE-----------------------------
# Figure 1
df_male$id <- "male"
df_fem$id <- "female"
combined <- rbind(df_male, df_fem)
ggplot(combined, aes(y, fill = id)) + geom_density(alpha = 0.2) + ggtitle("Figure 1")



## ---- echo=FALSE, warning=FALSE, results="asis"-------------
# a)
df$exp2 <- df$exp^2
df$exp3 <- df$exp^3
df_male <- df[df$female == 0,]
df_fem <- df[df$female == 1,]
reg_all_dummy <- lm(y ~ female, data = df)
reg_all_expand <- lm(y ~ educ + exp + exp2 + exp3 + female, data = df)
# b)
reg_men_expand <- lm(y ~ educ + exp + exp2 + exp3, data = df_male)
reg_fem_expand <- lm(y ~ educ + exp + exp2 + exp3, data = df_fem)
stargazer(reg_all_dummy, reg_all_expand, reg_men_expand, reg_fem_expand, type="latex", title="Pooled and Individual Regressions",
          omit.stat=c("LL","ser","f","rsq","adj.rsq"),
          header=FALSE,no.space=TRUE,notes = "(1) and (2) use pooled data. (3) and (4) use male and female data, respectively.")


## ---- echo=FALSE--------------------------------------------
# Male variable means
male_means <-c(mean(df_male$y), mean(df_male$educ), mean(df_male$exp), mean(df_male$exp2), mean(df_male$exp3))
names(male_means) <- c("y", "educ", "exp", "exp2", "exp3")

## ---- echo=FALSE--------------------------------------------
# Female variable means
fem_means <-c(mean(df_fem$y), mean(df_fem$educ), mean(df_fem$exp), mean(df_fem$exp2), mean(df_fem$exp3))
names(fem_means) <- c("y", "educ", "exp", "exp2", "exp3")

## ---- echo=FALSE--------------------------------------------
diff <- reg_all_dummy$coefficients["female"]


## ---- echo=FALSE--------------------------------------------
pool_explained <- reg_all_expand$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_all_expand$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_all_expand$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_all_expand$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"])


## ---- echo=FALSE--------------------------------------------
pool_unexplained <- reg_all_expand$coefficients["female"]


## ---- echo=FALSE--------------------------------------------
mret_explained <- reg_men_expand$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_men_expand$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_men_expand$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_men_expand$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"])


## ---- echo=FALSE--------------------------------------------
mret_returns <- fem_means["educ"] * (reg_fem_expand$coefficients["educ"] - reg_men_expand$coefficients["educ"]) + 
  fem_means["exp"] * (reg_fem_expand$coefficients["exp"] - reg_men_expand$coefficients["exp"]) + 
  fem_means["exp2"] * (reg_fem_expand$coefficients["exp2"] - reg_men_expand$coefficients["exp2"]) + 
  fem_means["exp3"] * (reg_fem_expand$coefficients["exp3"] - reg_men_expand$coefficients["exp3"])


## ---- echo=FALSE--------------------------------------------
fret_explained <- reg_fem_expand$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_fem_expand$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_fem_expand$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_fem_expand$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"])


## ---- echo=FALSE--------------------------------------------
fret_returns <- male_means["educ"] * (reg_fem_expand$coefficients["educ"] - reg_men_expand$coefficients["educ"]) + 
  male_means["exp"] * (reg_fem_expand$coefficients["exp"] - reg_men_expand$coefficients["exp"]) + 
  male_means["exp2"] * (reg_fem_expand$coefficients["exp2"] - reg_men_expand$coefficients["exp2"]) + 
  male_means["exp3"] * (reg_fem_expand$coefficients["exp3"] - reg_men_expand$coefficients["exp3"])


## ---- echo=FALSE--------------------------------------------
constant <- reg_fem_expand$coefficients["(Intercept)"] - reg_men_expand$coefficients["(Intercept)"]


## ---- echo=FALSE, warning=FALSE, results="asis"-------------
# a)
reg_all_dummy_2 <- lm(y ~ female + owage2, data = df)
reg_all_expand_2 <- lm(y ~ educ + exp + exp2 + exp3 + female + owage2, data = df)
# b)
reg_men_expand_2 <- lm(y ~ educ + exp + exp2 + exp3 + owage2, data = df_male)
reg_fem_expand_2 <- lm(y ~ educ + exp + exp2 + exp3 + owage2, data = df_fem)
stargazer(reg_all_dummy_2, reg_all_expand_2, reg_men_expand_2, reg_fem_expand_2, type="latex", title="Pooled and Individual Regressions",
          omit.stat=c("LL","ser","f","rsq","adj.rsq"),
          header=FALSE,no.space=TRUE,notes = "(1) and (2) use pooled data. (3) and (4) use male and female data, respectively.")


## ---- echo=FALSE--------------------------------------------
# Male variable means
male_means <-c(mean(df_male$y), mean(df_male$educ), mean(df_male$exp), mean(df_male$exp2), mean(df_male$exp3), mean(df_male$owage2))
names(male_means) <- c("y", "educ", "exp", "exp2", "exp3", "owage2")

## ---- echo=FALSE--------------------------------------------
# Female variable means
fem_means <-c(mean(df_fem$y), mean(df_fem$educ), mean(df_fem$exp), mean(df_fem$exp2), mean(df_fem$exp3), mean(df_fem$owage2))
names(fem_means) <- c("y", "educ", "exp", "exp2", "exp3", "owage2")


## ---- echo=FALSE--------------------------------------------
pool_explained <- reg_all_expand_2$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_all_expand_2$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_all_expand_2$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_all_expand_2$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"]) + 
  reg_all_expand_2$coefficients["owage2"] * (fem_means["owage2"] - male_means["owage2"])


## ---- echo=FALSE--------------------------------------------
pool_unexplained <- reg_all_expand_2$coefficients["female"]


## ---- echo=FALSE--------------------------------------------
mret_explained <- reg_men_expand_2$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_men_expand_2$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_men_expand_2$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_men_expand_2$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"]) + 
  reg_men_expand_2$coefficients["owage2"] * (fem_means["owage2"] - male_means["owage2"])


## ---- echo=FALSE--------------------------------------------
mret_returns <- fem_means["educ"] * (reg_fem_expand_2$coefficients["educ"] - reg_men_expand_2$coefficients["educ"]) + 
  fem_means["exp"] * (reg_fem_expand_2$coefficients["exp"] - reg_men_expand_2$coefficients["exp"]) + 
  fem_means["exp2"] * (reg_fem_expand_2$coefficients["exp2"] - reg_men_expand_2$coefficients["exp2"]) + 
  fem_means["exp3"] * (reg_fem_expand_2$coefficients["exp3"] - reg_men_expand_2$coefficients["exp3"]) + 
  fem_means["owage2"] * (reg_fem_expand_2$coefficients["owage2"] - reg_men_expand_2$coefficients["owage2"])


## ---- echo=FALSE--------------------------------------------
fret_explained <- reg_fem_expand_2$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_fem_expand_2$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_fem_expand_2$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_fem_expand_2$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"]) + 
  reg_fem_expand_2$coefficients["owage2"] * (fem_means["owage2"] - male_means["owage2"])


## ---- echo=FALSE--------------------------------------------
fret_returns <- male_means["educ"] * (reg_fem_expand_2$coefficients["educ"] - reg_men_expand_2$coefficients["educ"]) + 
  male_means["exp"] * (reg_fem_expand_2$coefficients["exp"] - reg_men_expand_2$coefficients["exp"]) + 
  male_means["exp2"] * (reg_fem_expand_2$coefficients["exp2"] - reg_men_expand_2$coefficients["exp2"]) + 
  male_means["exp3"] * (reg_fem_expand_2$coefficients["exp3"] - reg_men_expand_2$coefficients["exp3"]) +  
  male_means["owage2"] * (reg_fem_expand_2$coefficients["owage2"] - reg_men_expand_2$coefficients["owage2"])


## ---- echo=FALSE--------------------------------------------
constant <- reg_fem_expand_2$coefficients["(Intercept)"] - reg_men_expand_2$coefficients["(Intercept)"]


## ---- echo=FALSE--------------------------------------------
# a)
terciles_1 <- quantile(df$owage1, c(0, 1/3, 2/3, 3/3))
df$t1_1 <- ifelse(df$owage1 < terciles_1[2], 1, 0)
df$t2_1 <- ifelse(((df$owage1 >= terciles_1[2])) & (df$owage1 < terciles_1[3]), 1, 0)
df$t3_1 <- ifelse((df$owage1 >= terciles_1[3]), 1, 0)
terciles_2 <- quantile(df$owage2, c(0, 1/3, 2/3, 3/3))
df$t1_2 <- ifelse(df$owage2 < terciles_2[2], 1, 0)
df$t2_2 <- ifelse(((df$owage2 >= terciles_2[2])) & (df$owage2 < terciles_2[3]), 1, 0)
df$t3_2 <- ifelse((df$owage2 >= terciles_2[3]), 1, 0)
df$g1 <- df$t1_1  * df$t1_2
df$g2 <- df$t1_1  * df$t2_2
df$g3 <- df$t1_1  * df$t3_2
df$g4 <- df$t2_1  * df$t1_2
df$g5 <- df$t2_1  * df$t2_2
df$g6 <- df$t2_1  * df$t3_2
df$g7 <- df$t3_1  * df$t1_2
df$g8 <- df$t3_1  * df$t2_2
df$g9 <- df$t3_1  * df$t3_2
x_labels <- c(-3, -2, -1, 0, 1, 2)
# 1 -> 1
temp <- df[df$g1 == 1,]
g1_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g1_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p1 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 1 to Tercile 1") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 1 -> 2
temp <- df[df$g2 == 1,]
g2_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g2_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p2 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 1 to Tercile 2") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 1 -> 3
temp <- df[df$g3 == 1,]
g3_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g3_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p3 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 1 to Tercile 3") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 2 -> 1
temp <- df[df$g4 == 1,]
g4_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g4_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p4 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 2 to Tercile 1") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 2 -> 2
temp <- df[df$g5 == 1,]
g5_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g5_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p5 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 2 to Tercile 2") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 2 -> 3
temp <- df[df$g6 == 1,]
g6_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g6_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p6 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 2 to Tercile 3") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 3 -> 1
temp <- df[df$g7 == 1,]
g7_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g7_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p7 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 3 to Tercile 1") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 3 -> 2
temp <- df[df$g8 == 1,]
g8_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g8_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p8 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 3 to Tercile 2") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
# 3 -> 3
temp <- df[df$g9 == 1,]
g9_mwage <- c(mean(temp$yl3), mean(temp$yl2), mean(temp$yl1), mean(temp$y), mean(temp$yp1), mean(temp$yp2))
temp_df <- data.frame(x_labels, g9_mwage)
colnames(temp_df) <- c("Event_Time","Mean_Wage")
p9 <- ggplot(temp_df, aes(x=Event_Time, y=Mean_Wage)) + geom_point() + ggtitle("Tercile 3 to Tercile 3") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, ncol=3, nrow=3)


## ---- echo=FALSE, warning=FALSE, results="asis"-------------
# Fraction genders in groups
all_g_frac <- c(sum(df$g1 == 1),
                sum(df$g2 == 1),
                sum(df$g3 == 1),
                sum(df$g4 == 1),
                sum(df$g5 == 1),
                sum(df$g6 == 1),
                sum(df$g7 == 1),
                sum(df$g8 == 1),
                sum(df$g9 == 1)) / length(df$y)
male_g_frac <- c(sum((df$female == 0) & (df$g1 == 1)),
                sum((df$female == 0) & (df$g2 == 1)), 
                sum((df$female == 0) & (df$g3 == 1)),
                sum((df$female == 0) & (df$g4 == 1)),
                sum((df$female == 0) & (df$g5 == 1)),
                sum((df$female == 0) & (df$g6 == 1)),
                sum((df$female == 0) & (df$g7 == 1)),
                sum((df$female == 0) & (df$g8 == 1)),
                sum((df$female == 0) & (df$g9 == 1))) / length(df_male$y)
fem_g_frac <- c(sum((df$female == 1) & (df$g1 == 1)),
                sum((df$female == 1) & (df$g2 == 1)), 
                sum((df$female == 1) & (df$g3 == 1)),
                sum((df$female == 1) & (df$g4 == 1)),
                sum((df$female == 1) & (df$g5 == 1)),
                sum((df$female == 1) & (df$g6 == 1)),
                sum((df$female == 1) & (df$g7 == 1)),
                sum((df$female == 1) & (df$g8 == 1)),
                sum((df$female == 1) & (df$g9 == 1))) / length(df_fem$y)
totals <- c(sum(all_g_frac), sum(male_g_frac), sum(fem_g_frac))
tab <- data.frame(all_g_frac, male_g_frac, fem_g_frac)
tab <- rbind(tab, totals)
colnames(tab) <- c("All Frac.","Male Frac.","Female Frac.")
rownames(tab) <- c("T1-T1", "T1-T2", "T1-T3", "T2-T1", "T2-T2", "T2-T3", "T3-T1", "T3-T2", "T3-T3", "Sum")
stargazer(tab, type="latex",style="qje", title="Co-worker Tercile Transitions", summary=FALSE, header=FALSE, digits=3, table.layout = ("llll"))


## ---- echo=FALSE, warning=FALSE, results="asis"-------------
# a)
df$Dy <- df$y - df$yl1
df$Dwage <- df$owage2 - df$owage1
df$expl1 <- df$exp - 1
df$expl1_2 <- df$expl1^2
df_male <- df[df$female == 0,]
df_fem <- df[df$female == 1,]
reg_all_dummy_3 <- lm(Dy ~ female + Dwage, data = df)
reg_all_expand_3 <- lm(Dy ~ expl1 + expl1_2 + female + Dwage, data = df)
# b)
reg_men_expand_3 <- lm(Dy ~ expl1 + expl1_2 + Dwage, data = df_male)
reg_fem_expand_3 <- lm(Dy ~ expl1 + expl1_2 + Dwage, data = df_fem)
stargazer(reg_all_dummy_3, reg_all_expand_3, reg_men_expand_3, reg_fem_expand_3, type="latex", title="Pooled and Individual Regressions",
          omit.stat=c("LL","ser","f","rsq","adj.rsq"),
          header=FALSE,no.space=TRUE,notes = "Dy: y-yl1, (1) and (2) use pooled data. (3) and (4) use male and female data, respectively.")


## ---- echo=FALSE, warning=FALSE, results="asis"-------------
# a)
df$y_pool_adj1 <- df$y - reg_all_dummy_3$coefficients["Dwage"] * df$owage2
df$y_pool_adj2 <- df$y - reg_all_expand_3$coefficients["Dwage"] * df$owage2
df_male <- df[df$female == 0,]
df_fem <- df[df$female == 1,]
df_male$y_male_adj <- df_male$y - reg_men_expand_3$coefficients["Dwage"] * df_male$owage2
df_fem$y_fem_adj <- df_fem$y - reg_fem_expand_3$coefficients["Dwage"] * df_fem$owage2
reg_all_dummy_4 <- lm(y_pool_adj1 ~ female, data = df)
reg_all_expand_4 <- lm(y_pool_adj2 ~ educ + exp + exp2 + exp3 + female, data = df)
# b)
reg_men_expand_4 <- lm(y_male_adj ~ educ + exp + exp2 + exp3, data = df_male)
reg_fem_expand_4 <- lm(y_fem_adj ~ educ + exp + exp2 + exp3, data = df_fem)
stargazer(reg_all_dummy_4, reg_all_expand_4, reg_men_expand_4, reg_fem_expand_4, type="latex", title="Pooled and Individual Modified Regressions",
          omit.stat=c("LL","ser","f","rsq","adj.rsq"),
          header=FALSE,no.space=TRUE,notes = "(1) and (2) use pooled data. (3) and (4) use male and female data, respectively.")


## ---- echo=FALSE--------------------------------------------
pool_explained <- reg_all_expand_4$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_all_expand_4$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_all_expand_4$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_all_expand_4$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"]) + 
  reg_all_expand_3$coefficients["Dwage"] * (fem_means["owage2"] - male_means["owage2"])


## ---- echo=FALSE--------------------------------------------
pool_unexplained <- reg_all_expand_4$coefficients["female"]


## ---- echo=FALSE--------------------------------------------
mret_explained <- reg_men_expand_4$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_men_expand_4$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_men_expand_4$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_men_expand_4$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"]) + 
  reg_men_expand_3$coefficients["Dwage"] * (fem_means["owage2"] - male_means["owage2"])


## ---- echo=FALSE--------------------------------------------
mret_returns <- fem_means["educ"] * (reg_fem_expand_4$coefficients["educ"] - reg_men_expand_4$coefficients["educ"]) + 
  fem_means["exp"] * (reg_fem_expand_4$coefficients["exp"] - reg_men_expand_4$coefficients["exp"]) + 
  fem_means["exp2"] * (reg_fem_expand_4$coefficients["exp2"] - reg_men_expand_4$coefficients["exp2"]) + 
  fem_means["exp3"] * (reg_fem_expand_4$coefficients["exp3"] - reg_men_expand_4$coefficients["exp3"]) + 
  fem_means["owage2"] * (reg_fem_expand_3$coefficients["Dwage"] - reg_men_expand_3$coefficients["Dwage"])


## ---- echo=FALSE--------------------------------------------
fret_explained <- reg_fem_expand_4$coefficients["educ"] * (fem_means["educ"] - male_means["educ"]) + 
  reg_fem_expand_4$coefficients["exp"] * (fem_means["exp"] - male_means["exp"]) + 
  reg_fem_expand_4$coefficients["exp2"] * (fem_means["exp2"] - male_means["exp2"]) + 
  reg_fem_expand_4$coefficients["exp3"] * (fem_means["exp3"] - male_means["exp3"]) + 
  reg_fem_expand_3$coefficients["Dwage"] * (fem_means["owage2"] - male_means["owage2"])


## ---- echo=FALSE--------------------------------------------
fret_returns <- male_means["educ"] * (reg_fem_expand_4$coefficients["educ"] - reg_men_expand_4$coefficients["educ"]) + 
  male_means["exp"] * (reg_fem_expand_4$coefficients["exp"] - reg_men_expand_4$coefficients["exp"]) + 
  male_means["exp2"] * (reg_fem_expand_4$coefficients["exp2"] - reg_men_expand_4$coefficients["exp2"]) + 
  male_means["exp3"] * (reg_fem_expand_4$coefficients["exp3"] - reg_men_expand_4$coefficients["exp3"]) +  
  male_means["owage2"] * (reg_fem_expand_3$coefficients["Dwage"] - reg_men_expand_3$coefficients["Dwage"])


## ---- echo=FALSE--------------------------------------------
constant <- reg_fem_expand_4$coefficients["(Intercept)"] - reg_men_expand_4$coefficients["(Intercept)"]


## ---- echo=FALSE, warning=FALSE-----------------------------
df <- read.csv("project2020_rd.csv")
df$x <- df$psu - 475


## ---- echo=FALSE, warning=FALSE-----------------------------
# Figure 3
df$x_binned <- df$x - (df$x %% 5)
mean_rates <- 1:length(unique(df$x_binned))
i <- 1
for (bin in unique(df$x_binned)) {
  mean_rates[i] = mean(df[df$x_binned == bin,]$entercollege)
  i <- i + 1
}
temp_df <- data.frame(unique(df$x_binned), mean_rates)
colnames(temp_df) <- c("Binned_PSU_Differential","College_Rate")
ggplot(temp_df, aes(x=Binned_PSU_Differential, y=College_Rate)) + geom_point() + ggtitle("Figure 3") + labs(caption = "PSU scores are place into bins of 5, by rounding down to the nearest score divisible by 5.")

## ---- echo=FALSE, warning=FALSE, results= "asis"------------
# Table 5
df$x_binnedXover475 <- df$x_binned * df$over475
df_25 <- df[(df$x_binned >= -25 & df$x_binned <= 25),]
df_50 <- df[(df$x_binned >= -50 & df$x_binned <= 50),]
df_75 <- df[(df$x_binned >= -75 & df$x_binned <= 75),]
df_100 <- df[(df$x_binned >= -100 & df$x_binned <= 100),]
reg25 <- lm(entercollege ~ over475 + x_binned + x_binnedXover475, df_25)
reg50 <- lm(entercollege ~ over475 + x_binned + x_binnedXover475, df_50)
reg75 <- lm(entercollege ~ over475 + x_binned + x_binnedXover475, df_75)
reg100 <- lm(entercollege ~ over475 + x_binned + x_binnedXover475, df_100)
stargazer(reg25, reg50, reg75, reg100, type="latex", title="Binned Regressions for Bandwidths 25, 50, 75, 100",
          omit.stat=c("LL","ser","f","rsq","adj.rsq"),
          header=FALSE,no.space=TRUE)

## ---- echo=FALSE, warning=FALSE-----------------------------
beta <- 5:200
se2 <- 5:200
for (band in 5:200) {
  df_temp <- df[(df$x_binned >= -1 * band) & (df$x_binned <= band),]
  reg_temp <- lm(entercollege ~ over475 + x_binned + x_binnedXover475, df_temp)
  beta[band-4] <- reg_temp$coefficients["over475"]
  se2[band-4] <- summary(reg_temp)$coefficients[[6]] * 2
}
temp_df <- data.frame(5:200, beta, se2)
colnames(temp_df) <- c("bandwidth","beta","se2")
ggplot(temp_df, aes(x=bandwidth, y=beta)) + geom_errorbar(aes(ymin=beta-se2, ymax=beta+se2), width=.1) + geom_point() + ggtitle("Figure 4") + labs(caption = "Integer bandwidths from 5 to 200.")


## ---- echo=FALSE, warning=FALSE, results = "asis"-----------
df$q1 <- as.numeric(df$quintile == 1)
df$q2 <- as.numeric(df$quintile == 2)
df$q3 <- as.numeric(df$quintile == 3)
df$q4 <- as.numeric(df$quintile == 4)
df$gpa_60_70 <- as.numeric((df$gpa >= 60) & (df$gpa <= 70))
df$gpa_50_60 <- as.numeric((df$gpa >= 50) & (df$gpa < 60))
df$gpa_0_50 <- as.numeric(df$gpa < 50)
# Dependent
df$dXq1 <- df$entercollege * df$q1
df$dXq2 <- df$entercollege * df$q2
df$dXq3 <- df$entercollege * df$q3
df$dXq4 <- df$entercollege * df$q4
df$dXfemale <- df$entercollege * df$female
df$dXgpa_60_70 <- df$entercollege * df$gpa_60_70
df$dXgpa_50_60 <- df$entercollege * df$gpa_50_60
df$dXgpa_0_50 <- df$entercollege * df$gpa_0_50
df$dXhimom <- df$entercollege * df$himom
df$dXhidad <- df$entercollege * df$hidad
# Restrict to bandwidth 50
df_50 <- df[(df$x_binned >= -50 & df$x_binned <= 50),]
reg_q1 <-ivreg(dXq1 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_q2 <-ivreg(dXq2 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_q3 <-ivreg(dXq3 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_q4 <-ivreg(dXq4 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_female <-ivreg(dXfemale ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_gpa_60_70 <-ivreg(dXgpa_60_70 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_gpa_50_60 <-ivreg(dXgpa_50_60 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_gpa_0_50 <-ivreg(dXgpa_0_50 ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_himom <-ivreg(dXhimom ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
reg_hidad <-ivreg(dXhidad ~ entercollege + x_binned + x_binnedXover475 | x_binned + x_binnedXover475 + over475, x=TRUE, data=df_50)
means_all <- c(sum(df$q1), sum(df$q2), sum(df$q3), sum(df$q4), sum(df$female), sum(df$gpa_60_70), sum(df$gpa_50_60), sum(df$gpa_0_50), sum(df$himom), sum(df$hidad)) / length(df$x)
means_50 <- c(sum(df_50$q1), sum(df_50$q2), sum(df_50$q3), sum(df_50$q4), sum(df_50$female), sum(df_50$gpa_60_70), sum(df_50$gpa_50_60), sum(df_50$gpa_0_50), sum(df_50$himom), sum(df_50$hidad)) / length(df_50$x)
means_c <- c(reg_q1$coefficients["entercollege"], reg_q2$coefficients["entercollege"], reg_q3$coefficients["entercollege"], reg_q4$coefficients["entercollege"], reg_female$coefficients["entercollege"], reg_gpa_60_70$coefficients["entercollege"], reg_gpa_50_60$coefficients["entercollege"], reg_gpa_0_50$coefficients["entercollege"], reg_himom$coefficients["entercollege"], reg_hidad$coefficients["entercollege"])
ratio <- means_c / means_all
tab6 <- data.frame(means_all, means_50, means_c, ratio)
colnames(tab6) <- c("Full Sample","Bandwith 50 Sample","Compliers", "Ratio")
rownames(tab6) <- c("Share Income Q1", "Share Income Q2", "Share Income Q3", "Share Income Q4", "Share Female", "Share 60<=GPA<=70", "Share 50<=GPA<60", "Share GPA<50", "Share Mom Educ>HS", "Share Dad Educ>HS")
stargazer(tab6, type="latex",style="qje", title="Characteristic Shares", summary=FALSE, header=FALSE, digits=3, table.layout = ("llll"))

