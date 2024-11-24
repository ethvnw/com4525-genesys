import { Offcanvas } from 'bootstrap';

document.addEventListener("DOMContentLoaded", (event) => {

    const shareFeatureButtons = document.querySelectorAll('.share-feature-button');
    var myOffcanvas = document.getElementById('offcanvasBottom');
    var bsOffcanvas = new Offcanvas(myOffcanvas);

    shareFeatureButtons.forEach(button => {
        button.addEventListener('click', async () => {
            // Get the parent element of the button
            let shareFeatureCard = button.parentElement;
            
            // Get the text content of the feature name and description
            let featureName = shareFeatureCard.querySelector('.share-feature-name').textContent;
            let featureDescription = shareFeatureCard.querySelector('.share-feature-description').textContent;

            bsOffcanvas.show()
      });
    });
});