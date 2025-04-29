import QRCode from 'qrcode';

document.addEventListener('DOMContentLoaded', async () => {
  const img = document.getElementById('qr-image');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const counter = document.getElementById('qr-counter');
  const codeText = document.getElementById('qr-code-text');
  const titleText = document.getElementById('qr-code-title');

  let currentIndex = 0;
  const qrCodes = JSON.parse(document.getElementById('qr-code-data').textContent);
  const dataUrls = await Promise.all(qrCodes.map((ticket) => QRCode.toDataURL(ticket.code)));

  function showQR(index) {
    img.src = dataUrls[index];
    codeText.textContent = qrCodes[index].code;
    titleText.textContent = qrCodes[index].title_value;

    prevBtn.disabled = index === 0;
    nextBtn.disabled = index === dataUrls.length - 1;
    counter.textContent = `${index + 1} of ${dataUrls.length}`;
  }

  prevBtn.addEventListener('click', () => {
    if (currentIndex > 0) {
      currentIndex -= 1;
      showQR(currentIndex);
    }
  });

  nextBtn.addEventListener('click', () => {
    if (currentIndex < dataUrls.length - 1) {
      currentIndex += 1;
      showQR(currentIndex);
    }
  });

  showQR(currentIndex);
});
