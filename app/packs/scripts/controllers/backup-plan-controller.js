import { Controller } from '@hotwired/stimulus';
// eslint-disable-next-line import/no-unresolved
import Swiper from 'swiper/bundle';

/**
 * Make the previous slide inert for accessibility
 */
function updateInertSlides(swiper) {
  swiper.slides.forEach((slide, index) => {
    if (index === swiper.activeIndex) {
      slide.removeAttribute('inert');
    } else {
      slide.setAttribute('inert', '');
    }
  });
}

export default class extends Controller {
  connect() {
    this.carouselConfig = {
      effect: 'flip',
      on: {
        init() {
          updateInertSlides(this);
        },
        slideChangeTransitionEnd() {
          updateInertSlides(this);
        },
      },
      autoHeight: true,
      speed: 600,
    };

    const swiper = new Swiper(this.element, this.carouselConfig);
    const toggleButtons = this.element.querySelector('.swiper-toggle-button');

    toggleButtons.addEventListener('click', () => {
      if (swiper.activeIndex === 0) {
        swiper.slideTo(1);
      } else {
        swiper.slideTo(0);
      }
    });
  }
}
