import jsQR from 'jsqr';
import QRCode from 'qrcode';

// When a file is selected, read it and extract the QR code
document.getElementById('plan_qr_code').addEventListener('change', async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  // Use FileReader so the CSP doesn't block the image
  const reader = new FileReader();

  reader.onload = (e) => {
    const img = new Image();
    img.src = e.target.result;
    // When the image is loaded, extract the QR code using jsQR
    img.onload = () => {
      // Create a canvas and draw the image on it
      const canvas = document.createElement('canvas');
      canvas.width = img.width;
      canvas.height = img.height;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(img, 0, 0, img.width, img.height);
      const imageData = ctx.getImageData(0, 0, img.width, img.height);

      // Extract the QR code from the image data of the canvas
      const code = jsQR(imageData.data, imageData.width, imageData.height);

      // Display the extracted QR code data and recreate the QR code
      const resultContainer = document.getElementById('qr-result');
      const qrCanvas = document.getElementById('qr-recreated');

      if (code) {
        resultContainer.innerHTML = `Extracted QR Code Data: <strong>${code.data}</strong>`;
        resultContainer.classList.replace('d-none', 'd-block');

        // Generate a new QR code from extracted data and display it in the preview canvas
        QRCode.toCanvas(qrCanvas, code.data, { width: 200 }, () => {
          qrCanvas.classList.replace('d-none', 'd-block');
        });
      } else {
        // If there was no QR code found, display a message and clear the canvas
        resultContainer.innerHTML = 'No QR Code found in the image...';
        qrCanvas.getContext('2d').clearRect(0, 0, qrCanvas.width, qrCanvas.height);
        qrCanvas.classList.replace('d-block', 'd-none');
        resultContainer.classList.replace('d-block', 'd-none');
      }
    };
  };
  reader.readAsDataURL(file);
});
