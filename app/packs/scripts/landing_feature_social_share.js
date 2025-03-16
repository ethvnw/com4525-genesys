import { Offcanvas } from 'bootstrap';
import { getFeatureShareApiRoute } from './constants/api_routes';

const pageUrl = 'roamio.com';

let socialShareCanvas;
let bsSocialShareCanvas;

// Declare variables so that they can be used in other functions (defined in setup)
let shareClipboard;
let shareEmail;
let shareFacebook;
let shareTwitter;
let shareWhatsapp;

/**
 * Updates the icon in the "Copy Description" button.
 * @param {string} iconClass - The bs icon class to update.
 */
function updateIcon(iconClass) {
  const icon = socialShareCanvas.querySelector('#social-share-clipboard i');
  icon.className = `bi ${iconClass} display-4`;
}

/**
 * Attempts to write to clipboard and updates the "Copy Description" button
 * icon depending on success/fail.
 * @param {string} text - The text to write to the clipboard.
 */
async function writeClipboardText(text) {
  try {
    await navigator.clipboard.writeText(text);
    // If successfuly write to clipboard
    updateIcon('bi-check');
  } catch (error) {
    // If fail to write to clipboard
    updateIcon('bi-ban');
  }
}

/**
 * Updates all the social share links with the feature name and description.
 * @param {string} featureName - The name of the feature to share.
 * @param {string} featureDescription - The description of the feature to share.
 * @param {string} featureId - The ID of the feature to share
 */
function updateSocialShareLinks(featureName, featureDescription, featureId) {
  const featureBody = `With ${featureName} you can ${featureDescription.toLowerCase()}\n\nCheck it out on ${pageUrl}`;

  // Update all the links
  socialShareCanvas.querySelector('#social-share-title').textContent = featureName;
  socialShareCanvas.querySelector('#social-share-url').textContent = pageUrl;
  shareClipboard.onclick = () => {
    writeClipboardText(featureBody).then();
    fetch(getFeatureShareApiRoute(featureId, 'clipboard')).then();
  };

  shareEmail.href = getFeatureShareApiRoute(featureId, 'email');
  shareFacebook.href = getFeatureShareApiRoute(featureId, 'facebook');
  shareTwitter.href = getFeatureShareApiRoute(featureId, 'twitter');
  shareWhatsapp.href = getFeatureShareApiRoute(featureId, 'whatsapp');
}

/**
 * Adds event listeners to all social share buttons
 */
function shareSetup() {
  socialShareCanvas = document.getElementById('social-share-offcanvas');
  bsSocialShareCanvas = new Offcanvas(socialShareCanvas);

  shareClipboard = socialShareCanvas.querySelector('#social-share-clipboard');
  shareEmail = socialShareCanvas.querySelector('#social-share-email');
  shareFacebook = socialShareCanvas.querySelector('#social-share-facebook');
  shareTwitter = socialShareCanvas.querySelector('#social-share-twitter');
  shareWhatsapp = socialShareCanvas.querySelector('#social-share-whatsapp');

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
}

document.addEventListener('turbo:load', shareSetup);
