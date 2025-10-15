## 1. Install [Anaconda](https://www.anaconda.com/download) Python distribution
## 2. Create a separate environment to run the notebooks
- Create environment from environment.yaml file:<br><br>
        ```
        conda env create -f environment.yml
        ```
<br><br>
- Create environment from explicit.txt file:<br><br>
        ```
        conda create -n scs --file explicit.txt
        ```
<br><br>You can find more information how to manage conda environments [here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).
## 3. Change your working environment to the new environment 
<br>

        conda activate scs
