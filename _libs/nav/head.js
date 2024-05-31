const navItems = [
  { name: "Home", href: "/", sections: [], sectionItemWidth: "", id: "home" },
  {
    name: "Data Basics",
    id: "data",
    href: "/info/data",
    sections: [
      {
        name: "Loading and Accessing Data",
        href: "/data/loading/",
        tags: ["Data Processing"],
        ilos: [
            "Understand how to load and access various datasets in R using RDatasets.jl",
            "Learn how to save and load a local dataset in CSV format using CSV.jl"
        ]
      },
      {
        name: "Manipulating Data Frames with DataFrames.jl",
        href: "/data/dataframe/",
        tags: ["Data Processing"],
        ilos: [
        "Learn how to inspect, describe, and convert datasets into the form of Data Frames",
        "Learn how to modify a Data Frame by adding columns and imputing missing values",
        "Familiarize yourself with the groupby and combine operations on Data Frames"
        ]
      },
      {
        name: "Working with Categorical Data",
        href: "/data/categorical/",
        tags: ["Data Processing"],
        ilos: [
         "Understand the different types of categorical data (e.g., nominal and ordinal data) via CategoricalArrays.jl",
         "Learn how to work with and utilize such categorical arrays"
        ]
      },
      {
        name: "Understanding Scientific Types",
        href: "/data/scitype/",
        tags: ["Data Processing"],
        ilos: [
          "Gain a comprehension of the rationale behind having scientific types and their different categories",
          "Learn how to inspect and modify the scientific types in your data using ScientificTypes.jl",
          "Learn about practical tips and tricks related to scientific types"
        ]
      },
      {
        name: "Data Processing and Visualization",
        href: "/data/processing/",
        tags: ["Data Processing"],
        ilos: [
         "Learn how to apply common data processing techniques on a real-world dataset",
         "Learn how to create various plots (e.g., bar charts and histograms) to analyze your data"
        ]
      },
    ],
    sectionItemWidth: "long-item",
  },
  {
    name: "Getting Started",
    id: "getting-started",
    href: "/info/getting-started",
    sections: [
      {
        name: "Preparing data and model with Iris",
        href: "/getting-started/choosing-a-model/",
        tags: ["Classification", "Regression"],
        ilos: [
          "Understand why and how to coerce the data types of different variables in your dataset",
          "Learn how to separate features and targets for training",
          "Be able to find and load the models suitable for your data"
        ]
      },
      {
        name: "Supervised and Unsupervised Workflows in MLJ",
        href: "/getting-started/fit-and-predict/",
        tags: ["Classification", "Encoders"],
        ilos: [
          "Learn how to implement a supervised learning workflow with MLJ",
          "Learn how to implement an unsupervised learning workflow with MLJ",
          "Familiarize yourself with using MLJ's classification and transformation models",
        ]
      },
      {
        name: "Hyperparameter Tuning for Single and Composite Models",
        href: "/getting-started/model-tuning/",
        tags: ["Classification", "Hyperparameter Tuning"],
        ilos: [
          "Learn how to optimize a single hyperparameter of your model",
           "Learn how to tune multiple hyperparameters, that are possibly nested, and visualize the results"
        ]
      },
      {
        name: "Building and Tuning Bagging Ensemble Models",
        href: "/getting-started/ensembles/",
        tags: ["Regression", "Ensemble Models", "Hyperparameter Tuning"],
        ilos: [
          "Understand how to implement bagging ensemble models in MLJ and compare them to atomic models",
          "Learn how to optimize the parameters of bagging ensemble models and visualize the results"
        ]
      },
      {
        name: "Building Random Forests with Bagging Ensembles",
        href: "/getting-started/ensembles-2/",
        tags: ["Regression", "Ensemble Models", "Hyperparameter Tuning"],
        ilos: [
          "Familiarize yourself with dealing with real-world datasets such as the Boston Housing dataset",
          "Understand how to implement Random Forests using bagging over Decision Trees",
          "Learn how to analyze the effect of a specific hyperparameter using MLJ's learning curve",
          "Learn how to tune the parameters of Random Forests"
        ]
      },
      {
        name: "Composing Models and Target Transformations",
        href: "/getting-started/composing-models/",
        tags: ["Regression", "Encoders", "Pipelines"],
        ilos: [
          "Learn how to transform the target of your regression data using MLJ",
          "Understand how to combine models and transformation algorithms in MLJ",
          "Gain an understanding of the benefits of using MLJ pipelines"
        ]
      },
    ],
    sectionItemWidth: "long-item",
  },
  {
    name: "Intro to Stats Learning",
    id: "stats-learning",
    href: "/info/isl",
    sections: [
      {
        name: "Vectors, Matrices and Data Loading in Julia",
        href: "/isl/lab-2/",
        tags: ["Data Processing"],
        ilos : [
          "Understand how to work with vectors and matrices in Julia",
          "Learn about loading and plotting datasets in Julia"
        ]
      },
      { name: "Multivariate Linear Regression & Interactions", 
      href: "/isl/lab-3/", 
      tags: ["Regression"],
      ilos: [
        "Understand how to build single and multivariable linear regression models with MLJ",
        "Learn how to add interaction terms to model nonlinear trends in your data",
        "Learn how to plot regression fits and their residuals"
      ] 
    },
      {
        name: "Logistic Regression & Friends on Stock Market Data",
        href: "/isl/lab-4/",
        tags: ["Classification", "Bayesian Models", "Distribution Fitter"],
        ilos: [
          "Understand how to load and preprocess example datasets from RDatasets.jl",
          "Explore how to train and analyze logistic regression on stock market data",
          "Explore classification-related metrics such as cross-entropy loss, confusion matrix, and area under the ROC curve",
          "Compare logistic regression to various other classifiers such as LDA, QDA, and KNN",
          "Analyze training classification models on imbalanced datasets",
        ]
      },
      {
        name: "Building Polynomial Regression Models and Tuning Them",
        href: "/isl/lab-5/",
        tags: ["Regression", "Feature Selection", "Hyperparameter Tuning"],
        ilos: [
          "Understand how to build a polynomial regression model with MLJ",
          "Learn how to use feature selectors and models in an MLJ pipeline",
          "Analyze and hyperparameter tune polynomial regression models"
        ]
      },
      {
        name: "Ridge & Lasso Regression on Hitters Dataset",
        href: "/isl/lab-6b/",
        tags: ["Regression", "Encoders", "Hyperparameter Tuning"],
        ilos: [
          "Strengthen your data preparation, plotting, and analysis skills",
          "Compare different types of linear regression such as Lasso and Ridge regression",
          "Refresh on hyperparameter tuning and model composition with MLJ "
        ]
      },
      {
        name: "Exploring Tree-based Models",
        href: "/isl/lab-8/",
        tags: ["Iterative Models", "Classification", "Regression", "Hyperparameter Tuning"],
        ilos: [
          "Explore various tree-based models for classification and regression including ordinary decision trees, random forests, and XGBoost",
          "Refresh your skills on hyperparameter tuning and building MLJ pipelines"
        ]
      },
      {
        name: "Building and Tuning a Support Vector Machine",
        href: "/isl/lab-9/",
        tags: ["Classification", "Hyperparameter Tuning"],
        ilos: [
          "Familiarize yourself with generating and visualizing custom classification data",
          "Learn how to build and tune support vector machine (SVM) models with MLJ"
        ]
      },
      {
        name: "Unsupervised Learning with PCA and Clustering ",
        href: "/isl/lab-10/",
        tags: ["Dimensionality Reduction", "Clustering", "Pipelines"],
        ilos: [
          "Learn how to build unsupervised models such as KMeans and PCA in MLJ",
          "Learn how to analyze and visualize results from unsupervised models such as KMeans and PCA"
        ]
      },
    ],
    sectionItemWidth: "long-item",
  },

  {
    name: "End to End",
    id: "end-to-end",
    href: "/info/end-to-end",
    sections: [
      {
        name: "MLJ for Data Scientists in Two Hours",
        href: "/end-to-end/telco/",
        tags: [
          "Classification",
          "Data Processing",
          "Pipelines",
          "Feature Selection",
          "Iterative Models",
          "Hyperparameter Optimization",
        ],
        ilos: [
          "Get a grasp on using MLJ as a data scientist new to MLJ or Julia",
          "Refresh your skills on building simple models",
          "Learn how to prepare example real-life data by loading, coercing, partitioning and unpacking data",
          "Learn how to build pipelines in MLJ",
          "Learn about how to manually and automatically evaluate models in MLJ",
          "Understand how to perform feature selection in MLJ",
          "Learn how to wrap models in iterative strategies in MLJ",
          "Learn how to tune hyperparameters in MLJ",
          "Familiarize yourself with confusion matrices, ROC curve and stratified cross-validation",
          "Learn how to save and perform final evaluations on your models in MLJ",
          "Understand the different types and methods introduced by MLJ",
        ]
      },
      {
        name: "KNN & Ridge Regression Learning Network on AMES Pricing Data",
        href: "/end-to-end/AMES/",
        tags: ["Regression", "Learning Networks", "Hyperparameter Tuning"],
        ilos: [
          "Get familiar with building baselines models for your machine learning task",
          "Learn how to build simple learning networks (advanced model composition) in MLJ",
          "Learn how to tune and analyze the evaluation results from learning networks"
        ]
      },
      {
        name: "KNN, Logistic Regression and PCA on Wine Dataset",
        href: "/end-to-end/wine/",
        tags: [
          "Encoders",
          "Classification",
          "Pipelines",
          "Dimensionality Reduction",
        ],
        ilos: [
          "Familiarize yourself with the common data preprocessing steps in MLJ",
          "Refresh your skills on building pipelines and comparing classification models with MLJ",
          "Learn how to reduce the dimensionality of high-dimensional data using dimensionality reduction techniques such as PCA"
        ]
      },
      {
        name: "XGBoost on Crabs Dataset",
        href: "/end-to-end/crabs-xgb/",
        tags: ["Classification", "Iterative Models", "Hyperparameter Tuning"],
        ilos: [
          "Learn how to build XGBoost models in MLJ",
          "Familiarize yourself with various XGBoost hyperparameters and their effects",
          "Refresh your skills on using learning curves and hyperparameter tuning in MLJ"
        ]
      },
      {
        name: "EvoTree Classifier on Horse Colic Dataset",
        href: "/end-to-end/horse/",
        tags: [
          "Missing Value Imputation",
          "Classification",
          "Pipelines",
          "Iterative Models",
          "Hyperparameter Tuning",
        ],
        ilos: [
          "Familiarize yourself with common data preprocessing techniques in Julia",
          "Get familiar with building baselines models for your learning task in MLJ",
          "Refresh your understanding of using pipelines, evaluation and hyperparameter tuning in MLJ"
        ]
      },
      {
        name: "Tree-based models on King County Houses Dataset",
        href: "/end-to-end/HouseKingCounty/",
        tags: ["Regression", "Iterative Models"],
        ilos: [
          "Familiarize yourself with common data preprocessing and visualization techniques in Julia",
          "Explore different tree-based models such as decision trees, random forests and gradient boosters and compare them together"
        ]
      },
      {
        name: "Tree-based models on Airfoil Dataset",
        href: "/end-to-end/airfoil",
        tags: ["Encoders", "Regression", "Hyperparameter Tuning"],
        ilos: [
          "Familiarize yourself with common data preprocessing and visualization techniques in Julia",
          "Explore different tree-based models such as decision trees, random forests and compare them together",
          "Refresh your understanding of tuning hyperparameters with MLJ and analyzing tuning results"
        ]
      },
      {
        name: "LightGBM on Boston Data",
        href: "/end-to-end/boston-lgbm",
        tags: ["Regression", "Hyperparameter Tuning", "Iterative Models"],
        ilos: [
          "Familiarize yourself with common data preprocessing and visualization techniques in Julia",
          "Build and analyze LightGBM models in MLJ by utilizing learning curves and hyperparameter tuning",
        ]
      },
      {
        name: "Exploring Generative Linear Models",
        href: "/end-to-end/glm/",
        tags: ["Pipelines", "Encoders", "Classification", "Regression"],
        ilos: [
          "Understand how to use generative linear models from GLM.jl in MLJ",
          "Practice examples of using linear regression and logistic regression models in MLJ",
          "Understand how to interpret the outputs from linear and logistic regression models"
        ]
      },
      {
        name: "Linear Regression on Temporal Power Generation Data",
        href: "/end-to-end/powergen/",
        tags: ["Data Processing", "Regression"],
        ilos: [
          "Familiarize yourself with common data preprocessing and visualization workflows",
          "Gain an understanding of exploratory data analytics to better understand the data before developing your model",
          "Train and analyze linear regression models on temporal data with MLJ"
        ]
      },
      {
        name: "Custom Neural Networks on Boston Data",
        href: "/end-to-end/boston-flux",
        tags: [
          "Neural Networks",
          "Hyperparameter Tuning",
          "Regression",
          "Iterative Models",
        ],
        ilos: [
          "Learn how to build and train arbitrary feedforward neural networks via MLJFlux.jl",
          "Understand how deep learning MLJFlux models can be hyperparameter tuned with MLJ"
        ]
      },
      {
        name: "Benchmarking Classification Models on Breast Cancer Data",
        href: "/end-to-end/breastcancer",
        tags: [
          "Encoders",
          "Classification",
          "Iterative Models",
          "Distribution Fitter",
          "Bayesian Models",
          "Neural Networks",
        ],
        ilos: [
          "Familiarize yourself with common data preprocessing and visualization workflows",
          "Learn how MLJ can be used to benchmark a large set of models against some dataset"
        ]
      },
      {
        name: "Credit Fraud Detection with Logistic Regression, SVM and Neural Networks",
        href: "/end-to-end/creditfraud",
        tags: [
          "Classification",
          "Class Imbalance",
          "Encoders",
          "Pipelines",
          "Neural Networks",
        ],
        ilos: [
          "Familiarize yourself with common data preprocessing and visualization workflows",
          "Refresh your understanding of classification metrics such as the confusion matrix and ROC curves",
          "Build and hyperparameter tune logistic regression and SVM models",
          "Learn how to build basic neural networks with MLJFlux.jl",
          "Learn how to correct for class imbalance using the Imbalance.jl package"
        ]
      },
    ],
    sectionItemWidth: "long-item",
  },
  {
    name: "Advanced",
    id: "advanced",
    href: "#!",
    sections: [
      {
        name: "Build Basic Learning Networks with MLJ",
        href: "/advanced/ensembles-3",
        tags: ["Regression", "Learning Networks"],
        ilos: [
          "Have a clear understanding of how learning networks function in MLJ",
          "Be able to construct basic learning networks with MLJ",
          "Understand how to evaluate and tune learning networks"
        ]
      },
      {
        name: "Stacking with Learning Networks",
        href: "/advanced/stacking/",
        tags: ["Ensemble Models", "Learning Networks", "Hyperparameter Tuning"],
        ilos: [
          "Have a grasp of how to build and analyze complex learning networks (e.g., stacking)",
          "Be able to evaluate and tune learning networks"
        ]
      },
    ],
    sectionItemWidth: "medium-item",
  },
  { name: "Contribute", href: "https://github.com/JuliaAI/DataScienceTutorials.jl?tab=readme-ov-file#-for-developers", sections: [], sectionItemWidth: "", id: "contribute" },

];

