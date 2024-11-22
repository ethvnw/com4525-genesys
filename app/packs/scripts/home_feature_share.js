document.addEventListener("DOMContentLoaded", (event) => {

    const shareFeatureButtons = document.querySelectorAll('.share-feature-button');

    shareFeatureButtons.forEach(button => {
        button.addEventListener('click', async () => {
            // Get the parent element of the button
            let shareFeatureCard = button.parentElement;
            
            // Get the text content of the feature name and description
            let featureName = shareFeatureCard.querySelector('.share-feature-name').textContent;
            let featureDescription = shareFeatureCard.querySelector('.share-feature-description').textContent;
    
            if (navigator.share) {
              try {
                  await navigator.share({
                      title: `Check out ${featureName} on Roamio!`,
                      text: `Check out ${featureName} on Roamio!\n
With ${featureName} you can ${featureDescription.toLowerCase()}\n\n`,
                      url: '/'
                  });
                  
                  // App tracking should oocur here
                  console.log('Content shared successfully!');
              } catch (err) {
                console.error('Error sharing:', err);
              }
          } else {
              console.error('Web Share API is not supported on this device!');
          }
      });
    });
});