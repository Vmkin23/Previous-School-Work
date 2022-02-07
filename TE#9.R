library(tidyverse)
library(moderndive)
# Complete LC 7.1 and LC 7.2. Create histograms consistent with Figure 7.9. 
# Put your findings into a single file and upload for grading. 

tactile_prop_red

ggplot(tactile_prop_red, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 50 balls that were red",
       title = "Distribution of 33 proportions red")

# 7.1 It's important to mix the bowl to allow everyone to have the same
# sample to draw from. It would affect the outcome and skew the results
# for any draw beyond the first one.

# 7.2 Because sampling is chaotic and random like that! But everyone's
# sample was different and we need many different samples to get to 
# a close answer.

bowl

# segment 1 - sample size = 25
# 1a using the shovel 1000 times
virtual_samples_25 <- bowl %>%
  rep_sample_n(size = 25, reps = 1000)

#1b compute the resulting 1000 replicates of proportion red
virtual_prop_red_25 <- virtual_samples_25 %>%
  group_by(replicate) %>%
  summarise(red = sum(color == "red")) %>%
  mutate(prop_red = red/25)

#1c plotting this distribution via histogram

ggplot(virtual_prop_red_25, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 25 balls that were red", title = "25")

# now imma just copy and paste and change it out for 50 & 100 respectively
# 50
virtual_samples_50 <- bowl %>%
  rep_sample_n(size = 50, reps = 1000)

virtual_prop_red_50 <- virtual_samples_50 %>%
  group_by(replicate) %>%
  summarise(red = sum(color == "red")) %>%
  mutate(prop_red = red/50)

ggplot(virtual_prop_red_50, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 50 balls that were red", title = "50")

#100
virtual_samples_100 <- bowl %>%
  rep_sample_n(size = 100, reps = 1000)

virtual_prop_red_100 <- virtual_samples_100 %>%
  group_by(replicate) %>%
  summarise(red = sum(color == "red")) %>%
  mutate(prop_red = red/100)

ggplot(virtual_prop_red_100, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 100 balls that were red", title = "100")

#now we gotta have them all side by side

par(mfrow = c(1,2))
ggplot(virtual_prop_red_25, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 25 balls that were red", title = "25")
ggplot(virtual_prop_red_50, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 50 balls that were red", title = "50")
ggplot(virtual_prop_red_100, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of 100 balls that were red", title = "100")
par(mfrow = c(1,2))





