// responsible for logic to switch between navigation bars
const thinkDiv = document.getElementById("think");
const menuDiv = document.getElementById("menu");
const navDiv = document.getElementById("nav");
const layoutDiv = document.getElementById("layout");


thinkDiv.addEventListener("click", function() {
  // Toggle the display of both menus
  if (menuDiv.style.display === "none") {
    menuDiv.style.display = "block";
    navDiv.style.display = "none";
    layoutDiv.style.paddingLeft = "250px";
    
  }
  else {
    menuDiv.style.display = "none";
    navDiv.style.display = "block";
    layoutDiv.style.paddingLeft = "0px";
  }
 
});
