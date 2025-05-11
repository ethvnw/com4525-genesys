import { Controller } from '@hotwired/stimulus';
import { decode } from 'blurhash';

/**
 * Taken from:
 * https://github.com/avo-hq/active_storage-blurhash/blob/main/lib/generators/active_storage/blurhash/install/templates/javascript/index.js
 */
export default class extends Controller {
  connect() {
    this.image = this.element.querySelector('img');
    this.canvas = this.element.querySelector('canvas');

    // the image might already be completely loaded. In this case we need to do nothing
    if (this.image.complete) return;

    // if the image comes in with empty dimensions, we can't assign canvas data
    if (this.image.width === 0 || this.image.height === 0) return;

    this.renderBlurhash();
  }

  renderBlurhash() {
    const { width, height } = this.image;

    this.canvas.width = width;
    this.canvas.height = height;

    const pixels = decode(this.element.dataset.blurhash, width, height);
    const ctx = this.canvas.getContext('2d');
    const imageData = ctx.createImageData(width, height);
    imageData.data.set(pixels);
    ctx.putImageData(imageData, 0, 0);

    const swap = () => {
      this.canvas.style.opacity = '0';
    };

    if (this.image.complete) {
      // if image has loaded while rendering canvas
      swap();
    } else {
      // else we need to wait for it to load
      this.image.onload = swap;
    }
  }
}
