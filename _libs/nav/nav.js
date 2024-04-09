document.addEventListener('DOMContentLoaded', function () {
  // If a link has a dropdown, add sub menu toggle on hover.
  document.querySelectorAll('nav ul li a:not(:only-child)').forEach(function (element) {
    element.addEventListener('mouseover', function (e) {
      var siblingDropdown = this.nextElementSibling;
      if (siblingDropdown) {
        siblingDropdown.style.display = 'block';
      }
      this.style.backgroundColor = '#9b59b6';
      this.style.color = '#f1f1f1';
      this.style.borderRadius = '2rem 2rem 0 0';
    });

    // Hide dropdown when mouse leaves the link
    element.addEventListener('mouseout', function (e) {
      var siblingDropdown = this.nextElementSibling;
      if (siblingDropdown) {
        siblingDropdown.style.display = 'none';
      }
      this.style.backgroundColor = '';
      this.style.color = '';
      this.style.borderRadius = '';
    });
  });

  // Close dropdown only when hovering away from both the link and its dropdown
  document.querySelectorAll('.nav-dropdown').forEach(function (dropdown) {
    dropdown.addEventListener('mouseover', function (e) {
      e.stopPropagation(); // Prevent closing on mouseover within the dropdown
      this.style.display = 'block'; // Keep dropdown displayed while being hovered

      // Set left sibling's background color and border radius
      var leftSibling = this.previousElementSibling;
      if (leftSibling) {
        leftSibling.style.backgroundColor = '#9b59b6';
        leftSibling.style.color = '#f1f1f1';
        leftSibling.style.borderRadius = '2rem 2rem 0 0';
      }
    });

    dropdown.addEventListener('mouseout', function (e) {
      if (!e.relatedTarget || !e.relatedTarget.closest('.nav-dropdown')) {
        this.style.display = 'none';

        // Reset left sibling's background color and border radius
        var leftSibling = this.previousElementSibling;
        if (leftSibling) {
          leftSibling.style.backgroundColor = '';
          leftSibling.style.color = '';
          leftSibling.style.borderRadius = '';
        }
        setBackgroundColor();
      }
    });
  });
});

// Colors the navigation item based on the page
function colorNavItem(url, subRoute, elementID) {
  // Check if the URL contains "/data/"
  if (url.includes(subRoute)) {
    // If it does, set the background color of the element with ID "data" to purple
    document.getElementById(elementID).style.backgroundColor = "";
    document.getElementById(elementID).style.color = "#9b59b6";
    return true;
  }
  else {
    document.getElementById(elementID).style.backgroundColor = "";
    document.getElementById(elementID).style.color = "black";
    return false;
  }

}

// Function to set the background color based on the URL
function setBackgroundColor() {
  // Get the URL of the current page
  var url = window.location.href;
  let isData = colorNavItem(url, "/data/", "data");
  let isStart = colorNavItem(url, "/getting-started/", "getting-started");
  let isStats = colorNavItem(url, "/isl/", "stats-learning");
  let isEnd = colorNavItem(url, "/end-to-end/", "end-to-end");
  let isAdv = colorNavItem(url, "/advanced/", "advanced");
  if (!(isData || isStart || isStats || isEnd || isAdv)) {
    document.getElementById("home").style.backgroundColor = "";
    document.getElementById("home").style.color = "#9b59b6";
  }


}

// Call the function initially to set the background color based on the initial URL
setBackgroundColor();

// Add an event listener to listen for changes to the URL
window.addEventListener('popstate', setBackgroundColor);