// first get info on whether hosted or not
const origin = window.location.origin;
const hosted = origin.includes("github.io");

const navList = document.querySelector(".nav-list");

// for each object above we will call this function
function createNavItem(item) {
  // a nav item is an li wrapping an anchor
  const li = document.createElement("li");
  const link = document.createElement("a");
  // set style, link and text content of anchor
  link.textContent = item.name;
  link.classList.add("main-nav-item");
  link.href = hosted
    ? origin + "/DataScienceTutorials.jl" + item.href
    : item.href;
  link.id = item.id;

  li.appendChild(link);

  // create a dropdown it item.sections is not empty
  if (item.sections.length > 0) {
    const dropdown = createDropDown(item.sections, item.sectionItemWidth);
    li.appendChild(dropdown);
  }

  return li;
}

function createDropDown(sections, sectionWidth) {
  // a dropdown is a ul wrapping a sequence of li wrapping an anchor for each item
  const dropdown = document.createElement("ul");
  dropdown.classList.add("nav-dropdown");
  // for each section make an li wrapping an anchor
  sections.forEach((section) => {
    const subItem = document.createElement("li");
    subItem.classList.add(sectionWidth);
    const subLink = document.createElement("a");
    subLink.textContent = section.name;
    subLink.href = hosted
      ? origin + "/DataScienceTutorials.jl" + section.href
      : section.href;
    subItem.appendChild(subLink);
    dropdown.appendChild(subItem);
  });

  return dropdown;
}

