import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static get targets() {
    return ['browseButton', 'customButton', 'fileNameSpan', 'preview'];
  }

  connect() {
    this.setupImage();
  }

  setupImage() {
    const browseButton = this.browseButtonTarget;
    const customButton = this.customButtonTarget;
    const fileNameSpan = this.fileNameSpanTarget;
    const preview = this.previewTarget;

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
            preview.src = e.target.result;
          };
          preview.classList.remove('d-none');
          reader.readAsDataURL(file);
        } else {
          fileNameSpan.textContent = 'Invalid file type. Only JPG, JPEG, and PNG are allowed.';
        }
      } else {
        fileNameSpan.textContent = 'No files selected';
      }
    });
  }
}
