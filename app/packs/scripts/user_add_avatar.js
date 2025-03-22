// Used to call the browse images button when pressed by a custom button

const browseButton = document.getElementById('avatar-input');
const customButton = document.getElementById('avatar-custom');
const fileNameSpan = document.getElementById('avatar-file-name');

// When the custom button is clicked, trigger a click on the browse button
customButton.addEventListener('click', () => {
  browseButton.click();
});

// Update the file name span when a file is selected
browseButton.addEventListener('change', () => {
  const fileName = browseButton.files.length > 0 ? browseButton.files[0].name : 'No file selected';
  fileNameSpan.textContent = fileName;
});