navList.innerHTML = ""; // Clear existing content

navItems.forEach((item) => {
  navList.appendChild(createNavItem(item));
});

// add a final li as searchform
let formAction = hosted
  ? origin + "/DataScienceTutorials.jl" + "/search/index.html"
  : "/search/index.html";
let searchForm = `
  <li>
    <form id="lunrSearchForm" name="lunrSearchForm" style="margin-left: 1.5rem; margin-right: -2rem;">
      <input class="search-input" name="q" placeholder="Search..." type="text">
      <input type="submit" value="Search" formaction=${formAction} style="display:none">
    </form>
  </li>`;

navList.innerHTML += searchForm;

// For the mobile navigation bar:
function createListItem(item) {
  const href = hosted
    ? origin + "/DataScienceTutorials.jl" + item.href
    : item.href;
  return `
    <li class="pure-menu-item">
      <a href="${href}" class="pure-menu-link"><span style="padding-right:0.5rem;">•</span>${item.name}</a>
    </li>
  `;
}

// Function to create dropdown content
function createDropdownContent(category) {
  const items = category.sections.map(createListItem).join("");
  return `
    <div class="dropdown">
      <li class="pure-menu-sublist-title"><strong>${category.name}</strong></li>
    </div>
    <div class="collapse dropdown-content">
      <ul class="pure-menu-sublist">${items}</ul>
    </div>
  `;
}

