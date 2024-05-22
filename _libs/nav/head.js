const navItems = [
  // { name: "Home", href: "/", sections: [], sectionItemWidth: "", id: "home" },
  {
    name: "Data Basics",
    id: "data",
    href: "/info/data",
    sections: [
      {
        name: "Choosing a model",
        href: "/getting-started/choosing-a-model/",
        tags: ["Data Processing"],
      },
      {
        name: "Fit, predict, transform",
        href: "/getting-started/fit-and-predict/",
        tags: ["Data Processing"],
      },
      {
        name: "Model tuning",
        href: "/getting-started/model-tuning/",
        tags: ["Data Processing"],
      },
      {
        name: "Ensembles",
        href: "/getting-started/ensembles/",
        tags: ["Data Processing"],
      },
      {
        name: "Ensembles (2)",
        href: "/getting-started/ensembles-2/",
        tags: ["Data Processing"],
      },
      {
        name: "Composing models",
        href: "/getting-started/composing-models/",
        tags: ["Data Processing", "Missing Value Imputation"],
      },
    ],
    sectionItemWidth: "short-item",
  },
  {
    name: "Getting Started",
    id: "getting-started",
    href: "/info/getting-started",
    sections: [
      {
        name: "Choosing a model",
        href: "/getting-started/choosing-a-model/",
        tags: ["Classification", "Regression"],
      },
      {
        name: "Fit, predict, transform",
        href: "/getting-started/fit-and-predict/",
        tags: ["Classification", "Encoders"],
      },
      {
        name: "Model tuning",
        href: "/getting-started/model-tuning/",
        tags: ["Classification", "Hyperparameter Tuning"],
      },
      {
        name: "Ensembles",
        href: "/getting-started/ensembles/",
        tags: ["Regression", "Ensemble Models", "Hyperparameter Tuning"],
      },
      {
        name: "Ensembles (2)",
        href: "/getting-started/ensembles-2/",
        tags: ["Regression", "Ensemble Models", "Hyperparameter Tuning"],
      },
      {
        name: "Composing models",
        href: "/getting-started/composing-models/",
        tags: ["Regression", "Encoders", "Pipelines"],
      },
    ],
    sectionItemWidth: "medium-item",
  },
  {
    name: "Intro to Stats Learning",
    id: "stats-learning",
    href: "/info/isl",
    sections: [
      {
        name: "Basic Operations",
        href: "/isl/lab-2/",
        tags: ["Data Processing"],
      },
      { name: "Linear Regression", href: "/isl/lab-3/", tags: ["Regression"] },
      {
        name: "Logistic Regression & Friends",
        href: "/isl/lab-4/",
        tags: ["Classification", "Bayesian Models", "Distribution Fitter"],
      },
      {
        name: "Cross Validation",
        href: "/isl/lab-5/",
        tags: ["Regression", "Feature Selection", "Hyperparameter Tuning"],
      },
      {
        name: "Ridge & Lasso Regression",
        href: "/isl/lab-6b/",
        tags: ["Regression", "Encoders", "Hyperparameter Tuning"],
      },
      {
        name: "Tree-based Models",
        href: "/isl/lab-8/",
        tags: ["Iterative Models", "Classification", "Regression"],
      },
      {
        name: "Support Vector Machine",
        href: "/isl/lab-9/",
        tags: ["Classification", "Hyperparameter Tuning"],
      },
      {
        name: "PCA & Clustering",
        href: "/isl/lab-10/",
        tags: ["Dimensionality Reduction", "Clustering", "Pipelines"],
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
        name: "Telco Churn",
        href: "/end-to-end/telco/",
        tags: [
          "Classification",
          "Data Processing",
          "Pipelines",
          "Feature Selection",
          "Iterative Models",
          "Hyperparameter Optimization",
        ],
      },
      {
        name: "AMES",
        href: "/end-to-end/AMES/",
        tags: ["Regression", "Learning Networks", "Hyperparameter Tuning"],
      },
      {
        name: "Wine",
        href: "/end-to-end/wine/",
        tags: [
          "Encoders",
          "Classification",
          "Pipelines",
          "Dimensionality Reduction",
        ],
      },
      {
        name: "Crabs (XGB)",
        href: "/end-to-end/crabs-xgb/",
        tags: ["Classification", "Iterative Models", "Hyperparameter Tuning"],
      },
      {
        name: "Horse",
        href: "/end-to-end/horse/",
        tags: [
          "Missing Value Imputation",
          "Classification",
          "Pipelines",
          "Iterative Models",
          "Hyperparameter Tuning",
        ],
      },
      {
        name: "King County Houses",
        href: "/end-to-end/HouseKingCounty/",
        tags: ["Regression", "Iterative Models"],
      },
      {
        name: "Airfoil",
        href: "/end-to-end/airfoil",
        tags: ["Encoders", "Regression", "Hyperparameter Tuning"],
      },
      {
        name: "Boston (lgbm)",
        href: "/end-to-end/boston-lgbm",
        tags: ["Regression", "Hyperparameter Tuning", "Iterative Models"],
      },
      {
        name: "Using GLM.jl",
        href: "/end-to-end/glm/",
        tags: ["Pipelines", "Encoders", "Classification"],
      },
      {
        name: "Power Generation",
        href: "/end-to-end/powergen/",
        tags: ["Data Processing", "Regression"],
      },
      {
        name: "Boston (Flux)",
        href: "/end-to-end/boston-flux",
        tags: [
          "Neural Networks",
          "Hyperparameter Tuning",
          "Regression",
          "Iterative Models",
        ],
      },
      {
        name: "Breast Cancer",
        href: "/end-to-end/breastcancer",
        tags: [
          "Encoders",
          "Classification",
          "Iterative Models",
          "Distribution Fitter",
          "Bayesian Models",
          "Neural Networks",
        ],
      },
      {
        name: "Credit Fraud",
        href: "/end-to-end/creditfraud",
        tags: [
          "Classification",
          "Class Imbalance",
          "Encoders",
          "Pipelines",
          "Neural Networks",
        ],
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
        name: "Ensembles (3)",
        href: "/advanced/ensembles-3",
        tags: ["Regression", "Learning Networks"],
      },
      {
        name: "Stacking",
        href: "/advanced/stacking/",
        tags: ["Ensemble Models", "Learning Networks", "Hyperparamter Tuning"],
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
