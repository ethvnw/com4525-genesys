import { Controller } from '@hotwired/stimulus';
import jsQR from 'jsqr';
import QRCode from 'qrcode';

export default class extends Controller {
  connect() {
    this.results = [];
    this.currentIndex = 0;
    this.codesWithTitles = [];

    const input = document.getElementById('qr_codes_upload');
    this.resultsContainer = document.getElementById('qr-results');
    this.imagesContainer = document.getElementById('qr-images-container');
    this.prevBtn = document.getElementById('prev-btn');
    this.nextBtn = document.getElementById('next-btn');
    this.counter = document.getElementById('qr-counter');

    input.addEventListener('change', (event) => this.handleFileChange(event));
    this.prevBtn.addEventListener('click', () => this.prev());
    this.nextBtn.addEventListener('click', () => this.next());
  }

  // Show the current result based on the index
  showResult(index) {
    this.results.forEach(({ text, image }, i) => {
      text.classList.replace(
        i === index ? 'd-none' : 'd-block',
        i === index ? 'd-block' : 'd-none',
      );
      image.classList.replace(
        i === index ? 'd-none' : 'd-block',
        i === index ? 'd-block' : 'd-none',
      );
    });

    this.prevBtn.disabled = index === 0;
    this.nextBtn.disabled = index === this.results.length - 1;
    this.counter.innerText = `${index + 1} of ${this.results.length}`;
  }

  // When a title text box is updated, the titles array is updated
  updateTitles(title, code) {
    const item = this.codesWithTitles.find((c) => c.value === code);
    if (item) item.title = title;

    document.getElementById('scannable_ticket_titles').value = JSON.stringify(
      this.codesWithTitles.map((c) => c.title),
    );
  }

  // Handle file input change
  async handleFileChange(event) {
    const { files } = event.target;
    // If there are no files, do nothing
    if (!files.length) return;

    this.results = [];
    this.currentIndex = 0;

    this.resultsContainer.innerHTML = '';
    this.imagesContainer.innerHTML = '';
    this.resultsContainer.classList.replace('d-block', 'd-none');
    this.imagesContainer.classList.replace('d-block', 'd-none');

    // Wait for all files to load before processing
    await Promise.all(Array.from(files).map(async (file) => {
      const reader = new FileReader();

      const dataUrl = await new Promise((resolve) => {
        reader.onload = (e) => resolve(e.target.result);
        reader.readAsDataURL(file);
      });

      const img = new Image();
      img.src = dataUrl;

      await new Promise((resolve) => {
        img.onload = resolve;
      });

      // jsQR processes the image data by analysing a canvas' image data
      const canvas = document.createElement('canvas');
      canvas.width = img.width;
      canvas.height = img.height;
      const ctx = canvas.getContext('2d');
      // Fill the canvas with white to avoid transparency issues
      ctx.fillStyle = '#FFFFFF';
      ctx.fillRect(0, 0, img.width, img.height);
      ctx.drawImage(img, 0, 0, img.width, img.height);
      const imageData = ctx.getImageData(0, 0, img.width, img.height);

      // "code" is the actual QR code data
      const code = jsQR(imageData.data, imageData.width, imageData.height);

      const fileResult = document.createElement('div');
      fileResult.classList.add('qr-result-item', 'd-none');

      const imgContainer = document.createElement('div');
      imgContainer.classList.add('qr-image-container', 'd-flex', 'justify-content-center', 'd-none');

      // Create a div to hold the image and text
      const resultImage = document.createElement('img');
      resultImage.width = 200;
      resultImage.height = 200;
      resultImage.alt = 'QR preview';
      imgContainer.appendChild(resultImage);

      const textContainer = document.createElement('div');
      textContainer.classList.add('qr-text');

      if (code) {
        // Check if the QR code is already in the list, if not, add it
        const exists = this.codesWithTitles.some(({ value }) => value === code.data);
        if (!exists) {
          this.codesWithTitles.push({ value: code.data, title: code.data });

          try {
            const qrUrl = await QRCode.toDataURL(code.data, { width: 200, height: 200 });
            resultImage.src = qrUrl;

            const titleInput = document.createElement('input');
            titleInput.type = 'text';
            titleInput.name = 'qr_titles[]';
            titleInput.value = code.data;
            titleInput.placeholder = 'Enter title';
            titleInput.classList.add('form-control');

            titleInput.addEventListener('input', (edit) => {
              this.updateTitles(edit.target.value, code.data);
            });

            textContainer.appendChild(titleInput);
          } catch (err) {
            // If an error or a duplicate is found, show an error message and the original image.
            textContainer.innerHTML = '<p class="qr-error">Error generating QR image</p>';
            resultImage.src = dataUrl;
          }
        } else {
          textContainer.innerHTML = '<p class="qr-error">Error: Duplicate QR code</p>';
          resultImage.src = dataUrl;
        }
      } else {
        textContainer.innerHTML = '<p class="qr-error">No QR Code found in this image.</p>';
        resultImage.src = dataUrl;
      }

      // Append the image and text to the file result container
      fileResult.appendChild(textContainer);
      this.imagesContainer.appendChild(imgContainer);
      this.results.push({ text: fileResult, image: imgContainer });
      this.resultsContainer.appendChild(fileResult);
    }));

    // When images have been processed, show the previously hidden elements (show and navigation)
    if (this.results.length > 0) {
      this.resultsContainer.classList.replace('d-none', 'd-block');
      this.imagesContainer.classList.replace('d-none', 'd-block');
      document.getElementById('qr-navigation').classList.replace('d-none', 'd-block');
      document.getElementById('qr-codes-container').classList.replace('d-none', 'd-block');
      // By default, show the first result
      this.showResult(0);

      // Add all of the codes and titles to the hidden inputs
      document.getElementById('scannable_tickets').value = JSON.stringify(
        this.codesWithTitles.map(({ value }) => value),
      );

      document.getElementById('scannable_ticket_titles').value = JSON.stringify(
        this.codesWithTitles.map(({ title }) => title),
      );

      document.getElementById('qr-codes-found').classList.replace('d-none', 'd-block');
      document.getElementById('qr-codes-found').innerHTML = `Codes found in ${this.codesWithTitles.length}/${files.length} images`;
    }
  }

  // Functions to navigate through the results
  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex -= 1;
      this.showResult(this.currentIndex);
    }
  }

  next() {
    if (this.currentIndex < this.results.length - 1) {
      this.currentIndex += 1;
      this.showResult(this.currentIndex);
    }
  }
}