function generateSidebar(navItems) {
  const navList = document.querySelector(".pure-menu-list");
  let navHTML = "";
  // Home item is a special case
  const isHomePage = window.location.pathname === "/";
  const homeClass = isHomePage ? "pure-menu-selected" : "";
  navHTML += `
    <li id="home-sidebar" class="pure-menu-item pure-menu-top-item ${homeClass}">
      <a href="/" class="pure-menu-link"><strong>Home</strong></a>
    </li>
  `;

  // Then comes the rest of the categories and the dropdowns
  navItems.forEach((item) => {
    if (item.sections.length > 0) {
      navHTML += createDropdownContent(item);
    }
  });

  navList.innerHTML = navHTML;
}

// Call the function to generate the sidebar
generateSidebar(navItems);

// Flatten the nav items so we can easily iterate through them
function flattenNavItems(items) {
  return items.reduce((acc, item) => {
    const mainHrefs = [
      "/info/data",
      "/info/end-to-end",
      "/info/getting-started",
      "/info/isl",
      "#!",
    ];
    if (!mainHrefs.includes(item.href)) {
      acc.push(item);
    }
    if (item.sections) {
      acc.push(...flattenNavItems(item.sections));
    }
    return acc;
  }, []);
}

const flatItems = flattenNavItems(navItems);

