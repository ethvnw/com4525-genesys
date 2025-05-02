import { Controller } from '@hotwired/stimulus';
// eslint-disable-next-line import/no-unresolved
import Swiper from 'swiper/bundle';

export default class extends Controller {
  connect() {
    this.carouselConfig = {
      effect: 'flip',
    };

    this.carouselClasses = Array.from(
      document.querySelectorAll('[class*="trip-carousel-"]'),
    ).map((el) => Array.from(el.classList).find((cls) => cls.startsWith('trip-carousel-')));

    this.carouselClasses.forEach((carousel) => {
      const swiper = new Swiper(`.${carousel}`, this.carouselConfig);

      const toggleButtons = document.querySelectorAll(
        `.${carousel} .swiper-toggle-button`,
      );
      toggleButtons.forEach((button) => {
        button.addEventListener('click', () => {
          if (swiper.activeIndex === 0) {
            swiper.slideTo(1);
          } else {
            swiper.slideTo(0);
          }
        });
      });
    });
  }
}
