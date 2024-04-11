// JavaScript for the landing page (tab logic and run code button)

// Get the parent container
const tabContainer = document.querySelector('.get-started-tab-container');

// Add click event listener to the parent container
tabContainer.addEventListener('click', function(event) {
    // Remove "selected" class from all children
    const tabs = tabContainer.querySelectorAll('.get-started-tab');
    tabs.forEach(tab => tab.classList.remove('selected'));
    // Add "selected" class to the clicked child
    event.target.classList.add('selected');
    // do the same for the content
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(tab => tab.classList.remove('selected-content'));
    // get the index of the clicked child
    const index = Array.from(tabs).indexOf(event.target);
    // add "selected-content" class to the corresponding content
    tabContents[index].classList.add('selected-content');

    // Store the selected tab index in local storage
    localStorage.setItem('selectedTabIndex', index.toString());
});

// Restore selected tab on page load
document.addEventListener("DOMContentLoaded", function() {
    // Get the stored index from local storage
    const storedIndex = localStorage.getItem('selectedTabIndex');
    if (storedIndex !== null) {
        const index = parseInt(storedIndex);
        // Get all tabs and select the one corresponding to the stored index
        const tabs = tabContainer.querySelectorAll('.get-started-tab');
        tabs.forEach(tab => tab.classList.remove('selected'));
        tabs[index].classList.add('selected');
        
        // Get all tab contents and select the one corresponding to the stored index
        const tabContents = document.querySelectorAll('.tab-content');
        tabContents.forEach(tab => tab.classList.remove('selected-content'));
        tabContents[index].classList.add('selected-content');
    }
});

// make the button link to how-to-run-code
document.addEventListener("DOMContentLoaded", function() {
    // first get info on whether hosted or not
    const origin = window.location.origin;
    const hosted = origin.includes("github.io");
    // Get the div element with the class 'run-code'
    var element = document.querySelector('.run-code');
    
    // Add click event listener to the div element
    element.addEventListener('click', function(event) {
        // Change the location to "/how-to-run-code"
        window.location.href = (hosted) ? origin + "/DataScienceTutorials.jl" + "/how-to-run-code" : "/how-to-run-code";
    });
});
