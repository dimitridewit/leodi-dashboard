// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss";

import "phoenix_html";
import {Socket} from "phoenix";
import NProgress from "nprogress";
import {LiveSocket} from "phoenix_live_view";

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start());
window.addEventListener("phx:page-loading-stop", info => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

(() => {
  const $navbarBurger = document.querySelector('.navbar-burger');
  const $addIngredientsButton = document.querySelector('.js-add-ingredients-trigger');
  const $closeAddIngredients = document.querySelector('.js-close-add-ingredients-modal');

  // For Bulma Modals
  const openModal = ($target) => $target.classList.add('is-active');
  const closeModal = ($target) => $target.classList.remove('is-active');

  if ($addIngredientsButton) {
    const $ingredientsModal = document.getElementById($addIngredientsButton.dataset.target);
    const $ingredientsModalBackground = document.getElementById($addIngredientsButton.dataset.targetBackground);

    const toggle = () => {
      if ($ingredientsModal.classList.contains('is-active')) {
        closeModal($ingredientsModal);
      } else {
        openModal($ingredientsModal);
      }
    };

    $addIngredientsButton.addEventListener('click', toggle);
    $closeAddIngredients.addEventListener('click', () => closeModal($ingredientsModal))
    $ingredientsModalBackground.addEventListener('click', () => closeModal($ingredientsModal))
  }

  if ($navbarBurger) {
    const $target = document.getElementById($navbarBurger.dataset.target);

    const open = () => {
      $navbarBurger.classList.add('is-active');
      $target.classList.add('is-active');
    };

    const close = () => {
      $navbarBurger.classList.remove('is-active');
      $target.classList.remove('is-active');
    };

    const toggle = () => {
      $navbarBurger.classList.contains('is-active') ? close() : open();
    };

    $navbarBurger.addEventListener('click', toggle);

    window.addEventListener('resize', () => {
      window.innerWidth >= 1440 ? open() : close();
    });
  }

})();
