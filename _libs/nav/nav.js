// file contains logic for showing or hiding dropdowns in the top navifation bar
document.addEventListener('DOMContentLoaded', function() {
    // If a link has a dropdown, add sub menu toggle.
    document.querySelectorAll('nav ul li a:not(:only-child)').forEach(function(element) {
      element.addEventListener('click', function(e) {
        var siblingDropdown = this.nextElementSibling;
        if (siblingDropdown) {
          siblingDropdown.style.display = siblingDropdown.style.display === 'block' ? 'none' : 'block';
          // Close one dropdown when selecting another
          document.querySelectorAll('.nav-dropdown').forEach(function(dropdown) {
            if (dropdown !== siblingDropdown) {
              dropdown.style.display = 'none';
            }
          });
          e.stopPropagation();
        }
      });
    });
  
  // Clicking away from dropdown will remove the dropdown class
  document.addEventListener('click', function() {
    document.querySelectorAll('.nav-dropdown').forEach(function(dropdown) {
      dropdown.style.display = 'none';
    });
  });

  
    // Toggle open and close nav styles on click
    document.getElementById('nav-toggle').addEventListener('click', function() {
      var navUl = document.querySelector('nav ul');
      if (navUl.style.display === 'block') {
        navUl.style.display = 'none';
      } else {
        navUl.style.display = 'block';
      }
    });
  
    // Hamburger to X toggle
    document.getElementById('nav-toggle').addEventListener('click', function() {
      this.classList.toggle('active');
    });
  });
  