import jsQR from 'jsqr';
import QRCode from 'qrcode';

document.addEventListener('DOMContentLoaded', () => {
  let results = [];
  let currentIndex = 0;

  const input = document.getElementById('qr_codes_upload');
  const resultsContainer = document.getElementById('qr-results');
  const canvasesContainer = document.getElementById('qr-canvas-container');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const counter = document.getElementById('qr-counter');

  function showResult(index) {
    results.forEach(({ text, canvas }, i) => {
      text.classList.replace(
        i === index ? 'd-none' : 'd-block',
        i === index ? 'd-block' : 'd-none',
      );
      canvas.classList.replace(
        i === index ? 'd-none' : 'd-block',
        i === index ? 'd-block' : 'd-none',
      );
    });

    prevBtn.disabled = index === 0;
    nextBtn.disabled = index === results.length - 1;
    counter.innerText = `${index + 1} of ${results.length}`;
  }

  input.addEventListener('change', async (event) => {
    const { files } = event.target;
    if (!files.length) return;

    results = [];
    const extractedCodes = [];
    currentIndex = 0;

    resultsContainer.innerHTML = '';
    resultsContainer.classList.replace('d-block', 'd-none');

    Array.from(files).forEach((file) => {
      const reader = new FileReader();

      reader.onload = (e) => {
        const img = new Image();
        img.src = e.target.result;

        img.onload = () => {
          const canvas = document.createElement('canvas');
          canvas.width = img.width;
          canvas.height = img.height;
          const ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0, img.width, img.height);
          const imageData = ctx.getImageData(0, 0, img.width, img.height);

          const code = jsQR(imageData.data, imageData.width, imageData.height);

          const fileResult = document.createElement('div');
          fileResult.classList.add('qr-result-item', 'd-none');

          const qrCanvas = document.createElement('canvas');
          qrCanvas.width = 200;
          qrCanvas.height = 200;
          const qrCtx = qrCanvas.getContext('2d');

          const canvasContainer = document.createElement('div');
          canvasContainer.classList.add('qr-canvas-container', 'd-flex', 'justify-content-center', 'd-none');
          canvasContainer.appendChild(qrCanvas);

          const textContainer = document.createElement('div');
          textContainer.classList.add('qr-text');

          if (code) {
            if (!extractedCodes.includes(code.data)) {
              extractedCodes.push(code.data);
              textContainer.innerHTML = `<p class="m-0">Extracted QR Code Data: <strong>${code.data}</strong></p>`;
              QRCode.toCanvas(qrCanvas, code.data, { width: 200, height: 200 });
            } else {
              textContainer.innerHTML = '<p class="m-0">Error: Duplicate QR code</p>';
              qrCtx.drawImage(img, 0, 0, 200, 200);
            }
          } else {
            textContainer.innerHTML = '<p class="m-0">No QR Code found in this image.</p>';
            qrCtx.drawImage(img, 0, 0, 200, 200);
          }

          fileResult.appendChild(textContainer);
          canvasesContainer.appendChild(canvasContainer);
          results.push({ text: fileResult, canvas: canvasContainer });
          resultsContainer.appendChild(fileResult);

          if (results.length === files.length) {
            resultsContainer.classList.replace('d-none', 'd-block');
            canvasesContainer.classList.replace('d-none', 'd-block');
            document.getElementById('qr-navigation').classList.replace('d-none', 'd-block');
            document.getElementById('qr-codes-container').classList.replace('d-none', 'd-block');
            showResult(0);
            document.getElementById('scannable_tickets').value = JSON.stringify(extractedCodes);
            document.getElementById('qr-codes-found').classList.replace('d-none', 'd-block');
            document.getElementById('qr-codes-found').innerHTML = `Codes found in ${extractedCodes.length}/${files.length} images`;
          }
        };
      };

      reader.readAsDataURL(file);
    });
  });

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
