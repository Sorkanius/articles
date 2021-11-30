



## Introduction

The analysis will try to answer the following questions:

* Which weapon am I better with?
* Does the distance affect the number of bots I am able to shoot down?
* Am I actually better with a weapon at close distance and with a different one at a further distance?
* As the rounds progressed, was I actually getting better?

## Experiment Set Up

The experiment set up was the following:

In the range, 30 bots were configured. They were static and had armor on (150 HP). The difficulty set was **medium**.

The shots were fired at two different distances labeled as "close" and "long". Shown in the pictures below: 

<img src="imgs/vandal_close.png" alt="drawing" width="400"/>
*Close distance*

<img src="imgs/sheriff_long.png" alt="drawing" width="400"/>
*Long distance*


Three different weapons were used: Sheriff, Phantom and Vandal.

For each configuration, ten measurements were taken, thus: `3 weapons x 2 distances x 10 measurements = 60 samples`. The order was randomized in order to reduce bias.

## Plotting the Data

Here is a plot of the distribution of downed bots per distance and weapon:

![downed bots distribution](imgs/distribution.png "Bots downed per weapon and distance")*Distribution of downed bots in different configurations* 

It can be observed that there are differences between close distance and long distance. Also the vandal has produced better results than the other two weapons. Later, it will be checked if these differences are in fact statistically significant and if they are, they will be quantified.

Now, another interesting point to check is the interaction between weapons and distance. In order words, am I better with a weapon at close distance and better with other at long distance? Or, does my accuracy decrease less with one weapon than with other one? The following plot shoes these differences and tries to answer the question visually:

![downed bots interaction](imgs/interaction.png "Interaction between weapon and distance")*Interaction between weapon and distance*

Again, in a different way, the decrease of number of bots downed at long distance can be seen. There seems to be a little bit of interaction between distance and the weapon type, specially seen with the phantom, which produced better results at closer distance than with the sheriff but at long distance both weapons performed fairly similar. This interaction will be later checked for statistical significance.

![downed bots evolution](imgs/evolution.png "Evolution of downed bots")*Evolution of downed bots as samples were collected*

## Analysis

Two-way ANCOVA (Analysis of Covariance) will be used for the analysis of the interaction between the weapon and distance. If the F-test associated with the ANCOVA yields a significant p-value (the alpha level that will be used is `0.05`) the analysis will be followed with a Tukey Honest Significance Difference test (Tukey HSD), this way the differences for each comparison will be quantified. The index of the round will also be included in the model, to remove the effect of getting better as more rounds were collected.

Using R the model is built as:

## Conclusions
