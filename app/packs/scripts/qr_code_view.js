import QRCode from 'qrcode';

document.addEventListener('DOMContentLoaded', () => {
  const codeContainer = document.getElementById('qr-code-container');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const counter = document.getElementById('qr-counter');
  const codeText = document.getElementById('qr-code-text');
  const titleText = document.getElementById('qr-code-title');

  let currentIndex = 0;
  const qrElements = [];

  // Get the data for the QR codes via a JS object exposed in the view
  const qrCodes = JSON.parse(document.getElementById('qr-code-data').textContent);

  qrCodes.forEach((ticket) => {
    // Create a canvas for each code and draw the QR code on it
    const canvas = document.createElement('canvas');
    canvas.width = 200;
    canvas.height = 200;
    canvas.classList.add('qr-item');
    canvas.style.display = 'none';

    QRCode.toCanvas(canvas, ticket.code, { width: 200, height: 200 });

    codeContainer.appendChild(canvas);
    qrElements.push(canvas);
  });

  function showQR(index) {
    // Make the current QR code visible and hide others
    qrElements.forEach((qrCode, i) => {
      qrCode.classList.remove('d-block', 'd-none');
      qrCode.classList.add(i === index ? 'd-block' : 'd-none');
    });

    codeText.textContent = qrCodes[index].code.slice(0, 30);
    if (qrCodes[index].code.length > 30) {
      codeText.textContent += '...'; // Truncate long codes
    }
    titleText.textContent = qrCodes[index].title_value;

    prevBtn.disabled = index === 0;
    nextBtn.disabled = index === qrElements.length - 1;
    counter.textContent = `${index + 1} of ${qrElements.length}`;
  }

  prevBtn.addEventListener('click', () => {
    if (currentIndex > 0) {
      currentIndex -= 1;
      showQR(currentIndex);
    }
  });

  nextBtn.addEventListener('click', () => {
    if (currentIndex < qrElements.length - 1) {
      currentIndex += 1;
      showQR(currentIndex);
    }
  });

  // Show the first QR code by default
  showQR(currentIndex);
});
