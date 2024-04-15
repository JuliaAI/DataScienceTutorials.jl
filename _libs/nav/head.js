import navItems from '../../routes.json' assert {type: 'json'};

// first get info on whether hosted or not
const origin = window.location.origin;
const hosted = origin.includes("github.io");

const navList = document.querySelector('.nav-list');

// for each object above we will call this function
function createNavItem(item) {
  // a nav item is an li wrapping an anchor
  const li = document.createElement('li');
  const link = document.createElement('a');
  // set style, link and text content of anchor
  link.textContent = item.name;
  link.classList.add('main-nav-item');
  link.href = (hosted) ? origin + "/DataScienceTutorials.jl" + item.href : item.href;
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
    subLink.href = (hosted) ? origin + "/DataScienceTutorials.jl" + section.href : section.href;
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
let formAction = (hosted) ? origin + "/DataScienceTutorials.jl" + "/search/index.html" : "/search/index.html";
let searchForm = `
  <li>
    <form id="lunrSearchForm" name="lunrSearchForm" style="margin-left: 1.5rem; margin-right: -2rem;">
      <input class="search-input" name="q" placeholder="Search..." type="text">
      <input type="submit" value="Search" formaction=${formAction} style="display:none">
    </form>
  </li>`

navList.innerHTML += searchForm

// For the mobile navigation bar:
function createListItem(item) {
  const href = (hosted) ? origin + "/DataScienceTutorials.jl" + item.href : item.href;
  return `
    <li class="pure-menu-item">
      <a href="${href}" class="pure-menu-link"><span style="padding-right:0.5rem;">•</span>${item.name}</a>
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
    const mainHrefs = ["/info/data", "/info/end-to-end", "/info/getting-started", "/info/isl", "#!"];
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
  const prevHref =  (hosted) ? origin + "/DataScienceTutorials.jl" + previousTutorial.href : previousTutorial.href;
  const nextHref =  (hosted) ? origin + "/DataScienceTutorials.jl" + nextTutorial.href : nextTutorial.href;
  document.getElementById("prev-tutorial").setAttribute("href", prevHref);
  document.getElementById("next-tutorial").setAttribute("href", nextHref);
  document.getElementById("prev-label").innerHTML = previousTutorial.name;
  document.getElementById("next-label").innerHTML = nextTutorial.name;
  // if we are at home disable previous button
  document.getElementById("prev-tutorial").style.display = currentIndex === 0 ? "none" : "block";
  // if we are at last item disable next button
  document.getElementById("next-tutorial").style.display = currentIndex === flatItems.length - 1 ? "none" : "block";
}

const currentHref = window.location.href;
updateNavigationButtons(currentHref);
