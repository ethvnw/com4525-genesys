import jsQR from 'jsqr';
import QRCode from 'qrcode';

let results = [];
let currentIndex = 0;

const input = document.getElementById('qr_codes_upload');
const resultsContainer = document.getElementById('qr-results');
const imagesContainer = document.getElementById('qr-images-container');
const prevBtn = document.getElementById('prev-btn');
const nextBtn = document.getElementById('next-btn');
const counter = document.getElementById('qr-counter');

const codesWithTitles = [];

function showResult(index) {
  results.forEach(({ text, image }, i) => {
    text.classList.replace(
      i === index ? 'd-none' : 'd-block',
      i === index ? 'd-block' : 'd-none',
    );
    image.classList.replace(
      i === index ? 'd-none' : 'd-block',
      i === index ? 'd-block' : 'd-none',
    );
  });

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

  results = [];
  currentIndex = 0;

  resultsContainer.innerHTML = '';
  imagesContainer.innerHTML = '';
  resultsContainer.classList.replace('d-block', 'd-none');
  imagesContainer.classList.replace('d-block', 'd-none');

  Array.from(files).forEach((file) => {
    const reader = new FileReader();

    reader.onload = (e) => {
      const img = new Image();
      img.src = e.target.result;

      img.onload = async () => {
        const canvas = document.createElement('canvas');
        canvas.width = img.width;
        canvas.height = img.height;
        const ctx = canvas.getContext('2d');
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(0, 0, img.width, img.height);
        ctx.drawImage(img, 0, 0, img.width, img.height);
        const imageData = ctx.getImageData(0, 0, img.width, img.height);

        const code = jsQR(imageData.data, imageData.width, imageData.height);

        const fileResult = document.createElement('div');
        fileResult.classList.add('qr-result-item', 'd-none');

        const imgContainer = document.createElement('div');
        imgContainer.classList.add('qr-image-container', 'd-flex', 'justify-content-center', 'd-none');

        const resultImage = document.createElement('img');
        resultImage.width = 200;
        resultImage.height = 200;
        resultImage.alt = 'QR preview';
        imgContainer.appendChild(resultImage);

        const textContainer = document.createElement('div');
        textContainer.classList.add('qr-text');

        if (code) {
          const exists = codesWithTitles.some(({ value }) => value === code.data);
          if (!exists) {
            codesWithTitles.push({ value: code.data, title: code.data });

            try {
              const dataUrl = await QRCode.toDataURL(code.data, { width: 200, height: 200 });
              resultImage.src = dataUrl;

              const titleInput = document.createElement('input');
              titleInput.type = 'text';
              titleInput.name = 'qr_titles[]';
              titleInput.value = code.data;
              titleInput.placeholder = 'Enter title';
              titleInput.classList.add('form-control');

              titleInput.addEventListener('input', (edit) => {
                updateTitles(edit.target.value, code.data);
              });

              textContainer.appendChild(titleInput);
            } catch (err) {
              textContainer.innerHTML = '<p class="qr-error">Error generating QR image</p>';
              resultImage.src = e.target.result;
            }
          } else {
            textContainer.innerHTML = '<p class="qr-error">Error: Duplicate QR code</p>';
            resultImage.src = e.target.result;
          }
        } else {
          textContainer.innerHTML = '<p class="qr-error">No QR Code found in this image.</p>';
          resultImage.src = e.target.result;
        }

        fileResult.appendChild(textContainer);
        imagesContainer.appendChild(imgContainer);
        results.push({ text: fileResult, image: imgContainer });
        resultsContainer.appendChild(fileResult);

        if (results.length === files.length) {
          resultsContainer.classList.replace('d-none', 'd-block');
          imagesContainer.classList.replace('d-none', 'd-block');
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
