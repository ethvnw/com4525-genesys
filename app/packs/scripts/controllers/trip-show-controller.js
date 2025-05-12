import { Controller } from '@hotwired/stimulus';
// eslint-disable-next-line import/no-unresolved
import Swiper from 'swiper/bundle';

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
        }
      },
      autoHeight: true,
      speed: 600,
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

      // Recalculate the height of the carousel when accordion items are shown or hidden
      const accordion = document.querySelector(`.${carousel} .accordion-collapse`);
      if (!accordion) return;
      accordion.addEventListener('show.bs.collapse', () => {
        setTimeout(() => { swiper.updateAutoHeight(50); }, 15);
      });
      accordion.addEventListener('hide.bs.collapse', () => {
        setTimeout(() => { swiper.updateAutoHeight(50); }, 15);
      });
    });

    /**
     * Make the previous slide inert for accesibility
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
  }
}
