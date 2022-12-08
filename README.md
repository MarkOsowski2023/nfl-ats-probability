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
Four different supervised learning classification models were used since our target has three known categories -- win, lose or push. The models used are ***Logistic Regression, Stochastic Gradient Descent (SGD), K-Nearest Neighbors and Random Forest***.

To test each model, a function was created to train the X and y data and then fit and predict it. The function also printed out the train and test scores, Cohen's Kappa as well as the confusion matrix and classification reports.

Next, a pipeline was created to use for each model. The pipeline was first divided into numeric and categorical features and the columns were transformed.

### Logistic Regression
**Results**
- Train Score: 0.8139
- Test Score: 0.7989
- Cohen's Kappa: 0.6082


### Stochastic Gradient Descent (SGD)
Stochastic is defined as randomly determined or having a random probability distribution. As a gradient descent model is running, it tweaks the parameters of the model iteratively. So a SGD model is taking a random samples for each iteration instead of using the whole dataset. It finds the optimal solution while minimizing the cost function.

**Results**
- Train Score: 0.8076
- Test Score: 0.7847
- Cohen's Kappa: 0.5803

### K-Nearest Neighbors
Initially, this model was run with the default number of neighbors (5).

**Initial Results**
- Train Score: 0.8395
- Test Score: 0.7647
- Cohen's Kappa: 0.5428

After getting the results, the model was then optimized by looping through the odd numbers between 1 and 40 to test each number as the number of neighbors for the model. The results were also plotted using Matplotlib.

![The train and test scores of the number of neighbors plotted to determine the best k-nearest neighbor](/Images/kneighbors.png)

The number of neighbors (or the variable k) that had the highest test score was 27, so this is the number of neighbors defined in the second iteration of the model. The optimized results returned a lower train score, but a higher test score and Cohen's Kappa, which means the model ***did*** improve.


**Optimized Results**
- Train Score: 0.8084
- Test Score: 0.7979
- Cohen's Kappa: 0.6062

The results of the model for each class was then plotted on a Receiver Operating Characteristic/Area Under the Curve (ROC/AUC) graph. The strongest performing classes were lose and win. The more the lines pull towards the top left of the graph means there are more true positives, so model is performing more accurately.

![The Receiver Operating Characteristic/Area Under the Curve plot for the k-nearest neighbor classifier. Displays ROC of the lose, push, and win classes as well as the micro-average ROC curve, AUC and macro-average ROC curve, AUC](/Images/kneighbors_rocauc.png)

### Random Forest
**Results**
- Train Score: 1.0
- Test Score: 0.8015
- Cohen's Kappa: 0.6131

## Conclusions
1. All the models used provided similar results, which indicates that the correct statistics were used to predict the spread outcomes.
2. Vegas has a significant advantage when it comes to betting on teams.
   - In order to be profitable (assuming a -110 vig & the same unit is bet on each game), one has to win 52.4% of bets placed
   - The vast majority of teams cover between 40%-60% of the time, giving no real advantage
3. The expected accuracy of the model was 48.7% and the observed accuracy of the model is ***79%***

## Visualizations
### [Tableau](https://public.tableau.com/app/profile/henry7314/viz/NFLATSData/Story1#1)

### RStudio Interesting Observations
![NFL teams cover percentage against the spread.](/Images/team_win_percentage_ats.png)

![Tom Brady win percentage against the spread vs. offensive expected points added.](/Images/tom_brady_off_epa.png)

![Win percentage against the spread vs. defensive expected points added.](/Images/win_percentage_ats_and_def_epa.png)

![Win percentage against the spread vs. offensive expected points added.](/Images/win_percentage_ats_and_epa.png)

![NFL teams win against the spread.](/Images/wins_against_the_spread.png)
