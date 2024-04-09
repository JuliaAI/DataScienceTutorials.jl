
const navItems = [
  { name: 'Home', href: '/', sections: [], sectionItemWidth: '', id: 'home' },
  {
    name: 'Data Basics',                                    // Category name to be shown in navigation bar
    id: 'data',                                             // id to be manipulated with js
    href: '/data',                                             // in case it should link anywhere
    sections: [                                             // list items to be shown in its dropdown and where they link to
      { name: 'Loading Data', href: '/data/loading/' },
      { name: 'Data Frames', href: '/data/dataframe/' },
      { name: 'Categorical Arrays', href: '/data/categorical/' },
      { name: 'Scientific Type', href: '/data/scitype/' },
      { name: 'Data processing', href: '/data/processing/' },
    ],
    sectionItemWidth: 'short-item'
  },
  {
    name: 'Getting Started',
    id: 'getting-started',
    href: '/getting-started',
    sections: [
      { name: 'Choosing a model', href: '/getting-started/choosing-a-model/' },
      { name: 'Fit, predict, transform', href: '/getting-started/fit-and-predict/' },
      { name: 'Model tuning', href: '/getting-started/model-tuning/' },
      { name: 'Ensembles', href: '/getting-started/ensembles/' },
      { name: 'Ensembles (2)', href: '/getting-started/ensembles-2/' },
      { name: 'Composing models', href: '/getting-started/composing-models/' },
      { name: 'Stacking', href: '/getting-started/stacking/' },
    ],
    sectionItemWidth: 'medium-item'
  },
  {
    name: 'Intro to Stats Learning',
    id: 'stats-learning',
    href: '/isl',
    sections: [
      { name: 'Lab 2', href: '/isl/lab-2/' },
      { name: 'Lab 3', href: '/isl/lab-3/' },
      { name: 'Lab 4', href: '/isl/lab-4/' },
      { name: 'Lab 5', href: '/isl/lab-5/' },
      { name: 'Lab 6b', href: '/isl/lab-6b/' },
      { name: 'Lab 8', href: '/isl/lab-8/' },
      { name: 'Lab 9', href: '/isl/lab-9/' },
      { name: 'Lab 10', href: '/isl/lab-10/' },
    ],
    sectionItemWidth: 'long-item'
  },

  {
    name: 'End to End',
    id: 'end-to-end',
    href: '/end-to-end',
    sections: [
      { name: 'Telco Churn', href: '/end-to-end/telco/' },
      { name: 'AMES', href: '/end-to-end/AMES/' },
      { name: 'Wine', href: '/end-to-end/wine/' },
      { name: 'Crabs (XGB)', href: '/end-to-end/crabs-xgb/' },
      { name: 'Horse', href: '/end-to-end/horse/' },
      { name: 'King County Houses', href: '/end-to-end/HouseKingCounty/' },
      { name: 'Airfoil', href: '/end-to-end/airfoil' },
      // { name: 'Boston (lgbm)', href: '/end-to-end/boston-lgbm' },
      { name: 'Using GLM.jl', href: '/end-to-end/glm/' },
      { name: 'Power Generation', href: '/end-to-end/powergen/' },
      { name: 'Boston (Flux)', href: '/end-to-end/boston-flux' },
      { name: 'Breast Cancer', href: '/end-to-end/breastcancer' },
      { name: 'Credit Fraud', href: '/end-to-end/creditfraud' },
    ],
    sectionItemWidth: 'long-item'
  },
  {
    name: 'Advanced',
    id: 'advanced',
    href: '#!',
    sections: [{ name: 'Ensembles (3)', href: '/advanced/ensembles-3' }],
    sectionItemWidth: 'medium-item'
  },
];

const navList = document.querySelector('.nav-list');

// for each object above we will call this function
function createNavItem(item) {
  // a nav item is an li wrapping an anchor
  const li = document.createElement('li');
  const link = document.createElement('a');
  // set style, link and text content of anchor
  link.textContent = item.name;
  link.classList.add('main-nav-item');
  link.href = item.href;
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
  const dropdown = document.createElement('ul');
  dropdown.classList.add('nav-dropdown');

  // for each section make an li wrapping an anchor
  sections.forEach((section) => {
    const subItem = document.createElement('li');
    subItem.classList.add(sectionWidth)
    const subLink = document.createElement('a');
    subLink.textContent = section.name;
    subLink.href = section.href;
    subItem.appendChild(subLink);
    dropdown.appendChild(subItem);
  });

  return dropdown;
}

navList.innerHTML = ''; // Clear existing content

navItems.forEach((item) => {
  navList.appendChild(createNavItem(item));
});

// add a final li as searchform
searchForm = `
  <li>
    <form id="lunrSearchForm" name="lunrSearchForm" style="margin-left: 1.5rem; margin-right: -2rem;">
      <input class="search-input" name="q" placeholder="Search..." type="text">
      <input type="submit" value="Search" formaction="/search/index.html" style="display:none">
    </form>
  </li>`

navList.innerHTML += searchForm

// For the mobile navigation bar:
function createListItem(item) {
  return `
    <li class="pure-menu-item">
      <a href="${item.href}" class="pure-menu-link"><span style="padding-right:0.5rem;">•</span>${item.name}</a>
    </li>
  `;
}

// Function to create dropdown content
function createDropdownContent(category) {
  const items = category.sections.map(createListItem).join('');
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
  const navList = document.querySelector('.pure-menu-list');
  let navHTML = '';
  // Home item is a special case
  const isHomePage = window.location.pathname === '/';
  const homeClass = isHomePage ? 'pure-menu-selected' : '';
  navHTML += `
    <li id="home-sidebar" class="pure-menu-item pure-menu-top-item ${homeClass}">
      <a href="/" class="pure-menu-link"><strong>Home</strong></a>
    </li>
  `;

  // Then comes the rest of the categories and the dropdowns
  navItems.forEach(item => {
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
    const mainHrefs = ["/data", "/end-to-end", "/getting-started", "/isl", "#!"];
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
  let currentIndex = flatItems.findIndex(item => (currentHref.includes(item.href) && item.href != "/"));
  console.log(currentIndex)
  currentIndex = currentIndex === -1 ? 0 : currentIndex;
  const totalItems = flatItems.length;

  // Calculate previous and next indices considering rotation
  const previousIndex = (currentIndex - 1 + totalItems) % totalItems;
  const nextIndex = (currentIndex + 1) % totalItems;
  return {
    previousTutorial: flatItems[previousIndex],
    nextTutorial: flatItems[nextIndex],
    currentIndex
  };
}

// Update buttons based on current href
function updateNavigationButtons(currentHref) {
  const { previousTutorial, nextTutorial, currentIndex } = getPreviousAndNextTutorials(currentHref);
  document.getElementById("prev-tutorial").setAttribute("href", previousTutorial.href);
  document.getElementById("next-tutorial").setAttribute("href", nextTutorial.href);
  document.getElementById("prev-label").innerHTML = previousTutorial.name;
  document.getElementById("next-label").innerHTML = nextTutorial.name;
  // if we are at home disable previous button
  document.getElementById("prev-tutorial").style.display = currentIndex === 0 ? "none" : "block";
  // if we are at last item disable next button
  document.getElementById("next-tutorial").style.display = currentIndex === flatItems.length - 1 ? "none" : "block";
}

const currentHref = window.location.href;
updateNavigationButtons(currentHref);