import { Offcanvas } from 'bootstrap';
import { getFeatureShareApiRoute } from './constants/api_routes';

const pageUrl = 'roamio.com';
const socialShareCanvas = document.getElementById('social-share-offcanvas');
const bsSocialShareCanvas = new Offcanvas(socialShareCanvas);

const shareClipboard = socialShareCanvas.querySelector('#social-share-clipboard');
const shareEmail = socialShareCanvas.querySelector('#social-share-email');
const shareFacebook = socialShareCanvas.querySelector('#social-share-facebook');
const shareTwitter = socialShareCanvas.querySelector('#social-share-twitter');
const shareWhatsapp = socialShareCanvas.querySelector('#social-share-whatsapp');

/**
 * Updates the icon in the "Copy Description" button.
 * @param {string} iconClass - The bs icon class to update.
 */
const updateIcon = (iconClass) => {
  const icon = socialShareCanvas.querySelector('#social-share-clipboard i');
  icon.className = `bi ${iconClass} display-4`;
};

/**
 * Attempts to write to clipboard and updates the "Copy Description" button
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
 * @param {string} featureId - The ID of the feature to share
 */
const updateSocialShareLinks = (featureName, featureDescription, featureId) => {
  const featureBody = `With ${featureName} you can ${featureDescription.toLowerCase()}\n\nCheck it out on ${pageUrl}`;

  // Update all the links
  socialShareCanvas.querySelector('#social-share-title').textContent = featureName;
  socialShareCanvas.querySelector('#social-share-url').textContent = pageUrl;
  shareClipboard.onclick = () => {
    writeClipboardText(featureBody).then();
    fetch(getFeatureShareApiRoute(featureId, 'clipboard')).then();
  };

  shareEmail.href = getFeatureShareApiRoute(featureId, 'Email');
  shareFacebook.href = getFeatureShareApiRoute(featureId, 'Facebook');
  shareTwitter.href = getFeatureShareApiRoute(featureId, 'Twitter');
  shareWhatsapp.href = getFeatureShareApiRoute(featureId, 'WhatsApp');
};

// Add event listener to all social share buttons
document.querySelectorAll('.share-feature-button').forEach((button) => {
  button.addEventListener('click', () => {
    // Get the feature details from the card
    const card = button.parentElement;
    const featureName = card.querySelector('.share-feature-name').textContent;
    const featureDescription = card.querySelector('.share-feature-description').textContent;

    // Reset the icon and scroll in the socialShareCanvas
    updateIcon('bi-clipboard');
    socialShareCanvas.querySelector('.offcanvas-body').scrollLeft = 0;

    // Update the social share links with the feature
    updateSocialShareLinks(featureName, featureDescription, button.dataset.shareId);

    // Show the canvas
    bsSocialShareCanvas.show();
  });
});
