import jsQR from 'jsqr';
import QRCode from 'qrcode';

// DOMContentLoaded event to ensure the navigation buttons are available, script errors are avoided
document.addEventListener('DOMContentLoaded', () => {
  let results = [];
  let currentIndex = 0;

  const input = document.getElementById('qr_codes_upload');
  const resultsContainer = document.getElementById('qr-results');
  const canvasesContainer = document.getElementById('qr-canvas-container');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const counter = document.getElementById('qr-counter');

  const codesWithTitles = []; // [{ value: "qr_value", title: "james' ticket" }]

  // Function to show the current result based on the index and update the navigation buttons
  function showResult(index) {
    // Show the current result and hide others
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

    // Enable/disable navigation buttons based on the current index
    prevBtn.disabled = index === 0;
    nextBtn.disabled = index === results.length - 1;
    counter.innerText = `${index + 1} of ${results.length}`;
  }

  function updateTitles(title, code) {
    const item = codesWithTitles.find((c) => c.value === code);
    if (item) item.title = title;

    document.getElementById('scannable_ticket_titles').value = JSON.stringify(
      codesWithTitles.map((c) => c.title),
    );
  }

  input.addEventListener('change', async (event) => {
    const { files } = event.target;
    if (!files.length) return;

    results = []; // results is used to store the text and canvas elements
    currentIndex = 0;

    resultsContainer.innerHTML = '';
    resultsContainer.classList.replace('d-block', 'd-none');
    canvasesContainer.innerHTML = '';
    canvasesContainer.classList.replace('d-block', 'd-none');

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
            const exists = codesWithTitles.some(({ value }) => value === code.data);
            if (!exists) {
              codesWithTitles.push({ value: code.data, title: code.data });
              QRCode.toCanvas(qrCanvas, code.data, { width: 200, height: 200 });

              // Create paragraph showing the QR code value
              const qrText = document.createElement('p');
              qrText.classList.add('m-0');
              textContainer.appendChild(qrText);

              // Create input field for the title
              const titleInput = document.createElement('input');
              titleInput.type = 'text';
              titleInput.name = 'qr_titles[]';
              titleInput.value = code.data; // preload with QR data
              titleInput.placeholder = 'Enter title';
              titleInput.classList.add('form-control');

              // edit is used > event as event is declared already above
              titleInput.addEventListener('input', (edit) => {
                updateTitles(edit.target.value, code.data);
              });

              textContainer.appendChild(titleInput);
            } else {
              // If the QR code is a duplicate, show an error message & the original image
              textContainer.innerHTML = '<p class="m-0">Error: Duplicate QR code</p>';
              qrCtx.drawImage(img, 0, 0, 200, 200);
            }
          } else {
            // If no QR code is found, show the original image, also in 200x200
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

            document.getElementById('scannable_tickets').value = JSON.stringify(
              codesWithTitles.map(({ value }) => value),
            );

            document.getElementById('scannable_ticket_titles').value = JSON.stringify(
              codesWithTitles.map(({ title }) => title),
            );

            document.getElementById('qr-codes-found').classList.replace('d-none', 'd-block');
            document.getElementById('qr-codes-found').innerHTML = `Codes found in ${codesWithTitles.length}/${files.length} images`;
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
