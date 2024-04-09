// switch between navigation bars according to screen size
const menuDiv = document.getElementById("menu");
const navDiv = document.getElementById("nav");
const layoutDiv = document.getElementById("layout");

// Function to toggle navigation bars based on screen resolution
function toggleNavigation() {
    // Check if the screen width is below a certain threshold (e.g., 768px for mobile view)
    if (window.innerWidth < 1030) {
      menuDiv.style.display = "block";
      navDiv.style.display = "none";
      layoutDiv.style.paddingLeft = "0px";
    } else {
      menuDiv.style.display = "none";
      navDiv.style.display = "block";
      layoutDiv.style.paddingLeft = "0px";
    }
  }
  
  // Call the function initially to set navigation based on screen resolution
  toggleNavigation();
  
  // Add event listener for window resize to dynamically adjust navigation
  window.addEventListener("resize", toggleNavigation);
  