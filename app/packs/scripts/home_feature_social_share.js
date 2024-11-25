import { Offcanvas } from 'bootstrap';

document.addEventListener('DOMContentLoaded', () => {
  const pageUrl = 'roamio.com';
  const socialShareCanvas = document.getElementById('social-share-offcanvas');
  const bsSocialShareCanvas = new Offcanvas(socialShareCanvas);

  /**
   * Updates the icon in the "Copy Link" button.
   * @param {string} iconClass - The bs icon class to update.
   */
  const updateIcon = (iconClass) => {
    const icon = socialShareCanvas.querySelector('#social-share-link i');
    icon.className = `bi ${iconClass} display-2`;
  };

  /**
   * Attempts to write to clipboard and updates the "Copy Link" button
   * icon depending on success/fail.
   * @param {string} text - The text to write to the clipboard.
   */
  const writeClipboardText = async (text) => {
    try {
      await navigator.clipboard.writeText(text);
      // If successfuly write to clipboard
      updateIcon('bi-check');
    } catch (error) {
      // If fail to write to clipboard
      updateIcon('bi-ban');
    }
  };

  /**
   * Updates all the social share links with the feature name and description.
   * @param {string} featureName - The name of the feature to share.
   * @param {string} featureDescription - The description of the feature to share.
   */
  const updateSocialShareLinks = (featureName, featureDescription) => {
    const featureBody = encodeURIComponent(
      `With ${featureName} you can ${featureDescription.toLowerCase()}\n\nCheck it out on ${pageUrl}`,
    );
    const featureSubject = `Check out ${featureName} on Roamio!`;

    // Update all the links
    socialShareCanvas.querySelector('#social-share-title').textContent = featureName;
    socialShareCanvas.querySelector('#social-share-url').textContent = pageUrl;
    socialShareCanvas.querySelector('#social-share-email').href = `mailto:?body=${featureBody}&subject=${featureSubject}`;
    socialShareCanvas.querySelector('#social-share-facebook').href = `https://www.facebook.com/sharer/sharer.php?u=${pageUrl}`;
    socialShareCanvas.querySelector('#social-share-twitter').href = `https://twitter.com/intent/tweet?text=${featureBody}&url=${pageUrl}`;
    socialShareCanvas.querySelector('#social-share-whatsapp').href = `https://wa.me/?text=${featureBody}`;
  };

  // Add event listener to all social share buttons
  document.querySelectorAll('.share-feature-button').forEach((button) => {
    button.addEventListener('click', () => {
      // Get the feature details from the card
      const card = button.parentElement;
      const featureName = card.querySelector('.share-feature-name').textContent;
      const featureDescription = card.querySelector('.share-feature-description').textContent;

      // Reset the icon and scroll in the socialShareCanvas
      updateIcon('bi-link-45deg');
      socialShareCanvas.querySelector('.offcanvas-body').scrollLeft = 0;

      // Update the social share links with the feature
      updateSocialShareLinks(featureName, featureDescription);
      socialShareCanvas.querySelector('#social-share-link').onclick = () => writeClipboardText(pageUrl);

      // Show the canvas
      bsSocialShareCanvas.show();
    });
  });
});
