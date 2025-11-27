IMPORTANT: to view the Rmarkdown report of the project, download the .html file and open it.
# Kidney stone classification project
## Project overview
The goal of this project is to develop a classification model capable of distinguishing between patients with kidney stones and those without, based on several urinary chemical features. The analysis is carried out in R and includes data cleaning, exploratory data analysis, dimensionality reduction, regression analysis, and the development of a K-Nearest Neighbors (KNN) classifier.
## Materials and methods
### Data
The data used for this project comes from the [Kidney Stone Prediction dataset](https://www.kaggle.com/datasets/vuppalaadithyasairam/kidney-stone-prediction-based-on-urine-analysis), available on Kaggle. This dataset contains 79 entries which describe urine samples collected from patients through a number of features:
* Specific Gravity: density of urine relative to water
* pH: negative logarithm of hydrogen ion concentration
* Osmolarity (mOsm): measure proportional to the concentration of dissolved molecules
* Conductivity (mMho): proportional to the concentration of charged ions
* Urea Concentration (mmol/L)
* Calcium Concentration (mmol/L)
* Target: presence or absence of kidney stones
### Methods
The analysis was performed in R following these steps:
* Data Cleaning: handling missing values, removing outliers, and converting variables to appropriate data types
* Exploratory Data Analysis: examining distributions and correlations to identify underlying patterns
* Dimensionality Reduction: applying Principal Component Analysis (PCA) and selecting variables explaining a relevant portion of total variance
* Linear Modeling: evaluating the presence of a linear relationship between the selected variables
* Classification: building a KNN model using the simplified dataset, testing different values of k, and evaluating performance metrics
## Results
A KNN model was successfully implemented; however, its performance metrics were suboptimal, likely due to the limited size of the dataset (n = 79). In particular, the model achieved good specificity but low sensitivity, indicating difficulty in detecting positive (stone-present) cases.

While the current results are inconclusive, the model may benefit significantly from additional data. With more samples, retraining could lead to improved predictive performance, making the approach more suitable for potential clinical applications.
