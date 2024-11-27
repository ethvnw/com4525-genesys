/**
 * Handles the reordering of items (reviews/questions) in the admin panel.
 */

// TODO: Figure out why it sometimes takes two clicks to reorder for faq only

// Get all items and the save button assigned to variables
const items = document.querySelectorAll('.item');
const saveButton = document.querySelector('.save-button');
let unsaved = false;

items.forEach((item) => {
  // Get the up and down arrows for each item
  const upArrow = item.querySelector('.order-up-arrow');
  const downArrow = item.querySelector('.order-down-arrow');

  // When an arrow is clicked, move the item up or down
  const moveItem = (currentItem, targetItem, direction) => {
    saveButton.classList.remove('d-none');
    unsaved = true;

    const currentOrder = currentItem.getAttribute('data-order');
    const targetOrder = targetItem.getAttribute('data-order');

    currentItem.setAttribute('data-order', targetOrder);
    targetItem.setAttribute('data-order', currentOrder);

    if (direction === 'up') {
      currentItem.parentNode.insertBefore(currentItem, targetItem);
    } else {
      currentItem.parentNode.insertBefore(targetItem, currentItem);
    }
  };

  // Assign the moveItem function to the up and down arrows
  upArrow.addEventListener('click', () => {
    const previousItem = item.previousElementSibling;
    if (previousItem) {
      moveItem(item, previousItem, 'up');
    }
  });

  downArrow.addEventListener('click', () => {
    const nextItem = item.nextElementSibling;
    if (nextItem) {
      moveItem(item, nextItem, 'down');
    }
  });
});

// When the save button is clicked, save the new order of the items
const saveForm = document.getElementById('save-form');
const saveFunction = (event) => {
  event.preventDefault();

  const itemData = {};
  items.forEach((item) => {
    itemData[item.id.split('_')[1]] = parseInt(item.getAttribute('data-order'), 10);
  });

  const formData = new FormData(saveForm);
  formData.append('items', JSON.stringify(itemData));

  // save-form.action gives the route to the correct controller action depending on the item type
  fetch(saveForm.action, {
    method: 'POST',
    body: formData,
  }).then(() => {
    unsaved = false;
    saveButton.classList.add('d-none');
  });
};

// When the save button is clicked, save the new order of the items server-side
saveForm.addEventListener('submit', saveFunction);

// eslint-disable-next-line consistent-return
window.addEventListener('beforeunload', (event) => {
  if (unsaved) {
    const message = 'You have unsaved changes. Are you sure you want to leave?';
    // eslint-disable-next-line no-param-reassign
    event.returnValue = message;
    return message;
  }
});
