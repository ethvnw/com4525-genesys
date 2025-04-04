import jsQR from 'jsqr';
import QRCode from 'qrcode';

// DOMContentLoaded event to ensure the navigation buttons are available, script errors are avoided
document.addEventListener('DOMContentLoaded', () => {
  let results = [];
  let currentIndex = 0;

  const input = document.getElementById('qr_codes_upload');
  const resultsContainer = document.getElementById('qr-results');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const imageCounter = document.getElementById('image-counter');

  // Function to show the current result based on the index
  function showResult(index) {
    results.forEach((result, i) => {
      // Show the current result and hide others
      result.classList.replace(
        i === index ? 'd-none' : 'd-block',
        i === index ? 'd-block' : 'd-none',
      );
    });

    // Enable/disable navigation buttons based on the current index
    prevBtn.disabled = index === 0;
    nextBtn.disabled = index === results.length - 1;

    // Update the image counter
    imageCounter.innerText = `Image ${index + 1}/${results.length}`;
  }

  // When files are selected, read it and extract the QR code
  input.addEventListener('change', async (event) => {
    const { files } = event.target;
    if (!files.length) return;

    results = [];
    currentIndex = 0;

    resultsContainer.innerHTML = '';
    resultsContainer.classList.replace('d-block', 'd-none');

    Array.from(files).forEach((file) => {
      // Use FileReader so the CSP doesn't block the image
      const reader = new FileReader();

      reader.onload = (e) => {
        const img = new Image();
        img.src = e.target.result;

        img.onload = () => {
          // Create a canvas and draw the image on it
          const canvas = document.createElement('canvas');
          canvas.width = img.width;
          canvas.height = img.height;
          const ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0, img.width, img.height);
          const imageData = ctx.getImageData(0, 0, img.width, img.height);

          // When the image is loaded, extract the QR code using jsQR
          const code = jsQR(imageData.data, imageData.width, imageData.height);

          const fileResult = document.createElement('div');
          fileResult.classList.add('qr-result-item', 'd-none');

          // QR Codes/error images are displayed in a 200x200 canvas
          const qrCanvas = document.createElement('canvas');
          qrCanvas.width = 200; // Ensure fixed width for consistency
          qrCanvas.height = 200;
          const qrCtx = qrCanvas.getContext('2d');

          if (code) {
            fileResult.innerHTML = `
              <p class="m-0">Extracted QR Code Data: <strong>${code.data}</strong></p>
            `;
            QRCode.toCanvas(qrCanvas, code.data, { width: 200, height: 200 });
          } else {
            // If no QR code is found, show the original image, also in 200x200
            fileResult.innerHTML = '<p class="m-0">No QR Code found in this image.</p>';
            qrCtx.drawImage(img, 0, 0, 200, 200); // Draw original image in QR-sized canvas
          }

          fileResult.appendChild(qrCanvas);
          results.push(fileResult);
          resultsContainer.appendChild(fileResult);

          if (results.length === files.length) {
            resultsContainer.classList.replace('d-none', 'd-block');
            document.getElementById('qr-navigation').classList.replace('d-none', 'd-block');
            showResult(0);
          }
        };
      };

      reader.readAsDataURL(file);
    });
  });

  // Event listeners for navigation buttons
  prevBtn.addEventListener('click', () => {
    if (currentIndex > 0) {
      currentIndex -= 1;
      showResult(currentIndex);
    }
  });

  nextBtn.addEventListener('click', () => {
    if (currentIndex < results.length - 1) {
      currentIndex += 1;
      showResult(currentIndex);
    }
  });
});
