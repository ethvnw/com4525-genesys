// Used to call the browse images button when pressed by a custom button

function setupImage() {
  const browseButton = document.getElementById('image-input');
  const customButton = document.getElementById('image-custom');
  const fileNameSpan = document.getElementById('image-file-name');
  const avatarPreview = document.getElementById('image-preview');

  // If any of the elements are not found, return
  if (!browseButton || !customButton || !fileNameSpan || !avatarPreview) {
    return;
  }

  // When the custom button is clicked, trigger a click on the browse button
  customButton.addEventListener('click', () => {
    browseButton.click();
  });

  // Update the file name span when a file is selected
  browseButton.addEventListener('change', () => {
    if (browseButton.files.length > 0) {
      const file = browseButton.files[0];
      const fileName = file.name.toLowerCase();
      const validTypes = ['image/jpeg', 'image/jpg', 'image/png'];

      if (validTypes.includes(file.type)) {
        fileNameSpan.textContent = fileName;

        // Update the image preview
        const reader = new FileReader();
        reader.onload = (e) => {
          avatarPreview.src = e.target.result;
        };
        reader.readAsDataURL(file);
      } else {
        fileNameSpan.textContent = 'Invalid file type. Only JPG, JPEG, and PNG are allowed.';
      }
    } else {
      fileNameSpan.textContent = 'No files selected';
    }
  });
}

document.addEventListener('turbo:load', () => {
  setupImage();

  const form = document.getElementById('form-container');
  if (!form) {
    return;
  }

  const formObserver = new MutationObserver(setupImage);
  formObserver.observe(form, { childList: true });
});