// loop and roate based on clicks
function getPreviousAndNextTutorials(currentHref) {
  let currentIndex = flatItems.findIndex(
    (item) => currentHref.includes(item.href) && item.href != "/"
  );
  console.log(currentIndex);
  currentIndex = currentIndex === -1 ? 0 : currentIndex;
  const totalItems = flatItems.length;

  // Calculate previous and next indices considering rotation
  const previousIndex = (currentIndex - 1 + totalItems) % totalItems;
  const nextIndex = (currentIndex + 1) % totalItems;
  return {
    previousTutorial: flatItems[previousIndex],
    nextTutorial: flatItems[nextIndex],
    currentIndex,
  };
}

// Update buttons based on current href
function updateNavigationButtons(currentHref) {
  const { previousTutorial, nextTutorial, currentIndex } =
    getPreviousAndNextTutorials(currentHref);
  const prevHref = hosted
    ? origin + "/DataScienceTutorials.jl" + previousTutorial.href
    : previousTutorial.href;
  const nextHref = hosted
    ? origin + "/DataScienceTutorials.jl" + nextTutorial.href
    : nextTutorial.href;
  document.getElementById("prev-tutorial").setAttribute("href", prevHref);
  document.getElementById("next-tutorial").setAttribute("href", nextHref);
  document.getElementById("prev-label").innerHTML = previousTutorial.name;
  document.getElementById("next-label").innerHTML = nextTutorial.name;
  // if we are at home disable previous button
  document.getElementById("prev-tutorial").style.display =
    currentIndex === 0 ? "none" : "block";
  // if we are at last item disable next button
  document.getElementById("next-tutorial").style.display =
    currentIndex === flatItems.length - 1 ? "none" : "block";
}

const currentHref = window.location.href;
updateNavigationButtons(currentHref);
