# NFL Against the Spread Probability
***Henry Cutler, Kirsten Larson, Mark Osowski***

## Project Proposal
Our goal for Project 4 is to create a model that will predict whether or not an NFL team will cover a point spread in a given game, and then predict the specific probability of said team covering. We will do this by first collecting data from [nflreadr](https://nflreadr.nflverse.com/index.html), which hosts a number of dictionaries containing NFL statistics, cleaning the data into the necessary columns & values in RStudio as well as Pandas and then using Scikit-learn to train and model our data. Finally, we will present our results in a [slide deck](https://docs.google.com/presentation/d/1VqqjBqVliihmtLDAlVMV9Fx3lxCcxsOfNl1XN46MVhA/edit#slide=id.g1a681e807a9_0_0) to show our data, thought processes, results and conclusions. Our visuals will be made using [Tableau](https://public.tableau.com/app/profile/henry7314/viz/NFLATSData/Story1#1), RStudio, Matplotlib, and Yellowbrick.

## [nflreadr](https://nflreadr.nflverse.com/index.html)
nflreadr is a download package containing data from multiple repositories within the nflverse. For this project, two specific dictionaries were used:
1. PBP (or Play by Play)
2. Schedules

## What is a Point Spread?
In simple terms, the **point spread** is the amount of points that a team is expected to win or lose by for the purposes of placing bets. When comparing the results of the game **against the spread (or ATS)**, there are three outcomes -- win, lose, or push. For example, ...

## Data Cleaning

## Classification Models
Four different classification models were used since our target has three different categories -- win, lose or push.

### Linear Regression
### Stochastic Gradient Descent (SGD)
### K-Nearest Neighbors
### Random Forest

## Visualizations
### [Tableau](https://public.tableau.com/app/profile/henry7314/viz/NFLATSData/Story1#1)

### RStudio
![NFL teams cover percentage against the spread.](/Images/team_win_percentage_ats.png)

![Tom Brady win percentage against the spread vs. offensive expected points added.](/Images/tom_brady_off_epa.png)

![Win percentage against the spread vs. defensive expected points added.](/Images/win_percentage_ats_and_def_epa.png)

![Win percentage against the spread vs. offensive expected points added.](/Images/win_percentage_ats_and_epa.png)

![NFL teams win against the spread.](/Images/wins_against_the_spread.png)

### Matplotlib

![The train and test scores of the number of neighbors plotted to determine the best k-nearest neighbor](/Images/kneighbors.png)

### Yellowbrick

![The Receiver Operating Characteristic/Area Under the Curve plot for the k-nearest neighbor classifier. Displays ROC of the lose, push, and win classes as well as the micro-average ROC curve, AUC and macro-average ROC curve, AUC](/Images/kneighbors_rocauc.png)

## Conclusions
