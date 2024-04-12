// This adds the collapsing sections feature to all tutorials and sidebar

// first get info on whether hosted or not
let isHosted = window.location.origin.includes("github.io");
// accordingly get icons
const rightIcon = (isHosted) ? origin + "/DataScienceTutorials.jl" + "/assets/right-icon.svg" : "/assets/right-icon.svg";
const downIcon = (isHosted) ? origin + "/DataScienceTutorials.jl" + "/assets/left-icon.svg" : "/assets/down-icon.svg";

document.addEventListener("DOMContentLoaded", function () {
  var filename = window.location.pathname;
  // Get all elements with class name "dropdown"
  var dropdowns = document.querySelectorAll(".dropdown");

  // Iterate through each dropdown
  dropdowns.forEach(function (dropdown, index) {
    // Find the first heading or li tag inside the dropdown
    var heading = dropdown.querySelector("h1, h2, h3, h4, h5, h6, li");
    // make heading have cursor pointer
    heading.style.cursor = "pointer";
    // Create a span element with class "triangle" and content " ▼ "
    var triangleImage = document.createElement("img");
    triangleImage.className = "triangle";
    triangleImage.src = dropdown.nextElementSibling.classList.contains(
      "collapse"
    )
      ? rightIcon
      : downIcon;

    // check local storage localStorage.setItem("dropdown-" + index, newContent); but get
    const restoreMemory = function (localName) {
      if (localStorage.getItem(localName)) {
        const newContent = localStorage.getItem(localName);
        triangleImage.src = (newContent.includes("right-icon")) ? rightIcon : downIcon;
        var dropdownContent = dropdown.nextElementSibling;
        if (newContent.includes("down-icon")) {
          dropdownContent.style.display = "block";
        }
        else {
          dropdownContent.style.display = "none";
        }
      }
    }

    restoreMemory("dropdown-" + index + filename);
    // for li tags the memory doesn't depend on the filename (navigation bar always exists)
    if (heading.tagName === "LI") {
      restoreMemory("dropdown-" + index + "li");
    }

    triangleImage.style.cursor = "pointer";
    triangleImage.style.width = "30px";
    triangleImage.style.paddingLeft = "0px";
    triangleImage.style.marginRight = "8px";
    triangleImage.style.marginBottom = "-7px";

    // Prepend the triangle span to the heading
    heading.insertBefore(triangleImage, heading.firstChild);

    // Add click event listener to the triangle span
    const activation = function () {
      // Toggle between " ▼ " and " ► " upon click
      var currentContent = triangleImage.src;
      var newContent = "";

      // Access the parent sibling div. Should follow that it has class dropdown-content
      var dropdownContent = dropdown.nextElementSibling;

      if (currentContent.includes("down-icon")) {
        newContent = currentContent.replace("down-icon", "right-icon");
        // Hide the dropdown-content
        if (dropdownContent.classList.contains("dropdown-content")) {
          dropdownContent.style.display = "none";
        }
      } else {
        newContent = currentContent.replace("right-icon", "down-icon");
        // Show the dropdown-content
        if (dropdownContent.classList.contains("dropdown-content")) {
          dropdownContent.style.display = "block";
        }

      }
      triangleImage.src = newContent;

      // store this state using dropdown index
      localStorage.setItem("dropdown-" + index + filename, newContent);
      // if the element is li store it in local storage
      if (heading.tagName === "LI") {
        localStorage.setItem("dropdown-" + index + "li", newContent);
      }
    }

    // if heading is an li we don't want to be restricted to clicking on the triangle
    if (heading.tagName === "LI") {
      dropdown.addEventListener("click", activation);
    }
    // otherwise there is already an attached onclick event
    else {
      triangleImage.addEventListener("click", activation);
    }

  });
});
